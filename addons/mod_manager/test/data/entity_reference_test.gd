# GdUnit generated TestSuite
class_name EntityReferenceTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/mod_manager/src/data/entity_reference.gd'
var ref: EntityReference
var ent: Entity

func before_test() -> void:
	ref = auto_free(EntityReference.new()) as EntityReference
	ent = auto_free(Entity.new()) as Entity
	ent.add_child(ref)
	MOD_MANAGER.add_entity(ent)


func test_get_reference() -> void:
	ref.set_entity_id(ent.name)
	assert_object(ref.get_reference()).is_same(ent)


func test_get_entity_id() -> void:
	var id_0: String = "Id0"
	ref.set_entity_id(id_0)
	assert_str(ref.get_entity_id()).is_equal(id_0)


func test_set_entity_id() -> void:
	var id: String = ent.name
	ref.set_entity_id(id)
	assert_str(ref.get_entity_id()).is_equal(id)


func test__get_persistent_keys() -> void:
	var result: PackedStringArray = ref._get_persistent_keys()
	assert_array(result).contains(["_entity_id"])


func test_entity_exists() -> void:
	ref.set_entity_id("no_existe")
	assert_bool(ref.entity_exists()).is_false()
	ref.set_entity_id(ent.name)
	assert_bool(ref.entity_exists()).is_true()
