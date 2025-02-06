class_name Scene extends Entity
## Mantiene una [PackedScene] cargada y devuelve una instancia.

## Ruta a la [PackedScene].
@export_file("*.tscn") var _scene_path: String = ""
## Si es [code]true[/code] la ruta a la [PackedScene] será persistente.
@export var _scene_path_persistent: bool = false
## Configura si la [PackedScene] se mantiene cargada aunque no este siendo
## usada.
@export var _unloaded: BoolValue

# Referencia a la escena, usada para mantenerla cargada.
var _pck: PackedScene

func _ready() -> void:
	super._ready()
	_load_scene()


## Configura si la ruta a la escena es persistente.
func set_scene_path_persistent(scene_path_persistent: bool) -> void:
	_scene_path_persistent = scene_path_persistent


## Si regresa [code]true[/code], la ruta a la escena es persistente.
func is_scene_path_persistent() -> bool:
	return _scene_path_persistent


## Agrega un bloqueador que mantiene la escena cargada aunque no se este usando.
func add_unload_blocker(entity: Entity) -> void:
	_unloaded.add_blocker(entity)


## Quita un bloqueador, si no hay bloqueadores la escena será descargada.
func remove_unload_blocker(entity: Entity) -> void:
	_unloaded.remove_blocker(entity)


## Regresa [code]true[/code] si [param entity] esta bloqueando la descarga de
## la escena.
func has_unload_blocker(entity: Entity) -> bool:
	return _unloaded.has_blocker(entity)


## Configura la ruta de la escena.
func set_scene_path(scene_path: String) -> void:
	_scene_path = scene_path


## Regresa la ruta de la escena.
func get_scene_path() -> String:
	return _scene_path


## Si regresa [code]true[/code] la escena esta cargada.
func is_preloaded() -> bool:
	return not _unloaded.is_true()


## Configura si la escena esta precargada.
func set_preloaded(preloaded: bool) -> void:
	_unloaded.set_default(not preloaded)
	_load_scene()


## Regresa una instancia de la escena.
func get_scene() -> Node:
	if get_scene_path().is_empty():
		push_error("_scene_path está vacio, regresando null")
		return null

	var scene: Node = null
	if _pck != null:
		scene = _pck.instantiate()
	else:
		var pck: PackedScene = load(_scene_path)
		if pck != null:
			scene = pck.instantiate()
	return scene


func _get_persistent_keys() -> PackedStringArray:
	var keys: = super._get_persistent_keys()
	keys.append("_unloaded")
	if is_scene_path_persistent():
		keys.append("_scene_path")
	return keys


func _load_scene() -> void:
	if is_preloaded() and _pck == null:
		_pck = load(_scene_path)
	elif not is_preloaded():
		_pck = null
