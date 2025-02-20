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
			data_node.set_unique(false)
			data_node.name = id
			add_data(data_node)


## Obtiene un [Dictionary] con la información persistente de todos los nodos
## [Data] de la lista.
func get_data() -> Dictionary:
	var data: Dictionary = {}
	for child in get_children():
		var data_node: Data = child as Data
		if data_node != null:
			data[data_node.name] = data_node.get_data()
	return data


## Obtiene el [Array] de nodos [Data].
func get_data_nodes() -> Array[Data]:
	var array: Array[Data]
	array.assign(get_children())
	return array


## Agrega [param data] a la lista y luego regresa el mismo nodo. Si [param only_one] es
## [code]true[/code] se comprobará si ya existe algún nodo con la misma scene_file_path, si existe
## no se agregará y se regresará el ya nodo existente.
## @deprecated
func add_data(data: Data, only_one: bool = false) -> Data:
	push_warning("This method has been deprecated, use add_data_node instead.")
	return add_data_node(data, only_one)


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

		for node: Node in get_data_nodes():
			var path: String = node.scene_file_path
			if path.is_empty():
				continue
			elif path == data_node.scene_file_path:
				if not data_node.is_unique():
					data_node.delete()
				return node

	add_child(data_node, force_readable_name)

	return data_node


## Obtiene un nodo [Data] por su identificador.[br]
## [param id]: nombre del nodo.
## @deprecated
func get_data_by_name(id: String) -> Data:
	push_warning("This method has been deprecated, use get_data_node_by_name instead.")
	return get_data_node_by_name(id)


## Obtiene un nodo [Data] por su identificador.[br]
## [param id]: nombre del nodo.
func get_data_node_by_name(id: String) -> Data:
	if id.is_empty():
		return null
	return get_node_or_null(id)


## Regresa [code]true[/code] si [param data] se encuentra en la lista.
## @deprecated
func has_data(data: Data) -> bool:
	push_warning("This method has been deprecated, use has_data_node instead.")
	return has_data_node(data)


## Regresa [code]true[/code] si [param data_node] se encuentra en la lista.
func has_data_node(data_node: Data) -> bool:
	return data_node in get_children()


## Quita nodo [param data] de la lista. Si [param destroy] es [code]true[/code]
## Quita el nodo y lo borra.
func remove_data(data: Data, destroy: bool = false) -> void:
	push_warning("This method has been deprecated, use remove_data_node instead.")
	remove_data_node(data, destroy)


## Quita nodo [param data_node] de la lista. Si [param destroy] es [code]true[/code]
## Quita el nodo y lo borra.
func remove_data_node(data_node: Data, destroy: bool = false) -> void:
	if has_data(data_node):
		remove_child(data_node)
		if destroy:
			data_node.delete()


## Quita nodo con nombre [param data_node_name] de la lista. Si [param destroy] es
## [code]true[/code] Quita el nodo y lo borra.
func remove_data_node_by_name(data_node_name: String, destroy: bool = false) -> void:
	var data_node: Data = get_data_by_name(data_node_name)
	if data_node != null:
		remove_data_node(data_node)
