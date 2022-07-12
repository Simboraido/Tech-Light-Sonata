extends Control

onready var health_bar = $Health_bar
onready var player = get_parent().get_node("Player")

func _physics_process(delta):
	health_bar.value = player.vida
