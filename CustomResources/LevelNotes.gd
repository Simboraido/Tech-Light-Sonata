extends Resource
class_name LevelNotes


export (String) var name
export (int) var bpm
export (Vector2) var signature

var notes = []
const levelnote = preload("res://CustomResources/LevelNotes.gd")

func serialize():
	var serialized_notes = []
	for note in notes:
		serialized_notes.append(note.serialize())
	var data_dict = {
		"name": name,
		"bpm": bpm,
		"signature": [signature.x, signature.y],
		"notes": serialized_notes
	}
	return data_dict

func deserialize(data_dict):
	match data_dict:
		{"name": var d_name, "bpm": var d_bpm, "signature": var d_signature, "notes": var d_notes}:
			name = d_name
			bpm = d_bpm
			signature = Vector2(d_signature[0], d_signature[1])
			for note in d_notes:
				var new_note = levelnote.instance()
				new_note.deserialize(note)
				notes.append(new_note)
		_:
			print("No se pudieron obtener los datos de las notas de nivel")
