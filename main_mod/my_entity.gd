extends Node

var my_var: bool = true


func ente_get_data() -> Dictionary:
	var data: Dictionary = {}
	data["my_var"] = my_var
	return data


func ente_set_data(data: Dictionary) -> void:
	my_var = data.get("my_var", false)


func ente_on_game_event_clean_scene_tree() -> void:
	queue_free()


func _exit_tree() -> void:
	print("%s: saliendo" % name)


func _enter_tree() -> void:
	print("%s: entrando" % name)
