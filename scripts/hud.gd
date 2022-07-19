extends Control

onready var health_bar = $Health_bar
onready var player = get_parent().get_node("Player")
onready var text_combo = $Combo

onready var enemy_health_bar = $EnemyConteiner/VBoxContainer/Enemy_Health_bar
onready var enemy  = get_parent().get_node("Enemigo")

onready var anim = $AnimationPlayer

func _ready():
	health_bar.max_value = player.vidaMax
	anim.play("boss_healthbar")
	yield(anim, "animation_finished")
	enemy_health_bar.max_value = enemy.vidaMax


func _physics_process(delta):
	health_bar.value = player.vida
	enemy_health_bar.value = enemy.vida
	
	if Globales.combo != 0:
#		anim.play("combo_anim")
		text_combo.text = "x"+str(Globales.combo)
	else:
#		anim.play("combo_loss")
		text_combo.text = " "
