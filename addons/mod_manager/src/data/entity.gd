class_name Entity extends Data
## Clase base para los nodos que reciben la información de los mods.
##
## Los nodos que hereden de esta clase tiene que estar en el grupo
## [constant GROUP_PERSISTENT] para que sean guardados.
##
## @experimental


## Nombre de la propiedad con la ruta a la escena.
const KEY_SCENE_FILE_PATH: StringName = &"scene_file_path"
## Clave usada en el diccionario de persistencia.
const KEY_PROPERTIES: StringName = &"PROPERTIES"
## Nombre del grupo de nodos persistentes.
const GROUP_PERSISTENT: StringName = &"PERSISTENT"


var _unique: bool = true


func _ready() -> void:
	_add_groups()


# Configura la información de la entidad.
func _set_data(data: Dictionary) -> void:
	var properties: Dictionary = data.get(KEY_PROPERTIES, {}) as Dictionary
	if properties.is_empty():
		return
	set_properties(properties)


# Obtienen la configuración de la entidad
func get_data() -> Dictionary:
	var data: Dictionary = {KEY_SCENE_FILE_PATH: scene_file_path}
	data[KEY_PROPERTIES] = get_properties()
	return data


## Obtiene una entidad
func get_entity(entity_name: String) -> Entity:
	var entity: Entity = null
	if is_inside_tree():
		if not entity_name.is_empty():
			entity = get_node_or_null("/root/" + entity_name)
		else:
			push_error("entity_name esta vacio")
	else:
		push_error(
			"llamando get_entity en %s que no esta en SceneTree, retorno null" % name
		)
	return entity


func set_unique(value: bool) -> void:
	_unique = value


func is_unique() -> bool:
	return _unique


## Se llama cuando el juego es iniciado.
func _on_game_event_started() -> void:
	pass


## Se llama luego de agregar todas las entidades al arbol.
func _on_game_event_before_starting() -> void:
	pass


## Se llama al limpiar el arbol de nodos.
func _on_game_event_clean_scene_tree() -> void:
	queue_free()


## Se llama luego de que se agregaron todas las entidades al
## SceneTree.
func _on_game_event_all_entities_added() -> void:
	pass


func _get_groups() -> PackedStringArray:
	var groups: PackedStringArray = []
	groups.append_array(
		[
			GROUP_PERSISTENT,
			GameEvents.GROUP
		]
	)
	return groups


func _add_groups() -> void:
	for g: String in _get_groups():
		add_to_group(g)


func _get_persistent_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_persistent_keys()
	keys.append("_unique")
	return keys


func _get_not_settable_keys() -> PackedStringArray:
	var keys: PackedStringArray = super._get_not_settable_keys()
	keys.append(KEY_SCENE_FILE_PATH)
	return keys


static func create_entity(dict: Dictionary) -> Data:
	var data: Data = null
	var path: String = dict.get(KEY_SCENE_FILE_PATH, "") as String
	if path.is_empty():
		push_error("falta scene_file_path")
	else:
		var pck: PackedScene = load(path) as PackedScene
		if pck:
			data = pck.instantiate()
			data._set_data(dict)
	return data
