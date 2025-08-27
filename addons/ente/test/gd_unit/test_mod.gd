extends GutTest


func test_init__without_args__not_null() -> void:
	assert_not_null(EnteMod.new())


func test_init__with_args__not_null() -> void:
	assert_not_null(EnteMod.new(ConfigFile.new(), "name"))


func test_set_version__not_empty_string__same_string() -> void:
	var mod: EnteMod = EnteMod.new()
	var version: String = "1.2.2"
	mod.set_version(version)
	assert_eq(mod._version, version)


func test_get_version__not_setted__empty_string() -> void:
	var mod: EnteMod = EnteMod.new()
	assert_eq(mod.get_version(), "")


func test_get_version__setted__setted_version() -> void:
	var mod: EnteMod = EnteMod.new()
	var version: String = "1.1.1"
	mod._version = version
	assert_eq(mod.get_version(), version)


func test_is_correct__not_cfg__false() -> void:
	var mod: EnteMod = EnteMod.new()
	assert_false(mod.is_correct())


func test_is_correct__all_correct__true() -> void:
	var mod = partial_double(EnteMod).new()
	stub(mod.is_same_game).to_return(true)
	stub(mod.is_same_version).to_return(true)
	stub(mod.has_missing_dependencies).to_return(false)
	assert_true(mod.is_correct())


func test_is_same_version__same_version__true() -> void:
	var mod := EnteMod.new()
	mod._version = "0.0.1"
	assert_true(mod.is_same_version())


func test_is_same_version__not_same_version__false() -> void:
	var mod := EnteMod.new()
	mod._version = "1.1.1"
	assert_false(mod.is_same_version())


func test_is_same_version__empty_version__false() -> void:
	var mod := EnteMod.new()
	assert_false(mod.is_same_version())


func test_has_missing_dependencies__has_missing__true() -> void:
	var mod = partial_double(EnteMod).new()
	stub(mod.get_dependencies).to_return(PackedStringArray(["missing dependency"]))
	assert_true(mod.has_missing_dependencies())


func test_has_missing_dependencies__not_has_missing__false() -> void:
	var mod := EnteMod.new()
	assert_false(mod.has_missing_dependencies())


func test_get_missing_mod_names__missing_dependency__return_missings_dependency() -> void:
	var mod = partial_double(EnteMod).new()
	var missing_dependency: String = "missing"
	var loaded_mods: PackedStringArray = []
	stub(mod._get_loaded_mods).to_return(loaded_mods)
	var dependencies: PackedStringArray = [missing_dependency]
	stub(mod.get_dependencies).to_return(dependencies)
	var result: PackedStringArray = mod.get_missing_mod_names()
	assert_eq(result.size(), 1)
	assert_true(result.has(missing_dependency))


func test_set_name__setted_name__same_name() -> void:
	var mod := EnteMod.new()
	var new_name: String = "new name"
	mod.set_name(new_name)
	assert_eq(mod._name, new_name)


func test_get_name__setted_name__return_same_name() -> void:
	var mod := EnteMod.new()
	var new_name: String = "new name"
	mod._name = new_name
	assert_eq(mod.get_name(), new_name)


func test_set_game_id__setted_id__same_id() -> void:
	var mod := EnteMod.new()
	var new_id: String = "new id"
	mod.set_game_id(new_id)
	assert_eq(mod._game_id, new_id)


func test_set_pcks__setted_pcks__same_pcks() -> void:
	var mod := EnteMod.new()
	var pcks: PackedStringArray = ["pck1", "pck2"]
	mod.set_pcks(pcks)
	assert_same(mod._pcks, pcks)


func test_set_dependencies__setted_dependencies__same_dependencies() -> void:
	var mod := EnteMod.new()
	var dependendies: PackedStringArray = ["d1", "d2"]
	mod.set_dependencies(dependendies)
	assert_same(mod._dependencies, dependendies)


func test_set_entities__setted_entities__same_entities() -> void:
	var mod := EnteMod.new()
	var entities: Dictionary[String, Dictionary] = {"e1": {}}
	mod.set_entities(entities)
	assert_same(mod._entities, entities)


func test_is_same_game__same_id__true() -> void:
	var mod := EnteMod.new()
	mod._game_id = "game_id"
	assert_true(mod.is_same_game())


