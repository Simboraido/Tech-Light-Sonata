extends MarginContainer



func _ready():
	if Input.is_key_pressed(16777217):
		get_tree().change_scene("res://scenes/Menu.tscn")
