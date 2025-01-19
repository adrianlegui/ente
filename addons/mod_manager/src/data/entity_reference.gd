class_name EntityReference extends Data
## Guarda el id de una entidad y permite obtener una refencia a esa
## entidad.


@export var entity_id: StringName = &""


func get_reference() -> Entity:
	return MOD_MANAGER.get_entity(entity_id)


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append("entity_id")
	return keys
