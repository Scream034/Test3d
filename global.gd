extends Node

export var gravity_strenglth = 0
export var is_perspective_3D = true

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_F6 and !event.is_pressed():
			is_perspective_3D = false if is_perspective_3D else true
			if !is_perspective_3D:
				get_tree().change_scene("res://map_2d.tscn")
			else:
				get_tree().change_scene("res://map.tscn")
	if Input.is_action_just_pressed("restart"):
		_restart()

func _restart():
	get_tree().reload_current_scene()
