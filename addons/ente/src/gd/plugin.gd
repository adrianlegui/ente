@tool
extends EditorPlugin

const MOD_MANAGER_PATH = "res://addons/ente/src/gd/mod_manager.tscn"
const SINGLETON_NAME: String = "EnteModManager"

var mod_folder_path_property_path: String = EnteModManagerProperties.MODS_FOLDER_PATH_PROPERTY
var game_id_property_path: String = EnteModManagerProperties.GAME_ID_PROPERTY_PATH
var single_mode_property_path: String = EnteModManagerProperties.SINGLE_MODE_PROPERTY_PATH
var main_mod_property_path: String = EnteModManagerProperties.MAIN_MOD_PROPERTY_PATH
var main_mod_default_path: String = EnteModManagerProperties.MAIN_MOD_DEFAULT_PATH


func _enable_plugin() -> void:
	init()


func _disable_plugin() -> void:
	clean()


func init() -> void:
	add_autoload_singleton(SINGLETON_NAME, MOD_MANAGER_PATH)
	add_properties()
	ProjectSettings.save()


func add_properties() -> void:
	add_mod_folder_property()
	add_game_id_property()
	add_unique_mode_property()
	add_unique_mod_property()


func add_unique_mode_property() -> void:
	ProjectSettings.set(single_mode_property_path, true)

	var property_info = {"name": single_mode_property_path, "type": TYPE_BOOL}
	ProjectSettings.add_property_info(property_info)


func add_unique_mod_property() -> void:
	ProjectSettings.set(main_mod_property_path, main_mod_default_path)

	var property_info = {"name": main_mod_property_path, "type": TYPE_STRING}
	ProjectSettings.add_property_info(property_info)


func add_game_id_property() -> void:
	ProjectSettings.set(game_id_property_path, "game_id")

	var property_info = {"name": game_id_property_path, "type": TYPE_STRING}
	ProjectSettings.add_property_info(property_info)


func add_mod_folder_property() -> void:
	ProjectSettings.set(mod_folder_path_property_path, EnteModManagerProperties.MODS_FOLDER_PATH)
	var property_info = {"name": mod_folder_path_property_path, "type": TYPE_STRING}
	ProjectSettings.add_property_info(property_info)


func remove_properties() -> void:
	var ps := ProjectSettings
	ps.set(mod_folder_path_property_path, null)
	ps.set(game_id_property_path, null)
	ps.set(single_mode_property_path, null)
	ps.set(main_mod_property_path, null)


func clean() -> void:
	remove_autoload_singleton(SINGLETON_NAME)
	remove_properties()
	ProjectSettings.save()
