extends KinematicBody

# vidaMax y vida
export (int) var vidaMax = 20000
var vida = vidaMax

export (float) var eps = 0.1

export var rapidezW = 15								# rapidez normal
export var rapidezD = 60								# rapidez de dasheo
export var salto = 60									# valor de magnitud del salto
export var gravedad = 200								# valor de magnitude de la gravedad
onready var jefe = get_parent().get_node("Enemigo")		# se obtiene el nodo "Enemigo"
onready var targetCamera = $TargetPlayer				# se obtiene el nodo "TargetPlayer"
export var offsetC = Vector3(0,6,15)					# offset entre la cámara y el jugador 
onready var rotarCamara = $TargetPlayer/Camera 			# se obtiene el nodo "Camera"
var rapidez = rapidezW									# rapidez del personaje
var velocidad = Vector3(0,0,0) 							# vector velocidad, inicialmente en 0,0,0                           # se crea el vector velocidad del personaje
var rapidezY = 0										# rapidez inicial en Y

onready var dash_particles = $Particles

export (int) var timerAtq								# duracion del buffer
var adelante = false
var atras = false
var derecha = false
var izquierda = false
export (bool) var atacando = false						# si estamos atacando
var puede_atacar = true									# si puede atacar
var combo = 0
var arr_ataques = ["new_slash_right", "new_slash_left", "new_kick", "finisher"]
var pegando = false										# si te estan pegando

# maquina de estado del animation tree
onready var Animacion = $TargetPlayer/RootNode/AnimationPlayer/AnimationTree.get("parameters/playback")
# advance condition
onready var anim_tree = $TargetPlayer/RootNode/AnimationPlayer/AnimationTree
onready var colision_ref = $TargetPlayer/hitbox_ataque/CollisionShape

# dash
export var dash_cooldown = 20							# frames de cooldown al hacer dash
export var dash_duration = 15 							# duración del dash
var dashc = dash_cooldown                               # dash cooldown contador (si está en ele máximo está "cargado")
var dashE = 0											# dashE contador (si llega a el valor máximo, deja de dashear) 
var dashing = false										# booleano que dice si dahsea o no

# ataque
var attack = 1
var counter = 0
export (int) var atck_cooldown = 15

# fix camara
export (float) var dist_max_camara
export (float) var dist_min_camara
export (float) var dist_corte
export (float) var dist_limite

# declaramos señal
signal player_dead

# curar
var comboAnterior


func _ready():
	colision_ref.disabled = true
	atacando = false
	connect("player_dead", jefe, "_on_player_dead")



func _physics_process(delta):							# delta es 1/60 seg.+
	if vida <= 0:
		take_damage(1)
		return

	if Globales.combo >= 8 and Globales.combo!=comboAnterior:								# si el combo es >= 5 se cura
		vida += 2
	comboAnterior = Globales.combo		# OJO, es importante que combo anterior esté después de está función, si no lo está nunca será diferente al anterior

	counter +=1
		
	# fixed camara
	var distCentro = global_transform.origin.distance_to(Vector3.ZERO)			#distancia al jefe
	rotarCamara.translation.z = dist_max_camara - clamp((distCentro - dist_corte)/(dist_limite - dist_corte), 0, 1)*(dist_max_camara - dist_min_camara)

	var puntoMirar = jefe.global_transform.origin
	puntoMirar.y = global_transform.origin.y
	targetCamera.look_at(puntoMirar, Vector3.UP)

	var input = Vector3(Input.get_axis("izquierda","derecha"),0,Input.get_axis("arriba","abajo"))
	adelante = input.z < 0
	atras = input.z > 0  
	derecha = input.x > 0 and !adelante

	# salto
	velocidad = input.normalized()*rapidez + Vector3(0,rapidezY,0)
	if not is_on_floor():
		rapidezY -= gravedad*delta
	if Input.is_action_pressed("salto"):
		if is_on_floor():
			rapidezY = salto

	if timerAtq > 0:
		timerAtq -= 1
		anim_tree["parameters/conditions/transition_combo"] = timerAtq > 0 and combo < 4 
		anim_tree["parameters/conditions/no_sgte_atck"] = not (timerAtq > 0 and combo < 4) 
#	print(anim_tree["parameters/conditions/transition_combo"])

	if not dashing and dashc < dash_cooldown:
		dashc+=1
	if dashing and dashE < dash_duration:
		dashE+=1
	if dashE == dash_duration:
		rapidez = rapidezW
		dashing = false
		dashE = 0

#	colision_ref.disabled = not atacando

	velocidad = velocidad.rotated(Vector3.UP,targetCamera.rotation.y)
	velocidad = move_and_slide(velocidad,Vector3.UP)

	# Logica de transiciones
	if pegando:
		return
	if atacando:
		pass
	else:
		if velocidad.y > 0.01:
			Animacion.travel("jump")
		elif !is_on_floor() and velocidad.y < -0.01:
			Animacion.travel("caida")
		# para correr
		else:
			if abs(velocidad.x) > eps or abs(velocidad.z) > eps:
				if dashing:
					dash_particles.emitting = true
					Animacion.travel("dash")
				elif adelante:
					Animacion.travel("new_walk_foward") 
				elif atras:
					Animacion.travel("new_walk_backward")
				elif derecha:
					Animacion.travel("new_strafe_right")
				else:
					Animacion.travel("new_strafe_left")
			else:
				Animacion.travel("idle")


func _on_hitbox_ataque_body_entered(body):  
	body.take_damage()
	
func _input(event):
	if event.is_action_pressed("dash"):
		if dashc == dash_cooldown and Globales.enritmo:
			rapidez = rapidezD
			dashing = true
		dashc = 0

	if event.is_action_pressed("ataque"):
		if !Globales.enritmo:
			combo = 0
		if !puede_atacar:
			return
		if atacando or !is_on_floor():
			timerAtq = atck_cooldown
		else:
			atacando = true
			Animacion.travel(arr_ataques[0])
			combo = 1
			anim_tree["parameters/conditions/transition_combo"] = false
			anim_tree["parameters/conditions/no_sgte_atck"] = true

func take_damage(danno):
	vida -= danno
	if vida <= 0:
		emit_signal("player_dead")
		Animacion.travel("death")
	else:
		Animacion.travel("hit")
	
func scene_changer():
	get_tree().change_scene("res://scenes/GameOver.tscn")
	
# hacer un metodo para llamar en el dash, que desactive la colision shape del ataque del boss
