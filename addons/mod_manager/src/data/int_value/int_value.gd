@icon("res://addons/mod_manager/src/data/int_value/icon_int_value.svg")
class_name IntValue extends Data
## Usado para guardar valores [code]int[\code].
##
## @experimental


## Valor base.
@export var base: int = 0.0
## Modificador del valor.
@export var mod: int = 0.0


## Devuelve el valor actual.
func get_current_value() -> int:
	return base + mod


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append_array(["base", "mod"])
	return keys
