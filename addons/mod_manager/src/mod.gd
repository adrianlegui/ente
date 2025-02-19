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

	_game_id = cfg.get_value(KEY_MOD, KEY_GAME_ID, "")
	_same_game = _game_id == get_game_id()
	_pcks = cfg.get_value(KEY_MOD, KEY_PCKS, [])
	_dependencies = cfg.get_value(KEY_MOD, KEY_DEPENDENCIES, [])

	if not cfg.has_section(SECTION_ENTITIES):
		return

	for key: String in cfg.get_section_keys(SECTION_ENTITIES):
		_entities[key] = cfg.get_value(SECTION_ENTITIES, key, {})


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
