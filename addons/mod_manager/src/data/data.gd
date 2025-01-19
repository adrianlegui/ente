class_name Data extends Node
## @experimental


## Nombre de la propiedad con la ruta a la escena.
const KEY_SCENE_FILE_PATH: StringName = &"scene_file_path"
const KEY_PROPERTIES: StringName = &"PROPERTIES"


# Configura la información del nodo.
func _set_data(data: Dictionary) -> void:
	var properties: Dictionary = data.get(KEY_PROPERTIES, {}) as Dictionary
	if properties.is_empty():
		return
	for key in properties.keys():
		_set_property(key, properties[key])


func _set_property(key: String, property: Variant) -> void:
		if key in _get_not_settable_keys():
			return
		var v_node = get(key)
		if typeof(v_node) == TYPE_OBJECT:
			var data: Data = v_node as Data
			if data:
				data._set_data(property)
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
func get_data() -> Dictionary:
	var properties: Dictionary = {}
	for key in _get_persistent_keys():
		var v_node = get(key) # variable del nodo
		if typeof(v_node) == TYPE_OBJECT:
			var obj: Data = v_node as Data
			if is_instance_valid(obj):
				properties[key] = obj.get_data()
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

	var data: Dictionary = {KEY_SCENE_FILE_PATH: scene_file_path}
	data[KEY_PROPERTIES] = properties

	return data


## Devuelve [PackedStringArray] con las claves usadas para configurar el nodo.
func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = ["process_mode"]
	return keys


## Devuelve [PackedStringArray] con las claves que no tiene que configurar.
func _get_not_settable_keys() -> PackedStringArray:
	var keys: PackedStringArray = []
	keys.append(KEY_SCENE_FILE_PATH)
	return keys


func _needs_conversion(variant: Variant) -> bool:
	var type: int = typeof(variant)
	return (
		type == TYPE_VECTOR3
	)


func _can_be_saved(variable) -> bool:
	var type: int = typeof(variable)
	return (
		type == TYPE_BOOL or
		type == TYPE_INT or
		type == TYPE_FLOAT or
		type == TYPE_STRING or
		type == TYPE_STRING_NAME or
		type == TYPE_VECTOR3 or
		type == TYPE_PACKED_STRING_ARRAY
	)


static func create_data_node(dict: Dictionary) -> Data:
	var data: Data = null
	var path: String = dict.get(KEY_SCENE_FILE_PATH, "") as String
	if path.is_empty():
		push_error("falta scene_file_path")
	else:
		var pck: PackedScene = load(path) as PackedScene
		if pck:
			data = pck.instantiate()
			data._set_data(dict)
	return data
