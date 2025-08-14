@icon("res://addons/ente/src/resources/icons/mod_manager.svg")
extends Node
## Controla la carga de mods y packs de recursos.

## Nombre de la propiedad con la ruta a la escena.
const KEY_SCENE_FILE_PATH: String = "scene_file_path"
## Nombre de la clave que contiene la información de la entidad.
const KEY_DATA: String = "DATA"
## Nombre del método usado para configurar la entidad.
const METHOD_SET_DATA: String = "ente_set_data"
## Nombre del método usado para obtener la configuración la entidad.
const METHOD_GET_DATA: String = "ente_get_data"

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

@onready var _scene_tree: SceneTree = get_tree()


## Regresa [code]true[/code] si hubo fallos en la carga de pack de recursos.
func failed_to_load_pcks() -> bool:
	return is_instance_valid(_failed_pcks) and _failed_pcks.size() > 0


## Regresa [code]true[/code] si hubo fallos en la carga de mods.
func failed_to_load_mods() -> bool:
	return not _failed_mod.is_empty()


## Regresa [PackedStringArray] con los nombres de los mods cargados.
func get_loaded_mods() -> PackedStringArray:
	return _loaded_mod.keys()


## Inicia la carga de mods y pack de recursos. Emite [signal finished] al terminar.
func start() -> void:
	_load_mods_and_pcks()


## Inicia el juego. Emite [signal started_game] al finalizar.
func start_game() -> void:
	await Engine.get_main_loop().process_frame
	var _entities: Dictionary = {}
	for mod_name: String in _loaded_mod:
		var mod: EnteMod = _loaded_mod[mod_name]
		_entities = EnteDictionaryMerger.merge(_entities, mod.get_entities())

	_scene_tree.paused = true
	_start_game(_entities)


## Carga un juego guardado.
func load_savegame(savegame_name: String) -> void:
	await Engine.get_main_loop().process_frame
	var path_to_savegame: String = get_path_to_savegame(savegame_name)
	var savegame_info: EnteMod = check_savegame(savegame_name)
	if savegame_info.get_entities().is_empty():
		push_error("savegame %s esta corrupto" % savegame_name)
		failed_to_load_savegame.emit()
		return

	var entities: Dictionary = {}
	for mod_name in _loaded_mod:
		var mod: EnteMod = _loaded_mod[mod_name]
		entities = EnteDictionaryMerger.merge(entities, mod.get_entities())
	var savegame_entities: Dictionary = EnteDictionaryMerger.merge(
		entities, savegame_info.get_entities()
	)

	_scene_tree.paused = true
	_start_game(savegame_entities)


## Salva la información de los nodos que se encuentran en el grupo
## [constant Mod.GROUP_PERSISTENT].
func save_game(savegame_name: String) -> void:
	var ents: Dictionary = _get_data_from_entities()
	if _failed_to_create_save_directory():
		return

	var mod: EnteMod = EnteMod.create_mod_from_current_game(_loaded_mod.keys(), ents)

	var file_path: String = get_path_to_savegame(savegame_name)
	var fail: bool = not mod.save_data(
		file_path, EnteModManagerProperties.NOT_ENCRYPTED_SAVEGAME in OS.get_cmdline_user_args()
	)
	if fail:
		push_error("no se pudo guardar partida %s" % savegame_name)


## Genera el evento [constant GameEvents.CLEAN_SCENE_TREE].
func clean_scene_tree() -> void:
	_scene_tree.call_group(EnteGameEvents.GROUP, EnteGameEvents.CLEAN_SCENE_TREE)


## Borra partida guardada.
func delete_savegame(savegame_name: String) -> void:
	var file_path: String = get_path_to_savegame(savegame_name)
	if FileAccess.file_exists(file_path):
		OS.move_to_trash(ProjectSettings.globalize_path(file_path))


## Comprueba el juego salvado y obtiene información importante del mismo.
func check_savegame(savegame_name: String) -> EnteSavegame:
	var path_to_savegame: String = get_path_to_savegame(savegame_name)
	var savegame_info: EnteSavegame = EnteSavegame.new()
	savegame_info.load_data_from_file(path_to_savegame)
	return savegame_info


