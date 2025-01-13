@tool
class_name ScriptCreator extends Node
## Crea script con class_name Entities que contiene los nombres de las entidades
## como constantes.


const SCRIPT_NAME: String = "entities.gd"
const CLASS_NAME: String = "Entities"

@export var update: bool = false : set=set_update
@export_file("*.json") var json_file: String = ""
@export_dir var output: String = "res://"


func set_update(value: bool) -> void:
	if value:
		_create_script()


func _create_script() -> void:
	if json_file.is_empty() or output.is_empty():
		return

	var file_access: FileAccess = FileAccess.open(json_file,FileAccess.READ)
	var json: JSON = JSON.new()
	json.parse(file_access.get_as_text())
	file_access.close()
	var data: Dictionary = json.data
	var entities: Dictionary = data[Mod.KEY_ENTITIES]

	var out: FileAccess = FileAccess.open(
		output.path_join(SCRIPT_NAME),
		FileAccess.WRITE
	)

	out.store_line("class_name %s extends Node" % CLASS_NAME)
	out.store_line("## Contiene los nombres de las entidades.")
	out.store_line("")
	out.store_line("")
	for key in entities:
		out.store_line("const %s: String = \"%s\"" % [key, key])
	out.store_line("")
	out.close()
