extends Node


func _ready() -> void:
	ModManager.finished.connect(_on_finished)
	ModManager.could_not_open_load_order_file.connect(_on_could_not_open_load_order_file)
	ModManager.start()


func _on_finished() -> void:
	ModManager.finished.disconnect(_on_finished)

	if ModManager.failed_to_load_mods() or ModManager.failed_to_load_pcks():
		push_error("falló la carga de mods o pck")
		get_tree().quit()
	else:
		ModManager.start_game()
		queue_free()


func _on_could_not_open_load_order_file() -> void:
	get_tree().quit()
