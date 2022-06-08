extends KinematicBody

var velocidad = Vector3(0,0,0) 			# vector velocidad, inicialmente en 0,0,0                           # se crea el vector velocidad del personaje
export var rapidez = 15                                   # rapidez del personaje
var rapidezY = 0										  # rapidez inicial en Y
export var salto = 60                                     # valor de magnitud del salto
export var gravedad = 200                                 # valor de magnitude de la gravedad
onready var jefe = get_parent().get_node("Enemigo")       # se obtiene el nodo "Enemigo"
onready var targetCamera = $TargetPlayer				  # se obtiene el nodo "TargetPlayer"
onready var mesh = $TargetPlayer/MeshInstance	  # se obtiene el nodo "Player"
export var offsetC = Vector3(0,6,15)			  		  # offset entre la cámara y el jugador 
onready var rotarCamara = $TargetPlayer/Camera 			  # se obtiene el nodo "Camera"

# dash
export var dash_cooldown = 30							# frames de cooldown al hacer dash
export var dash_duration = 15 							# duración del dash
var dash = dash_cooldown                                # dash cooldown contador
var dashing = false										# booleano que dice si dahsea o no

# ataque
var attack = 1
var attacking = false

var counter = 0

# fix camara
export (float) var dist_max_camara
export (float) var dist_min_camara
export (float) var dist_corte
export (float) var dist_limite

func _ready():
	$TargetPlayer/hitbox_ataque/CollisionShape.disabled = true

func _physics_process(delta):			# delta es 1/60 seg.
	counter +=1
	# fixed camara
	var distCentro = global_transform.origin.distance_to(Vector3.ZERO)	#distancia al jefe
	rotarCamara.translation.z = dist_max_camara-clamp((distCentro-dist_corte)/(dist_limite-dist_corte), 0, 1)*(dist_max_camara-dist_min_camara)
	
	var puntoMirar = jefe.global_transform.origin		# con global transform se obtiene "el 0,0,0 del jefe" y .origin dice la posción en el mundo
	puntoMirar.y = global_transform.origin.y			# coordenada y de la pos en el mundo	
	targetCamera.look_at(puntoMirar, Vector3.UP)
	var input = Vector3(Input.get_axis("izquierda","derecha"),0,Input.get_axis("arriba","abajo"))			# recibe los inputs de movimineto 
	velocidad = input.normalized()*rapidez+Vector3(0,rapidezY,0)	# velocidad es el vector input normalizado por la rapidez más el vector de salto
	if not is_on_floor():			# si no está en el piso
		rapidezY -= gravedad*delta			# se aplica la gravedad
	if Input.is_action_pressed("salto"):	# si se apreta la tecla de salto
		if is_on_floor():			# si está en el piso salta, si no, no hace nada
			rapidezY = salto				# salta

	if Input.is_action_just_pressed("dash"):
		if dash == dash_cooldown and (not dashing) and Globales.enritmo:
			rapidez = 60
			dash = 0
			dashing = true
		else:
			dash = 0
	if dash < dash_cooldown:
		dash+=1
		if dash == dash_duration:
			rapidez = 15
			dashing = false

	if attack < 1:
		attack += 1
		$TargetPlayer/hitbox_ataque/CollisionShape.disabled = true			
	if Input.is_action_just_pressed("ataque"):
			$TargetPlayer/hitbox_ataque/CollisionShape.disabled = false
			attack = 0

	velocidad = velocidad.rotated(Vector3.UP,targetCamera.rotation.y)
	velocidad = move_and_slide(velocidad,Vector3.UP)
	
	
func _on_hitbox_ataque_body_entered(body):  
	body.take_damage()
