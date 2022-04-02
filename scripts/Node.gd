extends Node

export(int) var bpm
export(float) var tiempGracia = 0.2 # tiempo de gracia
var t_0 # t inicial
var t_actual
var t_sig # el tiempo siguiente que tiene que pegar
var incremento_tsig
onready var musica = $AudioStreamPlayer 

func _ready():
	t_actual = 0
	incremento_tsig = 60.0/bpm
	t_sig = incremento_tsig
	t_0 = OS.get_ticks_msec()
	musica.play()
	
func _process(delta):
	t_actual = musica.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency() # ajustar latencia
	if t_actual >= t_sig:
		t_sig += incremento_tsig
		
func _unhandled_input(event): # procedencia de las cosas interfaz > controles
	if event.is_action("ataque"):
		if abs(t_actual - t_sig) < tiempGracia:
			print("SI")
		else:
			print("NO")
