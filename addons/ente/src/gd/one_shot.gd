class_name OneShot extends PersistentData
# Entidad que llama a un método al iniciar una partida por primera vez.

var _first_start: bool = true


func set_first_start(first_start: bool) -> void:
	_first_start = first_start


func is_first_start() -> bool:
	return _first_start


func _on_game_event_started() -> void:
	if is_first_start():
		set_first_start(false)
		_on_first_start()


func _get_persistent_properties() -> PackedStringArray:
	var persistent_properties: PackedStringArray = super._get_persistent_properties()
	persistent_properties.append("_first_start")
	return persistent_properties


## Será llamado cuando la partida inicie por primera vez. Sobreescribir para
## dar funcionalidad.
## [color=yellow]Método virtual.[/color]
func _on_first_start() -> void:
	pass
