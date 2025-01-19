@icon("res://addons/mod_manager/src/mm/icon.svg")
class_name ModManager extends Node
## Controla la carga de mods y packs de recursos.
##
## @experimental


## Se emite si no se puedo abrir el fichero load_order.txt
signal could_not_open_load_order_file
## Se emite cuando la carga de mods y packs de recursos ha terminado.
signal finished
## Se emite al iniciar el juego.
signal started_game
## Se emite cuando falla la carga de una partida guardada.
signal failed_to_load_savegame


## Nombre del fichero que contiene el orden de carga de los mods.
const LOAD_ORDER_FILE: String = "load_order.txt"
## Ruta al directorio donde se encuentran los mods.
const MODS_FOLDER_PATH: String = "user://mods"
## Ruta a la propiedad que contiene la ruta al directorio de mods
const MODS_FOLDER_PATH_PROPERTY: String = "mod_manager/mods_folder_path"
## Extension de los fichero de los mod.
const MOD_EXTENSION: String = "json"
## Ruta al directorio de las partidas guardadas.
const SAVEGAME_FOLDER_PATH: String = "user://save"
const GAME_ID_PROPERTY_PATH: String = "mod_manager/game_id"
## Ruta a la propiedad con el nombre del juego
const GAME_NAME_PROPERTY_PATH: String = "application/config/name"
## Parametro usado para Debug.
## Al ser usado las partidas guardadas serán creadas como json.
const NOT_ENCRYPTED_SAVEGAME: String = "--not-encrypted-savedgame"
## Extensión usada en las partidas guardadas cifradas.
const ENCRYPTED_EXTENSION: String = "sav"


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


## Devuelve la ruta del directorio donde se encuentran los mods.
func get_mods_folder_path() -> String:
	return ProjectSettings.get_setting(
		MODS_FOLDER_PATH_PROPERTY,
		MODS_FOLDER_PATH
	)


## Devuelve el nombre del fichero con los nombres y el orden de los mods para
## cargar.
func get_load_order_file_name() -> String:
	return LOAD_ORDER_FILE


## Devuelve la ruta al fichero [constant LOAD_ORDER_FILE].
func get_load_order_file_path() -> String:
	return get_mods_folder_path().path_join(get_load_order_file_name())


## Inicia el juego. Emite [signal started_game] al finalizar.
func start_game() -> void:
	while _thread.is_alive():
		await Engine.get_main_loop().process_frame
	_thread.wait_to_finish()

	_scene_tree.paused = true
	var _entities: Dictionary = {}
	for mod_name: String in _loaded_mod:
		var mod: Mod = _loaded_mod[mod_name]
		_entities = merge_dictionary(_entities, mod.entities)
	_thread = Thread.new()
	_thread.start(_start_game.bind(_entities))


## Carga un juego guardado.
func load_savegame(savegame_name: String) -> void:
	var path_to_savegame: String = get_path_to_savegame(savegame_name)
	var info: SavegameInfo = check_savegame(savegame_name)
	if not info.is_correct():
		return

	while _thread.is_alive():
		await Engine.get_main_loop().process_frame
	_thread.wait_to_finish()

	var savegame_entities: Dictionary = {}
	var entities: Dictionary = {}
	for mod_name in _loaded_mod:
		var mod: Mod = _loaded_mod[mod_name]
		entities = merge_dictionary(entities, mod.entities)

	var ents: Dictionary = {}
	var ext: String = path_to_savegame.get_extension()
	if ext == MOD_EXTENSION:
		var savegame_data: Dictionary = _load_json(path_to_savegame)
		ents = savegame_data[Mod.KEY_ENTITIES]
	elif ext == ENCRYPTED_EXTENSION:
		var text: String = EncryptDecrypt.load_encrypted_file(
			path_to_savegame,
			_get_encryption_key()
		)
		ents = _json_parse(text).get(Mod.KEY_ENTITIES, {})
	else:
		push_error(
			"falló la carga de partida guardada: %s" % path_to_savegame
		)
		failed_to_load_savegame.emit()
		return

	savegame_entities = merge_dictionary(entities, ents)
	_thread = Thread.new()
	_thread.start(_start_game.bind(savegame_entities))


## Salva la información de los nodos que se encuentran en el grupo
## [constant EntityData.GROUP_PERSISTENT].
func save_game(savegame_name: String) -> void:
	var persistent: Array[Node] = get_tree().get_nodes_in_group(
		Entity.GROUP_PERSISTENT
	)
	var ents: Dictionary = {}
	for node: Entity in persistent:
		var node_data: Dictionary = node.get_data()
		if not node_data.is_empty():
			ents[node.name] = node_data

	var err_creating_dir: int
	if not DirAccess.dir_exists_absolute(get_savegame_folder_path()):
		err_creating_dir = DirAccess.make_dir_recursive_absolute(
			get_savegame_folder_path()
		)
	if err_creating_dir != OK:
		push_error(
			"no se pudo crear directorio: %s" % get_savegame_folder_path()
		)
		return

	var data: Dictionary = {}
	data[Mod.KEY_GAME_ID] = Mod.get_game_id()
	data[Mod.KEY_DEPENDENCIES] = _loaded_mod.keys()
	data[Mod.KEY_ENTITIES] = ents
	var json_data: String = JSON.stringify(data)

	var file: FileAccess
	var not_encrypted: bool = NOT_ENCRYPTED_SAVEGAME in OS.get_cmdline_user_args()
	var file_path: String = get_path_to_savegame(savegame_name)
	if not_encrypted:
		file = FileAccess.open(file_path, FileAccess.WRITE)
		if not is_instance_valid(file):
			push_error("no se pudo crear fichero %s, " % [
				file_path,
				error_string(FileAccess.get_open_error())
				]
			)
			return

		file.store_line(json_data)
		file.close()
	else:
		EncryptDecrypt.save_encrypted_file(
			json_data,
			file_path,
			_get_encryption_key()
		)


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
		if ext == MOD_EXTENSION:
			data = _load_json(path_to_savegame)
		elif ext == ENCRYPTED_EXTENSION:
			var text: String = EncryptDecrypt.load_encrypted_file(
				path_to_savegame,
				_get_encryption_key()
			)
			data = _json_parse(text)
			save_game.set_data(
				data,
				path_to_savegame.get_file().get_basename(),
				_loaded_mod.keys()
			)
		else:
			push_error(
				"partida guardada %s no es un fichero válido" % path_to_savegame
			)
	save_game.set_data(
		data,
		path_to_savegame.get_file().get_basename(),
		_loaded_mod.keys()
	)
	return save_game


