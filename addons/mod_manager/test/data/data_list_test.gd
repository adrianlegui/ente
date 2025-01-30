# GdUnit generated TestSuite
class_name DataListTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/mod_manager/src/data/data_list.gd'

func test_get_data_nodes() -> void:
	var data_list: DataList = auto_free(DataList.new()) as DataList
	var data_0: Data = auto_free(Data.new()) as Data
	var data_1: Data = auto_free(Data.new()) as Data
	data_list.add_data(data_0)
	data_list.add_data(data_1)
	var datas: Array[Data] = data_list.get_data_nodes()
	assert_array(datas).contains([data_0, data_1])


func test_add_data() -> void:
	var data_list: DataList = auto_free(DataList.new()) as DataList
	var data: Data = auto_free(Data.new()) as Data
	data_list.add_data(data)
	assert_bool(data.is_unique()).is_true()
	var result: bool = data_list.has_data_node(data)
	assert_bool(result).is_true()


func test_get_data_by_name() -> void:
	var data_list: DataList = auto_free(DataList.new()) as DataList
	var _name: String = "nombre"
	var data: Data = auto_free(Data.new()) as Data
	data.name = _name
	data_list.add_data(data)
	var result: Data = data_list.get_data_by_name(_name)
	assert_object(result).is_same(data)


func test_has_data_node() -> void:
	var data_list: DataList = auto_free(DataList.new()) as DataList
	var data: Data = auto_free(Data.new()) as Data
	data_list.add_data(data)
	var result: bool = data_list.has_data_node(data)
	assert_bool(result).is_true()


func test_remove_data() -> void:
	var data_list: DataList = auto_free(DataList.new()) as DataList
	var data: Data = Data.new()
	data_list.add_data(data)
	var destroy: bool = true
	data_list.remove_data(data, destroy)
	var result: bool = data_list.has_data(data)
	assert_bool(result).is_false()
