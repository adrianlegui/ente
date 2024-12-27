class_name ModManager extends Node
## Controla la carga de mods y packs de recursos.
##
## @experimental


## Se emite si no hay mods para cargar
signal load_order_file_is_empty
## Se emite si no se puedo abrir el fichero load_order.txt
signal could_not_open_load_order_file
## Se emite cuando falla la carga de un mod.
signal failed_to_load_mod(mod_name: String)
## Se emite cuando la carga de mods y packs de recursos ha terminado.
signal finished
## Se emite cuando se obtiene el numero de pack de recursos para cargar.
signal updated_count_pck_to_load(count: int)
## Se emite al cargar un pack de recursos.
signal loaded_pck(pck_name: String)
## Se emite si la carga de un pack de recursos ha fallado.
signal failed_to_load_pck(pck_name: String)
## Se emite al abortar la carga de packs de recursos.
signal aborted_loading_pck
## Se emite al iniciar el juego.
signal started_game
## Se emite cuando un juego guardado es cargado.
signal loaded_savegame


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
const KEY_GAME_ID: StringName = &"GAME_ID"
const KEY_MODS: StringName = &"MODS"
const KEY_ENTITIES: StringName = &"ENTITIES"
const KEY_PCKS: StringName = &"PCKS"
## Estado inicial.
const STATE_START: StringName = &"START"
## Estado carga de pck
const STATE_LOAD_PCK: StringName = &"LOAD_PCK"
const STATE_WAITING: StringName = &"WAITING"
## Estado al finalizar la carga de packs de recursos.
const STATE_FINISH: StringName = &"FINISH"
## Nombre del grupo con los nodos que no se tiene que borrar al limpiar el árbol
## de nodos.
const GROUP_NOT_DELETE: StringName = &"NOT_DELETE"


## Nombre de los mods que se tiene que cargar.
var mod_names: PackedStringArray = []
## Ficheros con los recursos que se tienen que cargar.
var pcks_to_load: PackedStringArray = []
## Pack de rescursos cargados.
var loaded_pcks: PackedStringArray = []
## Pack de recursos que no se pudieron cargar.
var failed_pcks: PackedStringArray = []
## Información de las entidades.
var entities: Dictionary = {}
## Mods que no se cargaron.
var failed_mods: PackedStringArray = []
## Mods cargados.
var loaded_mods: PackedStringArray = []


# Usado para FSM.
var _current_state: StringName = STATE_START
# Usado en la carga de pack de recursos.
var _thread: Thread
# Ruta al pack de recursos que se esta cargando.
var _current_pck_path: String
# Nombre del pack de recursos que se esta cargando.
var _current_pck: String
# Contador usado en la carga de pack de recursos.
var _count: int = 0
# Usado para abortar la carga de pack de recursos.
var _abort_load: bool = false


func _process(_delta: float) -> void:
	_process_state(_delta)


## Aborta la carga de los paquetes de recursos, no es inmediato.
func abort_pck_load() -> void:
	_abort_load = true


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


## Inicia el juego.
func start_game() -> void:
	_start_game(entities)


## Carga un juego guardado.
func load_savegame(path_to_savegame: String) -> void:
	var savegame_entities: Dictionary = {}
	var savegame_data: Dictionary = _load_json(path_to_savegame)

	var ents: Dictionary = savegame_data[KEY_ENTITIES]
	savegame_entities = merge_dictionary(entities, ents)

	_start_game(savegame_entities)
	loaded_savegame.emit()


