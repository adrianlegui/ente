class_name Mod extends RefCounted

const KEY_GAME_ID: StringName = &"GAME_ID"
const KEY_DEPENDENCIES: StringName = &"DEPENDENCIES"
const KEY_PCKS: StringName = &"PCKS"
const SECTION_ENTITIES: StringName = &"ENTITIES"
const KEY_ENTITIES: StringName = &"ENTITIES"
const KEY_MOD: String = "MOD"

var _game_id: String = ""
var _dependencies: PackedStringArray = []
var _pcks: PackedStringArray = []
var _entities: Dictionary = {}
var _same_game: bool = false


func _init(cfg: ConfigFile = null) -> void:
	if cfg == null:
		return

	load_data(cfg)


func set_game_id(game_id) -> void:
	_game_id = game_id


func set_pcks(pcks: PackedStringArray) -> void:
	_pcks = pcks


func set_dependencies(dependencies: PackedStringArray) -> void:
	_dependencies = dependencies


func set_entities(entities: Dictionary) -> void:
	_entities = entities


func is_same_game() -> bool:
	return _same_game


func get_dependencies() -> PackedStringArray:
	return _dependencies


func get_pcks() -> PackedStringArray:
	return _pcks


func get_entities() -> Dictionary:
	return _entities


static func get_game_id() -> String:
	return ProjectSettings.get_setting(
		ModManagerProperties.GAME_ID_PROPERTY_PATH,
		ProjectSettings.get_setting(ModManagerProperties.GAME_NAME_PROPERTY_PATH)
	)


func load_data(cfg: ConfigFile) -> void:
	_game_id = cfg.get_value(KEY_MOD, KEY_GAME_ID, "")
	_same_game = _game_id == get_game_id()
	_pcks = cfg.get_value(KEY_MOD, KEY_PCKS, _pcks)
	_dependencies = cfg.get_value(KEY_MOD, KEY_DEPENDENCIES, _dependencies)

	if not cfg.has_section(SECTION_ENTITIES):
		return

	for key: String in cfg.get_section_keys(SECTION_ENTITIES):
		_entities[key] = cfg.get_value(SECTION_ENTITIES, key, {})


func load_data_from_file(file_path: String) -> void:
	var cfg: ConfigFile = _load_cfg(file_path)
	if cfg == null:
		push_error("no se pudo cargar la información desde fichero %s" % file_path)
		return
	load_data(cfg)


func save_data(file_path: String, not_encrypted: bool = true) -> bool:
	var cfg: ConfigFile = ConfigFile.new()
	var section: String = Mod.KEY_MOD
	cfg.set_value(section, Mod.KEY_GAME_ID, Mod.get_game_id())
	cfg.set_value(section, Mod.KEY_PCKS, get_pcks())
	cfg.set_value(section, Mod.KEY_DEPENDENCIES, get_dependencies())

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
