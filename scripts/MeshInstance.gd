extends MeshInstance
var counter = 0

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if not Globales.enritmo:
		get("material/0").albedo_color = Color.red
		counter = 0
		return
	if counter == 0:
		get("material/0").albedo_color = Color.orange
		counter += 1
	elif counter == 1:
		get("material/0").albedo_color = Color.yellow
		counter += 1
	elif counter == 2:
		get("material/0").albedo_color = Color.green
