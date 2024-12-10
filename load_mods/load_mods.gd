class_name LoadMods extends FiniteStateMachine
## Carga mods.
##
## @experimental


## Se emite al terminar la carga de  mods.
signal finished
signal max_mods_updated(count: int)
signal mod_loaded


## Ruta al directorio donde se encuentran los mods.
const MODS_FOLDER_PATH: String = "user://mods"
## Ruta al fichero que contiene el orden de carga de los mods.
const MODS_LOAD_ORDER_FILE_PATH: String = "user://mods/load_order.txt"
## Estado que cambia la escena al menu de inicio.
const STATE_FINISH: String = "FINISH"
## Estado donde se cargan los mods.
const STATE_LOAD_MODS: String = "LOAD_MODS"
## Estado donde espera a que el hilo termine de cargar el mod.
const STATE_WAITING: String = "WAITING"
## Extension del fichero del mod.
const MOD_EXTENSION: String = "pck"

var _thread: Thread
var _mod_path: String
var _file: FileAccess
var _line: String


@warning_ignore("unused_parameter")
func _process_state(delta: float) -> void:
	match current_state:
		STATE_START:
			_process_start()
		STATE_LOAD_MODS:
			_process_load_mods()
		STATE_WAITING:
			_process_waiting()
		STATE_FINISH:
			_process_finish()


func _process_start() -> void:
	if FileAccess.file_exists(MODS_LOAD_ORDER_FILE_PATH):
		current_state = STATE_LOAD_MODS
	else:
		current_state = STATE_FINISH


func _process_load_mods() -> void:
	if _file.eof_reached():
		_file.close()
		current_state = STATE_FINISH
	else:
		if not _line.is_empty() and _line.get_extension() == MOD_EXTENSION:
			var mod_path: String = MODS_FOLDER_PATH.path_join(_line)
			if FileAccess.file_exists(mod_path):
				_thread = Thread.new()
				_thread.start(ProjectSettings.load_resource_pack.bind(mod_path))
				current_state = STATE_WAITING
			else:
				push_error("no existe fichero: %s" % mod_path)
		else:
			_line = _file.get_line()


func _process_waiting() -> void:
	if not _thread.is_alive():
		var loaded: bool = _thread.wait_to_finish()
		if not loaded:
			push_error("no se puedo cargar fichero %s" % _mod_path)
		_line = _file.get_line()
		current_state = STATE_LOAD_MODS


func _process_finish() -> void:
	finished.emit()
	process_mode = PROCESS_MODE_DISABLED


func _current_state_changed(
	previous_state: String,
	new_state: String
) -> void:
	if previous_state == STATE_START and new_state == STATE_LOAD_MODS:
		_file = FileAccess.open(
			MODS_LOAD_ORDER_FILE_PATH,
			FileAccess.READ
		)
		if is_instance_valid(_file):
			max_mods_updated.emit(_file)
			_line = _file.get_line()
		else:
			current_state = STATE_FINISH
