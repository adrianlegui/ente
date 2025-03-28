class_name Data extends Node
## Nodo con propiedades persistentes.

## Nombre de la propiedad con la ruta a la escena.
const KEY_SCENE_FILE_PATH: String = "scene_file_path"


## Regresa un nodo de clase [Data] con las propiedades persistentes
## configuradas.
static func create_data_node(dict: Dictionary) -> Data:
	var data: Data = null
	var path: String = dict.get(KEY_SCENE_FILE_PATH, "") as String
	if path.is_empty():
		push_error("falta scene_file_path")
	else:
		var pck: PackedScene = load(path) as PackedScene
		if pck:
			data = pck.instantiate() as Data
			data.set_data(dict)
	return data


## Obtiene un [Dictionary] con la información persistente del nodo.
func get_data() -> Dictionary:
	var data: Dictionary = {KEY_SCENE_FILE_PATH: scene_file_path}
	data = _get_properties(data)
	return data


## Configura el nodo.
func set_data(data: Dictionary) -> void:
	if data.is_empty():
		return
	set_properties(data)


## Configura las propiedades persistentes del nodo.
func set_properties(properties: Dictionary) -> void:
	for key in properties.keys():
		_set_property(key, properties[key])


# configura una propiedad.
func _set_property(key: String, property: Variant) -> void:
	if key in _get_not_settable_keys():
		return
	var v_node = get(key)
	if v_node == null and typeof(property) == TYPE_DICTIONARY:
		_set_null_node_variable(key, property)
	elif typeof(v_node) == TYPE_OBJECT:
		_set_object_node_variable(key, property)
	elif not _can_be_saved(v_node):
		push_warning(
			"%s.%s es de tipo %s y no puede ser cargado" % [name, key, type_string(typeof(v_node))]
		)
		return
	else:
		set(key, property)


## Obtiene las propiedades persitentes del nodo.
func _get_properties(properties: Dictionary) -> Dictionary:
	for key in _get_persistent_properties():
		var v_node = get(key)  # variable del nodo
		if typeof(v_node) == TYPE_OBJECT:
			var data: Data = v_node as Data
			if is_instance_valid(data):
				properties[key] = data.get_data()
			else:
				push_warning("variable %s.%s no es de clase Data" % [name, key])
		elif not _can_be_saved(v_node):
			push_warning(
				(
					"%s.%s es de tipo %s y no puede ser guardado"
					% [name, key, type_string(typeof(v_node))]
				)
			)
			continue
		else:
			properties[key] = v_node

	return properties


# Regresa [PackedStringArray] con las propiedades persistentes.
func _get_persistent_properties() -> PackedStringArray:
	var properties: PackedStringArray = []
	_add_extra_persistent_properties(properties)
	return properties


## Sobreescribir para agregar propiedades persistentes.
## [color=yellow]Método virtual.[/color]
func _add_extra_persistent_properties(persistent_properties: PackedStringArray) -> void:
	pass


## Devuelve [PackedStringArray] con las claves que no tiene que configurar.
func _get_not_settable_keys() -> PackedStringArray:
	var keys: PackedStringArray = []
	keys.append(KEY_SCENE_FILE_PATH)
	return keys


func _can_be_saved(variable) -> bool:
	var type: int = typeof(variable)
	return (
		type == TYPE_BOOL
		or type == TYPE_INT
		or type == TYPE_FLOAT
		or type == TYPE_STRING
		or type == TYPE_STRING_NAME
		or type == TYPE_VECTOR2
		or type == TYPE_VECTOR3
		or type == TYPE_PACKED_STRING_ARRAY
		or type == TYPE_TRANSFORM2D
		or type == TYPE_TRANSFORM3D
	)


func _set_null_node_variable(key: String, property: Dictionary) -> void:
	var data: Data = create_data_node(property)

	if not is_instance_valid(data):
		return

	data.name = key.capitalize().replace(" ", "")
	set(key, data)
	var force_readable_name: bool = true
	add_child(data, force_readable_name)


func _set_object_node_variable(key: String, property: Dictionary) -> void:
	var v_node = get(key)
	var data: Data = get(key) as Data
	if is_instance_valid(data):
		data.set_data(property)
	else:
		push_warning("variable %s.%s no es de clase Data" % [name, key])


func _on_game_event_clean_scene_tree() -> void:
	queue_free()
