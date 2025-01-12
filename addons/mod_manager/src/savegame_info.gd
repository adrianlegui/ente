class_name SavegameInfo extends RefCounted
## @experimental


var _savegame_name: String
var _same_game: bool = false
var _missing_mods: PackedStringArray = []
var _empty: bool = false
var _has_entities: bool = false


func set_data(
	data: Dictionary,
	name: String,
	loaded_mod: Array
) -> void:
	_savegame_name = name

	_empty = data.is_empty()
	if _empty:
		return

	_has_entities = data.has(Mod.KEY_ENTITIES)

	_same_game = (
		data.has(Mod.KEY_GAME_ID)
		and data[Mod.KEY_GAME_ID] == Mod.get_game_id()
	)
	if _same_game:
		var dependencies: PackedStringArray = data.get(Mod.KEY_DEPENDENCIES, [])
		for d: String in dependencies:
			if not loaded_mod.has(d):
				_missing_mods.append(d)


func get_name() -> String:
	return _savegame_name


func is_same_game() -> bool:
	return _same_game


func has_missing_mods() -> bool:
	return _missing_mods.size() > 0


func get_missing_mod_names() -> PackedStringArray:
	return _missing_mods


func is_correct() -> bool:
	return (
		not is_corrupt() and
		_same_game and
		not has_missing_mods() and
		_has_entities
		)

func is_corrupt() -> bool:
	return _empty
