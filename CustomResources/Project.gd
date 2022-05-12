extends Resource
class_name Project


var project_name: String = "Nuevo nivel"
var save_path: String = ""
var song_tracks: Array = []
var level_notes: Array = []
var curr_pixoct: int = 140
var curr_pixsec: int = 200
var track_names = []
var note_template
var note_template_path = ""
var track_len = 0
var song_bpm = 0


func serialize():
	var s_tracks = []
	var notes = []
	
	for track in song_tracks:
		s_tracks.append(track.serialize())
		
	for note in level_notes:
		notes.append(note.serialize())
	
	var data = {
		"name": project_name,
		"save_path": save_path,
		"pixoct": curr_pixoct,
		"pixsec": curr_pixsec,
		"song_tracks": s_tracks,
		"level_notes": notes,
		"track_names": track_names,
		"template_path": note_template_path,
		"track_len": track_len,
		"bpm": song_bpm
	}
	return data

func deserialize(data):
	match data:
		{"name": var p_name, "save_path": var p_path, "pixoct": var p_pixoct, "pixsec": var p_pixsec, "song_tracks": var p_tracks, "level_notes": var p_notes, "track_names": var p_tnames, "template_path": var p_template, "track_len": var p_len, "bpm": var p_bpm}:
			project_name = p_name
			save_path = p_path
			curr_pixoct = p_pixoct
			curr_pixsec = p_pixsec
			song_tracks = p_tracks
			level_notes = p_notes
			track_names = p_tnames
			note_template_path = p_template
			track_len = p_len
			song_bpm = p_bpm
			
			if note_template_path != "":
				note_template = load(note_template_path)
			
			var p_song_tracks = []
			var p_level_notes = []
			
			for track in p_tracks:
				var new_track = SongTrack.new()
				new_track.deserialize(track)
				p_song_tracks.append(new_track)
			
			for note in p_notes:
				var new_note = Note.new() if note_template == null else note_template.new()
				new_note.deserialize(note)
				p_level_notes.append(new_note)
			
			level_notes = p_level_notes
			song_tracks = p_song_tracks
			
		_: return

