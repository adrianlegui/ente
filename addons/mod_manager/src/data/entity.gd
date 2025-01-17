class_name Entity extends Data
## Clase base para los nodos que reciben la información de los mods.
##
## Los nodos que hereden de esta clase tiene que estar en el grupo
## [constant GROUP_PERSISTENT] para que sean guardados.
##
## @experimental


## Nombre del grupo de nodos persistentes.
const GROUP_PERSISTENT: StringName = &"PERSISTENT"


func _ready() -> void:
	_add_groups()


## Obtiene una entidad
func get_entity(entity_name: String) -> Entity:
	var entity: Entity = null
	if is_inside_tree():
		if not entity_name.is_empty():
			entity = get_node_or_null("/root/" + entity_name)
		else:
			push_error("entity_name esta vacio")
	else:
		push_error(
			"llamando get_entity en %s que no esta en SceneTree, retorno null" % name
		)
	return entity


## Se llama cuando el juego es iniciado.
func _on_game_event_started() -> void:
	pass


## Se llama luego de agregar todas las entidades al arbol.
func _on_game_event_before_starting() -> void:
	pass


## Se llama al limpiar el arbol de nodos.
func _on_game_event_clean_scene_tree() -> void:
	queue_free()


## Se llama luego de que se agregaron todas las entidades al
## SceneTree.
func _on_game_event_all_entities_added() -> void:
	pass


func _get_groups() -> PackedStringArray:
	var groups: PackedStringArray = []
	groups.append_array(
		[
			GROUP_PERSISTENT,
			GameEvents.GROUP
		]
	)
	return groups


func _add_groups() -> void:
	for g: String in _get_groups():
		add_to_group(g)
