extends Entity


@export var my_data: Data
@export var my_not_data_node: Node
@export var my_entity_reference: EntityReference
var my_bool: bool = false
var my_int: int = 0
var my_string: String = "my_string"
var my_string_name: StringName = "my_string_name"
var my_float: float = 0.0
var my_packed_string_array: PackedStringArray = []
var my_array: Array = []


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append_array(
		[
			"my_bool",
			"my_int",
			"my_string",
			"my_string_name",
			"my_float",
			"my_data",
			"my_packed_string_array",
			"my_array",
			"my_not_data_node",
			"my_entity_reference"
		]
	)
	return keys


func _on_game_event_all_entities_added() -> void:
	print(name +": " + "todas las entidades agregadas")


func _on_game_event_before_starting() -> void:
	print(name +": " + "antes de iniciar")


## Se llama cuando el juego es iniciado.
func _on_game_event_started() -> void:
	print(name +": " + "iniciando")
	if name == "EntityForTest":
		print("guardando partida")
		MOD_MANAGER.save_game("partida_guardada")
