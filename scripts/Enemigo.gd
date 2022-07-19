extends KinematicBody


onready var jugador = get_parent().get_node("Player")  

export(float) var rapidez = 8		# rapidez del enemigo
export(float) var rapidez2 = 20 	# rapidez del enemigo en la segunda fase

onready var vision = $RootNode
onready var angulo = $angulo

export (int) var vidaMax = 400		# vida máxima del enemigo
var vida = vidaMax					# vida del enemigo
onready var malla = $MeshInstance

var girar = true					# le dice si puede "hacer look at"
var puedeCaminar = true				# dice si puede caminar

var distanciaV 						# vector distancia entre enemigo y jugador 
var direccion						# dirreción (unitario) entre enemigo y jugador
var distancia						# distnacia (número) etre enemigo y jugador
export var distanciaPersecucion = 25  # dice la distancia en la que el enemigo se mueve hacia el juagdor 
export var distanciaPersecucion2 = 17	# DEBE SER MAYOR QUE LA DISTANCIA DE LOS GOLPES CORTOS Y LARGOS!!!
# maquina de estado del animation tree
onready var Animacion = $RootNode/AnimationPlayer/AnimationTree.get("parameters/playback")
# advance condition
onready var anim_tree = $RootNode/AnimationPlayer/AnimationTree
const combatState = "c"				# estado de combate 
const rifleState = "r"				# estado de rifle
var State = combatState  			# le dice que estado tiene, combate or rifle
const normalState = ""				# caminar lento	animación
const rapidoState = "_f"			# caminar rápido animación
var speedState = normalState		# le dice si caminar rápido o lento en la animación, es nulo para animación normal y rápido para

var	anguloP360 						# ángulo del player entre 0 y 360
var vidaDelta 						# cambio de vida entre el golpe actual y el anterior
var tiempoTranscurrido = 0			# tiempo transucrrido desde que se apreta start (cuando está en pausa no cuenta)
var vivo = true						# dice si el enemigo está vivo o no
export (bool) var inmune = false	# dice si el enemigo es inmune al daño o no
var segundoActual = 0				# dice el segundo EN EL TICK actual
var puedeAtacar = false				# dice si puede atacar 
var PunoPorcentaje = 75				# porcentaje de probabilidad de pege un puñetazo
var PatadaPorcentaje = 30 			# porcentaje de veces que hace una patada, el complemento es las veces que pegará con los puños, es independiednte de porcentajeDeAtaque, este decide si es que pega o no (patada o puño)
var dado1							# dado que dice si patea
var dado2							# dado que dice si golpea 
var distanciaAtaqueCorto = 8		# distancia en la que el enemigo golpea 
var distanciaAtaqueLargo = 16		# distancia en la que el enemigo patea
var distanciaIdle = max(distanciaAtaqueCorto,distanciaAtaqueLargo)		# distancia en la que el enemigo se queda en idle
var atras = false					# dice si se está detras del enemigo



func rotateEnemy(Derecha:bool):		# ayuda con la animación de rotación, derecha=true, izquierda=false
	rotation.y += -(PI/2) if Derecha else +(PI/2)	# radianes
	if vida > 0:
		puedeCaminar = true

func take_damage():
	if inmune or atras:				# pregunta si es inmune o se está atrás del enemigo, si es true no se hace nada
		return
		
	if Globales.enritmo:
		vida-= (5 + (Globales.combo*2))
		vidaDelta = 5 + (Globales.combo*2)
		if not ((vida+vidaDelta)>=(vidaMax/2) and vida<=(vidaMax/2)) and State == combatState:
			if	jugador.global_transform.origin.y>0:
				Animacion.travel("c_hit_h")
			elif anguloP360>180 and anguloP360<360:
				Animacion.travel("c_hit_right")
			else:
				Animacion.travel("c_hit_left")
		else:
			Animacion.travel("c_hit_strong")
	else:
		vida-=2
		vidaDelta = 2
	
