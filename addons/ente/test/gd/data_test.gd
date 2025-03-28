# GdUnit generated TestSuite
class_name DataTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://addons/ente/src/gd/data.gd"
const ENTITY_FOR_TEST = preload("res://addons/ente/test/entity_for_test/entity_for_test.tscn")


func test__set_data() -> void:
	var data: Data = auto_free(ENTITY_FOR_TEST.instantiate())
	var numero: int = 1111
	var dict: Dictionary = {
		"scene_file_path": "", "my_bool": true, "my_data": {"scene_file_path": "", "numero": numero}
	}
	var my_bool: bool = true

	data.set_data(dict)
	assert_bool(data.my_bool).is_true()
	assert_int(data.my_data.numero).is_equal(numero)
