@icon("res://addons/mod_manager/data/float_value/icon_float_value.svg")
class_name FloatValue extends Data
## Usado para guardar valores float.
##
## @experimental


## Valor base.
@export var base: float = 0.0
## Modificador del valor.
@export var mod: float = 0.0


## Devuelve el valor actual.
func get_current_value() -> float:
	return base + mod


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append_array(["base", "mod"])
	return keys
