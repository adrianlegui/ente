class_name LoadMods extends ModsPath
## Carga mods en formato json.
##
## @experimental


## Extension del fichero del mod.
const MOD_EXTENSION: String = "json"
const KEY_FORMAT: StringName = &"FORMAT"
const KEY_GAME_NAME: StringName = &"GAME_NAME"
const KEY_VERSION: StringName = &"VERSION"
const KEY_MODS: StringName = &"MODS"
const KEY_ENTITIES: StringName = &"ENTITIES"
const GAME_NAME_PROPERTY_PATH: String = "application/config/name"


func get_mod_names() -> PackedStringArray:
	var mods: PackedStringArray = []

	var file_path: String = ModsPath.get_mods_load_order_file_path()
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
				mods.append(line)
			line = file.get_line()
		file.close()
	else:
		var error: int = file.get_open_error()
		push_error(
			"no se pudo abrir fichero %s. error: %s" % [
				file_path,
				error_string(error)
			]
		)

	return mods


func load_json(json_path: String) -> Dictionary:
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
				"json invalido. %s en linea %s" % [
					json.get_error_message(),
					json.get_error_line()
				]
			)
	else:
		push_error("%s no existe." % json_path)

	return dict


func mod_exists(mod_name: String) -> bool:
	var file_path: String = ModsPath.get_mods_folder_path().path_join(mod_name)
	return FileAccess.file_exists(file_path)


func load_mods() -> LoadedMods:
	var loaded_mods: LoadedMods = LoadedMods.new()
	var mod_names: PackedStringArray = get_mod_names()
	for mod_name: String in mod_names:
		if mod_exists(mod_name):
			var json_path: String = ModsPath.get_mods_folder_path().path_join(mod_name)
			var data: Dictionary = load_json(json_path)
			if data.is_empty() or data[KEY_GAME_NAME] != get_game_name():
				loaded_mods.add_failed(mod_name)
			else:
				loaded_mods.add_data(data)
		else:
			loaded_mods.add_failed(mod_name)
	return loaded_mods


func get_game_name() -> String:
	return ProjectSettings.get_setting(GAME_NAME_PROPERTY_PATH)


class LoadedMods:
	var data: Dictionary = {}
	var failed: PackedStringArray = []


	func mod_loading_failed() -> bool:
		return failed.size() > 0


	func add_data(dict: Dictionary) -> void:
		var mods: Dictionary = dict[KEY_MODS]
		if data.is_empty():
			data = mods
		else:
			var overwrite: bool = true
			for mod_name: String in mods:
				var entities: Dictionary = mods[mod_name]
				for entity_name in entities:
					if not data.has(mod_name):
						data[mod_name] = {}

					if not data[mod_name].has(entity_name):
						data[mod_name][entity_name] = {}

					data[mod_name][entity_name].merge(
						entities[entity_name],
						overwrite
					)


	func add_failed(mod_name: String) -> void:
		failed.append(mod_name)


	func get_data() -> Dictionary:
		return data
