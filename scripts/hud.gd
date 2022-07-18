extends Control

onready var health_bar = $Health_bar
onready var player = get_parent().get_node("Player")

onready var enemy_health_bar = $EnemyConteiner/VBoxContainer/Enemy_Health_bar
onready var enemy  = get_parent().get_node("Enemigo")

func _ready():
	health_bar.max_value = player.vidaMax
	enemy_health_bar.max_value = enemy.vidaMax

func _physics_process(delta):
	health_bar.value = player.vida
	enemy_health_bar.value = enemy.vida
