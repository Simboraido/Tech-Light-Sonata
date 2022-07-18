extends MarginContainer

onready var katana = $HBoxContainer/VBoxContainer2/VBoxContainer/katana
onready var play_again = $HBoxContainer/VBoxContainer2/VBoxContainer/Play_again
onready var exit = $HBoxContainer/VBoxContainer2/VBoxContainer/Exit

func _input(event):
	play_again.grab_focus()


func _on_Play_again_focus_entered():
	katana.global_position.y = play_again.rect_global_position.y + play_again.rect_size.y/2
	katana.global_position.x = play_again.rect_global_position.x + play_again.rect_size.x

func _on_Exit_focus_entered():
	katana.global_position.y = play_again.rect_global_position.y + play_again.rect_size.y/2
	katana.global_position.x = play_again.rect_global_position.x + play_again.rect_size.x

func _on_Play_again_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_Exit_pressed():
	get_tree().quit()
