extends Resource
class_name Note


export (float) var time = 0
export (float) var duration = 0
const colors = [
	Color.white,
	Color.red,
	Color.green,
	Color.blue,
	Color.yellow
]
export (int, "White", "Red", "Green", "Blue", "Yellow") var color = 0 setget set_color


func set_color(c):
	if c is int:
		color = c
		return
	for i in range(colors.size()):
		if colors[i] == c:
			color = i
			return
	color = 0
	
func get_color():
	return colors[color]
	
func get_color_index():
	return color

func serialize():
	var data_dict = {
		"time": time,
		"duration": duration,
		"color": color
	}
	return data_dict

func deserialize(data_dict):
	match data_dict:
		{"time": var d_time, "duration": var d_duration, "color": var d_color, ..}:
			time = d_time
			duration = d_duration
			color = d_color
		_:
			print("No se pudieron obtener los datos de una nota")
			
