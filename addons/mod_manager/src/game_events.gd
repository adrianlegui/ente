class_name GameEvents extends RefCounted


const GROUP: StringName = "GAME_EVENTS"
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
