extends KinematicBody


onready var jugador = get_parent().get_node("Player")  

export(float) var rapidez = 8		# rapidez del enemigo
export(float) var rapidez2 = 14 	# rapidez del enemigo en la segunda fase

onready var vision = $RootNode
onready var angulo = $angulo

export var vidaMax = 40
var vida = vidaMax				# vida del enemigo
onready var malla = $MeshInstance
#export var fov = 90             	# mitad del fov del enemigo
export var izq = 270
export var der = 90
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
var State = combatState  				# le dice que estado tiene, combate or rifle
const normalState = ""						# caminar lento	animación
const rapidoState = "_f"						# caminar rápido animación
var speedState = normalState					# le dice si caminar rápido o lento en la animación, es nulo para animación normal y rápido para 



func rotateEnemy(Derecha:bool):					# ayuda con la animación de rotación, derecha=true, izquierda=false
	rotation.y += -(PI/2) if Derecha else +(PI/2)						# radianes 	
	if vida > 0:
		puedeCaminar = true

func take_damage():
	if Globales.enritmo:
		vida-=10
		Animacion.travel("c_hit_right")
	else:
		vida-=1
	
	if Globales.enritmo:
		if Globales.combo == 1:
			malla.get("material/0").albedo_color = Color.purple
		else:
			malla.get("material/0").albedo_color = Color.yellow

	else:
		malla.get("material/0").albedo_color = Color.red
		return

	if vida <= 0:
		puedeCaminar = false
		Animacion.travel(State+"_death")
		#get_tree().change_scene("res://scenes/Final.tscn")
		
	print(vida)

	if vida <= vidaMax/4:
		rapidez = rapidez2
		distanciaPersecucion = distanciaPersecucion2
		speedState = rapidoState
		
		
func _physics_process(delta):
	
	
	var puntoMirar = jugador.global_transform.origin		# con global transform se obtiene "el 0,0,0 del jefe" y .origin dice la posción en el mundo
	puntoMirar.y = global_transform.origin.y			# coordenada y de la pos en el mundo	
	#look_at(puntoMirar, Vector3.UP)

	angulo.look_at(puntoMirar,Vector3.UP)
		
	var anguloP = angulo.rotation_degrees.y			# ángulo del player respecto al frente del enemigo 
	var anguloP360 = int(anguloP+180)				# ángulo del player entre 0 y 360
#	print(anguloP360)
	
	if (anguloP360>225 and anguloP360<315): 		# grados
		Animacion.travel(State+"_rotate_left")
		puedeCaminar = false


	if (anguloP360<135 and anguloP360 > 45):
		Animacion.travel(State+"_rotate_right")
		puedeCaminar = false
		
	



	distanciaV = puntoMirar - global_transform.origin
	distancia = distanciaV.length()
	direccion = distanciaV/distancia
	 
	if distancia <7:
		Animacion.travel("c_punch_left")
#	print(distancia)
	
	#print(direccion)

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

func _on_hitbox_c_punch_left_body_entered(body):
	body.take_damage()

func _on_hitbox_c_punch_down_body_entered(body):
	body.take_damage(10)

func _on_hitbox_c_down_body_entered(body):
	body.take_damage(20)




			

		
		


		
		









		
		

	
	
	
	
	
	

	
	
	


	