func test_get_dependencies__setted_dependencies__same_dependencies() -> void:
	var mod := EnteMod.new()
	var dependencies: PackedStringArray = ["d1"]
	mod._dependencies = dependencies
	assert_same(mod.get_dependencies(), dependencies)


func test_get_pcks__setted_pcks__same_pcks() -> void:
	var mod := EnteMod.new()
	var pcks: PackedStringArray = ["pck1"]
	mod._pcks = pcks
	assert_same(mod.get_pcks(), pcks)


func test_get_entities__setted_entities__same_entities() -> void:
	var mod := EnteMod.new()
	var entities: Dictionary[String, Dictionary] = {"e1": {}}
	mod._entities = entities
	assert_same(mod.get_entities(), entities)


func test_load_data__right_cfg__right_data() -> void:
	var mod := EnteMod.new()
	var cfg: ConfigFile = ConfigFile.new()

	var section_mod: String = EnteMod.SECTION_MOD
	var game_id: String = "game id"
	cfg.set_value(section_mod, EnteMod.KEY_GAME_ID, game_id)

	var pcks: PackedStringArray = ["pck1"]
	cfg.set_value(section_mod, EnteMod.KEY_PCKS, pcks)

	var dependencies: PackedStringArray = ["d1"]
	cfg.set_value(section_mod, EnteMod.KEY_DEPENDENCIES, dependencies)

	var version: String = "1.1.1"
	cfg.set_value(section_mod, EnteMod.KEY_VERSION, version)

	var ent_0: String = "ent 0"
	cfg.set_value(EnteMod.SECTION_PERSISTENT_DATA, ent_0, {})

	mod.load_data(cfg)
	assert_eq(mod._game_id, game_id)
	assert_same(mod._pcks, pcks)
	assert_same(mod._dependencies, dependencies)
	assert_eq(mod._version, version)
	assert_false(mod._entities.is_empty())
	assert_true(mod._entities.has(ent_0))


func test_load_data__bad_cfg__default_data() -> void:
	var mod := EnteMod.new()
	var cfg: ConfigFile = ConfigFile.new()
	mod.load_data(cfg)
	assert_true(mod._game_id.is_empty())
	assert_true(mod._pcks.is_empty())
	assert_true(mod._dependencies.is_empty())
	assert_true(mod._version.is_empty())
	assert_true(mod._entities.is_empty())


func test_load_data_from_file__incorrect_path__not_call_load() -> void:
	var mod = partial_double(EnteMod).new()
	var path: String = "path.ext"
	stub(mod._load_cfg.bind(path)).to_return(null)
	mod.load_data_from_file(path)
	assert_not_called(mod, "load_data")


func test_load_data_from_file__correct_path__call_load() -> void:
	var mod = partial_double(EnteMod).new()
	var path: String = "path.ext"
	var cfg: ConfigFile = ConfigFile.new()
	stub(mod, "_load_cfg").when_passed(path).to_return(cfg)
	mod.load_data_from_file(path)
	assert_called(mod, "load_data", [cfg])


func test_save_data__not_encrypted__return_true() -> void:
	var mod := EnteMod.new()
	var file_path: String = "user://save.cfg"
	assert_true(mod.save_data(file_path, true))


func test_save_data__encrypted__return_true() -> void:
	var mod := EnteMod.new()
	var file_path: String = "user://save." + EnteModManagerProperties.ENCRYPTED_EXTENSION
	assert_true(mod.save_data(file_path, false))


func test__load_cfg__encrypted__not_null() -> void:
	var mod := EnteMod.new()
	var path := "res://addons/ente/test/mods/test.egd"
	assert_not_null(mod._load_cfg(path))


func test__load_cfg__not_encrypted__not_null() -> void:
	var mod := EnteMod.new()
	var path := "res://addons/ente/test/mods/test.cfg"
	assert_not_null(mod._load_cfg(path))


func test__load_cfg__incorrect_extension__null() -> void:
	var mod := EnteMod.new()
	var path := "res://addons/ente/test/mods/test.f"
	assert_null(mod._load_cfg(path))


func test_create_mod_from_current_game__current_configuration__not_null() -> void:
	var dependencies: PackedStringArray = []
	var entities: Dictionary[String, Dictionary] = {}
	var mod := EnteMod.create_mod_from_current_game(dependencies, entities)
	assert_same(dependencies, mod._dependencies)
	assert_same(entities, mod._entities)
	assert_eq(mod._version, "0.0.1")
	assert_eq(mod._game_id, "game_id")
