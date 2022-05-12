extends Node

export(int) var bpm
export(float) var tiempGracia = 0.2 # tiempo de gracia
var t_0 # t inicial
var t_actual
var t_sig # el tiempo siguiente que tiene que pegar
var incremento_tsig
onready var musica = $AudioStreamPlayer 
var musika = false

func _ready():
	t_actual = 0
	incremento_tsig = 60.0/bpm
	t_sig = incremento_tsig
	t_0 = OS.get_ticks_msec()
	yield(get_tree().create_timer(0.03),"timeout")
	musica.play()
	musika = true
	
func _process(delta):
	if not musika:
		return 
	#t_actual = musica.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency() # ajustar latencia
	t_actual += delta
	if t_actual >= t_sig:
		t_sig += incremento_tsig
		
func _unhandled_input(event): # procedencia de las cosas interfaz > controles
	if event.is_action_pressed("ataque"):
		if abs(t_actual - t_sig) < tiempGracia:
			print("SÍ") #incrementar daño
			$sonido.play()
		else:
			print("NO")