## Devuelve la ruta a la partida guardada.[br]
## [color=yellow]Warning:[/color] No comprueba la existencia de la misma.
func get_path_to_savegame(savegame_name: String) -> String:
	var extension: String = ""
	if EnteModManagerProperties.NOT_ENCRYPTED_SAVEGAME in OS.get_cmdline_user_args():
		extension = EnteModManagerProperties.MOD_EXTENSION
	else:
		extension = EnteModManagerProperties.ENCRYPTED_EXTENSION
	return (
		"%s.%s"
		% [EnteModManagerProperties.get_savegame_folder_path().path_join(savegame_name), extension]
	)


func _mod_exists(mod_name) -> bool:
	var path: String = (
		"%s.%s"
		% [
			EnteModManagerProperties.get_mods_folder_path().path_join(mod_name),
			EnteModManagerProperties.MOD_EXTENSION
		]
	)
	return FileAccess.file_exists(path)


func _create_node(entity_name: String, data: Dictionary) -> Node:
	var node: Node = null
	var path: String = data.get(KEY_SCENE_FILE_PATH, "")
	if path.is_empty():
		push_error(
			"la entidad %s no puede ser creada porque no tiene scene_file_path." % entity_name
		)
	else:
		var pck: PackedScene = load(path)
		if pck == null:
			push_error("No se pudo cargar %s ." % path)
		else:
			node = pck.instantiate()
	return node


func _conf_node(conf: Dictionary, node: Node, entity_name: String) -> void:
	if conf.is_empty():
		return
	else:
		if node.has_method(METHOD_SET_DATA):
			node.call(METHOD_SET_DATA, conf)
		else:
			push_error(
				(
					"la entidad %s no pudo ser configurada porque no tiene método %s"
					% [entity_name, METHOD_SET_DATA]
				)
			)


func _start_game(_entities: Dictionary) -> void:
	for entity_name in _entities:
		var root: Node = get_tree().root
		var node: Node = root.get_node_or_null(entity_name)
		var data: Dictionary = _entities[entity_name]
		if node == null:
			node = _create_node(entity_name, data)

		if node != null:
			var conf: Dictionary = data.get(KEY_DATA, {})
			_conf_node(conf, node, entity_name)

			node.name = entity_name
			if not node.is_inside_tree():
				root.call_deferred("add_child", node)
		else:
			push_error("fallo la carga de la entidad %s" % entity_name)

	await Engine.get_main_loop().process_frame
	_scene_tree.call_group_flags(
		SceneTree.GROUP_CALL_DEFERRED, EnteGameEvents.GROUP, EnteGameEvents.ALL_ENTITIES_ADDED
	)

	await Engine.get_main_loop().process_frame
	_scene_tree.call_group_flags(
		SceneTree.GROUP_CALL_DEFERRED, EnteGameEvents.GROUP, EnteGameEvents.BEFORE_STARTING
	)

	await Engine.get_main_loop().process_frame
	_scene_tree.call_group_flags(
		SceneTree.GROUP_CALL_DEFERRED, EnteGameEvents.GROUP, EnteGameEvents.STARTED
	)

	started_game.emit()
	_scene_tree.paused = false


func _get_mod_names() -> PackedStringArray:
	var names: PackedStringArray = []
	if EnteModManagerProperties.is_single_mode_active():
		return names

	var file_path: String = EnteModManagerProperties.get_load_order_file_path()
	var file = FileAccess.open(file_path, FileAccess.READ)
	if is_instance_valid(file):
		_get_mod_names_from_file(file, names)
	else:
		call_deferred("_emit_could_not_open_load_order_file")
		var error: int = FileAccess.get_open_error()
		push_error("no se pudo abrir fichero %s. error: %s" % [file_path, error_string(error)])
	return names


func _get_mod_names_from_file(file: FileAccess, names: PackedStringArray) -> void:
	while not file.eof_reached():
		var line: String = file.get_line()
		if (
			not line.is_empty()
			and line.get_extension() == EnteModManagerProperties.MOD_EXTENSION
			and not line.begins_with("#")
		):
			var mod_name: String = line.get_basename()
			if names.has(mod_name):
				push_warning("mod duplicado: %s" % line)
			else:
				names.append(mod_name)
	file.close()


func _emit_could_not_open_load_order_file() -> void:
	could_not_open_load_order_file.emit()


