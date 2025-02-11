# GdUnit generated TestSuite
class_name BoolValueTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/mod_manager/src/blocker/bool_value.gd'


func test_set_default() -> void:
	# cambia
	var bool_value: BoolValue = BoolValue.new()
	bool_value.set_default(false)
	assert_bool(bool_value.get_default()).is_false()

	# no cambia
	var entity: Entity = Entity.new()
	bool_value.add_blocker(entity)
	bool_value.set_default(true)
	assert_bool(bool_value.get_default()).is_false()

	# cambia con force
	var force: bool = true
	bool_value.set_default(true, force)
	assert_bool(bool_value.get_default()).is_true()

	# Limpiar
	bool_value.queue_free()
	entity.queue_free()


func test_get_default() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	bool_value.set_default(false)
	var result: bool = bool_value.get_default()
	assert_bool(result).is_false()


func test_is_true() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	assert_bool(bool_value.is_true()).is_true()
	var blocker: Data = auto_free(Data.new()) as Data
	bool_value.add_blocker(blocker)
	assert_bool(bool_value.is_true()).is_false()


func test_can_be_true() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	assert_bool(bool_value.can_be_true()).is_true()
	var blocker: Data = auto_free(Data.new()) as Data
	bool_value.add_blocker(blocker)
	assert_bool(bool_value.can_be_true()).is_false()


func test_add_blocker() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	var blocker: Data = auto_free(Data.new()) as Data
	bool_value.add_blocker(blocker)
	assert_bool(bool_value.has_blocker(blocker)).is_true()


func test_remove_blocker() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	var blocker: Data = auto_free(Data.new()) as Data
	bool_value.add_blocker(blocker)
	assert_bool(bool_value.has_blocker(blocker)).is_true()
	bool_value.remove_blocker(blocker)
	assert_bool(bool_value.has_blocker(blocker)).is_false()


func test_has_blocker() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	var blocker_0: Data = auto_free(Data.new()) as Data
	assert_bool(bool_value.has_blocker(blocker_0)).is_false()
	var blocker_1: Data = auto_free(Data.new()) as Data
	bool_value.add_blocker(blocker_1)
	assert_bool(bool_value.has_blocker(blocker_1)).is_true()


func test__get_persistent_properties() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	var keys: PackedStringArray = ["_blockers", "_default"]
	assert_array(bool_value._get_persistent_properties()).contains(keys)
