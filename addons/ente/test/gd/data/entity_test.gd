# GdUnit generated TestSuite
class_name EntityTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/ente/src/gd/data/entity.gd'


func test_get_entity_not_inside_tree_return_null() -> void:
	var entity: Entity = auto_free(Entity.new()) as Entity
	var entity_name: String = "EntityName"
	assert_object(entity.get_entity(entity_name)).is_null()
