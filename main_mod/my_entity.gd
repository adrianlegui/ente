@tool
extends Node

@export var my_var: bool = true


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	await EnteModManager.all_entities_added
	print("%s: todas las entidades agregadas" % name)
	await EnteModManager.before_start
	print("%s: antes de iniciar" % name)
	await EnteModManager.started_game
	print("%s: iniciando" % name)


func ente_get_data() -> Dictionary:
	var data: Dictionary = {}
	data["my_var"] = my_var
	return data


func ente_set_data(data: Dictionary) -> void:
	my_var = data.get("my_var", false)


func ente_on_game_event_clean_scene_tree() -> void:
	queue_free()


func _exit_tree() -> void:
	if Engine.is_editor_hint():
		return
	print("%s: saliendo" % name)


func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return
	print("%s: entrando" % name)
