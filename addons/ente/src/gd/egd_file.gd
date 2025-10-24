@tool
class_name EnteEGDViewer extends Resource

@export_file_path("*.egd") var egd_file: String = ""
@export_tool_button("Load EGD") var load_egd: Callable = _load_egd
@export_tool_button("Update EGD") var update_egd: Callable = _update_egd
@export var data: Dictionary = {}


func _update_egd() -> void:
	if egd_file.is_empty():
		return

	if not FileAccess.file_exists(egd_file):
		return

	if data.is_empty():
		return

	_save_file(egd_file)


func _load_egd() -> void:
	if egd_file.is_empty():
		return

	if not FileAccess.file_exists(egd_file):
		return

	_load_file(egd_file)


func _load_file(path: String) -> void:
	var f := FileAccess.open_compressed(egd_file, FileAccess.READ, FileAccess.COMPRESSION_GZIP)
	var state := f.get_open_error()
	if state != OK:
		return

	var d: Dictionary = f.get_var()
	f.close()
	if not d:
		return

	data = d


func _save_file(path: String) -> void:
	var f := FileAccess.open_compressed(path, FileAccess.WRITE, FileAccess.COMPRESSION_GZIP)
	var state := f.get_open_error()
	if state != OK:
		return

	f.store_var(data)
	f.close()
