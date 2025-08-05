class_name EnteGameEvents extends RefCounted
## Contiene nombre de grupo y nombre de los métodos que serán llamados en los eventos del juego.
##
## Para recibir el evento del juego un nodo tiene tener el método correspondiente al evento
## implementado y tiene que estar en el grupo [param GameEvents.GROUP].

## Grupo en el que tienen que estar un nodo para recibir los eventos del juego.
const GROUP: StringName = "ENTE_GAME_EVENTS"

## Nombre del método que será llamado al iniciar la partida.
## [codeblock]
## func _ente_on_game_event_started() -> void:
##     pass
## [/codeblock]
const STARTED: StringName = &"_ente_on_game_event_started"

## Nombre del método que será llamado luego de agregar todas las entidades al [SceneTree].
## Implementar el método para recibir este evento.
## [codeblock]
## func _ente_on_game_event_before_starting() -> void:
##     pass
## [/codeblock]
const BEFORE_STARTING: StringName = &"_ente_on_game_event_before_starting"

## Nombre del método que será llamado al limpiar el árbol de nodos. Sobreescribir método
## [code]_on_game_event_clean_scene_tree[/code] para agregar lógica extra.
## [codeblock]
## func _ente_on_game_event_clean_scene_tree() -> void:
##     queue_free()
## [/codeblock]
const CLEAN_SCENE_TREE: StringName = &"_ente_on_game_event_clean_scene_tree"

## Nombre del método que será llamado al agregar todas las entidades al [SceneTree] cuando se inicia
## una partida o se carga una partida guardada. Implementar el método para recibir este evento.
## [codeblock]
## func _ente_on_game_event_all_entities_added() -> void:
##     pass
## [/codeblock]
const ALL_ENTITIES_ADDED: StringName = &"_ente_on_game_event_all_entities_added"

## Nombre del método que será llamado antes de guardar la partida. Implementar el método para
## recibir este evento.
## [codeblock]
## func _ente_on_game_event_before_saving() -> void:
##     pass
## [/codeblock]
const BEFORE_SAVE: StringName = &"_ente_on_game_event_before_saving"
