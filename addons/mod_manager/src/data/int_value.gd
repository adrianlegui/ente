@icon("res://addons/mod_manager/src/icons/int_value.svg")
class_name IntValue extends Data
## Usado para guardar valores [code]int[/code].

## Valor base.
@export var _base: int = 0
## Si es [code]true[/code] el valor base es persistente.
@export var _base_persistent: bool = true
## Si es [code]true[/code] el modificador del valor es persistente.
@export var _mod_persistent: bool = true

## Modificador del valor.
var _mod: int = 0

## Regresa [code]true[/code] si el modificador del valor es persistente.
func is_base_persistent() -> bool:
	return _base_persistent


## Configura si el valor base es persistente.
func set_base_persistent(base_persistent: bool) -> void:
	_base_persistent = base_persistent


## Regresa [code]true[/code] si el valor base es persistente.
func is_mod_persistent() -> bool:
	return _mod_persistent


## Configura si el modificador del valor es persistente.
func set_mod_persistent(mod_persistent: bool) -> void:
	_mod_persistent = mod_persistent


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
func get_current_value() -> int:
	return _base + _mod


func _get_persistent_properties() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_properties()
	keys.append_array(
		[
			"_base_persistent",
			"_mod_persistent"
		]
	)
	if is_base_persistent():
		keys.append("_base")
	if is_mod_persistent():
		keys.append("_mod")
	return keys
