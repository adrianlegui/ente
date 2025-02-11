@tool
extends EditorPlugin

const MOD_MANAGER_PATH = (
	"res://addons/mod_manager/src/mod_manager/mod_manager.tscn"
)
const SINGLETON_NAME: String = "ModManager"

var mod_folder_path_property_path: String = ModManagerProperties.MODS_FOLDER_PATH_PROPERTY
var game_id_property_path: String = ModManagerProperties.GAME_ID_PROPERTY_PATH

func _enable_plugin() -> void:
	init()


func _disable_plugin() -> void:
	clean()


func init() -> void:
	add_autoload_singleton(
		SINGLETON_NAME,
		MOD_MANAGER_PATH
	)
	add_properties()
	ProjectSettings.save()


func add_properties() -> void:
	add_mod_folder_property()
	add_game_id_property()


func add_game_id_property() -> void:
	ProjectSettings.set(
		game_id_property_path,
		"game_id"
	)
	var property_info = {
		"name": game_id_property_path,
		"type": TYPE_STRING
	}
	ProjectSettings.add_property_info(property_info)


func add_mod_folder_property() -> void:
	ProjectSettings.set(
		mod_folder_path_property_path,
		ModManagerProperties.MODS_FOLDER_PATH
	)
	var property_info = {
		"name": mod_folder_path_property_path,
		"type": TYPE_STRING
	}
	ProjectSettings.add_property_info(property_info)


func remove_properties() -> void:
	ProjectSettings.set(mod_folder_path_property_path, null)
	ProjectSettings.set(game_id_property_path, null)


func clean() -> void:
	remove_autoload_singleton(SINGLETON_NAME)
	remove_properties()
	ProjectSettings.save()
