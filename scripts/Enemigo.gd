extends KinematicBody

export var rapidez = 3
export var vida = 50
onready var malla = $MeshInstance

func take_damage():
	if Globales.enritmo:
		vida-=2
	else:
		vida-=1
	print(vida)

	if Globales.enritmo:
		if Globales.combo == 1:
			malla.get("material/0").albedo_color = Color.purple
		else:
			malla.get("material/0").albedo_color = Color.yellow
			
	else:
		malla.get("material/0").albedo_color = Color.red
		return



func _physics_process(delta):
	move_and_slide(Vector3(1,0,0) * rapidez, Vector3.UP)
	if vida <= 0:
		get_tree().change_scene("res://scenes/Final.tscn")
	if Globales.enritmo: #


