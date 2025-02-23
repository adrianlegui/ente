# GdUnit generated TestSuite
class_name ModManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/ente/src/gd/mod_manager/mod_manager.gd'


func test__thread_wait_to_finish() -> void:
	var mod_manager: = ModManager
	mod_manager._thread = Thread.new()
	mod_manager._thread.start(callable_for_test)
	mod_manager._thread_wait_to_finish()
	assert_object(mod_manager._thread).is_null()


func callable_for_test() -> void:
	pass
