class_name EntityData extends Node
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
const GAME_EVENT_BEFORE_STARTING: StringName = &"_on_game_event_before_starting"
const KEY_SCENE_FILE_PATH: StringName = &"scene_file_path"

var active: bool = false : set=set_active


func set_active(value: bool) -> void:
	active = value
	if active:
		process_mode = PROCESS_MODE_INHERIT
	else:
		process_mode = PROCESS_MODE_DISABLED


## Obtiene la ruta a la escena.
func get_path_to_scene() -> String:
	return scene_file_path


## Configura la información del nodo.
func set_data(data: Dictionary) -> void:
	for key in _get_persistent_keys():
		if data.has(key):
			set(key, data[key])


## Obtiene la información del nodo.
func get_data() -> Dictionary:
	var data: Dictionary = {}
	for key in _get_persistent_keys():
		data[key] = get(key)

	return data


## Se llama cuando el juego es iniciado.
func _on_game_event_started() -> void:
	pass


## Se llama luego de agregar todas las entidades al arbol.
func _on_game_event_before_starting() -> void:
	pass


## Devuelve [PackedStringArray] con las claves usadas para configurar el nodo.
func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = [KEY_SCENE_FILE_PATH, "active"]
	return keys
