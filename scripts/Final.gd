extends MarginContainer

func _input(event):
	if event.is_action_pressed("reset"):
		get_tree().change_scene("res://scenes/Menu.tscn")
