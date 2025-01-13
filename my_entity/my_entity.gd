extends EntityData


var my_bool: bool = false
var my_int: int = 0
var my_string: String = "my_string"
var my_string_name: StringName = "my_string_name"
var my_float: float = 0.0


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append_array(
		[
			"my_bool",
			"my_int",
			"my_string",
			"my_string_name",
			"my_float"
		]
	)
	return keys


func _on_game_event_all_entities_added() -> void:
	print("todas las entidades agregadas")


func _on_game_event_before_starting() -> void:
	print("antes de iniciar")


## Se llama cuando el juego es iniciado.
func _on_game_event_started() -> void:
	print("iniciando")
