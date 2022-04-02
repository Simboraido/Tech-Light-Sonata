extends KinematicBody

var velocidad = Vector3(0,0,0)
export var rapidez = 15
export var salto = 30
export var gravedad = 200
onready var jefe = get_parent().get_node("Enemigo")
onready var targetCamera = $TargetPlayer
export var offsetC:Vector3 = Vector3(0,6,15)
onready var rotarCamara = $TargetPlayer/Camera 
var rapidezY = 0

func _ready():
	pass

func _physics_process(delta):
	var posicionJefe = Vector2(jefe.global_transform.origin.x,jefe.global_transform.origin.z)
	var posicionPlayer = Vector2(global_transform.origin.x,global_transform.origin.z)
	var anguloTargetP = posicionPlayer.angle_to(posicionJefe)
	targetCamera.rotation.y = anguloTargetP
	var input = Vector3(Input.get_axis("izquierda","derecha"),0,Input.get_axis("arriba","abajo"))
	velocidad = input.normalized()*rapidez+Vector3(0,rapidezY,0)
	rapidezY -= gravedad*delta
	if Input.is_action_pressed("salto"):
		rapidezY = salto
	velocidad = velocidad.rotated(Vector3.UP,anguloTargetP)
	velocidad = move_and_slide(velocidad)

