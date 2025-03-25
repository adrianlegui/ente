extends Data

var my_var: bool = true


func _add_extra_persistent_properties(persistent_properties: PackedStringArray) -> void:
	persistent_properties.append("my_var")
