# GdUnit generated TestSuite
class_name BoolValueTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://addons/ente/src/gd/bool_value.gd"


func test_set_default() -> void:
	# cambia
	var bool_value := auto_free(BoolValue.new()) as BoolValue
	bool_value.set_default(false)
	assert_bool(bool_value.get_default()).is_false()

	# no cambia
	var entity := auto_free(PersistentData.new()) as PersistentData
	add_child(entity)
	bool_value.add_blocker(entity)
	bool_value.set_default(true)
	assert_bool(bool_value.get_default()).is_false()

	# cambia con force
	var force: bool = true
	bool_value.set_default(true, force)
	assert_bool(bool_value.get_default()).is_true()


func test_get_default() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	bool_value.set_default(false)
	var result: bool = bool_value.get_default()
	assert_bool(result).is_false()


func test_is_true() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	assert_bool(bool_value.is_true()).is_true()
	var blocker: Data = auto_free(Data.new()) as Data
	add_child(blocker)
	bool_value.add_blocker(blocker)
	assert_bool(bool_value.is_true()).is_false()


func test_can_be_true() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	assert_bool(bool_value.can_be_true()).is_true()
	var blocker: Data = auto_free(Data.new()) as Data
	add_child(blocker)
	bool_value.add_blocker(blocker)
	assert_bool(bool_value.can_be_true()).is_false()


func test_add_blocker() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	var blocker: Data = auto_free(Data.new()) as Data
	add_child(blocker)
	bool_value.add_blocker(blocker)
	assert_bool(bool_value.has_blocker(blocker)).is_true()


func test_remove_blocker() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	var blocker: Data = auto_free(Data.new()) as Data
	add_child(blocker)
	bool_value.add_blocker(blocker)
	assert_bool(bool_value.has_blocker(blocker)).is_true()
	bool_value.remove_blocker(blocker)
	assert_bool(bool_value.has_blocker(blocker)).is_false()


func test_has_blocker() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	var blocker_0: Data = auto_free(Data.new()) as Data
	add_child(blocker_0)
	assert_bool(bool_value.has_blocker(blocker_0)).is_false()
	var blocker_1: Data = auto_free(Data.new()) as Data
	add_child(blocker_1)
	bool_value.add_blocker(blocker_1)
	assert_bool(bool_value.has_blocker(blocker_1)).is_true()


func test__get_persistent_properties() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	var keys: PackedStringArray = ["_blockers", "_default"]
	assert_array(bool_value._get_persistent_properties()).contains(keys)


func test__get_node_id() -> void:
	var bool_value: BoolValue = auto_free(BoolValue.new()) as BoolValue
	var node := auto_free(Node.new()) as Node
	node.name = "Nodo"
	add_child(node)
	assert_str(bool_value._get_node_id(node)).is_equal(str(node.get_path()))
