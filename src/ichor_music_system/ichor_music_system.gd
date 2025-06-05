@tool
extends AudioStreamPlayer

signal started

var folder_path: String = "":
	set = set_folder_path
var pause_on_song_finished: float = 0.05
var fade_in_time: float = 0.025
var fade_out_time: float = 0.025
var is_looping: bool = false
var shuffle_after_song_finished: bool = false
var shuffle_after_setting_folder_path: bool = false

var _song_list: Array = []
var _current_song: String = "":
	set(value):
		_current_song = value
		_load_current_song()



func _init() -> void:
	finished.connect(_on_finished)


func _load_current_song() -> void:
	var song: AudioStream = null
	var path: String = folder_path.path_join(_current_song)
	
	match _current_song.get_extension():
		"wav":
			song = AudioStreamWAV.load_from_file(path)
		"mp3":
			song = AudioStreamMP3.load_from_file(path)
		"ogg":
			song = AudioStreamOggVorbis.load_from_file(path)
		_:
			print("IchorMusicSystem: Illegal file type provided: %s" % _current_song.get_extension())
			return
	
	stream = song


func play_song(song_name: String) -> void:
	var tween: Tween = get_tree().create_tween()
	
	if playing:
		tween.tween_property(self, "volume_linear", 0.0, fade_out_time)
		await tween.finished
	
	_current_song = song_name
	play()
	tween = get_tree().create_tween()
	tween.tween_property(self, "volume_linear", 1.0, fade_in_time)
	started.emit()


func play_next_song_in_list() -> void:
	if _song_list.is_empty():
		print("IchorMusicSystem: song list is empty, cannot play next song.")
		return
	
	if not _current_song.is_empty():
		_song_list.push_back(_current_song)
	
	play_song(_song_list.pop_front())


func shuffle_song_list() -> void:
	if _song_list.is_empty():
		print("IchorMusicSystem: song list is empty, cannot shuffle.")
		return
	
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
	
	if shuffle_after_setting_folder_path:
		shuffle_song_list()
	
	if playing:
		_current_song = _song_list.pop_front()
		play_song(_current_song)


func get_song_list() -> PackedStringArray:
	return PackedStringArray(_song_list.duplicate())


func get_current_song() -> String:
	return _current_song



func _on_finished() -> void:
	if not is_looping:
		await get_tree().create_timer(pause_on_song_finished).timeout
	
	if shuffle_after_song_finished:
		shuffle_song_list()
	
	play_next_song_in_list() if not is_looping else play()
