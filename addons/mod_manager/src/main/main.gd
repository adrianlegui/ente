extends Node


func _ready() -> void:
	MOD_MANAGER.finished.connect(_on_finished)
	MOD_MANAGER.could_not_open_load_order_file.connect(
		_on_could_not_open_load_order_file
	)
	MOD_MANAGER.load_order_file_is_empty.connect(_on_load_order_file_is_empty)


func _on_finished() -> void:
	_disconnet_signals()
	MOD_MANAGER.start_game()
	queue_free()


func _on_could_not_open_load_order_file() -> void:
	_disconnet_and_quit()


func _on_load_order_file_is_empty() -> void:
	_disconnet_and_quit()


func _disconnet_signals() -> void:
	MOD_MANAGER.finished.disconnect(_on_finished)
	MOD_MANAGER.could_not_open_load_order_file.disconnect(
		_on_could_not_open_load_order_file
	)
	MOD_MANAGER.load_order_file_is_empty.disconnect(
		_on_load_order_file_is_empty
	)


func _disconnet_and_quit() -> void:
	_disconnet_signals()
	get_tree().quit
