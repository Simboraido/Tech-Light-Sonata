extends MeshInstance
var counter = 0

# Called when the node enters the scene tree for the first time.
# probe muchas cosas, el problema es que se actualiza todo el rato entonces
# hace el += 1 todo el rato por eso no se puede tener un contador decente
# quiza armar el contador en otra función aparte que no se este actualizando
# todo el rato y que solo revise la _physics_process
func _physics_process(delta):
	if Globales.enritmo:
		if counter != 0:
			get("material/0").albedo_color = Color.purple
		else:
			get("material/0").albedo_color = Color.yellow
		counter += 1
	else:
		get("material/0").albedo_color = Color.red
		counter = 0
		return

#get("material/0").albedo_color = Color.orange
