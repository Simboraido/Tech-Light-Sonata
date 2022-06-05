extends KinematicBody

export var rapidez = 3
export var vida = 20

func take_damage():
	if Globales.enritmo:
		vida-=2
	else:
		vida-=1
	print(vida)

func _physics_process(delta):
	#move_and_slide(Vector3(1,0,0) * rapidez, Vector3.UP)
	if vida <= 0:
		get_tree().change_scene("res://scenes/Final.tscn")
