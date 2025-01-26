# GdUnit generated TestSuite
class_name BoolValueTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/mod_manager/src/data/bool_value.gd'


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
