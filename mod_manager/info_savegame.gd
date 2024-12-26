class_name InfoSavegame extends Resource
## @experimental


var _savegame_name: String
var _same_game: bool = false
var _missing_mods: PackedStringArray = []
var _failed: bool = false


func set_data(data: Dictionary, name: String, mod_manager: ModManager) -> void:
	_savegame_name = name

	_failed = data.is_empty()
	if _failed:
		return

	_same_game = (
		data.has(ModManager.KEY_GAME_NAME)
		and data[ModManager.KEY_GAME_NAME] == ModManager.get_game_name()
	)
	if _same_game:
		var dependencies: PackedStringArray = []
		if data.has[ModManager.KEY_MODS]:
			for d: String in dependencies:
				if not mod_manager.loaded_mods.has(d):
					_missing_mods.append(d)


func get_name() -> String:
	return _savegame_name


func is_same_game() -> bool:
	return _same_game


func has_missing_mods() -> bool:
	return _missing_mods.size() > 0


func get_missing_mod_names() -> PackedStringArray:
	return _missing_mods
