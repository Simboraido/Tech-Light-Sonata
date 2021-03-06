extends KinematicBody


onready var jugador = get_parent().get_node("Player")  

export(float) var rapidez = 8		# rapidez del enemigo
export(float) var rapidez2 = 12 	# rapidez del enemigo en la segunda fase

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
var StompPorcentajeLejos = 30		# probabilidad de que haga el ataque salto/backflip al estár más lejos que el idle
var StompPorcentajeCerca = 10
var StompPorcentaje	= StompPorcentajeCerca		# probabilidad de que haga el ataque salto/backflip, toma prioridad sobre tanto la patada como el puño
const numeroDeStompsFase1 = 3
const numeroDeStompsFase2 = 5
var numeroDeStomps = numeroDeStompsFase1			# numero de veces que salta/hace backflip
var stompsRestantes = 0
var dado1							# dado que dice si patea
var dado2							# dado que dice si golpea 
var dado3							# dado que dice si salta
var hacerStomp						# dice si se debe hacer stomp
var distanciaAtaqueCorto = 8			# distancia en la que el enemigo golpea 
var distanciaAtaqueLargo = 15			# distancia en la que el enemigo patea
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
		Globales.puntaje += 50 + (Globales.combo+1)*2
		vida-= (5 + (Globales.combo*2))
		vidaDelta = 5 + (Globales.combo*2)
		if not ((vida+vidaDelta)>=(vidaMax/2) and vida<=(vidaMax/2)):
			if	jugador.global_transform.origin.y>0:
				Animacion.travel("c_hit_h")
			elif anguloP360>180 and anguloP360<360:
				Animacion.travel("c_hit_right")
			else:
				Animacion.travel("c_hit_left")
		else:
			Animacion.travel("c_hit_strong")
	else:
		Globales.puntaje += 10
		vida-=2
		vidaDelta = 2
	
	if vida <= 0:
		vivo = false
		puedeCaminar = false
		Animacion.travel("c_death")
		jugador.rapidezW = 0
		jugador.rapidezD = 0
		jugador.rapidez = 0
		jugador.salto = 0
		jugador.puede_atacar = false

#	print(vida)

	if vida <= vidaMax/2:
		rapidez = rapidez2
		distanciaPersecucion = distanciaPersecucion2
		speedState = rapidoState
		numeroDeStomps = numeroDeStompsFase2
				
func _physics_process(delta):
	if vida < 0:
		take_damage()
		return

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

	if (anguloP360>225 and anguloP360<315) and vivo and stompsRestantes==0: 		# grados
		Animacion.travel("c_rotate_left")
		puedeCaminar = false

	if (anguloP360<135 and anguloP360 >45) and vivo and stompsRestantes==0:
		Animacion.travel("c_rotate_right")
		puedeCaminar = false
	
	if tiempoTranscurrido-segundoActual <0.01:
		puedeAtacar = true
	else:
		puedeAtacar = false

	if puedeAtacar and vivo:
		if distancia>=distanciaIdle:				# dice que probabilidad usar
			StompPorcentaje = StompPorcentajeLejos
		else:
			StompPorcentaje = StompPorcentajeCerca

		if stompsRestantes == 0:
			dado3 = randi() % 100 + 1			# entero entre 1 y 100
			hacerStomp = dado3<StompPorcentaje	# booleano de hacer stomps
			if hacerStomp:
				stompsRestantes = numeroDeStomps

		if !hacerStomp: 			# si es que no debe hacer un salto
			if int(distancia) <=distanciaAtaqueLargo and vivo and not atras:
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
		else:	# debe hacer un salto
			Animacion.travel("c_backflip")
			stompsRestantes -= 1

	if !puedeCaminar:
		return
	if distancia >= distanciaPersecucion and !hacerStomp:
		look_at(puntoMirar, Vector3.UP)	
		move_and_slide(direccion * rapidez, Vector3.UP)
		Animacion.travel("c_walk"+speedState)
	else:
		if distancia >=distanciaIdle and !hacerStomp:					# máxima distancia de ataque 
			Animacion.travel("c_idle")


func _on_hitbox_c_punch_right_body_entered(body):
	body.take_damage(10)

func _on_hitbox_punch_left_body_entered(body):
	body.take_damage(10)

func _on_hitbox_c_punch_down_body_entered(body):
	body.take_damage(10)

func _on_hitbox_c_kick_body_entered(body):
	body.take_damage(20)

func _on_hitbox_c_backflip_body_entered(body):
	body.take_damage(20)

func change_scene():
	get_tree().change_scene("res://scenes/Final.tscn")
	
func _on_player_dead():
	Animacion.travel("e_dance")