func _load_main_mod() -> void:
	var main_mod: String = EnteModManagerProperties.get_main_mod()
	if main_mod.is_empty():
		push_warning("main_mod está vacío.")
	else:
		var mod: EnteMod = EnteMod.new()
		mod.load_data_from_file(main_mod)
		if not mod.is_same_game() or not _has_all_dependencies(mod):
			_failed_mod[main_mod] = mod
		else:
			_loaded_mod[main_mod] = mod


func _load_mod_data(mod_names) -> void:
	_load_main_mod()

	if EnteModManagerProperties.is_single_mode_active():
		return

	for mod_name: String in mod_names:
		if _mod_exists(mod_name):
			_load_mod_data_from_file(mod_name)
		else:
			push_error("no existe mod %s" % mod_name)


func _load_mod_data_from_file(mod_name: String) -> void:
	var mod_path: String = (
		"%s.%s"
		% [
			EnteModManagerProperties.get_mods_folder_path().path_join(mod_name),
			EnteModManagerProperties.MOD_EXTENSION
		]
	)
	var cfg: ConfigFile = ConfigFile.new()
	var state: int = cfg.load(mod_path)
	if state != OK:
		push_error("error al cargar mod %s" % mod_name)
		return

	var mod: EnteMod = EnteMod.new(cfg)
	if not mod.is_same_game() or not _has_all_dependencies(mod):
		_failed_mod[mod_name] = mod
	else:
		_loaded_mod[mod_name] = mod


func _get_encryption_key() -> String:
	return EnteMod.get_game_id()


func _has_all_dependencies(mod: EnteMod) -> bool:
	for name: String in mod.get_dependencies():
		if not name in _loaded_mod.keys():
			return false
	return true


func _load_pcks(mods: Dictionary) -> void:
	var failed: PackedStringArray = []
	for name: String in mods:
		var mod: EnteMod = mods[name]
		for pck: String in mod.get_pcks():
			var path: String = EnteModManagerProperties.get_mods_folder_path().path_join(pck)
			if FileAccess.file_exists(path) and ProjectSettings.load_resource_pack(path):
				continue
			else:
				push_error("no se pudo cargar pack de recursos %s" % path)
				failed.append(pck)

	_failed_pcks = failed


func _load_mods_and_pcks() -> void:
	var names: PackedStringArray = _get_mod_names()
	_load_mod_data(names)
	_load_pcks(_loaded_mod)
	finished.emit()


func _failed_to_create_save_directory() -> bool:
	var err_creating_dir: int
	if not DirAccess.dir_exists_absolute(EnteModManagerProperties.get_savegame_folder_path()):
		err_creating_dir = DirAccess.make_dir_recursive_absolute(
			EnteModManagerProperties.get_savegame_folder_path()
		)
	if err_creating_dir != OK:
		push_error(
			"no se pudo crear directorio: %s" % EnteModManagerProperties.get_savegame_folder_path()
		)
		return true
	return false


func _get_data_from_entities() -> Dictionary[String, Dictionary]:
	var ents: Dictionary[String, Dictionary] = {}
	for node: Node in _scene_tree.root.get_children():
		if node.is_in_group(EnteMod.GROUP_PERSISTENT):
			if node.scene_file_path.is_empty():
				push_warning("scene_file_path del nodo %s esta vacia" % node.name)
			var data: Dictionary = {KEY_SCENE_FILE_PATH: node.scene_file_path}
			if node.has_method(METHOD_GET_DATA):
				data[KEY_DATA] = node.call(METHOD_GET_DATA)
			ents[node.name] = data
	return ents


func _load_savegame_cfg(path_to_savegame: String) -> ConfigFile:
	var cfg: ConfigFile = ConfigFile.new()
	var ext: String = path_to_savegame.get_extension()
	if ext == EnteModManagerProperties.MOD_EXTENSION:
		cfg.load(path_to_savegame)
	elif ext == EnteModManagerProperties.ENCRYPTED_EXTENSION:
		cfg.load_encrypted_pass(path_to_savegame, _get_encryption_key())
	else:
		push_error("falló la carga de partida guardada: %s" % path_to_savegame)
		failed_to_load_savegame.emit()
		return null
	return cfg
