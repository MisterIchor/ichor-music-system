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
static var audio_bus: String = "":
	set = set_audio_bus
static var pause_between_songs: float = 0.05
static var fade_in: float = 0.025
static var fade_out: float = 0.025
static var is_stopped: bool = false:
	set = set_is_stopped
static var is_paused: bool = false:
	set = set_is_paused

static var _song_list: Array = []
static var _playback: AudioStreamSynchronized = AudioStreamSynchronized.new()
static var _stream: AudioStreamPlayback = AudioStreamPlayback.new()
static var _song_position: float = 0.00



static func play() -> void:
	return


static func pause() -> void:
	return


static func stop() -> void:
	return


static func play_from_list(song_list: String) -> void:
	return


static func play_next() -> void:
	_song_list.push_back(_song_list.pop_front())
	current_song = _song_list.front()


static func shuffle_song_list() -> void:
	_song_list.shuffle()



static func set_current_song(new_song: String) -> void:
	return


static func set_folder_path(new_path: String) -> void:
	return


static func set_audio_bus(bus_name: String) -> void:
	return


static func set_is_stopped(value: bool) -> void:
	return


static func set_is_paused(value: bool) -> void:
	return
