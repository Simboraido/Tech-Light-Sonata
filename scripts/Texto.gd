extends Control
export (Array, String, MULTILINE) var dialogos = []
var indice 	= 0										# indice del texto que se está leyendo
onready var texto = $Texto/RichTextLabel			# donde se ve el texto

func _ready():
	texto.parse_bbcode(dialogos[0])
	

func _input(event):
	if event.is_action_pressed("ataque"):
		indice+=1
		if indice<dialogos.size():
			texto.parse_bbcode(dialogos[indice])	
		else:
			get_tree().change_scene("res://scenes/Main.tscn")
				