## Salva la información de los nodos que se encuentran en el grupo
## [constant EntityData.GROUP_PERSISTENT].
func save_game(savegame_name: String) -> void:
	var persistent: Array[Node] = get_tree().get_nodes_in_group(
		EntityData.GROUP_PERSISTENT
	)
	var ents: Dictionary = {}
	for node: EntityData in persistent:
		var node_data: Dictionary = node.get_data()
		if not node_data.is_empty():
			ents[node.name] = node_data

	var err_creating_dir: int
	if not DirAccess.dir_exists_absolute(get_savegame_folder_path()):
		err_creating_dir = DirAccess.make_dir_recursive_absolute(
			get_savegame_folder_path()
		)
	if err_creating_dir != OK:
		push_error("no se pudo crear directorio: %s" % get_savegame_folder_path())
		return

	var file_path: String = "%s.%s" %  [
		get_savegame_folder_path().path_join(savegame_name),
		MOD_EXTENSION
	]
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	if not is_instance_valid(file):
		push_error("no se pudo crear fichero %s, " % [
			file_path,
			error_string(FileAccess.get_open_error())
			]
		)
		return

	var data: Dictionary = {}
	data[KEY_GAME_ID] = get_game_id()
	data[KEY_MODS] = loaded_mods
	data[KEY_ENTITIES] = ents
	var json_data: String = JSON.stringify(data)
	file.store_line(json_data)
	file.close()


## Limpia el árbol de nodos. Todos los nodos que no estén en el grupo
## [constant GROUP_NOT_DELETE] serán borrados.
func clean_scene_tree() -> void:
	var root: Window = get_tree().root
	for child: Node in root.get_children():
		if not child.is_in_group(GROUP_NOT_DELETE):
			child.queue_free()


## Comprueba el juego salvado y obtiene información importante del mismo.
## Además, realiza comprobaciones.
func check_savegame(path_to_savegame: String) -> InfoSavegame:
	var data: Dictionary = _load_json(path_to_savegame)
	var save_game: InfoSavegame = InfoSavegame.new()
	save_game.set_data(
		data,
		path_to_savegame.get_file().get_basename(),
		self
	)
	return save_game


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


func _process_state(delta: float) -> void:
	match _current_state:
		STATE_START:
			_process_start()
		STATE_LOAD_PCK:
			_process_load_pck()
		STATE_WAITING:
			_process_waiting()
		STATE_FINISH:
			_process_finish()


func _process_start() -> void:
	_load_mod_names()
	if mod_names.is_empty():
		load_order_file_is_empty.emit()
		_current_state = STATE_FINISH
	else:
		_load_game_data()
		if pcks_to_load.size() == 0:
			_current_state = STATE_FINISH
		else:
			updated_count_pck_to_load.emit(pcks_to_load.size())
			_current_pck = pcks_to_load[_count]
			_current_state = STATE_LOAD_PCK


func _process_load_pck() -> void:
	if _abort_load:
		_current_state = STATE_FINISH
		aborted_loading_pck.emit()
		return

	_current_pck_path = get_mods_folder_path().path_join(_current_pck)
	if FileAccess.file_exists(_current_pck_path):
		_thread = Thread.new()
		_thread.start(ProjectSettings.load_resource_pack.bind(_current_pck_path))
		_current_state = STATE_WAITING
	else:
		push_error("no existe fichero: %s" % _current_pck_path)
		failed_to_load_pck.emit(_current_pck_path)
		failed_pcks.append(_current_pck)
		_count += 1
		if _count < pcks_to_load.size():
			_current_pck = pcks_to_load[_count]
		else:
			_current_state = STATE_FINISH


func _process_waiting() -> void:
	if not _thread.is_alive():
		var loaded: bool = _thread.wait_to_finish()
		if not loaded:
			push_error("no se puedo cargar fichero %s" % _current_pck_path)
			failed_to_load_pck.emit(_current_pck_path)
			failed_pcks.append(_current_pck)
		else:
			loaded_pck.emit(_current_pck_path)
			loaded_pcks.append(_current_pck)
		_count += 1
		if _count < pcks_to_load.size():
			_current_pck = pcks_to_load[_count]
			_current_state = STATE_LOAD_PCK
		else:
			_current_state = STATE_FINISH


func _process_finish() -> void:
	_thread = null
	_count = 0
	_current_pck = ""
	_current_pck_path = ""
	finished.emit()
	process_mode = PROCESS_MODE_DISABLED


