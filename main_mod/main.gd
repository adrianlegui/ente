extends Node


func _ready() -> void:
	EnteModManager.finished.connect(_on_finished)
	EnteModManager.start()


func _on_finished() -> void:
	EnteModManager.finished.disconnect(_on_finished)
	var failed_pcks := EnteModManager.get_failed_pcks()
	var failed_mods := EnteModManager.get_failed_mods()

	if (
		not EnteModManager.load_order_file_is_correct()
		or not failed_mods.is_empty()
		or not failed_pcks.is_empty()
	):
		print(failed_mods)
		print(failed_pcks)
		push_error("falló la carga de mods o pck. Saliendo del juego.")
		get_tree().quit()
	else:
		get_tree().paused = true
		EnteModManager.start_game()
		await EnteModManager.started_game
		var savegame_name: String = "partida_guardada"
		EnteModManager.save_game(savegame_name)
		EnteModManager.clean_scene_tree()
		get_tree().paused = false

		await get_tree().process_frame
		get_tree().paused = true
		await Engine.get_main_loop().process_frame
		EnteModManager.load_savegame(savegame_name)
		await EnteModManager.started_game
		get_tree().paused = false
		queue_free()
