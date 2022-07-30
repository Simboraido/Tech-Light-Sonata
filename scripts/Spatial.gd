extends Spatial

onready var luz = $OmniLight
onready var mus = get_parent().get_node("Nodo_musica")

func _process(delta):
	if Globales.combo == 1:
		luz.light_color = Color.yellow
	elif Globales.combo == 2:
		luz.light_color = Color.green
	elif Globales.combo >= 3:
		luz.light_color = Color.cyan
	else:
		luz.light_color = Color.red

# Tiempo para que suena la otra nota
	var t_dif = abs(mus.t_sig - mus.t_actual)
	luz.light_energy = t_dif * 10
