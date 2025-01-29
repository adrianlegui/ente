@icon("res://addons/mod_manager/src/icons/int_value.svg")
class_name IntValue extends Data
## Usado para guardar valores [code]int[/code].

# Valor base.
@export var _base: int = 0

# Modificador del valor.
var _mod: int = 0

## Configura el valor base.
func set_base_value(value: int) -> void:
	_base = value


## Obtiene el valor base.
func get_base_value() -> int:
	return _base


## Agrega [param value] al valor base.
func add_base_value(value: int) -> void:
	_base += value


## Configura modificacion del valor.
func set_mod_value(value: int) -> void:
	_mod = value


## Obtiene modificación del valor.
func get_mod_value() -> int:
	return _mod


## Agrega [param value] al modificador.
func add_mod_value(value: int) -> void:
	_mod += value


## Devuelve el valor actual.
func get_current_value() -> float:
	return _base + _mod


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append_array(["_base", "_mod"])
	return keys
