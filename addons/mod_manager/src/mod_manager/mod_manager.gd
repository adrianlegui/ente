@icon("res://addons/mod_manager/src/resources/icons/mod_manager.svg")
extends Node
## Controla la carga de mods y packs de recursos.

## Se emite si no se puedo abrir el fichero load_order.txt
signal could_not_open_load_order_file
## Se emite cuando la carga de mods y packs de recursos ha terminado.
signal finished
## Se emite al iniciar el juego.
signal started_game
## Se emite cuando falla la carga de una partida guardada.
signal failed_to_load_savegame

# mods que no se cargaron
var _failed_mod: Dictionary = {}
# mods cargados.
var _loaded_mod: Dictionary = {}
# pck que no se cargaron
var _failed_pcks: PackedStringArray
var _thread: Thread

@onready var _scene_tree: SceneTree = get_tree()

func _exit_tree() -> void:
	if is_instance_valid(_thread) and not _thread.is_alive():
		_thread.wait_to_finish()
		_thread = null


## Regresa [code]true[/code] si hubo fallos en la carga de pack de recursos.
func failed_to_load_pcks() -> bool:
	return is_instance_valid(_failed_pcks) and _failed_pcks.size() > 0


## Regresa [code]true[/code] si hubo fallos en la carga de mods.
func failed_to_load_mods() -> bool:
	return not _failed_mod.is_empty()


## Inicia la carga de mods y pack de recursos. Emite [signal finished] al
## terminar.
func start() -> void:
	if is_instance_valid(_thread) and _thread.is_alive():
		_thread.wait_to_finish()

	await Engine.get_main_loop().process_frame
	_thread = Thread.new()
	_thread.start(_load_mods_and_pcks)


# necesario para se usado en thread
func _emit_finished() -> void:
	finished.emit()


## Inicia el juego. Emite [signal started_game] al finalizar.
func start_game() -> void:
	while _thread.is_alive():
		await Engine.get_main_loop().process_frame
	_thread.wait_to_finish()

	var _entities: Dictionary = {}
	for mod_name: String in _loaded_mod:
		var mod: Mod = _loaded_mod[mod_name]
		_entities = DictionaryMerger.merge(_entities, mod.get_entities())

	_scene_tree.paused = true
	_thread = Thread.new()
	_thread.start(_start_game.bind(_entities))


## Carga un juego guardado.
func load_savegame(savegame_name: String) -> void:
	var path_to_savegame: String = get_path_to_savegame(savegame_name)
	var info: SavegameInfo = check_savegame(savegame_name)
	if not info.is_correct():
		push_error("savegame %s esta corrupto" % savegame_name)
		failed_to_load_savegame.emit()
		return

	while _thread.is_alive():
		await Engine.get_main_loop().process_frame
	_thread.wait_to_finish()

	var savegame_entities: Dictionary = {}
	var entities: Dictionary = {}
	for mod_name in _loaded_mod:
		var mod: Mod = _loaded_mod[mod_name]
		entities = DictionaryMerger.merge(entities, mod.entities)

	var cfg: ConfigFile = _load_savegame_cfg(path_to_savegame)
	if cfg == null:
		return

	var mod: Mod = Mod.new(cfg)
	var ents: Dictionary = {}
	ents = mod.get_entities()

	_scene_tree.paused = true
	savegame_entities = DictionaryMerger.merge(entities, ents)
	_thread = Thread.new()
	_thread.start(_start_game.bind(savegame_entities))


## Salva la información de los nodos que se encuentran en el grupo
## [constant EntityData.GROUP_PERSISTENT].
func save_game(savegame_name: String) -> void:
	var ents: Dictionary = _get_data_from_entities()
	if _failed_to_create_save_directory():
		return

	var cfg: ConfigFile = ConfigFile.new()
	var section: String = Mod.KEY_MOD
	cfg.set_value(section, Mod.KEY_GAME_ID, Mod.get_game_id())
	cfg.set_value(section, Mod.KEY_DEPENDENCIES, _loaded_mod.keys())

	for key: String in ents:
		cfg.set_value(Mod.SECTION_ENTITIES, key, ents[key])

	var not_encrypted: bool = (
		ModManagerProperties.NOT_ENCRYPTED_SAVEGAME in OS.get_cmdline_user_args()
	)
	var file_path: String = get_path_to_savegame(savegame_name)
	if not_encrypted:
		var state: int = cfg.save(file_path)
		if state != OK:
			push_error(
				"error al guardar la partida %s: %s" % [
					savegame_name,
					error_string(state)
				]
			)
	else:
		cfg.save_encrypted_pass(file_path, _get_encryption_key())


