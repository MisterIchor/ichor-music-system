@tool
extends AudioStreamPlayer

signal song_finished
signal song_started

var current_song: String = "":
	set(value):
		current_song = value
		_load_current_song()
var folder_path: String = "":
	set = set_folder_path
var pause_between_songs: float = 0.05
var fade_in: float = 0.025
var fade_out: float = 0.025

var _song_list: Array = []



func _init() -> void:
	stream = AudioStreamSynchronized.new()


func _load_current_song() -> void:
	var song: AudioStream = null
	var path: String = folder_path.path_join(current_song)
	
	match current_song.get_extension():
		"wav":
			song = AudioStreamWAV.load_from_file(path)
		"mp3":
			song = AudioStreamMP3.load_from_file(path)
		"ogg":
			song = AudioStreamOggVorbis.load_from_file(path)
		_:
			print("IchorMusicSystem: Illegal file type provided: %s" % current_song.get_extension())
			return
	
	stream = song



func play_next_song_in_list() -> void:
	_song_list.push_back(_song_list.pop_front())
	current_song = _song_list.front()


func shuffle_song_list() -> void:
	_song_list.shuffle()


func set_folder_path(new_path: String) -> void:
	folder_path = new_path
	var folder_dir: DirAccess = DirAccess.open(folder_path)
	
	if not folder_dir:
		print("IchorMusicSystem: could not find folder at path %s." % folder_path)
		return
	
	folder_dir.list_dir_begin()
	_song_list.clear()
	var current_file: String = folder_dir.get_next()
	
	while not current_file.is_empty():
		if current_file.get_extension() in ["wav", "ogg", "mp3"]:
			_song_list.append(current_file)
		
		current_file = folder_dir.get_next()
	
	current_song = _song_list.front()
