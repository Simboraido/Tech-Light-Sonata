extends KinematicBody

export(float) var rapidez = 0

export var vida = 500
onready var malla = $MeshInstance

# maquina de estado del animation tree
onready var Animacion = $RootNode/AnimationPlayer/AnimationTree.get("parameters/playback")
# advance condition
onready var anim_tree = $RootNode/AnimationPlayer/AnimationTree

func take_damage():
	if Globales.enritmo:
		vida-=10
		Animacion.travel("c_hit_right")
	else:
		vida-=1
	print(vida)
	

#	if Globales.enritmo:
#		if Globales.combo == 1:
#			malla.get("material/0").albedo_color = Color.purple
#		else:
#			malla.get("material/0").albedo_color = Color.yellow
#
#	else:
#		malla.get("material/0").albedo_color = Color.red
#		return



func _physics_process(delta):	
	move_and_slide(Vector3(1,0,0) * rapidez, Vector3.UP)
	if vida <= 0:
		get_tree().change_scene("res://scenes/Final.tscn")




