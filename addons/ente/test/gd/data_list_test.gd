# GdUnit generated TestSuite
class_name DataListTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://addons/ente/src/gd/data_list.gd"
const MY_DATA = preload("res://addons/ente/test/entity_for_test/my_data.tscn")


func test_add_data_node_only_one_false() -> void:
	var data_list: DataList = auto_free(DataList.new()) as DataList
	var data: Data = auto_free(Data.new()) as Data
	data_list.add_data_node(data)
	assert_bool(data.is_unique()).is_false()
	var result: bool = data in data_list.get_children()
	assert_bool(result).is_true()


func test_add_data_node_only_one_true_is_not_scene() -> void:
	var data_list: DataList = auto_free(DataList.new()) as DataList
	var only_one: bool = true
	assert_object(data_list.add_data_node(auto_free(Data.new()), only_one)).is_null()


func test_add_data_node_only_one_true_non_existent_data() -> void:
	var data_list: DataList = auto_free(DataList.new()) as DataList
	var data: Data = auto_free(MY_DATA.instantiate()) as Data
	var only_one: bool = true
	assert_object(data_list.add_data_node(data, only_one)).is_same(data)
	assert_bool(data in data_list.get_children()).is_true()


func test_add_data_node_only_one_true_existing_data() -> void:
	var data_list: DataList = auto_free(DataList.new()) as DataList
	var only_one: bool = true
	var existing_data: Data = data_list.add_data_node(auto_free(MY_DATA.instantiate()), only_one)
	var data: Data = auto_free(MY_DATA.instantiate()) as Data
	var added_data: Data = data_list.add_data_node(data, only_one)
	assert_object(added_data).is_not_same(data)
	assert_object(added_data).is_same(existing_data)
	assert_bool(data in data_list.get_children()).is_false()


func test_remove_data_node() -> void:
	var data_list: DataList = auto_free(DataList.new()) as DataList
	var data: Data = Data.new()
	data_list.add_data_node(data)
	var destroy: bool = true
	data_list.remove_data_node(data, destroy)
	var result: bool = data in data_list.get_children()
	assert_bool(result).is_false()


func test_remove_data_node_by_name() -> void:
	var data_list: DataList = auto_free(DataList.new()) as DataList
	var data: Data = auto_free(Data.new())
	data_list.add_data_node(data)
	var destroy: bool = true
	data_list.remove_data_node_by_name(data.name, destroy)
	var result: bool = data in data_list.get_children()
	assert_bool(result).is_false()
