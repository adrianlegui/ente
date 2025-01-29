@icon("res://addons/mod_manager/src/icons/float_value.svg")
class_name FloatValue extends Data
## Usado para guardar valores [code]float[/code].

# Valor base.
@export var _base: float = 0.0

# Modificador del valor.
var _mod: float = 0.0

## Configura el valor base.
func set_base_value(value: float) -> void:
	_base = value


## obtiene el valor base.
func get_base_value() -> float:
	return _base


## Agrega [param value] al valor base.
func add_base_value(value: float) -> void:
	_base += value


## Configura el modificador del valor.
func set_mod_value(value: float) -> void:
	_mod = value


## Obtiene el modificador del valor:
func get_mod_value() -> float:
	return _mod


## Agrega [param value] al modificador del valor.
func add_mod_value(value: float) -> void:
	_mod += value


## Devuelve el valor actual.
func get_current_value() -> float:
	return _base + _mod


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append_array(["_base", "_mod"])
	return keys
