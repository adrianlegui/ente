@tool
extends EditorPlugin

const MOD_MANAGER_PATH = (
	"res://addons/mod_manager/src/mod_manager/mod_manager.tscn"
)
const SINGLETON_NAME: String = "ModManager"

func _enter_tree() -> void:
	init()



func _exit_tree() -> void:
	clean()


func init() -> void:
	add_autoload_singleton(
		SINGLETON_NAME,
		MOD_MANAGER_PATH
	)
	var property_path: String = ModManagerProperties.MODS_FOLDER_PATH_PROPERTY
	ProjectSettings.set(property_path, "user://mods")
	var property_info = {
		"name": property_path,
		"type": TYPE_STRING
	}
	ProjectSettings.add_property_info(property_info)
	ProjectSettings.save()


func clean() -> void:
	remove_autoload_singleton(SINGLETON_NAME)
	var property_path: String = ModManagerProperties.MODS_FOLDER_PATH_PROPERTY
	ProjectSettings.set(property_path, null)
	ProjectSettings.save()
