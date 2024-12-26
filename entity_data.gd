class_name EntityData extends Node
## Clase base para los nodos que reciben la información de los mods.
##
## Los nodos que hereden de esta clase tiene que estar en el grupo
## [constant GROUP_PERSISTENT] para que sean guardados.
## @experimental


## Nombre del grupo de nodos persistentes.
const GROUP_PERSISTENT: StringName = &"PERSISTENT"
const EVENT_GAME_STARTED: StringName = &"_on_game_event_started"
const EVENT_UPDATE_REFERENCES: StringName = &"_update_references"
const EVENT_GAME_FIRST_START: StringName = &"_on_game_event_first_start"
const KEY_SCENE_FILE_PATH: StringName = &"scene_file_path"


## Obtiene la ruta a la escena.
func get_path_to_scene() -> String:
	return scene_file_path


## Configura la información del nodo. Sobreescribir para dar funcionalidad.
func set_data(data: Dictionary) -> void:
	pass


## Obtiene la información del nodo. Sobreescribir para extender funcionalidad.
func get_data() -> Dictionary:
	var data: Dictionary = {}
	data[KEY_SCENE_FILE_PATH] = get_path_to_scene()
	return data


## Se llama cuando el juego es iniciado.
func _on_game_event_started() -> void:
	pass


## Se llama para actualizar las referencias luego de agregar las entidades
## al arbol.
func _update_references() -> void:
	pass


## Se llama luego de cargar los nodos al arbol y no es un juego guardado.
func _on_game_event_first_start() -> void:
	pass
