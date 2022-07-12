extends KinematicBody

# vidaMax y vida
export (int) var vidaMax = 200
var vida = vidaMax

export (float) var eps = 0.1

export var rapidezW = 15								  # rapidez normal
export var rapidezD = 60								  # rapidez de dasheo
export var salto = 60                                     # valor de magnitud del salto
export var gravedad = 200                                 # valor de magnitude de la gravedad
onready var jefe = get_parent().get_node("Enemigo")       # se obtiene el nodo "Enemigo"
onready var targetCamera = $TargetPlayer				  # se obtiene el nodo "TargetPlayer"
onready var mesh = $TargetPlayer/MeshInstance	  		  # se obtiene el nodo "Player"
export var offsetC = Vector3(0,6,15)			  		  # offset entre la cámara y el jugador 
onready var rotarCamara = $TargetPlayer/Camera 			  # se obtiene el nodo "Camera"
var rapidez = rapidezW                                    # rapidez del personaje
var velocidad = Vector3(0,0,0) 			# vector velocidad, inicialmente en 0,0,0                           # se crea el vector velocidad del personaje
var rapidezY = 0										  # rapidez inicial en Y

# duracion del buffer
export (int) var timerAtq

# si estamos caminando hacia adelante
var adelante = false
# si estamos atacando
export (bool) var atacando = false
# si puede atacar
var puede_atacar = true
var combo = 0
var arr_ataques = ["slash_right", "slash_left", "kick", "finisher"]
# si te estan pegando
var pegando = false

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
export (int) var atck_cooldown = 20

# fix camara
export (float) var dist_max_camara
export (float) var dist_min_camara
export (float) var dist_corte
export (float) var dist_limite

func _ready():
	colision_ref.disabled = true
	atacando = false

func _physics_process(delta):			# delta es 1/60 seg.
	counter +=1
	
	# fixed camara
	var distCentro = global_transform.origin.distance_to(Vector3.ZERO)	#distancia al jefe
	rotarCamara.translation.z = dist_max_camara-clamp((distCentro-dist_corte)/(dist_limite-dist_corte), 0, 1)*(dist_max_camara-dist_min_camara)
	
	var puntoMirar = jefe.global_transform.origin		# con global transform se obtiene "el 0,0,0 del jefe" y .origin dice la posción en el mundo
	puntoMirar.y = global_transform.origin.y			# coordenada y de la pos en el mundo	
	targetCamera.look_at(puntoMirar, Vector3.UP)
	var input = Vector3(Input.get_axis("izquierda","derecha"),0,Input.get_axis("arriba","abajo"))			# recibe los inputs de movimineto 
	adelante = input.z != 0
	velocidad = input.normalized()*rapidez+Vector3(0,rapidezY,0)	# velocidad es el vector input normalizado por la rapidez más el vector de salto
	if not is_on_floor():			# si no está en el piso
		rapidezY -= gravedad*delta			# se aplica la gravedad
	if Input.is_action_pressed("salto"):	# si se apreta la tecla de salto
		if is_on_floor():					# si está en el piso salta, si no, no hace nada
#			take_damage(1)					# para probar
			rapidezY = salto				# salta

	if timerAtq > 0:
		timerAtq -= 1
		anim_tree["parameters/conditions/transition_combo"] = timerAtq > 0 and combo < 4 
		anim_tree["parameters/conditions/no_sgte_atck"] = not (timerAtq > 0 and combo < 4) 
	print(anim_tree["parameters/conditions/transition_combo"])

	if not dashing and dashc < dash_cooldown:
		dashc+=1
	if dashing and dashE < dash_duration:
		dashE+=1
	if dashE == dash_duration:
		rapidez = rapidezW
		dashing = false
		dashE = 0
		

#	if attack < 1:
#		attack += 1
#		$TargetPlayer/hitbox_ataque/CollisionShape.disabled = true			
#	if Input.is_action_just_pressed("ataque"):
#			$TargetPlayer/hitbox_ataque/CollisionShape.disabled = false
#			attack = 0
	
	colision_ref.disabled = not atacando

	velocidad = velocidad.rotated(Vector3.UP,targetCamera.rotation.y)
	velocidad = move_and_slide(velocidad,Vector3.UP)
	
	# Logica de transiciones
	if pegando:
		return
	if atacando:
#		if timerAtq > 0:
#			combo += 1
#		else:
#			combo = 4
#		if combo < 4:
#			Animacion.travel(arr_ataques[combo])
#		else:
#			Animacion.travel("idle")
#			combo = 0
#			timerAtq = 0
		pass
	else:
#		print("mov")
		if velocidad.y > 0:
			Animacion.travel("jump")
		if !is_on_floor() and velocidad.y < 0:
			Animacion.travel("caida")
		# para correr
		if abs(velocidad.x) > eps or abs(velocidad.z) > eps:
			if dashing:
				Animacion.travel("dash")
			elif adelante:
				Animacion.travel("walk") 
			else:
				Animacion.travel("strafe")
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
#		if !Globales.enritmo:
#			combo = 0
		if !puede_atacar:
			return
		if atacando or !is_on_floor():
			timerAtq = atck_cooldown
		else:
			atacando = true
#			timerAtq = 120
			Animacion.travel(arr_ataques[0])
			combo = 1
			anim_tree["parameters/conditions/transition_combo"] = false
			anim_tree["parameters/conditions/no_sgte_atck"] = true

func take_damage(danno):
	vida -= danno
