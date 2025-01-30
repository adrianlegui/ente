extends "res://gd-plug/plug.gd"


func _plugging():
	plug(
		"MikeSchulze/gdUnit4",
		{
			"tag": "v4.5.0",
			"include": ["addons/gdUnit4"],
			"exclude": ["addons/gdUnit4/test"]
		}
	)
