extends Control

onready var resume = $MarginContainer/VBoxContainer/Resume
onready var exit = $MarginContainer/VBoxContainer/Exit
onready var main_menu = $MarginContainer/VBoxContainer/Main_menu
onready var anim = $MarginContainer/AnimationPlayer
onready var timer = $Timer
onready var katana = $MarginContainer/katana
onready var parp = $AP2

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("FadeIn")
	resume.grab_focus()
	resume.connect("pressed" , self, "_on_resume_pressed")
	exit.connect("pressed", self, "_on_exit_pressed")
	main_menu.connect("pressed", self, "_on_main_menu_pressed")
	timer.start(7+2*rand_range(-2,2))
	
	visible = false
	
func _on_resume_pressed():
	visible = false
	get_tree().paused = false

func _on_main_menu_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
	get_tree().paused = false
	
func _on_exit_pressed():
	get_tree().quit()
	
func _on_exit_focus_entered():
	katana.global_position.y = exit.rect_global_position.y + exit.rect_size.y/2
	katana.global_position.x = exit.rect_global_position.x + exit.rect_size.x

func _on_resume_focus_entered():
	katana.global_position.y = resume.rect_global_position.y + resume.rect_size.y/2
	katana.global_position.x = resume.rect_global_position.x + resume.rect_size.x

func _on_timer_timeout():
	parp.play("parpadeo")
	timer.start(7+2*rand_range(-2,2))

func _input(event):
	if event.is_action_pressed("pause") and not event.is_echo():
		get_tree().paused = !visible
		visible = !visible
