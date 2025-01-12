extends Node


func _ready() -> void:
	MOD_MANAGER.finished.connect(_on_finished)
	MOD_MANAGER.could_not_open_load_order_file.connect(
		_on_could_not_open_load_order_file
	)
	MOD_MANAGER.start()


func _on_finished() -> void:
	MOD_MANAGER.finished.disconnect(_on_finished)

	if MOD_MANAGER.failed_to_load_mods() or MOD_MANAGER.failed_to_load_pcks():
		push_error("falló la carga de mods o pck")
		get_tree().quit()
	else:
		MOD_MANAGER.start_game()
		queue_free()


func _on_could_not_open_load_order_file() -> void:
	get_tree().quit()