## Devuelve la ruta a la partida guardada.
## No comprueba la existencia de la misma.
func get_path_to_savegame(savegame_name: String) -> String:
	return "%s.%s" % [
		get_savegame_folder_path().path_join(savegame_name),
		MOD_EXTENSION if OS.get_cmdline_user_args() else ENCRYPTED_EXTENSION
	]


## Agrega entidad al SceneTree.
func add_entity(entity: Entity) -> void:
	var force_readable_name: bool = true
	_scene_tree.root.add_child(entity, force_readable_name)


## Obtiene una entidad
func get_entity(entity_name: String) -> Entity:
	var entity: Entity = null
	if not entity_name.is_empty():
		entity = get_node_or_null("/root/" + entity_name)
	else:
		push_error("entity_name esta vacio")
	return entity

## Fusiona diccionarios de forma recursiva y devuelve un diccionario nuevo.
## Fusiona [param dictionary_b] con [param dictionary_a].
func merge_dictionary(
	dictionary_a: Dictionary,
	dictionary_b: Dictionary
) -> Dictionary:
	var deep: bool = true
	var output: Dictionary = dictionary_a.duplicate(deep)
	return _merge_dictionary(
		output,
		dictionary_b
	)


func _merge_dictionary(dict_a: Dictionary, dict_b: Dictionary) -> Dictionary:
	for key in dict_b:
		if dict_a.has(key) and typeof(dict_a[key]) == TYPE_DICTIONARY:
			_merge_dictionary(dict_a[key], dict_b[key])
		else:
			dict_a[key] = dict_b[key]
	return dict_a


func _load_json(json_path: String) -> Dictionary:
	var dict: Dictionary = {}
	if FileAccess.file_exists(json_path):
		var file_access: FileAccess = FileAccess.open(
			json_path,
			FileAccess.READ
		)
		var json_text: String = file_access.get_as_text()
		file_access.close()

		var json: JSON = JSON.new()
		var error: int = json.parse(json_text)
		if error == OK:
			if typeof(json.data) == TYPE_DICTIONARY:
				dict = json.data
		else:
			print_debug(
				"%s: %s en linea %s" % [
					json_path,
					json.get_error_message(),
					json.get_error_line()
				]
			)
	else:
		push_error("%s no existe." % json_path)

	return dict


func _json_parse(text: String) -> Dictionary:
	var dict: Dictionary = {}
	var json: JSON = JSON.new()
	var error: int = json.parse(text)
	if error == OK:
		if typeof(json.data) == TYPE_DICTIONARY:
			dict = json.data
	else:
		push_error(
			"%s en linea %s" % [
				json.get_error_message(),
				json.get_error_line()
			]
		)
	return dict


func _mod_exists(mod_name) -> bool:
	var path: String = "%s.%s" % [
		get_mods_folder_path().path_join(mod_name),
		MOD_EXTENSION
	]
	return FileAccess.file_exists(path)


func _start_game(_entities: Dictionary) -> void:
	for entity_name in _entities:
		var root: Node = get_tree().root
		var data: Dictionary = _entities[entity_name]
		var entity: Entity = Entity.create_data_node(data)
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
	var file_path: String = get_load_order_file_path()
	var file = FileAccess.open(
		file_path,
		FileAccess.READ
	)
	if is_instance_valid(file):
		while not file.eof_reached():
			var line: String = file.get_line()
			if (
				not line.is_empty()
				and line.get_extension() == MOD_EXTENSION
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
			var json_path: String = "%s.%s" % [
				get_mods_folder_path().path_join(mod_name),
				MOD_EXTENSION
				]
			var data: Dictionary = _load_json(json_path)
			var mod: Mod = Mod.new(data)
			if (
				data.is_empty() or
				not data.has(Mod.KEY_GAME_ID) or
				data[Mod.KEY_GAME_ID] != Mod.get_game_id() or
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
	for name: String in mod.dependencies:
		if not name in _loaded_mod.keys():
			return false
	return true


func _load_pcks(mods: Dictionary) -> void:
	var failed: PackedStringArray = []
	for name: String in mods:
		var mod: Mod = mods[name]
		for pck: String in  mod.pcks:
			var path: String = get_mods_folder_path().path_join(pck)
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


## Devuelve el directorio de las partidas guardadas.
static func get_savegame_folder_path() -> String:
	return SAVEGAME_FOLDER_PATH
