class_name PersistentDataReference extends Data
## Guarda el id de una entidad y permite obtener una refencia a esa entidad.

@export var _persistent_data_id: StringName = &""
@export var _persistent: bool = true


func is_persistent() -> bool:
	return _persistent


func set_persistent(persistent: bool) -> void:
	_persistent = persistent


## Obtiene una referencia a la entidad configurada.
func get_reference() -> Data:
	return ModManager.get_persistent_data(_persistent_data_id)


## Configura el identificador.
func set_persistent_data(persistent_data: Data) -> void:
	if not persistent_data.is_inside_tree():
		push_error("persistent_data %s no esta en el arbol de nodos." % persistent_data.name)
		return
	set_persistent_data_id(persistent_data.name)


## Obtiene el identificador de la entidad
func get_persistent_data_id() -> String:
	return _persistent_data_id


## Configura el identificador de la entidad
func set_persistent_data_id(persistent_data_id: String) -> void:
	_persistent_data_id = persistent_data_id


## Regresa [code]true[/code] si el nodo con el id correcto existe.
func persistent_data_exists() -> bool:
	return ModManager.persistent_data_exists(get_persistent_data_id())


func _get_persistent_properties() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_properties()
	if is_persistent():
		keys.append("_persistent_data_id")
	return keys
