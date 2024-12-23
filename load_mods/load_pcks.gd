class_name LoadPcks extends ModsPath
## Carga Pcks.
##
## @experimental


## Se emite al terminar la carga de ficheros pck.
signal finished
signal max_pcks_updated(count: int)
signal pck_loaded(pck_name: String)
signal pck_load_failed(pck_name: String)


## Estado inicial.
const STATE_START: StringName = &"START"
## Estado final.
const STATE_FINISH: StringName = &"FINISH"
## Estado donde se cargan los mods.
const STATE_LOAD_MODS: StringName = &"LOAD_MODS"
## Estado donde espera a que el hilo termine de cargar el mod.
const STATE_WAITING: StringName = &"WAITING"
## Extension del fichero del mod.
const PCK_EXTENSION: String = "pck"


## Estado actual.
var current_state: StringName = STATE_START :
	set=set_current_state


var _thread: Thread
var _pck_path: String
var _pck: String
var _pcks: PackedStringArray = []
var _count: int = 0
var _mod_folder: String = ModsPath.get_mods_folder_path()
var _abort_load: bool = false


func abort_load() -> void:
	_abort_load = true


func set_file_names(file_names: PackedStringArray) -> void:
	_pcks = file_names


func set_current_state(new_state: String) -> void:
	if new_state == current_state:
		return

	var previous_state: String = current_state
	current_state = new_state

	if Engine.is_editor_hint():
		return

	if is_inside_tree():
		_current_state_changed(previous_state, current_state)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	_process_state(delta)


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
	if _pcks.is_empty():
		current_state = STATE_FINISH
	else:
		max_pcks_updated.emit(_pcks.size())
		_pck = _pcks[0]
		current_state = STATE_LOAD_MODS


func _process_load_mods() -> void:
	if _abort_load:
		current_state = STATE_FINISH
		return

	_pck_path = "%s.%s" % [_mod_folder.path_join(_pck), PCK_EXTENSION]
	if FileAccess.file_exists(_pck_path):
		_thread = Thread.new()
		_thread.start(ProjectSettings.load_resource_pack.bind(_pck_path))
		current_state = STATE_WAITING
	else:
		push_error("no existe fichero: %s" % _pck_path)
		pck_load_failed.emit(_pck_path)
		_count += 1
		if _count < _pcks.size():
			_pck = _pcks[_count]
		else:
			current_state = STATE_FINISH


func _process_waiting() -> void:
	if not _thread.is_alive():
		var loaded: bool = _thread.wait_to_finish()
		if not loaded:
			push_error("no se puedo cargar fichero %s" % _pck_path)
			pck_load_failed.emit(_pck_path)
		else:
			pck_loaded.emit(_pck_path)
		_count += 1
		if _count >= _pcks.size():
			current_state = STATE_FINISH
		else:
			_pck = _pcks[_count]
			current_state = STATE_LOAD_MODS


func _process_finish() -> void:
	finished.emit()
	process_mode = PROCESS_MODE_DISABLED


func _current_state_changed(
	previous_state: String,
	new_state: String
) -> void:
	pass