#	if Globales.enritmo:
#		if Globales.combo == 1:
#			malla.get("material/0").albedo_color = Color.purple
#		else:
#			malla.get("material/0").albedo_color = Color.yellow
#
#	else:
#		malla.get("material/0").albedo_color = Color.red
#		return


	if vida <= 0:
		vivo = false
		puedeCaminar = false
		Animacion.travel(State+"_death")
		jugador.rapidezW = 0
		jugador.rapidezD = 0
		jugador.rapidez = 0
		jugador.salto = 0
		jugador.puede_atacar = false

	print(vida)

	if vida <= vidaMax/2:
		rapidez = rapidez2
		distanciaPersecucion = distanciaPersecucion2
		speedState = rapidoState
		
		
func _physics_process(delta):

#	print(atras)
	
	tiempoTranscurrido+=delta			# tiempo transcurrido
	segundoActual = int(tiempoTranscurrido)			# dice el segundo del tick actual
#	print(tiempoTranscurrido)

	var puntoMirar = jugador.global_transform.origin	# con global transform se obtiene "el 0,0,0 del jefe" y .origin dice la posción en el mundo
	puntoMirar.y = global_transform.origin.y			# coordenada y de la pos en el mundo	

	distanciaV = puntoMirar - global_transform.origin
	distancia = distanciaV.length()
	direccion = distanciaV/distancia
	 


	angulo.look_at(puntoMirar,Vector3.UP)

	var anguloP = angulo.rotation_degrees.y			# ángulo del player respecto al frente del enemigo 
	anguloP360 = int(anguloP+180)				# ángulo del player entre 0 y 360

	if (anguloP360<45) or (anguloP360>315):		#  se está atrás del enemigo
		atras = true
	else: 
		atras = false

	print(distancia)
#	print(anguloP360)	

	if (anguloP360>225 and anguloP360<315) and vivo: 		# grados
		Animacion.travel(State+"_rotate_left")
		puedeCaminar = false

	if (anguloP360<135 and anguloP360 > 45) and vivo:
		Animacion.travel(State+"_rotate_right")
		puedeCaminar = false
	
	if tiempoTranscurrido-segundoActual <0.01:
		puedeAtacar = true
	else:
		puedeAtacar = false

	if int(distancia) <=distanciaAtaqueLargo and vivo and puedeAtacar and not atras and State == combatState:
		dado1 = randi() % 100 + 1			# entero entre 1 y 100
		dado2 = randi() % 100 + 1			# entero entre 1 y 100		
		
		if dado1 <= PatadaPorcentaje:						# la patada toma prioridad al puño pues hace más daño, pero es menos probable que salga
			Animacion.travel("c_kick_p")			
		else:		# si eleige pegar con el puño, para que se cumpla debe estar a la distancia del puño
			if dado2 <= PunoPorcentaje and int(distancia)<=distanciaAtaqueCorto:		# su el resultado del dado es favorable y no se está en la espalda del enemigo					#
				if anguloP360<=175:			# si se está a su derecha
					Animacion.travel("c_punch_right_p")
				elif anguloP360>=200:		# si se está a su izquierda
					Animacion.travel("c_punch_left_p")
				else:						# si se está al medio
					Animacion.travel("c_punch_down_p")

#	print(anguloP360)
#	print(distancia)

#	print(int(distancia))

	if !puedeCaminar:
		return
	if distancia >= distanciaPersecucion:
		look_at(puntoMirar, Vector3.UP)	
		move_and_slide(direccion * rapidez, Vector3.UP)
		Animacion.travel(State+"_walk"+speedState)
	else:
		if distancia >=distanciaIdle:					# máxima distancia de ataque 
			Animacion.travel(State+"_idle")


func _on_hitbox_c_punch_right_body_entered(body):
	body.take_damage(10)

func _on_hitbox_punch_left_body_entered(body):
	body.take_damage(10)

func _on_hitbox_c_punch_down_body_entered(body):
	body.take_damage(10)

func _on_hitbox_c_kick_body_entered(body):
	body.take_damage(20)

func change_scene():
	get_tree().change_scene("res://scenes/Final.tscn")
	
func _on_player_dead():
	Animacion.travel("e_dance")
