@icon("res://addons/ente/src/resources/icons/bool_value.svg")
class_name BoolValue extends Data
## Configura y administra variable [code]bool[/code],

## Se emite cuando el valor default cambia.
signal value_changed

## Valor predeteminado
@export var _default: bool = true

# Arreglo de bloqueadores.
var _blockers: PackedStringArray = []


## Configura valor default.
func set_default(value: bool, force: bool = false) -> void:
	if _default == value:
		return

	var before: bool = _default
	if force:
		_default = value
	else:
		_default = value and can_be_true()

	if before != _default:
		value_changed.emit()


## Obtiene valor default.
func get_default() -> bool:
	return _default


## Regresa [code]true[/code] si [BoolValue] es [code]true[/code].
func is_true() -> bool:
	return _default if _blockers.size() == 0 else false


## Regresa [code]true[/code] si no hay bloqueadores bloqueando [BoolValue].
func can_be_true() -> bool:
	return _blockers.size() == 0


## Agrega un bloqueador que bloquea al [BoolValue].
func add_blocker(blocker: String) -> void:
	if blocker.is_empty():
		push_error("blocker está vacio")
		return
	if not _blockers.has(blocker):
		_blockers.append(blocker)
		value_changed.emit()


## Quita un bloqueador que bloquea al [BoolValue].
func remove_blocker(blocker: String) -> void:
	if blocker.is_empty():
		push_error("no se pudo quitar blocker porque esta vacio")
		return

	var idx: int = _blockers.find(blocker)
	if idx != -1:
		_blockers.remove_at(idx)
		value_changed.emit()
	else:
		push_error("%s no es un blocker" % blocker)


## Regresa [code]true[/code] si [param blocker] esta bloqueando el
## [BoolValue].
func has_blocker(blocker: String) -> bool:
	return _blockers.has(blocker)


func _get_persistent_properties() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_properties()
	keys.append_array(["_blockers", "_default"])
	return keys
