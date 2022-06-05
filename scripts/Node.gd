extends Node

export(int) var bpm
export(float) var tiempGracia = 0.2 # tiempo de gracia
var t_0 # t inicial
var t_actual
var t_sig # el tiempo siguiente que tiene que pegar
onready var musica = $AudioStreamPlayer
var largoCancion
export(Resource) var beatmap
var indiceNota: int = 0 # para declarar algo y definir su tipo

func _ready():
	t_actual = 0
	t_sig = beatmap.notes[indiceNota].time
	largoCancion = musica.stream.get_length()
	t_0 = OS.get_ticks_msec()
	yield(get_tree().create_timer(0.03),"timeout")
	musica.play()
	
func _process(delta):
	t_actual = musica.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency() # ajustar latencia
	if t_actual > largoCancion:
		t_actual -= largoCancion
	if t_actual >= t_sig + tiempGracia:
		indiceNota = (indiceNota + 1)%beatmap.notes.size()
		t_sig = beatmap.notes[indiceNota].time
		
func _unhandled_input(event): # procedencia de las cosas interfaz > controles
	if event.is_action_pressed("ataque"):
		if abs(t_actual - t_sig) < tiempGracia:
			Globales.enritmo = true
			Globales.combo += 1
			$sonido.play()
		else:
			Globales.enritmo = false
			Globales.combo = 0
