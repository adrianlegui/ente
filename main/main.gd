extends Node


func _ready() -> void:
	MOD_MANAGER.finished.connect(_on_finished)
	MOD_MANAGER.could_not_open_load_order_file.connect(
		_on_could_not_open_load_order_file
	)


func _on_finished() -> void:
	_disconet_signals()
	MOD_MANAGER.start_game()
	queue_free()


func _on_could_not_open_load_order_file() -> void:
	_disconet_signals()
	get_tree().quit(FAILED)


func _disconet_signals() -> void:
	MOD_MANAGER.finished.disconnect(_on_finished)
	MOD_MANAGER.could_not_open_load_order_file.disconnect(
		_on_could_not_open_load_order_file
	)
