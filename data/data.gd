class_name Data extends Node
## @experimental


const KEY_ACTIVE: StringName = &"active"


var active: bool = false : set=set_active


## Configura la información del nodo.
func set_data(data: Dictionary) -> void:
	for key in _get_persistent_keys():
		if data.has(key):
			set(key, data[key])


## Obtiene la información del nodo.
func get_data() -> Dictionary:
	var data: Dictionary = {}
	for key in _get_persistent_keys():
		data[key] = get(key)

	return data


func set_active(value: bool) -> void:
	active = value
	if active:
		process_mode = PROCESS_MODE_INHERIT
	else:
		process_mode = PROCESS_MODE_DISABLED


## Devuelve [PackedStringArray] con las claves usadas para configurar el nodo.
func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = [KEY_ACTIVE]
	return keys
