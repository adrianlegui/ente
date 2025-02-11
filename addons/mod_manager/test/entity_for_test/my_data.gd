extends Data

var numero: int = 0

func _get_persistent_properties() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_properties()
	keys.append("numero")
	return keys
