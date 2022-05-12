extends KinematicBody

export var rapidez = 3
export var vida = 10

func take_damage():
	vida-=1
	print(vida)

func _physics_process(delta):
	#move_and_slide(Vector3(1,0,0) * rapidez, Vector3.UP)
	pass
