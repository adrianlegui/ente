class_name Mod extends RefCounted

const KEY_GAME_ID: StringName = &"GAME_ID"
const KEY_DEPENDENCIES: StringName = &"DEPENDENCIES"
const KEY_PCKS: StringName = &"PCKS"
const KEY_ENTITIES: StringName = &"ENTITIES"

var game_id: String = ""
var dependencies: PackedStringArray = []
var pcks: PackedStringArray = []
var entities: Dictionary = {}
var same_game: bool = false

func _init(data_mod: Dictionary) -> void:
	game_id = data_mod.get(KEY_GAME_ID, "")
	same_game = game_id == get_game_id()
	pcks = data_mod.get(KEY_PCKS, [])
	dependencies = data_mod.get(KEY_DEPENDENCIES, [])
	entities = data_mod.get(KEY_ENTITIES, {})


static func get_game_id() -> String:
	return ProjectSettings.get_setting(
		ModManagerProperties.GAME_ID_PROPERTY_PATH,
		ProjectSettings.get_setting(ModManagerProperties.GAME_NAME_PROPERTY_PATH)
		)