func _load_mod_names() -> void:
	var file_path: String = get_load_order_file_path()
	var file = FileAccess.open(
		file_path,
		FileAccess.READ
	)
	if is_instance_valid(file):
		var line: String = file.get_line()
		while not file.eof_reached():
			if (
				not line.is_empty()
				and line.get_extension() == MOD_EXTENSION
				and not line.begins_with("#")
			):
				var mod_name: String = line.get_basename()
				if mod_names.has(mod_name):
					push_warning("mod duplicado: %s" % line)
				else:
					mod_names.append(mod_name)
			line = file.get_line()
		file.close()
	else:
		could_not_open_load_order_file.emit()
		var error: int = FileAccess.get_open_error()
		push_error(
			"no se pudo abrir fichero %s. error: %s" % [
				file_path,
				error_string(error)
			]
		)


func _load_json(json_path: String) -> Dictionary:
	var dict: Dictionary = {}
	if FileAccess.file_exists(json_path):
		var file_access: FileAccess = FileAccess.open(json_path, FileAccess.READ)
		var json_text: String = file_access.get_as_text()
		file_access.close()

		var json: JSON = JSON.new()
		var error: int = json.parse(json_text)
		if error == OK:
			if typeof(json.data) == TYPE_DICTIONARY:
				dict = json.data
		else:
			print(
				"%s: %s en linea %s" % [
					json_path,
					json.get_error_message(),
					json.get_error_line()
				]
			)
	else:
		push_error("%s no existe." % json_path)

	return dict


func _load_game_data() -> void:
	for mod_name: String in mod_names:
		if _mod_exists(mod_name):
			var json_path: String = "%s.%s" % [
				get_mods_folder_path().path_join(mod_name),
				MOD_EXTENSION
				]
			var data: Dictionary = _load_json(json_path)
			if data.is_empty() or data[KEY_GAME_ID] != ModManager.get_game_id():
				failed_mods.append(mod_name)
			else:
				_add_data(data, mod_name)
		else:
			failed_mods.append(mod_name)


func _mod_exists(mod_name) -> bool:
	var path: String = "%s.%s" % [
		get_mods_folder_path().path_join(mod_name),
		MOD_EXTENSION
	]
	return FileAccess.file_exists(path)


func _add_data(dict: Dictionary, mod_name: String) -> void:
	var dependencies: PackedStringArray = dict[KEY_MODS]
	for d in dependencies:
		if not loaded_mods.has(d):
			failed_mods.append(mod_name)
			failed_to_load_mod.emit(mod_name)
			return

	var pcks: PackedStringArray = dict[KEY_PCKS]
	for pck in pcks:
		if not pcks_to_load.has(pck):
			pcks_to_load.append(pck)

	var overwrite: bool = true
	var ents: Dictionary = dict[KEY_ENTITIES]
	entities = merge_dictionary(entities, ents)
	loaded_mods.append(mod_name)


func _start_game(_entities: Dictionary) -> void:
	for entity_name in _entities:
		var root: Node = get_tree().root
		var data: Dictionary = entities[entity_name]
		if data.has(EntityData.KEY_SCENE_FILE_PATH):
			var file_path: String = data[EntityData.KEY_SCENE_FILE_PATH]
			var pck: PackedScene = load(file_path)
			if is_instance_valid(pck):
				var entity: EntityData = pck.instantiate()
				entity.name = entity_name
				entity.set_data(data)
				root.add_child(entity)
			else:
				push_error("fallo la carga de %s." % file_path)
		else:
			push_error(
				"fallo la carga de la entidad %s, no tiene %s." % [
					entity_name,
					EntityData.KEY_SCENE_FILE_PATH
				]
			)

	var scene_tree: SceneTree = get_tree()

	scene_tree.call_group_flags(
		SceneTree.GROUP_CALL_DEFERRED,
		EntityData.GROUP_PERSISTENT,
		EntityData.GAME_EVENT_BEFORE_STARTING
	)

	scene_tree.call_group_flags(
		SceneTree.GROUP_CALL_DEFERRED,
		EntityData.GROUP_PERSISTENT,
		EntityData.GAME_EVENT_STARTED
	)

	started_game.emit()


## Devuelve el directorio de las partidas guardadas.
static func get_savegame_folder_path() -> String:
	return SAVEGAME_FOLDER_PATH


## Devuelve el nombre del juego.
static func get_game_id() -> String:
	return ProjectSettings.get_setting(
		GAME_ID_PROPERTY_PATH,
		ProjectSettings.get_setting(GAME_NAME_PROPERTY_PATH)
		)
