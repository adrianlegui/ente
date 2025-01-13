class_name Entity extends Data
## Clase base para los nodos que reciben la información de los mods.
##
## Los nodos que hereden de esta clase tiene que estar en el grupo
## [constant GROUP_PERSISTENT] para que sean guardados.
##
## @experimental


## Nombre del grupo de nodos persistentes.
const GROUP_PERSISTENT: StringName = &"PERSISTENT"
## Nombre del método que será llamado al iniciar la partida.
const GAME_EVENT_STARTED: StringName = &"_on_game_event_started"
## Nombre del método que será llamado luego de agregar todas las entidades al
## árbol.
const GAME_EVENT_BEFORE_STARTING: StringName = (
	&"_on_game_event_before_starting"
)
## Nombre del método que sera llamado al limpiar el árbol de nodos.
const GAME_EVENT_CLEAN_SCENE_TREE: StringName = (
	&"_on_game_event_clean_scene_tree"
)
const GAME_EVENT_ALL_ENTITIES_ADDED: StringName = (
	&"_on_game_event_all_entities_added"
)


func _ready() -> void:
	_add_groups()


## Obtiene una entidad
func get_entity(entity_name: String) -> Entity:
	return get_node("/root/" + entity_name)


## Se llama cuando el juego es iniciado.
func _on_game_event_started() -> void:
	pass


## Se llama luego de agregar todas las entidades al arbol.
func _on_game_event_before_starting() -> void:
	pass


## Se llama al limpiar el arbol de nodos.
func _on_game_event_clean_scene_tree() -> void:
	queue_free()


func _on_game_event_all_entities_added() -> void:
	pass


func _get_groups() -> PackedStringArray:
	var groups: PackedStringArray = []
	groups.append(GROUP_PERSISTENT)
	return groups


func _add_groups() -> void:
	for g: String in _get_groups():
		add_to_group(g)
