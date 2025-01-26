class_name Data extends Node
## @experimental


# Configura las propiedades
func set_properties(properties: Dictionary) -> void:
	for key in properties.keys():
		_set_property(key, properties[key])


func _set_property(key: String, property: Variant) -> void:
		if key in _get_not_settable_keys():
			return
		var v_node = get(key)
		if typeof(v_node) == TYPE_OBJECT:
			var data: Data = v_node as Data
			if data:
				data.set_properties(property)
			else:
				push_warning("variable %s.%s no es de clase Data" % [name, key])
		elif not _can_be_saved(v_node):
			push_warning(
				"%s.%s es de tipo %s y no puede ser cargado" % [
					name,
					key,
					type_string(typeof(v_node))
				]
			)
			return
		elif _needs_conversion(v_node):
			set(key, str_to_var(property))
		else:
			set(key, property)


## Obtiene la información del nodo.
func get_properties() -> Dictionary:
	var properties: Dictionary = {}
	for key in _get_persistent_keys():
		var v_node = get(key) # variable del nodo
		if typeof(v_node) == TYPE_OBJECT:
			var data: Data = v_node as Data
			if is_instance_valid(data):
				properties[key] = data.get_properties()
			else:
				push_warning("variable %s.%s no es de clase Data" % [name, key])
		elif not _can_be_saved(v_node):
			push_warning(
				"%s.%s es de tipo %s y no puede ser guardado" % [
					name,
					key,
					type_string(typeof(v_node))
				]
			)
			continue
		elif _needs_conversion(v_node):
			properties[key] = var_to_str(v_node)
		else:
			properties[key] = v_node

	return properties


## Devuelve [PackedStringArray] con las claves usadas para configurar el nodo.
func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = ["process_mode"]
	return keys


## Devuelve [PackedStringArray] con las claves que no tiene que configurar.
func _get_not_settable_keys() -> PackedStringArray:
	return []


func _needs_conversion(variant: Variant) -> bool:
	var type: int = typeof(variant)
	return (
		type == TYPE_VECTOR2 or
		type == TYPE_VECTOR3 or
		type == TYPE_TRANSFORM2D or
		type == TYPE_TRANSFORM3D
	)


func _can_be_saved(variable) -> bool:
	var type: int = typeof(variable)
	return (
		type == TYPE_BOOL or
		type == TYPE_INT or
		type == TYPE_FLOAT or
		type == TYPE_STRING or
		type == TYPE_STRING_NAME or
		type == TYPE_VECTOR2 or
		type == TYPE_VECTOR3 or
		type == TYPE_PACKED_STRING_ARRAY or
		type == TYPE_TRANSFORM2D or
		type == TYPE_TRANSFORM3D
	)
