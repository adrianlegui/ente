class_name EntityReference extends Data
## Guarda el id de una entidad y permite obtener una refencia a esa
## entidad.

@export var _entity_id: StringName = &""

## Obtiene una referencia a la entidad configurada.
func get_reference() -> Entity:
	return MOD_MANAGER.get_entity(_entity_id)


## Obtiene el identificador de la entidad
func get_entity_id() -> String:
	return _entity_id


## Configura el identificador de la entidad
func set_entity_id(entity_id: String) -> void:
	_entity_id = entity_id


## Regresa [code]true[/code] si la entidad existe.
func entity_exists() -> bool:
	return MOD_MANAGER.entity_exists(get_entity_id())


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append("_entity_id")
	return keys
