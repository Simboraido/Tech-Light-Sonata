extends Control


onready var Katana = $CenterConteiner/katana
onready var exit = $CenterConteiner/VBoxContainer2/VBoxContainer/Exit
onready var next = $CenterConteiner/VBoxContainer2/VBoxContainer/Next
onready var animacion = $CenterConteiner/VBoxContainer2/AnimationPlayer

func _ready():
	animacion.play("Fade In Game_Over")
	next.grab_focus()
	next.connect("pressed" , self, "_on_start_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")


func _on_Next_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_Exit_pressed():
	get_tree().quit()
	
func _on_Exit_focus_entered():
	Katana.global_position.y = exit.rect_global_position.y + exit.rect_size.y/2
	Katana.global_position.x = exit.rect_global_position.x + exit.rect_size.x*3/4

func _on_Next_focus_entered():
	Katana.global_position.y = next.rect_global_position.y + next.rect_size.y/2
	Katana.global_position.x = next.rect_global_position.x + next.rect_size.x*3/4
