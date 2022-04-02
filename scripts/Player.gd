extends KinematicBody

var velocidad = Vector3(0,0,0)
const rapidez = 10
const salto = 30
const gravedad = 300

func _ready():
	pass

func _physics_process(delta):
	var input = Vector3(Input.get_axis("ui_left","ui_right"),0,Input.get_axis("ui_up","ui_down"))
	velocidad = velocidad.move_toward(input.normalized()*rapidez,0.8)
	velocidad = move_and_slide(velocidad)
	velocidad = velocidad.move_toward(Vector3(0,-gravedad,0),3)
	if Input.is_action_pressed("ui_accept"):
		velocidad.y = salto
