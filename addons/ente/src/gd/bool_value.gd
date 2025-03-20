@icon("res://addons/ente/src/resources/icons/bool_value.svg")
class_name BoolValue extends Data
## Configura y administra variable [code]bool[/code],

## Se emite cuando el valor default cambia.
signal default_changed
## Se emite cuando se agrega un nodo bloqueador.
signal bloker_added(blocker: Data)
## Se emite cuando se quita un nodo bloqueador
signal bloker_removed(blocker: Data)

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
		default_changed.emit()


## Obtine valor default.
func get_default() -> bool:
	return _default


## Regresa [code]true[/code] si [BoolValue] es [code]true[/code].
func is_true() -> bool:
	return _default if _blockers.size() == 0 else false


## Regresa [code]true[/code] si no hay nodos bloqueando [BoolValue].
func can_be_true() -> bool:
	return _blockers.size() == 0


## Agrega un nodo que bloquea al [BoolValue].
func add_blocker(blocker: Node) -> void:
	var id: String = _get_node_id(blocker)

	if id.is_empty():
		push_error("no se pudo agregar blocker: %s" % blocker.name)
		return

	if not _blockers.has(id):
		_blockers.append(id)
		bloker_added.emit(blocker)


## Quita un nodo que bloquea al [BoolValue].
func remove_blocker(blocker: Node) -> void:
	var id: String = _get_node_id(blocker)

	if id.is_empty():
		push_error("no se pudo quitar blocker: %s" % blocker.name)
		return

	var idx: int = _blockers.find(id)
	if idx != -1:
		_blockers.remove_at(idx)
		bloker_removed.emit(blocker)


## Regresa [code]true[/code] si el nodo [param blocker] esta bloqueando el
## [BoolValue].
func has_blocker(blocker: Node) -> bool:
	return _blockers.has(_get_node_id(blocker))


func _get_persistent_properties() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_properties()
	keys.append_array(["_blockers", "_default"])
	return keys


func _get_node_id(node: Node) -> String:
	var id: String = node.get_path()
	if id.is_empty():
		push_error(
			"no se pudo obtener id para el nodo %s porque no esta dentro del SceneTree" % node.name
		)
	return id
