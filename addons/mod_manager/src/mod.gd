class_name Mod extends RefCounted

const SECTION_MOD: StringName = &"MOD"
const KEY_GAME_ID: StringName = &"GAME_ID"
const KEY_DEPENDENCIES: StringName = &"DEPENDENCIES"
const KEY_PCKS: StringName = &"PCKS"
const KEY_VERSION: StringName = &"VERSION"
const SECTION_ENTITIES: StringName = &"ENTITIES"

var _name: String = ""
var _game_id: String = ""
var _dependencies: PackedStringArray = []
var _pcks: PackedStringArray = []
var _entities: Dictionary = {}
var _same_game: bool = false
var _version: String = ""


func _init(cfg: ConfigFile = null, name: String = "") -> void:
	if cfg == null:
		return

	_name = name
	load_data(cfg)


func set_version(version: String) -> void:
	_version = version


func get_version() -> String:
	return _version


## Regresa [code]true[/code] si es del mismo juego, es de la misma versión del juego, tiene
## tiene entidades y no tiene dependencias faltantes.
func is_correct() -> bool:
	return (
		is_same_game() and is_same_version() and not is_corrupt() and not has_missing_dependencies()
	)


## Regresa [code]true[/code] si no tiene entidades.
func is_corrupt() -> bool:
	return get_entities().is_empty()


## Regresa [code]true[/code] si es de la misma versión del juego.
func is_same_version() -> bool:
	var game_version: String = ModManagerProperties.get_version()
	var version: String = get_version()
	if version.is_empty():
		push_error("%s: version esta vaciá.")
		return false
	elif not game_version.is_empty():
		return game_version == version
	return false


## Regresa [code]true[/code] si faltan mods de los cuales depende.
func has_missing_dependencies() -> bool:
	var loaded_mods: PackedStringArray = ModManager.get_loaded_mods()
	for d: String in get_dependencies():
		if d not in loaded_mods:
			return true
	return false


## Regresa [PackedStringArray] con los nombres de los mods faltantes.
func get_missing_mod_names() -> PackedStringArray:
	var loaded_mods: PackedStringArray = ModManager.get_loaded_mods()
	var missing_mods: PackedStringArray = []
	for d: String in get_dependencies():
		if d not in loaded_mods:
			missing_mods.append(d)
	return missing_mods


func set_name(mod_name: String) -> void:
	_name = mod_name


func get_name() -> String:
	return _name


func set_game_id(game_id) -> void:
	_game_id = game_id


func set_pcks(pcks: PackedStringArray) -> void:
	_pcks = pcks


func set_dependencies(dependencies: PackedStringArray) -> void:
	_dependencies = dependencies


func set_entities(entities: Dictionary) -> void:
	_entities = entities


func is_same_game() -> bool:
	return _game_id == get_game_id()


func get_dependencies() -> PackedStringArray:
	return _dependencies


func get_pcks() -> PackedStringArray:
	return _pcks


func get_entities() -> Dictionary:
	return _entities


func load_data(cfg: ConfigFile) -> void:
	_game_id = cfg.get_value(SECTION_MOD, KEY_GAME_ID, _game_id)
	_pcks = cfg.get_value(SECTION_MOD, KEY_PCKS, _pcks)
	_dependencies = cfg.get_value(SECTION_MOD, KEY_DEPENDENCIES, _dependencies)
	_version = cfg.get_value(SECTION_MOD, KEY_VERSION, _version)

	if not cfg.has_section(SECTION_ENTITIES):
		return

	for key: String in cfg.get_section_keys(SECTION_ENTITIES):
		_entities[key] = cfg.get_value(SECTION_ENTITIES, key, {})


func load_data_from_file(file_path: String) -> void:
	var cfg: ConfigFile = _load_cfg(file_path)
	if cfg == null:
		push_error("no se pudo cargar la información desde fichero %s" % file_path)
		return
	set_name(file_path.get_file().replace(file_path.get_extension(), ""))
	load_data(cfg)


func save_data(file_path: String, not_encrypted: bool = true) -> bool:
	var cfg: ConfigFile = ConfigFile.new()
	var section: String = Mod.SECTION_MOD
	cfg.set_value(section, Mod.KEY_GAME_ID, Mod.get_game_id())
	cfg.set_value(section, Mod.KEY_PCKS, get_pcks())
	cfg.set_value(section, Mod.KEY_DEPENDENCIES, get_dependencies())
	cfg.set_value(section, Mod.KEY_VERSION, get_version())

	var ents: Dictionary = get_entities()
	for key: String in ents:
		cfg.set_value(Mod.SECTION_ENTITIES, key, ents[key])

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


func _load_cfg(file_path: String) -> ConfigFile:
	var cfg: ConfigFile = ConfigFile.new()
	var ext: String = file_path.get_extension()
	if ext == ModManagerProperties.MOD_EXTENSION:
		cfg.load(file_path)
	elif ext == ModManagerProperties.ENCRYPTED_EXTENSION:
		cfg.load_encrypted_pass(file_path, get_game_id())
	else:
		push_error("falló la cargar del fichero: %s" % file_path)
		return null
	return cfg


static func get_game_id() -> String:
	return ProjectSettings.get_setting(
		ModManagerProperties.GAME_ID_PROPERTY_PATH,
		ProjectSettings.get_setting(ModManagerProperties.GAME_NAME_PROPERTY_PATH)
	)
