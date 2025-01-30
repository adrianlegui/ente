# GdUnit generated TestSuite
class_name FloatValueTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/mod_manager/src/data/float_value.gd'
const APPROX: float = 0.0001

func test_get_current_value() -> void:
	var float_value: FloatValue = auto_free(FloatValue.new()) as FloatValue
	var base: float = 1.2
	var mod: float = 1.8
	float_value.add_base_value(base)
	float_value.add_mod_value(mod)
	var result: float = float_value.get_current_value()
	assert_float(result).is_equal_approx(base + mod, APPROX)


func test__get_persistent_keys() -> void:
	var float_value: FloatValue = auto_free(FloatValue.new()) as FloatValue
	var vars: PackedStringArray = float_value._get_persistent_keys()
	assert_array(vars).contains_same(["_base", "_mod"])


func test_add_mod_value() -> void:
	var float_value: FloatValue = auto_free(FloatValue.new()) as FloatValue
	var mod: float = 83.0
	float_value.add_mod_value(mod)
	float_value.add_mod_value(mod)
	assert_float(float_value.get_mod_value()).is_equal_approx(mod * 2, APPROX)


func test_get_mod_value() -> void:
	var float_value: FloatValue = auto_free(FloatValue.new()) as FloatValue
	assert_float(float_value.get_mod_value()).is_equal_approx(0.0, APPROX)


func test_set_mod_value() -> void:
	var float_value: FloatValue = auto_free(FloatValue.new()) as FloatValue
	var mod: float = 23.0
	float_value.set_mod_value(mod)
	assert_float(float_value.get_mod_value()).is_equal_approx(mod, APPROX)


func test_add_base_value() -> void:
	var float_value: FloatValue = auto_free(FloatValue.new()) as FloatValue
	var base:float = 9.0
	float_value.add_base_value(base)
	float_value.add_base_value(base)
	assert_float(float_value.get_base_value()).is_equal_approx(base * 2, APPROX)


func test_get_base_value() -> void:
	var float_value: FloatValue = auto_free(FloatValue.new()) as FloatValue
	assert_float(float_value.get_base_value()).is_equal_approx(0.0, APPROX)


func test_set_base_value() -> void:
	var float_value: FloatValue = auto_free(FloatValue.new()) as FloatValue
	var base: float = 9.0
	float_value.set_base_value(base)
	assert_float(float_value.get_base_value()).is_equal_approx(base, APPROX)
