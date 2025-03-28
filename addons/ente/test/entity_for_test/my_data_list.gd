extends DataList

var string: String = "string"


func _add_extra_persistent_properties(persistent_properties: PackedStringArray) -> void:
	persistent_properties.append("string")
