extends Node


func _ready() -> void:
	EnteModManager.finished.connect(_on_finished)
	EnteModManager.could_not_open_load_order_file.connect(_on_could_not_open_load_order_file)
	EnteModManager.start()
	await EnteModManager.finished


func _on_finished() -> void:
	EnteModManager.finished.disconnect(_on_finished)
	var failed_pcks := EnteModManager.get_failed_pcks()
	var failed_mods := EnteModManager.get_failed_mods()

	if not failed_mods.is_empty() or not failed_pcks.is_empty():
		print(failed_mods)
		print(failed_pcks)
		push_error("falló la carga de mods o pck")
		get_tree().quit()
	else:
		EnteModManager.start_game()
		await EnteModManager.started_game
		var savegame_name: String = "partida_guardada"
		EnteModManager.save_game(savegame_name)
		EnteModManager.clean_scene_tree()
		await Engine.get_main_loop().process_frame
		EnteModManager.load_savegame(savegame_name)
		await EnteModManager.started_game
		queue_free()


func _on_could_not_open_load_order_file() -> void:
	get_tree().quit()