## Limpia el árbol de nodos. Todos los nodos que pertenescan al grupo
## [constant EntityData.GROUP_PERSISTENT] serán borrados.
func clean_scene_tree() -> void:
	_scene_tree.call_group(
		GameEvents.GROUP,
		GameEvents.GAME_EVENT_CLEAN_SCENE_TREE
	)


## Borra partida guardada.
func delete_savegame(savegame_name: String) -> void:
	var file_path: String =  get_path_to_savegame(savegame_name)
	if FileAccess.file_exists(file_path):
		OS.move_to_trash(ProjectSettings.globalize_path(file_path))


## Comprueba el juego salvado y obtiene información importante del mismo.
func check_savegame(savegame_name: String) -> SavegameInfo:
	var path_to_savegame: String = get_path_to_savegame(savegame_name)
	var save_game: SavegameInfo = SavegameInfo.new()
	var ext: String = path_to_savegame.get_extension()
	var data: Dictionary = {}
	if FileAccess.file_exists(path_to_savegame):
		var cfg: ConfigFile = ConfigFile.new()
		if ext == ModManagerProperties.MOD_EXTENSION:
			cfg.load(path_to_savegame)
			data = cfg.get_value(Mod.KEY_MOD, Mod.KEY_ENTITIES, {})
		elif ext == ModManagerProperties.ENCRYPTED_EXTENSION:
			cfg.load_encrypted_pass(
				path_to_savegame,
				_get_encryption_key()
			)
			data = cfg.get_value(Mod.KEY_MOD, Mod.KEY_ENTITIES, {})
			save_game.set_data(
				data,
				path_to_savegame.get_file().get_basename(),
				_loaded_mod.keys()
			)
		else:
			push_error(
				"partida guardada %s no es un fichero válido" % path_to_savegame
			)
	return save_game


## Devuelve la ruta a la partida guardada.[br]
## [color=yellow]Warning:[/color] No comprueba la existencia de la misma.
func get_path_to_savegame(savegame_name: String) -> String:
	var extension: String = ""
	if ModManagerProperties.NOT_ENCRYPTED_SAVEGAME in OS.get_cmdline_user_args():
		extension = ModManagerProperties.MOD_EXTENSION
	else:
		extension = ModManagerProperties.ENCRYPTED_EXTENSION
	return "%s.%s" % [
		ModManagerProperties.get_savegame_folder_path().path_join(savegame_name),
		extension
	]


## Agrega entidad al SceneTree.
func add_entity(entity: Entity) -> void:
	var force_readable_name: bool = true
	entity.set_unique(false)
	_scene_tree.root.add_child(entity, force_readable_name)


## Obtiene una entidad.
func get_entity(entity_id: String) -> Entity:
	var entity: Entity = null
	if not entity_id.is_empty():
		entity = get_node_or_null("/root/" + entity_id)
	else:
		push_error("entity_id esta vacio, regresando null")
	return entity


## Borra entidad.
func delete_entity_by_id(entity_id: String) -> void:
	if entity_id.is_empty():
		push_error("entity_id esta vacio")
		return

	var entity: Entity = get_entity(entity_id)
	if not is_instance_valid(entity):
		push_error("entity %s no existe" % entity_id)
		return

	entity.delete()


## Regresa [code]true[/code] si la entidad existe.
func entity_exists(entity_id: String) -> bool:
	return get_entity(entity_id) != null


func _mod_exists(mod_name) -> bool:
	var path: String = "%s.%s" % [
		ModManagerProperties.get_mods_folder_path().path_join(mod_name),
		ModManagerProperties.MOD_EXTENSION
	]
	return FileAccess.file_exists(path)


func _start_game(_entities: Dictionary) -> void:
	for entity_name in _entities:
		var root: Node = get_tree().root
		var data: Dictionary = _entities[entity_name]
		var entity: Entity = Entity.create_entity(data)
		if entity:
			entity.name = entity_name
			root.call_deferred("add_child", entity)
		else:
			push_error("fallo la carga de la entidad %s" % entity_name)

	# esperar que las escenas entren al arbol
	await Engine.get_main_loop().process_frame
	await Engine.get_main_loop().process_frame

	_scene_tree.call_group_flags(
		SceneTree.GROUP_CALL_DEFERRED,
		GameEvents.GROUP,
		GameEvents.GAME_EVENT_ALL_ENTITIES_ADDED
	)

	await Engine.get_main_loop().process_frame
	_scene_tree.call_group_flags(
		SceneTree.GROUP_CALL_DEFERRED,
		GameEvents.GROUP,
		GameEvents.GAME_EVENT_BEFORE_STARTING
	)

	await Engine.get_main_loop().process_frame
	_scene_tree.call_group_flags(
		SceneTree.GROUP_CALL_DEFERRED,
		GameEvents.GROUP,
		GameEvents.GAME_EVENT_STARTED
	)

	started_game.emit()
	_scene_tree.paused = false


