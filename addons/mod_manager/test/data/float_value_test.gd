# GdUnit generated TestSuite
class_name FloatValueTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/mod_manager/src/data/float_value.gd'


func test_get_current_value() -> void:
	var base: float = 1.2
	var mod: float = 1.8
	var float_value: FloatValue = FloatValue.new()
	float_value.base = base
	float_value.mod = mod
	var result: float = float_value.get_current_value()
	assert_float(result).is_equal_approx(base + mod, 0.001)
	float_value.queue_free()


func test__get_persistent_keys() -> void:
	var base: String = "base"
	var mod: String = "mod"
	var float_value: FloatValue = FloatValue.new()
	var vars: PackedStringArray = float_value._get_persistent_keys()
	assert_array(vars).contains_same([base, mod])
	float_value.queue_free()
