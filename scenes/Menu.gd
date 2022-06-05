extends MarginContainer

onready var anim = $AnimationPlayer
onready var start = $VBoxContainer/Start
onready var exit = $VBoxContainer/Exit
onready var Katana = $katana
onready var song = $AudioStreamPlayer
onready var sound = $Sonido

func _ready():
	anim.play("FadeIn")
	song.play()
	start.grab_focus()
	start.connect("pressed" , self, "_on_start_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")

func _input(event):
	if event.is_action_pressed("abajo"):
		Katana.rect_position.y += 30
	if event.is_action_pressed("arriba"):
		Katana.rect_position.y -= 30
		
func _on_start_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")
	
func _on_exit_pressed():
	get_tree().quit()
