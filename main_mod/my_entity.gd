extends Node

var my_var: bool = true


func ente_get_data() -> Dictionary:
	var data: Dictionary = {}
	data["my_var"] = my_var
	return data


func ente_set_data(data: Dictionary) -> void:
	my_var = data.get("my_var", false)
