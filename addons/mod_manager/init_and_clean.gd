@tool
extends EditorPlugin


const MOD_MANAGER_PATH: String = "res://addons/mod_manager/src/mm/mod_manager.tscn"
const SINGLETON_NAME: String = "MOD_MANAGER"


func _enter_tree() -> void:
	add_autoload_singleton(
		SINGLETON_NAME,
		MOD_MANAGER_PATH
	)


func _exit_tree() -> void:
	remove_autoload_singleton(SINGLETON_NAME)
