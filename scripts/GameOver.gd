extends Control


onready var Katana = $MarginContainer/katana
onready var exit = $MarginContainer/VBoxContainer/Exit
onready var next = $MarginContainer/VBoxContainer/Next

func _ready():
	next.grab_focus()
	next.connect("pressed" , self, "_on_start_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")

func _on_Next_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_Exit_pressed():
	get_tree().quit()
	
func _on_Exit_focus_entered():
	Katana.global_position.y = exit.rect_global_position.y + exit.rect_size.y/2
	Katana.global_position.x = exit.rect_global_position.x + exit.rect_size.x

func _on_Next_focus_entered():
	Katana.global_position.y = next.rect_global_position.y + next.rect_size.y/2
	Katana.global_position.x = next.rect_global_position.x + next.rect_size.x
