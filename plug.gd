extends "res://gd-plug/plug.gd"


func _plugging():
	plug(
		"MikeSchulze/gdUnit4",
		{
			"tag": "v5.0.5",
			"include": ["addons/gdUnit4"],
			"exclude": ["addons/gdUnit4/test"]
		}
	)
