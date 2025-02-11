# GdUnit generated TestSuite
class_name IntValueTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/mod_manager/src/data/int_value.gd'


func test_set_base_value() -> void:
	var int_value: IntValue = auto_free(IntValue.new()) as IntValue
	var base: int = 100
	int_value.set_base_value(base)
	assert_int(int_value.get_base_value()).is_equal(base)


func test_get_base_value() -> void:
	var int_value: IntValue = auto_free(IntValue.new()) as IntValue
	assert_int(int_value.get_base_value()).is_zero()


func test_add_base_value() -> void:
	var int_value: IntValue = auto_free(IntValue.new()) as IntValue
	var base: int = 10
	int_value.add_base_value(base)
	int_value.add_base_value(base)
	assert_int(int_value.get_base_value()).is_equal(base * 2)


func test_set_mod_value() -> void:
	var int_value: IntValue = auto_free(IntValue.new()) as IntValue
	var mod: int = 100
	int_value.set_mod_value(mod)
	assert_int(int_value.get_mod_value()).is_equal(mod)


func test_get_mod_value() -> void:
	var int_value: IntValue = auto_free(IntValue.new()) as IntValue
	assert_int(int_value.get_mod_value()).is_zero()


func test_add_mod_value() -> void:
	var int_value: IntValue = auto_free(IntValue.new()) as IntValue
	var mod: int = 10
	int_value.add_mod_value(mod)
	int_value.add_mod_value(mod)
	assert_int(int_value.get_mod_value()).is_equal(mod * 2)


func test_get_current_value() -> void:
	var int_value: IntValue = auto_free(IntValue.new()) as IntValue
	var base: int = 10
	var mod: int = 11
	int_value.set_base_value(base)
	int_value.set_mod_value(mod)
	assert_int(int_value.get_current_value()).is_equal(base + mod)


func test__get_persistent_properties() -> void:
	var int_value: IntValue = auto_free(IntValue.new()) as IntValue
	assert_array(int_value._get_persistent_properties()).contains(["_base", "_mod"])
	int_value.set_base_persistent(false)
	assert_array(int_value._get_persistent_properties()).not_contains(["_base"])
	int_value.set_mod_persistent(false)
	assert_array(int_value._get_persistent_properties()).not_contains(["_mod"])


func test_is_base_persistent() -> void:
	var int_value: IntValue = auto_free(IntValue.new()) as IntValue
	assert_bool(int_value.is_base_persistent()).is_true()


func test_set_base_persistent() -> void:
	var int_value: IntValue = auto_free(IntValue.new()) as IntValue
	assert_bool(int_value.is_base_persistent()).is_true()
	int_value.set_base_persistent(false)
	assert_bool(int_value.is_base_persistent()).is_false()


func test_is_mod_persistent() -> void:
	var int_value: IntValue = auto_free(IntValue.new()) as IntValue
	assert_bool(int_value.is_mod_persistent()).is_true()


func test_set_mod_persistent() -> void:
	var int_value: IntValue = auto_free(IntValue.new()) as IntValue
	assert_bool(int_value.is_mod_persistent()).is_true()
	int_value.set_mod_persistent(false)
	assert_bool(int_value.is_mod_persistent()).is_false()