func _get_mod_names() -> PackedStringArray:
	var names: PackedStringArray = []
	var file_path: String = ModManagerProperties.get_load_order_file_path()
	var file = FileAccess.open(
		file_path,
		FileAccess.READ
	)
	if is_instance_valid(file):
		while not file.eof_reached():
			var line: String = file.get_line()
			if (
				not line.is_empty()
				and line.get_extension() == ModManagerProperties.MOD_EXTENSION
				and not line.begins_with("#")
			):
				var mod_name: String = line.get_basename()
				if names.has(mod_name):
					push_warning("mod duplicado: %s" % line)
				else:
					names.append(mod_name)
		file.close()
	else:
		call_deferred("_emit_could_not_open_load_order_file")
		var error: int = FileAccess.get_open_error()
		push_error(
			"no se pudo abrir fichero %s. error: %s" % [
				file_path,
				error_string(error)
			]
		)
	return names


func _emit_could_not_open_load_order_file() -> void:
	could_not_open_load_order_file.emit()


func _load_mod_data(mod_names) -> void:
	for mod_name: String in mod_names:
		if _mod_exists(mod_name):
			var mod_path: String = "%s.%s" % [
				ModManagerProperties.get_mods_folder_path().path_join(mod_name),
				ModManagerProperties.MOD_EXTENSION
				]
			var cfg: ConfigFile = ConfigFile.new()
			var state: int = cfg.load(mod_path)
			if state != OK:
				push_error("error al cargar mod %s" % mod_name)
				continue

			var mod: Mod = Mod.new(cfg)
			if (
				not mod.is_same_game() or
				not _has_all_dependencies(mod)
			):
				_failed_mod[mod_name] = mod
			else:
				_loaded_mod[mod_name] = mod
		else:
			push_error("no existe mod %s" % mod_name)


func _get_encryption_key() -> String:
	return Mod.get_game_id()


func _has_all_dependencies(mod: Mod) -> bool:
	for name: String in mod.get_dependencies():
		if not name in _loaded_mod.keys():
			return false
	return true


func _load_pcks(mods: Dictionary) -> void:
	var failed: PackedStringArray = []
	for name: String in mods:
		var mod: Mod = mods[name]
		for pck: String in  mod.get_pcks():
			var path: String = ModManagerProperties.get_mods_folder_path().path_join(pck)
			if (
				FileAccess.file_exists(path) and
				ProjectSettings.load_resource_pack(path)
			):
				continue
			else:
				push_error("no se pudo cargar pack de recursos %s" % path)
				failed.append(pck)

	_failed_pcks = failed



func _load_mods_and_pcks() -> void:
	var names: PackedStringArray = _get_mod_names()
	_load_mod_data(names)
	_load_pcks(_loaded_mod)
	call_deferred("_emit_finished")


func _failed_to_create_save_directory() -> bool:
	var err_creating_dir: int
	if not DirAccess.dir_exists_absolute(
		ModManagerProperties.get_savegame_folder_path()
	):
		err_creating_dir = DirAccess.make_dir_recursive_absolute(
			ModManagerProperties.get_savegame_folder_path()
		)
	if err_creating_dir != OK:
		push_error(
			"no se pudo crear directorio: %s" % ModManagerProperties.get_savegame_folder_path()
		)
		return true
	return false


func _get_data_from_entities() -> Dictionary:
	var persistent: Array[Node] = get_tree().get_nodes_in_group(
		Entity.GROUP_PERSISTENT
	)
	var ents: Dictionary = {}
	for node: Entity in persistent:
		var node_data: Dictionary = node.get_data()
		if not node_data.is_empty():
			ents[node.name] = node_data
	return ents


func _load_savegame_cfg(path_to_savegame: String) -> ConfigFile:
	var cfg: ConfigFile = ConfigFile.new()
	var ext: String = path_to_savegame.get_extension()
	if ext == ModManagerProperties.MOD_EXTENSION:
		cfg.load(path_to_savegame)
	elif ext == ModManagerProperties.ENCRYPTED_EXTENSION:
		cfg.load_encrypted_pass(path_to_savegame, _get_encryption_key())
	else:
		push_error(
			"falló la carga de partida guardada: %s" % path_to_savegame
		)
		failed_to_load_savegame.emit()
		return null
	return cfg
