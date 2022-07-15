extends KinematicBody


onready var jugador = get_parent().get_node("Player")  

export(float) var rapidez = 0		# rapidez del enemigo

onready var vision = $RootNode
onready var angulo = $angulo

export var vida = 500				# vida del enemigo
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
	

	if Globales.enritmo:
		if Globales.combo == 1:
			malla.get("material/0").albedo_color = Color.purple
		else:
			malla.get("material/0").albedo_color = Color.yellow

	else:
		malla.get("material/0").albedo_color = Color.red
		return

	if vida <= 0:
		get_tree().change_scene("res://scenes/Final.tscn")


func _physics_process(delta):	
	move_and_slide(Vector3(1,0,0) * rapidez, Vector3.UP)
	
	var puntoMirar = jugador.global_transform.origin		# con global transform se obtiene "el 0,0,0 del jefe" y .origin dice la posción en el mundo
	puntoMirar.y = global_transform.origin.y			# coordenada y de la pos en el mundo	
	#look_at(puntoMirar, Vector3.UP)


	angulo.look_at(puntoMirar,Vector3.UP)
	
	var anguloP = angulo.rotation_degrees.y			# angulo del player respecto al frente del enemigo 
	var anguloP360 = int(anguloP+180)
	print(anguloP360)
	
	var inf = anguloP360-90
	var maxi = anguloP360+90
	
	if maxi>360:
		var  tempmaxi = maxi
		var  tempinf = inf
		inf = tempmaxi%360
		maxi = inf 
	
	if inf<0:
		var  tempmaxi = maxi
		var  tempinf = inf
		

	print("inf "+str(inf))
	print("maxi "+str(maxi))

	
	
	
	
	
	

	
	
	


	




