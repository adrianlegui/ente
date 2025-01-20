@icon("res://addons/mod_manager/src/icons/bool_value.svg")
class_name BoolValue extends Data
## @experimental

signal bloker_added(entity: Entity)
signal bloker_removed(entity: Entity)

@export var _default: bool = true

var _blockers: PackedStringArray = []

func set_default(value: bool) -> void:
	_default = value


func get_default() -> bool:
	return _default


func is_true() -> bool:
	return _default if _blockers.size() == 0 else false


func can_be_true() -> bool:
	return _blockers.size() == 0


func add_blocker(entity: Entity) -> void:
	var id: String = entity.name
	if not _blockers.has(id):
		_blockers.append(id)
		bloker_added.emit(entity)


func remove_blocker(entity: Entity) -> void:
	var id: String = entity.name
	var idx: int = _blockers.find(id)
	if idx != -1:
		_blockers.remove_at(idx)
		bloker_removed.emit(entity)


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append_array(
		[
			"_blockers",
			"_default"
		]
	)
	return keys
