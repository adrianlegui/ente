extends Node

@export var my_var: bool = true

func _enter_tree() -> void:
	print("%s: entrando al árbol" % name)

func _ready() -> void:
	await EnteModManager.all_entities_added
	print("%s: todas las entidades agregadas" % name)
	await EnteModManager.before_start
	print("%s: antes de iniciar" % name)
	await EnteModManager.started_game
	print("%s: iniciando" % name)


func ente_get_data() -> Dictionary:
	var data: Dictionary = {
		"bf": false,
		"bt": true,
		"i": 1,
		"i1": 1,
		"f": 1.0009,
		"f1": 1.0009,
		"s": "string",
		"s1": "string",
		"V2": Vector2.ZERO,
		"V21": Vector2.ZERO,
		"R2": Rect2(),
		"R21": Rect2(),
		"V3": Vector3.UP,
		"V31": Vector3.UP,
		"T2D": Transform2D.IDENTITY,
		"T2D1": Transform2D.IDENTITY,
		"P": Plane(),
		"P1": Plane(),
		"Q": Quaternion(),
		"Q1": Quaternion(),
		"Q2": Quaternion(),
		"AABB": AABB(),
		"B": Basis(),
		"B1": Basis(),
		"T3D": Transform3D.IDENTITY,
		"C": Color(),
		"C1": Color(),
		"N": NodePath(""),
		"RID": RID(),
		"D": {"cosa": "cosa"},
	}
	data["my_var"] = my_var
	return data


func ente_set_data(data: Dictionary) -> void:
	my_var = data.get("my_var", false)


func ente_on_game_event_clean_scene_tree() -> void:
	queue_free()
