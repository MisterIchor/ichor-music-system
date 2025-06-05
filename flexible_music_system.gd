class_name IchorMusicSystem
extends Object

signal song_finished
signal song_started
signal music_stopped
signal music_resumed

static var current_song: String = "":
	set = set_current_song
static var folder_path: String = "":
	set = set_folder_path
static var music_audio_bus: String = "":
	set = set_music_audio_bus
static var pause_between_songs: float = 0.05
static var is_stopped: bool = false:
	set = set_is_stopped
static var is_paused: bool = false:
	set = set_is_paused

static var _song_list: Array = []
static var _playback: AudioStreamSynchronized = AudioStreamSynchronized.new()
static var _stream: AudioStreamPlayback = AudioStreamPlayback.new()



static func play() -> void:
	return


static func play_from_list(song_list: String) -> void:
	return


static func play_next() -> void:
	_song_list.push_back(_song_list.pop_front())
	current_song = _song_list.front()


static func shuffle_song_list() -> void:
	_song_list.shuffle()
