extends Control

@onready var level = get_tree().get_first_node_in_group("Level")
@onready var full_screen = level.full_screen

@onready var music = $MarginContainer/SoundControls/Music
@onready var sfx = $MarginContainer/SoundControls/SFX

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		level.pauseMenu()
		
func _ready():
	music.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sfx.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

func _on_resume_pressed():
	level.pauseMenu()

func _on_quit_pressed():
	get_tree().quit()

func _on_full_screen_pressed():
	if full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		full_screen = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		full_screen = true

func _on_controls_pressed():
	$MarginContainer/VBoxContainer.hide()
	$MarginContainer/InputSettings.show()
	$PanelContainer.hide()

func _on_back_controls_pressed():
	$MarginContainer/InputSettings.hide()
	$MarginContainer/VBoxContainer.show()
	$PanelContainer.show()
	InteractionManager.change_text()
	BigGlobal.save_game()

func _on_main_menu_pressed():
	Global.remove_progress()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_sound_pressed():
	$MarginContainer/SoundControls.show()
	$MarginContainer/VBoxContainer.hide()


func _on_music_value_changed(value):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)


func _on_sfx_value_changed(value):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)


func _on_back_setting_pressed():
	$MarginContainer/SoundControls.hide()
	$MarginContainer/VBoxContainer.show()
