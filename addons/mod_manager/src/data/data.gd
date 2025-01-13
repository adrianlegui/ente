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
	for key in _get_persistent_keys():
		if properties.has(key):
			_set_property(key, properties)


func _set_property(key: String, properties: Dictionary) -> void:
		if key in _get_not_settable_keys():
			return
		var v_data = properties[key]
		var v_node = get(key)
		if typeof(v_node) == TYPE_OBJECT:
			var data: Data = v_node as Data
			if data:
				data._set_data(v_data)
			else:
				push_warning("variable %s.%s no es de clase Data" % [name, key])
		elif _no_needs_conversion(v_node):
			set(key, properties[key])
		else:
			set(key, str_to_var(properties[key]))


## Obtiene la información del nodo.
func get_data() -> Dictionary:
	var properties: Dictionary = {}
	for key in _get_persistent_keys():
		var v_node = get(key)
		if typeof(v_node) == TYPE_OBJECT:
			var obj: Data = v_node as Data
			if is_instance_valid(obj):
				properties[key] = obj.get_data()
			else:
				push_warning("variable %s.%s no es de clase Data" % [name, key])
		elif _no_needs_conversion(v_node):
			properties[key] = v_node
		else:
			properties[key] = var_to_str(v_node)

	var data: Dictionary = {KEY_SCENE_FILE_PATH: scene_file_path}
	data[KEY_PROPERTIES] = properties

	return data


## Devuelve [PackedStringArray] con las claves usadas para configurar el nodo.
func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = ["process_mode"]
	keys.append(KEY_SCENE_FILE_PATH)
	return keys


## Devuelve [PackedStringArray] con las claves que no tiene que configurar.
func _get_not_settable_keys() -> PackedStringArray:
	var keys: PackedStringArray = []
	keys.append(KEY_SCENE_FILE_PATH)
	return keys


func _no_needs_conversion(variant: Variant) -> bool:
	return (
		typeof(variant) == TYPE_INT or
		typeof(variant) == TYPE_BOOL or
		typeof(variant) == TYPE_STRING or
		typeof(variant) == TYPE_FLOAT or
		typeof(variant) == TYPE_STRING_NAME
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
