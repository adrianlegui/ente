# GdUnit generated TestSuite
class_name EntityReferenceTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

# TestSuite generated from
const __source = "res://addons/mod_manager/src/gd/data/entity_reference.gd"
var entity_reference: EntityReference
var ent: Entity


func before_test() -> void:
	entity_reference = auto_free(EntityReference.new()) as EntityReference
	ent = auto_free(Entity.new()) as Entity
	ent.add_child(entity_reference)
	ModManager.add_entity(ent)


func test_get_reference() -> void:
	entity_reference.set_entity_id(ent.name)
	assert_object(entity_reference.get_reference()).is_same(ent)


func test_get_entity_id() -> void:
	var id_0: String = "Id0"
	entity_reference.set_entity_id(id_0)
	assert_str(entity_reference.get_entity_id()).is_equal(id_0)


func test_set_entity_id() -> void:
	var id: String = ent.name
	entity_reference.set_entity_id(id)
	assert_str(entity_reference.get_entity_id()).is_equal(id)


func test__get_persistent_properties() -> void:
	assert_array(entity_reference._get_persistent_properties()).contains(
		["_entity_id", "_persistent_entity_id"]
	)
	entity_reference.set_persistent_entity_id(false)
	assert_array(entity_reference._get_persistent_properties()).not_contains(["_entity_id"])


func test_entity_exists() -> void:
	entity_reference.set_entity_id("no_existe")
	assert_bool(entity_reference.entity_exists()).is_false()
	entity_reference.set_entity_id(ent.name)
	assert_bool(entity_reference.entity_exists()).is_true()


func test_set_entity() -> void:
	var entity_reference: EntityReference = auto_free(EntityReference.new()) as EntityReference
	var entity: Entity = auto_free(Entity.new())
	ModManager.add_entity(entity)
	entity_reference.set_entity(entity)
	assert_object(entity_reference.get_reference()).is_same(entity)
