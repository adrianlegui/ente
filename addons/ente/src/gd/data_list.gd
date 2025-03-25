class_name DataList extends Data
## Lista de nodos [Data].


## Configura los nodos [Data] de la lista.
func set_data(data: Dictionary) -> void:
	for id in data:
		var d: Data = get_node_or_null(id)
		if d != null:
			d.set_data(data[id])
		else:
			var data_node: Data = Data.create_data_node(data[id])
			data_node.name = id
			add_data_node(data_node)


## Obtiene un [Dictionary] con la información persistente de todos los nodos
## [Data] de la lista.
func get_data() -> Dictionary:
	var data: Dictionary = {}
	for child in get_children():
		var data_node: Data = child as Data
		if data_node != null:
			data[data_node.name] = data_node.get_data()
	return data


## Agrega [param data_node] a la lista y luego regresa el mismo nodo. Si [param only_one] es
## [code]true[/code] se comprobará si ya existe algún nodo con la misma scene_file_path, si existe
## no se agregará y se regresará el ya nodo existente.
func add_data_node(data_node: Data, only_one: bool = false) -> Data:
	data_node.set_unique(false)
	var force_readable_name: bool = true

	if only_one:
		if data_node.scene_file_path.is_empty():
			push_error("%s no es una escena. No se pudo agregar a %s" % [data_node.name, name])
			return null

		for node: Node in get_children():
			var path: String = node.scene_file_path
			if path.is_empty():
				continue
			elif path == data_node.scene_file_path:
				if not data_node.is_unique():
					data_node.delete()
				return node

	add_child(data_node, force_readable_name)

	return data_node


## Quita nodo [param data_node] de la lista. Si [param destroy] es [code]true[/code]
## Quita el nodo y lo borra.
func remove_data_node(data_node: Data, destroy: bool = false) -> void:
	if data_node in get_children():
		remove_child(data_node)
		if destroy:
			data_node.delete()


## Quita nodo con nombre [param data_node_name] de la lista. Si [param destroy] es
## [code]true[/code] Quita el nodo y lo borra.
func remove_data_node_by_name(data_node_name: String, destroy: bool = false) -> void:
	var data_node: Data = get_node_or_null(data_node_name)
	if data_node != null:
		remove_data_node(data_node)
