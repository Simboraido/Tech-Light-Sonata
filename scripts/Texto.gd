extends Control
export (Array, String, MULTILINE) var dialogos = []
var indice  = 0										# indice del texto que se está leyendo
onready var texto = $Texto/RichTextLabel			# donde se ve el texto
onready var timer = $Timer
onready var conti = $Sprite
onready var anim = $AnimationPlayer

func _ready():
	texto.parse_bbcode(dialogos[0])
	texto.set_visible_characters(0)
	
func _input(event):
	if event.is_action_pressed("ataque"):
		if texto.get_visible_characters() > texto.get_total_character_count():
			indice += 1
			texto.set_visible_characters(0)
			if indice < dialogos.size():
				texto.parse_bbcode(dialogos[indice])
			else:
				get_tree().change_scene("res://scenes/Main.tscn")
		else:
			texto.set_visible_characters(texto.get_total_character_count())

func _on_Timer_timeout():
	if texto.get_visible_characters() <= texto.get_total_character_count():
		texto.set_visible_characters(texto.get_visible_characters() + 1)
	else:
		anim.play("parpadeo_conti")
