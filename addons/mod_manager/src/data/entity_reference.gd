class_name EntityReference extends Data
## Guarda el id de una entidad y permite obtener una refencia a esa
## entidad.

@export var _entity_id: StringName = &""

func get_reference() -> Entity:
	return MOD_MANAGER.get_entity(_entity_id)


func get_entity_id() -> String:
	return _entity_id


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append("_entity_id")
	return keys
