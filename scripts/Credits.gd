extends Control


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			get_tree().change_scene("res://scenes/Menu.tscn")
