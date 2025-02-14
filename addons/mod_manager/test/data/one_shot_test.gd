# GdUnit generated TestSuite
class_name OneShotTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/mod_manager/src/data/one_shot.gd'


func test__on_game_event_started() -> void:
	var one_shot: OneShot = auto_free(OneShot.new()) as OneShot
	var spy_one_shot: = spy(one_shot) as OneShot
	spy_one_shot._on_game_event_started()
	verify(spy_one_shot, 1)._on_first_start()


func test__add_extra_persistent_properties() -> void:
	var one_shot: OneShot = auto_free(OneShot.new()) as OneShot
	var props: PackedStringArray = []
	one_shot._add_extra_persistent_properties(props)
	assert_array(props).contains(["_first_start"])


func test_set_first_start() -> void:
	var one_shot: OneShot = auto_free(OneShot.new()) as OneShot
	var first_start: bool = false
	one_shot.set_first_start(first_start)
	assert_bool(one_shot.is_first_start()).is_false()


func test_is_first_start() -> void:
	var one_shot: OneShot = auto_free(OneShot.new()) as OneShot
	assert_bool(one_shot.is_first_start()).is_true()
