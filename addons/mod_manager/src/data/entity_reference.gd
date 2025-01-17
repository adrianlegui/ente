class_name EntityReference extends Data
## Guarda el id de una entidad y permite obtener una refencia a esa
## entidad.


@export var entity_id: StringName = &""


var _reference: Entity


func _ready() -> void:
	add_to_group(GameEvents.GROUP)


func get_reference() -> Entity:
	return _reference


func _on_game_event_all_entities_added() -> void:
	if entity_id.is_empty():
		push_error("entity_id esta vacio")
	_reference = get_node_or_null("/root/" + entity_id)
