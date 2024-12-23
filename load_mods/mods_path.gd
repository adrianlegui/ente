class_name ModsPath extends Node


## Nombre del fichero que contiene el orden de carga de los mods.
const LOAD_ORDER_FILE: String = "load_order.txt"
## Ruta al directorio donde se encuentran los mods.
const MODS_FOLDER_PATH: String = "user://mods"


static func get_mods_folder_path() -> String:
	return MODS_FOLDER_PATH


static func get_mods_load_order_file_path() -> String:
	var path: String = ModsPath.get_mods_folder_path().path_join(LOAD_ORDER_FILE)
	return path
