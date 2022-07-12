extends Control

onready var resume = $MarginContainer/VBoxContainer2/VBoxContainer/Resume
onready var exit = $MarginContainer/VBoxContainer2/VBoxContainer/Exit
onready var main_menu = $MarginContainer/VBoxContainer2/VBoxContainer/Main_menu
onready var anim = $MarginContainer/AnimationPlayer
onready var timer = $Timer
onready var katana = $MarginContainer/katana

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("FadeIn")
	resume.connect("pressed" , self, "_on_Resume_pressed")
	exit.connect("pressed", self, "_on_Exit_pressed")
	main_menu.connect("pressed", self, "_on_Main_menu_pressed")
	
	visible = false
	
func _on_Resume_pressed():
	visible = false
	get_tree().paused = false

func _on_Main_menu_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
	get_tree().paused = false
	
func _on_Exit_pressed():
	get_tree().quit()
	
func _input(event):
	if event.is_action_pressed("pause") and not event.is_echo():
		resume.grab_focus()
		get_tree().paused = !visible
		visible = !visible


func _on_Resume_focus_entered():
	katana.global_position.y = resume.rect_global_position.y + resume.rect_size.y/2
	katana.global_position.x = resume.rect_global_position.x + resume.rect_size.x

func _on_Exit_focus_entered():
	katana.global_position.y = exit.rect_global_position.y + exit.rect_size.y/2
	katana.global_position.x = exit.rect_global_position.x + exit.rect_size.x


func _on_Main_menu_focus_entered():
	katana.global_position.y = main_menu.rect_global_position.y + main_menu.rect_size.y/2
	katana.global_position.x = main_menu.rect_global_position.x + main_menu.rect_size.x
