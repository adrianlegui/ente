class_name MyData extends Data

var numero: int = 0


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append("numero")
	return keys
