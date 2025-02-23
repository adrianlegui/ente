class_name Entity extends Data
## Clase base para los nodos que reciben la información de los mods.

## Nombre del grupo de nodos persistentes.
const GROUP_PERSISTENT: StringName = &"PERSISTENT"


## Obtiene una entidad
func get_entity(entity_name: String) -> Entity:
	var entity: Entity = null
	if is_inside_tree():
		if not entity_name.is_empty():
			entity = get_node_or_null("/root/" + entity_name)
		else:
			push_error("entity_name esta vacio")
	else:
		push_error("llamando get_entity en %s que no esta en SceneTree, retorno null" % name)
	return entity


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


func _get_groups() -> PackedStringArray:
	var groups: PackedStringArray = super._get_groups()
	groups.append_array([GROUP_PERSISTENT, GameEvents.GROUP])
	return groups


## Regresa una [Entity] con los datos de [param data].
static func create_entity(data: Dictionary) -> Entity:
	return Data.create_data_node(data)
