extends Control

@onready var level = get_tree().get_first_node_in_group("Level")
@onready var full_screen = level.full_screen

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		level.pauseMenu()

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

func _on_save_pressed():
	Global.save_game()

func _on_load_pressed():
	Global.load_game()

func _on_button_pressed():
	Global.next_day()

func _on_controls_pressed():
	$MarginContainer/VBoxContainer.hide()
	$MarginContainer/InputSettings.show()

func _on_back_controls_pressed():
	$MarginContainer/InputSettings.hide()
	$MarginContainer/VBoxContainer.show()
	InteractionManager.change_text()
	BigGlobal.save_game()
