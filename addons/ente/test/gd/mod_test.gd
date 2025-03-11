# GdUnit generated TestSuite
class_name ModTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://addons/ente/src/gd/mod.gd"


func test__init() -> void:
	assert_object(Mod.new()).is_not_null()


func test_is_same_game() -> void:
	var mod: Mod = Mod.new()
	assert_bool(mod.is_same_game()).is_false()


func test_get_dependencies() -> void:
	var mod: Mod = Mod.new()
	var dependencies: PackedStringArray = ["dependencies"]
	mod._dependencies = dependencies
	assert_object(mod.get_dependencies()).is_same(dependencies)


func test_get_pcks() -> void:
	var mod: Mod = Mod.new()
	var pcks: PackedStringArray = []
	mod._pcks = pcks
	assert_object(mod.get_pcks()).is_same(pcks)


func test_get_entities() -> void:
	var mod: Mod = Mod.new()
	var entities: Dictionary[String, Dictionary] = {}
	mod._entities = entities
	assert_object(mod.get_entities()).is_same(entities)


func test_get_game_id() -> void:
	var mod: Mod = Mod.new()
	var game_id: String = "game_id"
	assert_str(mod.get_game_id()).is_equal(game_id)


func test_load_data() -> void:
	var mod: Mod = Mod.new()
	var cfg: ConfigFile = mock(ConfigFile) as ConfigFile
	var game_id: String = "game_id"
	do_return(game_id).on(cfg).get_value(Mod.SECTION_MOD, Mod.KEY_GAME_ID, "")
	var pcks: PackedStringArray = []
	do_return(pcks).on(cfg).get_value(Mod.SECTION_MOD, Mod.KEY_PCKS, mod._pcks)
	var dependencies: PackedStringArray = []
	do_return(dependencies).on(cfg).get_value(Mod.SECTION_MOD, Mod.KEY_DEPENDENCIES, mod._dependencies)
	do_return(false).on(cfg).has_section(Mod.SECTION_PERSISTENT_DATA)
	mod.load_data(cfg)
	assert_str(mod.get_game_id()).is_equal(game_id)
	assert_object(mod.get_pcks()).is_same(mod._pcks)
	assert_object(mod.get_dependencies()).is_same(mod._dependencies)
