extends Control

onready var anim = $MarginContainer/AnimationPlayer
onready var start = $MarginContainer/VBoxContainer/Start
onready var exit = $MarginContainer/VBoxContainer/Exit
onready var credits = $MarginContainer/VBoxContainer/Credits
onready var Katana = $MarginContainer/katana
onready var song = $AudioStreamPlayer
onready var sound = $Sonido
onready var parp = $AP2
onready var timer = $Timer

func _ready():
	anim.play("FadeIn")
	song.play()
	start.grab_focus()
	yield(anim, "animation_finished")
	timer.start(7+2*rand_range(-2,2))

func _on_Start_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_Exit_pressed():
	get_tree().quit()

func _on_Exit_focus_entered():
	Katana.global_position.y = exit.rect_global_position.y + exit.rect_size.y/2
	Katana.global_position.x = exit.rect_global_position.x + exit.rect_size.x

func _on_Start_focus_entered():
	Katana.global_position.y = start.rect_global_position.y + start.rect_size.y/2
	Katana.global_position.x = start.rect_global_position.x + start.rect_size.x

func _on_Timer_timeout():
	parp.play("parpadeo")
	timer.start(7+2*rand_range(-2,2))


func _on_Credits_focus_entered():
	Katana.global_position.y = credits.rect_global_position.y + credits.rect_size.y/2
	Katana.global_position.x = credits.rect_global_position.x + credits.rect_size.x


func _on_Credits_pressed():
	get_tree().change_scene("res://scenes/Credits.tscn")
