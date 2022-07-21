extends Control

onready var katana = $MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/katana
onready var play_again = $MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/Play_again
onready var exit = $MarginContainer/HBoxContainer/VBoxContainer2/VBoxContainer/Exit
onready var points = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Points
onready var grade = $MarginContainer/HBoxContainer/VBoxContainer2/Grade

func grade_points(points):
	if points > 16500:
		return "S"
	elif points > 14000:
		return "A"
	elif points > 12000:
		return "B"
	elif points > 10000:
		return "C"
	else:
		return "D"

func _ready():
	play_again.grab_focus()
	points.text = str(Globales.puntaje)
	grade.text = grade_points(Globales.puntaje)

func _on_Play_again_focus_entered():
	katana.global_position.y = play_again.rect_global_position.y + play_again.rect_size.y/2
	katana.global_position.x = play_again.rect_global_position.x + play_again.rect_size.x -37.5

func _on_Exit_focus_entered():
	katana.global_position.y = exit.rect_global_position.y + exit.rect_size.y/2
	katana.global_position.x = exit.rect_global_position.x + exit.rect_size.x -37.5

func _on_Play_again_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_Exit_pressed():
	get_tree().quit()
