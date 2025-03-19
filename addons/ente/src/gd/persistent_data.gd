class_name PersistentData extends Data
## Clase base para los nodos que reciben la información de los mods.

## Nombre del grupo de nodos persistentes.
const GROUP_PERSISTENT: StringName = &"PERSISTENT_DATA"


## Obtiene una entidad
func get_persistent_data(persistent_data_id: String) -> PersistentData:
	var persistent_data: PersistentData = null
	if is_inside_tree():
		if not persistent_data_id.is_empty():
			persistent_data = get_node_or_null("/root/" + persistent_data_id)
		else:
			push_error("persistent_data_id esta vacio")
	else:
		push_error("%s: no esta en SceneTree, llamando get_persistent_data, retorno null" % name)
	return persistent_data


## Se llama cuando el juego es iniciado.[br]
## [color=yellow]Método virtual.[/color]
func _on_game_event_started() -> void:
	pass


## Se llama luego de agregar todas las entidades al [SceneTree].[br]
## [color=yellow]Método virtual.[/color]
func _on_game_event_before_starting() -> void:
	pass


## Se llama al limpiar el arbol de nodos.[br]
## [color=yellow]Método virtual.[/color]
func _on_game_event_clean_scene_tree() -> void:
	queue_free()


## Se llama luego de que se agregaron todas las entidades al [SceneTree].[br]
## [color=yellow]Método virtual.[/color]
func _on_game_event_all_entities_added() -> void:
	pass


## Se llama antes de guardar la partida.[br]
## [color=yellow]Método virtual.[/color]
func _on_game_event_before_saving() -> void:
	pass


## Regresa una [Entity] con los datos de [param data].
static func create_persistent_data(data: Dictionary) -> PersistentData:
	return Data.create_data_node(data)
