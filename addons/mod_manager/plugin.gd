@tool
extends EditorPlugin

const MOD_MANAGER_PATH = (
	"res://addons/mod_manager/src/mod_manager/mod_manager.tscn"
)
const SINGLETON_NAME: String = "ModManager"

func _enter_tree() -> void:
	add_autoload_singleton(
		SINGLETON_NAME,
		MOD_MANAGER_PATH
	)


func _exit_tree() -> void:
	remove_autoload_singleton(SINGLETON_NAME)
