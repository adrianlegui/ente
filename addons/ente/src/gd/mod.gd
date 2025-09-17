class_name EnteMod extends RefCounted
## Short description
##
## Long description

#region Constants
const GROUP_PERSISTENT: String = "ENTE_PERSISTENT"
const SECTION_MOD: String = "MOD"
const SECTION_PERSISTENT_DATA: String = "PERSISTENT"
const KEY_GAME_ID: String = "GAME_ID"
const KEY_DEPENDENCIES: String = "DEPENDENCIES"
const KEY_PCKS: String = "PCKS"
const KEY_VERSION: String = "VERSION"
#endregion

#region Private Variables
var _name: String = ""
var _game_id: String = ""
var _dependencies: PackedStringArray = []
var _pcks: PackedStringArray = []
var _entities: Dictionary[String, Dictionary] = {}
var _version: String = ""
#endregion


#region Built-in Fuction
func _init(cfg: ConfigFile = null, name: String = "") -> void:
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
	var ext := file_path.get_extension()
	if ext == EnteModManagerProperties.MOD_EXTENSION:
		var cfg: ConfigFile = _load_cfg(file_path)
		if not cfg:
			push_error("no se pudo cargar la información desde fichero %s" % file_path)
		else:
			load_data(cfg)
	elif ext == EnteModManagerProperties.BINARY_EXTENSION:
		var d := _load_binary_file(file_path)
		if d.is_empty():
			push_error("no se pudo cargar la información desde fichero %s" % file_path)
		else:
			_set_data_from_dictionary(d)

	set_name(file_path.get_file().get_basename())


## Guarda la información del mod en un fichero. Regresa [code]true[/code] si el guardado fue
## exitoso.
func save_data(file_path: String, binary: bool = false) -> bool:
	if not binary:
		return _save_cfg(file_path)
	else:
		var f := FileAccess.open_compressed(
			file_path, FileAccess.WRITE, FileAccess.COMPRESSION_GZIP
		)
		if not f:
			return false
		f.store_var(_get_data_dictionary())
		f.close()
		return true


#endregion


#region Private Fuction
func _save_cfg(file_path: String) -> bool:
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

	state = cfg.save(file_path)
	if state == OK:
		return true
	else:
		push_error("error al guardar %s: %s" % [file_path, error_string(state)])
		return false


# Regresa un [Dictionary] con la información del mod.
func _get_data_dictionary() -> Dictionary:
	return {
		SECTION_MOD:
		{
			KEY_GAME_ID: _game_id,
			KEY_PCKS: get_pcks(),
			KEY_DEPENDENCIES: get_dependencies(),
			KEY_VERSION: get_version()
		},
		SECTION_PERSISTENT_DATA: get_entities()
	}


func _set_data_from_dictionary(data: Dictionary) -> void:
	var m := data.get(SECTION_MOD, {})
	_game_id = m.get(KEY_GAME_ID, _game_id)
	_pcks = m.get(KEY_PCKS, _pcks)
	_dependencies = m.get(KEY_DEPENDENCIES, _dependencies)
	_version = m.get(KEY_VERSION, _version)

	_entities = data.get(SECTION_PERSISTENT_DATA, _entities)


# Regresa un diccionario con la informacion del fichero.
func _load_binary_file(file_path: String) -> Dictionary:
	var f := FileAccess.open_compressed(file_path, FileAccess.READ, FileAccess.COMPRESSION_GZIP)
	var b := {}
	if f:
		b = f.get_var()
	return b


# Regresa un objeto ConfigFile con la información de un mod
func _load_cfg(file_path: String) -> ConfigFile:
	var cfg: ConfigFile = ConfigFile.new()
	if (
		file_path.get_extension() == EnteModManagerProperties.MOD_EXTENSION
		and cfg.load(file_path) == OK
	):
		return cfg
	push_error("falló la cargar del fichero: %s" % file_path)
	return null


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
