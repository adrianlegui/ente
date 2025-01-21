@icon("res://addons/mod_manager/src/icons/int_value.svg")
class_name IntValue extends Data
## Usado para guardar valores [code]int[\code].
##
## @experimental

## Valor base.
@export var _base: int = 0

## Modificador del valor.
var _mod: int = 0

func set_base_value(value: int) -> void:
	_base = value


func get_base_value() -> int:
	return _base


func set_mod_value(value: int) -> void:
	_mod = value


func get_mod_value() -> int:
	return _mod


func add_mod_value(value: int) -> void:
	_mod += value


## Devuelve el valor actual.
func get_current_value() -> float:
	return _base + _mod


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append_array(["_base", "_mod"])
	return keys
