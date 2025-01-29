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
	return get_children() as Array[Data]


## Agrega un nodo [Data] a la lista.
func add_data(data_node: Data) -> void:
	var force_readable_name: bool = true
	add_child(data_node, force_readable_name)


## Obtiene un nodo [Data] por su identificador.[br]
## [param id]: nombre del nodo.
func get_data_by_name(id: String) -> Data:
	return get_node_or_null(id)
