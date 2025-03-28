class_name DataList extends Data
## Lista de nodos [Data].


## Configura los nodos [Data] de la lista.
func set_data(data: Dictionary) -> void:
	var force_readable: bool = true
	for id in data:
		if id == KEY_SCENE_FILE_PATH:
			continue

		if typeof(data[id]) != TYPE_DICTIONARY:
			_set_property(id, data[id])

		var d: Data = get_node_or_null(id) as Data
		if d != null:
			d.set_data(data[id])
		else:
			var data_node: Data = Data.create_data_node(data[id])
			if data_node != null:
				data_node.name = id
				add_child(data_node, force_readable)


## Obtiene un [Dictionary] con la información persistente de todos los nodos
## [Data] de la lista.
func get_data() -> Dictionary:
	var data: Dictionary = super.get_data()
	for child in get_children():
		var data_node: Data = child as Data
		if data_node != null:
			data[str(data_node.name)] = data_node.get_data()
	return data
