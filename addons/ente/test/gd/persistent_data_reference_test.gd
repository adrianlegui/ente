# GdUnit generated TestSuite
class_name PersistentDataReferenceTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://addons/ente/src/gd/persistent_data_reference.gd"
var persistent_data_reference: PersistentDataReference
var ent: Data


func before_test() -> void:
	persistent_data_reference = auto_free(PersistentDataReference.new()) as PersistentDataReference
	ent = auto_free(Data.new()) as Data
	ent.add_child(persistent_data_reference)
	ModManager.add_persistent_data(ent)


func test_get_reference() -> void:
	persistent_data_reference.set_persistent_data_id(ent.name)
	assert_object(persistent_data_reference.get_reference()).is_same(ent)


func test_get_persistent_data_id() -> void:
	var id_0: String = "Id0"
	persistent_data_reference.set_persistent_data_id(id_0)
	assert_str(persistent_data_reference.get_persistent_data_id()).is_equal(id_0)


func test_set_persistent_data_id() -> void:
	var id: String = ent.name
	persistent_data_reference.set_persistent_data_id(id)
	assert_str(persistent_data_reference.get_persistent_data_id()).is_equal(id)


func test__get_persistent_properties() -> void:
	assert_array(persistent_data_reference._get_persistent_properties()).contains(
		["_persistent_data_id"]
	)
	persistent_data_reference.set_persistent(false)
	assert_array(persistent_data_reference._get_persistent_properties()).not_contains(["_persistent_data_id"])


func test_persistent_data_exists() -> void:
	persistent_data_reference.set_persistent_data_id("no_existe")
	assert_bool(persistent_data_reference.persistent_data_exists()).is_false()
	persistent_data_reference.set_persistent_data_id(ent.name)
	assert_bool(persistent_data_reference.persistent_data_exists()).is_true()


func test_set_persistent_data() -> void:
	var persistent_data_reference := auto_free(PersistentDataReference.new()) as PersistentDataReference
	var persistent_data := auto_free(Data.new()) as Data
	ModManager.add_persistent_data(persistent_data)
	persistent_data_reference.set_persistent_data(persistent_data)
	assert_object(persistent_data_reference.get_reference()).is_same(persistent_data)
