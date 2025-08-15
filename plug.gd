#!/usr/bin/env -S godot --headless -s
extends "res://gd-plug/plug.gd"


func _plugging():
	plug("bitwes/Gut", {"tag": "v9.4.0"})
