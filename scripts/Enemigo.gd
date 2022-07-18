extends KinematicBody


onready var jugador = get_parent().get_node("Player")  

export(float) var rapidez = 8		# rapidez del enemigo
export(float) var rapidez2 = 16 	# rapidez del enemigo en la segunda fase

onready var vision = $RootNode
onready var angulo = $angulo

export (int) var vidaMax = 40		# vida máxima del enemigo
var vida = vidaMax					# vida del enemigo
onready var malla = $MeshInstance

var girar = true					# le dice si puede "hacer look at"
var puedeCaminar = true				# dice si puede caminar

var distanciaV 						# vector distancia entre enemigo y jugador 
var direccion						# dirreción (unitario) entre enemigo y jugador
var distancia						# distnacia (número) etre enemigo y jugador
export var distanciaPersecucion = 30  # dice la distancia en la que el enemigo se mueve hacia el juagdor 
export var distanciaPersecucion2 = 15
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
var inmune = false					# dice si el enemigo es inmune al daño o no

# arreglar árbol y agregar animaciones P

func rotateEnemy(Derecha:bool):		# ayuda con la animación de rotación, derecha=true, izquierda=false
	rotation.y += -(PI/2) if Derecha else +(PI/2)	# radianes
	if vida > 0:
		puedeCaminar = true

func take_damage():
	if inmune:			# pregunta si es inmune, si lo es no se hace nada
		return
		
	if Globales.enritmo:
		vida-=10
		vidaDelta = 10
		if not ((vida+vidaDelta)>=(vidaMax/2) and vida<=(vidaMax/2)):
			if anguloP360>180 and anguloP360<360:
				Animacion.travel("c_hit_right")
			else:
				Animacion.travel("c_hit_left")
		else:
			Animacion.travel("c_hit_strong")
	else:
		vida-=1
		vidaDelta = 1
	
	if Globales.enritmo:
		if Globales.combo == 1:
			malla.get("material/0").albedo_color = Color.purple
		else:
			malla.get("material/0").albedo_color = Color.yellow

	else:
		malla.get("material/0").albedo_color = Color.red
		return

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

	if vida <= vidaMax/4:
		rapidez = rapidez2
		distanciaPersecucion = distanciaPersecucion2
		speedState = rapidoState
		
		
func _physics_process(delta):


	tiempoTranscurrido+=delta
	print(int(tiempoTranscurrido))

	var puntoMirar = jugador.global_transform.origin	# con global transform se obtiene "el 0,0,0 del jefe" y .origin dice la posción en el mundo
	puntoMirar.y = global_transform.origin.y			# coordenada y de la pos en el mundo	

	angulo.look_at(puntoMirar,Vector3.UP)

	var anguloP = angulo.rotation_degrees.y			# ángulo del player respecto al frente del enemigo 
	anguloP360 = int(anguloP+180)				# ángulo del player entre 0 y 360

	if (anguloP360>225 and anguloP360<315) and vivo: 		# grados
		Animacion.travel(State+"_rotate_left")
		puedeCaminar = false

	if (anguloP360<135 and anguloP360 > 45) and vivo:
		Animacion.travel(State+"_rotate_right")
		puedeCaminar = false

	distanciaV = puntoMirar - global_transform.origin
	distancia = distanciaV.length()
	direccion = distanciaV/distancia
	 

	if distancia <7 and vivo:
		Animacion.travel("c_kick_p")



	if !puedeCaminar:
		return
	if distancia > distanciaPersecucion:
		look_at(puntoMirar, Vector3.UP)	
		move_and_slide(direccion * rapidez, Vector3.UP)
		Animacion.travel(State+"_walk"+speedState)
	else:
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

	
	
	
	
	

	
	
	


	
























