class_name LoadMods extends FiniteStateMachine
## Carga mods.
##
## @experimental


## Ruta a escena principal
const MAIN_SCENE_PATH: String = "res://main.tscn"
## Ruta al directorio donde se encuentran los mods.
const MODS_FOLDER_PATH: String = "user://mods"
## Ruta al fichero que contiene el orden de carga de los mods.
const MODS_LOAD_ORDER_FILE_PATH: String = "user://mods/load_order.txt"
## Estado que cambia la escena al menu de inicio.
const STATE_FINISH: String = "FINISH"
## Estado donde se cargan los mods.
const STATE_LOAD_MODS: String = "LOAD_MODS"
## Extension del fichero del mod.
const MOD_EXTENSION: String = "pck"


@warning_ignore("unused_parameter")
func _process_state(delta: float) -> void:
	match current_state:
		STATE_START:
			_process_start()
		STATE_LOAD_MODS:
			_process_load_mods()
		STATE_FINISH:
			_process_finish()


func _process_start() -> void:
	if FileAccess.file_exists(MODS_LOAD_ORDER_FILE_PATH):
		current_state = STATE_LOAD_MODS
	else:
		current_state = STATE_FINISH


func _process_load_mods() -> void:
	var file: FileAccess = FileAccess.open(
		MODS_LOAD_ORDER_FILE_PATH,
		FileAccess.READ
	)
	var line: String = file.get_line()
	if is_instance_valid(file):
		while not file.eof_reached():
			if not line.is_empty() and line.get_extension() == MOD_EXTENSION:
				var mod_path: String = MODS_FOLDER_PATH.path_join(line)
				if FileAccess.file_exists(mod_path):
					var loaded: bool = ProjectSettings.load_resource_pack(mod_path)
					if not loaded:
						push_error("%s no se pudo cargar" % mod_path)
				else:
					push_error("no existe fichero: %s" % mod_path)
			line = file.get_line()

		file.close()

	current_state = STATE_FINISH


func _process_finish() -> void:
	var scene_tree: SceneTree = get_tree()
	var STATE: int = scene_tree.change_scene_to_file(MAIN_SCENE_PATH)
	if STATE != OK:
		if STATE == ERR_CANT_OPEN:
			push_error("no se pudo cargar escena %s" % MAIN_SCENE_PATH)
		elif STATE == ERR_CANT_CREATE:
			push_error("no se pudo instanciar escena %s" % MAIN_SCENE_PATH)
		var FAIL: int = 1
		scene_tree.quit(FAIL)
