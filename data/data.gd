class_name Data extends Node
## @experimental


var active: bool = false : set=set_active


## Configura la información del nodo.
func set_data(data: Dictionary) -> void:
	for key in _get_persistent_keys():
		if data.has(key):
			if key in _get_not_settable_keys():
				continue
			var v_data = data[key]
			var v_node = get(key)
			if typeof(v_node) == TYPE_OBJECT:
				var obj: Data = v_node as Data
				assert(is_instance_valid(obj))
				obj.set_data(v_data)
			else:
				set(key, str_to_var(data[key]))


## Obtiene la información del nodo.
func get_data() -> Dictionary:
	var data: Dictionary = {}
	for key in _get_persistent_keys():
		var v_node = get(key)
		if typeof(v_node) == TYPE_OBJECT:
			var obj: Data = v_node as Data
			assert(is_instance_valid(obj))
			data[key] = obj.get_data()
		else:
			data[key] = var_to_str(v_node)

	return data


func set_active(value: bool) -> void:
	active = value
	if active:
		process_mode = PROCESS_MODE_INHERIT
	else:
		process_mode = PROCESS_MODE_DISABLED


## Devuelve [PackedStringArray] con las claves usadas para configurar el nodo.
func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = ["active"]
	return keys


## Devuelve [PackedStringArray] con las claves que no tiene que configurar.
func _get_not_settable_keys() -> PackedStringArray:
	var keys: PackedStringArray = []
	return keys
