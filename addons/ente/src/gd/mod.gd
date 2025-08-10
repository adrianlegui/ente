class_name EnteMod extends RefCounted
## Short description
##
## Long description

#region Constants
const GROUP_PERSISTENT: StringName = &"ENTE_PERSISTENT"
const SECTION_MOD: StringName = &"MOD"
const SECTION_PERSISTENT_DATA: StringName = &"PERSISTENT"
const KEY_GAME_ID: StringName = &"GAME_ID"
const KEY_DEPENDENCIES: StringName = &"DEPENDENCIES"
const KEY_PCKS: StringName = &"PCKS"
const KEY_VERSION: StringName = &"VERSION"
#endregion

#region Private Variables
var _name: String = "mod name"
var _game_id: String = ""
var _dependencies: PackedStringArray = []
var _pcks: PackedStringArray = []
var _entities: Dictionary[String, Dictionary] = {}
var _version: String = ""
#endregion


#region Built-in Fuction
func _init(cfg: ConfigFile = null, name: String = "mod name") -> void:
	if cfg == null:
		return

	_name = name
	load_data(cfg)


#endregion


#region Public Fuction
## Configura versión.
func set_version(version: String) -> void:
	_version = version


## Obtiene versión.
func get_version() -> String:
	return _version


## Regresa [code]true[/code] si es del mismo juego, es de la misma versión del juego, tiene
## entidades y no tiene dependencias faltantes.
func is_correct() -> bool:
	return is_same_game() and is_same_version() and not has_missing_dependencies()


## Regresa [code]true[/code] si es de la misma versión del juego.
func is_same_version() -> bool:
	var game_version: String = EnteModManagerProperties.get_version()
	var version: String = get_version()
	if version.is_empty():
		push_warning("%s: versión esta vaciá." % _name)
		return false
	elif not game_version.is_empty():
		return game_version == version
	return false


## Regresa [code]true[/code] si faltan mods de los cuales depende.
func has_missing_dependencies() -> bool:
	var loaded_mods: PackedStringArray = _get_loaded_mods()
	for d: String in get_dependencies():
		if d not in loaded_mods:
			return true
	return false


## Regresa [PackedStringArray] con los nombres de los mods faltantes.
func get_missing_mod_names() -> PackedStringArray:
	var loaded_mods: PackedStringArray = _get_loaded_mods()
	var missing_mods: PackedStringArray = []
	for d: String in get_dependencies():
		if d not in loaded_mods:
			missing_mods.append(d)
	return missing_mods


## Configura nombre del mod.
func set_name(mod_name: String) -> void:
	_name = mod_name


## Obtiene nombre del mod.
func get_name() -> String:
	return _name


## Configura el id del juego al que pertenece el mod.
func set_game_id(game_id) -> void:
	_game_id = game_id


## Configura los ficheros pcks que utiliza el mod.
func set_pcks(pcks: PackedStringArray) -> void:
	_pcks = pcks


## Configura las dependencias que necesita el mod.
func set_dependencies(dependencies: PackedStringArray) -> void:
	_dependencies = dependencies


## Configura los datos de las entidades que tiene el mod.
func set_entities(entities: Dictionary[String, Dictionary]) -> void:
	_entities = entities


## Regresa [code]true[/code] si el mod es para el juego actual.
func is_same_game() -> bool:
	return _game_id == get_game_id()


## Regresa las dependencias de este mod.
func get_dependencies() -> PackedStringArray:
	return _dependencies


## Regresa una lista con los nombres de los pck que se necesitan cargar con el mod.
func get_pcks() -> PackedStringArray:
	return _pcks


## Regresa la información de las entidades del mod.
func get_entities() -> Dictionary:
	return _entities


## Carga la información de un mod desde un objeto ConfigFile.
func load_data(cfg: ConfigFile) -> void:
	_game_id = cfg.get_value(SECTION_MOD, KEY_GAME_ID, _game_id)
	_pcks = cfg.get_value(SECTION_MOD, KEY_PCKS, _pcks)
	_dependencies = cfg.get_value(SECTION_MOD, KEY_DEPENDENCIES, _dependencies)
	_version = cfg.get_value(SECTION_MOD, KEY_VERSION, _version)
	var section: String = SECTION_PERSISTENT_DATA
	if not cfg.has_section(section):
		return

	for key: String in cfg.get_section_keys(section):
		_entities[key] = cfg.get_value(section, key, {})


## Carga la informacion de un mod desde un fichero de configuración.
func load_data_from_file(file_path: String) -> void:
	var cfg: ConfigFile = _load_cfg(file_path)
	if cfg == null:
		push_error("no se pudo cargar la información desde fichero %s" % file_path)
		return
	set_name(file_path.get_file().replace(".%s" % file_path.get_extension(), ""))
	load_data(cfg)


## Guarda la información del mod en un fichero. Regresa [code]true[/code] si el guardado fue
## exitoso.
func save_data(file_path: String, not_encrypted: bool = true) -> bool:
	var cfg: ConfigFile = ConfigFile.new()
	var section: String = SECTION_MOD
	cfg.set_value(section, EnteMod.KEY_GAME_ID, EnteMod.get_game_id())
	cfg.set_value(section, EnteMod.KEY_PCKS, get_pcks())
	cfg.set_value(section, EnteMod.KEY_DEPENDENCIES, get_dependencies())
	cfg.set_value(section, EnteMod.KEY_VERSION, get_version())

	var ents: Dictionary = get_entities()
	for key: String in ents:
		cfg.set_value(SECTION_PERSISTENT_DATA, key, ents[key])

	var state: int
	if not_encrypted:
		state = cfg.save(file_path)
	else:
		state = cfg.save_encrypted_pass(file_path, get_game_id())

	if state == OK:
		return true
	else:
		push_error("error al guardar %s: %s" % [file_path, error_string(state)])
		return false


#endregion


#region Private Fuction
# Regresa un objeto ConfigFile con la información de un mod
func _load_cfg(file_path: String) -> ConfigFile:
	var cfg: ConfigFile = ConfigFile.new()
	var ext: String = file_path.get_extension()
	if ext == EnteModManagerProperties.MOD_EXTENSION:
		cfg.load(file_path)
	elif ext == EnteModManagerProperties.ENCRYPTED_EXTENSION:
		cfg.load_encrypted_pass(file_path, get_game_id())
	else:
		push_error("falló la cargar del fichero: %s" % file_path)
		return null
	return cfg


# usado para evitar llamar de manera directa al método get_loaded_mods de EnteModManager
func _get_loaded_mods() -> PackedStringArray:
	return EnteModManager.get_loaded_mods()


#endregion


#region Static Fuction
## Regresa el id del juego.
static func get_game_id() -> String:
	return ProjectSettings.get_setting(
		EnteModManagerProperties.GAME_ID_PROPERTY_PATH,
		ProjectSettings.get_setting(EnteModManagerProperties.GAME_NAME_PROPERTY_PATH)
	)


## Regresa un EnteMod con la información de la partida actual.
static func create_mod_from_current_game(
	dependencies: PackedStringArray, entities: Dictionary[String, Dictionary]
) -> EnteMod:
	var mod: EnteMod = EnteMod.new()
	mod.set_game_id(EnteMod.get_game_id())
	mod.set_dependencies(dependencies)
	mod.set_entities(entities)
	mod.set_version(EnteModManagerProperties.get_version())
	return mod
#endregion
