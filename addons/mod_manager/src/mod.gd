class_name Mod extends RefCounted
## @experimental


const KEY_GAME_ID: StringName = &"GAME_ID"
const KEY_MODS: StringName = &"MOD"
const KEY_PCKS: StringName = &"PCKS"
const KEY_ENTITIES: StringName = &"ENTITIES"
const GAME_ID_PROPERTY_PATH: String = "mod_manager/game_id"
const GAME_NAME_PROPERTY_PATH: String = "application/config/name"


var game_id: String = ""
var mods: PackedStringArray = []
var pcks: PackedStringArray = []
var entities: Dictionary = {}
var same_game: bool = false


func _init(data_mod: Dictionary) -> void:
	game_id = data_mod.get(KEY_GAME_ID, "")
	same_game = game_id == get_game_id()
	pcks = data_mod.get(KEY_PCKS, [])
	mods = data_mod.get(KEY_MODS, [])
	entities = data_mod.get(KEY_ENTITIES, {})


static func get_game_id() -> String:
	return ProjectSettings.get_setting(
		GAME_ID_PROPERTY_PATH,
		ProjectSettings.get_setting(GAME_NAME_PROPERTY_PATH)
		)
