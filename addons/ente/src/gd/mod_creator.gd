@tool
class_name EnteModCreator extends Node

@export_tool_button("Create") var create: Callable = _create
@export_dir var output: String = ""
@export var mod_name: String = ""
## Solo se guardará la informacion de los nodos que esten en este grupo.
@export var name_group: String = ""
## Nombre de los mods del que depende sin la extensión del fichero.
@export var dependencies: PackedStringArray = []
## Nombres de los ficheros pck que serán cargados con este mod.
@export var pcks: PackedStringArray = []


func _create() -> void:
	if output.is_empty() or mod_name.is_empty():
		return
	var ents := _get_data_from_entities()
	var m := EnteMod.create_mod_from_current_game(dependencies, ents)
	m.set_pcks(pcks)
	#m.save_data(output.path_join(mod_name) + "." + EnteModManagerProperties.MOD_EXTENSION)
	m.save_data(output.path_join(mod_name) + "." + EnteModManagerProperties.MOD_EXTENSION)


func _get_data_from_entities() -> Dictionary[String, Dictionary]:
	var ents: Dictionary[String, Dictionary] = {}
	for node: Node in get_children():
		_add_ent(node, ents)
	return ents


func _add_ent(node: Node, ents: Dictionary) -> void:
	if node.is_in_group(EnteMod.GROUP_PERSISTENT):
		if not name_group.is_empty() and not node.is_in_group(name_group):
			return

		if node.scene_file_path.is_empty():
			push_warning("scene_file_path del nodo %s esta vacia" % node.name)
		var data: Dictionary = {EnteModManager.KEY_SCENE_FILE_PATH: node.scene_file_path}
		if node.has_method(EnteModManager.METHOD_GET_DATA):
			data[EnteModManager.KEY_DATA] = node.call(EnteModManager.METHOD_GET_DATA)
		ents[node.name] = data
