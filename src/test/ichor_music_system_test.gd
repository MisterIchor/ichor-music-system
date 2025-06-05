extends Control

@onready var play_next_song_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/PlayNextSongButton
@onready var stop_player_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/StopPlayerButton
@onready var load_selected_folder_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/LoadSelectedFolderButton
@onready var shuffle_song_list_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/ShuffleSongListButton
@onready var quit_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/QuitButton
@onready var fade_in_spin_box: SpinBox = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/FadeInContainer/FadeInSpinBox
@onready var fade_out_spin_box: SpinBox = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/FadeOutContainer/FadeOutSpinBox
@onready var pause_spin_box: SpinBox = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/PauseContainer/PauseSpinBox
@onready var folder_list: ItemList = $PanelContainer/VBoxContainer/HBoxContainer/FolderListContainer/FolderList
@onready var song_list: ItemList = $PanelContainer/VBoxContainer/HBoxContainer/SongListContainer/SongList
@onready var play_current_song_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/PlayCurrentSongButton
@onready var start_player_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/StartPlayerButton
@onready var pause_player_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/PausePlayerButton
@onready var add_folder_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/AddFolderButton
@onready var remove_folder_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/RemoveFolderButton
@onready var shuffle_song_finished_check_box: CheckBox = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/ShuffleSongFinshedContainer/ShuffleSongFinishedCheckBox
@onready var shuffle_setting_folder_check_box: CheckBox = $PanelContainer/VBoxContainer/HBoxContainer/OptionContainer/ShuffleSettingFolderContainer/ShuffleSettingFolderCheckBox
@onready var current_song_label: Label = $PanelContainer/VBoxContainer/CurrentSongLabel

var _last_folder_selected: int = -1



func _ready() -> void:
	play_current_song_button.pressed.connect(IchorMusicSystem.play_current_song)
	play_next_song_button.pressed.connect(_on_PlayNextSongButton_pressed)
	start_player_button.pressed.connect(IchorMusicSystem.play)
	pause_player_button.pressed.connect(_on_PausePlayerButton_pressed)
	stop_player_button.pressed.connect(IchorMusicSystem.stop)
	add_folder_button.pressed.connect(_on_AddFolderButton_pressed)
	remove_folder_button.pressed.connect(_on_RemoveFolderButton_pressed)
	load_selected_folder_button.pressed.connect(_on_LoadSelectedFolderButton_pressed)
	shuffle_song_list_button.pressed.connect(_on_ShuffleSongListButton_pressed)
	quit_button.pressed.connect(get_tree().quit)
	fade_in_spin_box.value_changed.connect(_on_FadeInSpinBox_value_changed)
	fade_out_spin_box.value_changed.connect(_on_FadeOutSpinBox_value_changed)
	pause_spin_box.value_changed.connect(_on_PauseSpinBox_value_changed)
	folder_list.item_selected.connect(_on_FolderList_item_selected)
	shuffle_setting_folder_check_box.toggled.connect(_on_ShuffleSettingFolderCheckBox_toggled)
	shuffle_song_finished_check_box.toggled.connect(_on_ShuffleSongFinishedCheckBox_toggled)
	IchorMusicSystem.finished.connect(_on_IchorMusicSystem_finished)
	IchorMusicSystem.started.connect(_on_IchorMusicSystem_started)
	
	fade_in_spin_box.value = IchorMusicSystem.fade_in_time
	fade_out_spin_box.value = IchorMusicSystem.fade_out_time
	pause_spin_box.value = IchorMusicSystem.pause_between_songs
	shuffle_setting_folder_check_box.button_pressed = IchorMusicSystem.shuffle_after_setting_folder_path
	shuffle_song_finished_check_box.button_pressed = IchorMusicSystem.shuffle_after_song_finished



func _refresh_song_list() -> void:
	song_list.clear()
	
	for i in IchorMusicSystem.get_song_list():
		song_list.add_item(i)
		song_list.set_item_disabled(song_list.item_count - 1, true)



func _on_FadeInSpinBox_value_changed(new_value: float) -> void:
	IchorMusicSystem.fade_in_time = new_value


func _on_FadeOutSpinBox_value_changed(new_value: float) -> void:
	IchorMusicSystem.fade_out_time = new_value


func _on_PauseSpinBox_value_changed(new_value: float) -> void:
	IchorMusicSystem.pause_between_songs = new_value


func _on_AddFolderButton_pressed() -> void:
	var file_dialog: FileDialog = FileDialog.new()
	
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.popup_exclusive_centered(self)
	folder_list.add_item(await file_dialog.dir_selected)
	file_dialog.queue_free()


func _on_LoadSelectedFolderButton_pressed() -> void:
	if _last_folder_selected == -1:
		print("IchorMusicSystemTest: no folders are selected, cannot load.")
		return
	
	print(folder_list.get_item_text(_last_folder_selected))
	IchorMusicSystem.folder_path = folder_list.get_item_text(_last_folder_selected)
	_refresh_song_list()


func _on_RemoveFolderButton_pressed() -> void:
	if _last_folder_selected == -1:
		print("IchorMusicSystemTest: no folders are selected, cannot remove.")
		return
	
	folder_list.remove_item(_last_folder_selected)


func _on_FolderList_item_selected(idx: int) -> void:
	_last_folder_selected = idx


func _on_PausePlayerButton_pressed() -> void:
	IchorMusicSystem.stream_paused = !IchorMusicSystem.stream_paused


func _on_ShuffleSettingFolderCheckBox_toggled(is_toggled: bool) -> void:
	IchorMusicSystem.shuffle_after_setting_folder_path = is_toggled


func _on_ShuffleSongFinishedCheckBox_toggled(is_toggled: bool) -> void:
	IchorMusicSystem.shuffle_after_song_finished = is_toggled


func _on_ShuffleSongListButton_pressed() -> void:
	IchorMusicSystem.shuffle_song_list()
	_refresh_song_list()


func _on_IchorMusicSystem_finished() -> void:
	if IchorMusicSystem.shuffle_after_song_finished:
		_refresh_song_list()


func _on_IchorMusicSystem_started() -> void:
	current_song_label.text = str("Current Song: ", IchorMusicSystem.current_song)


func _on_PlayNextSongButton_pressed() -> void:
	IchorMusicSystem.play_next_song_in_list()
	_refresh_song_list()
