extends Control

var full_screen = false
@onready var level = get_tree().get_first_node_in_group("Level")

func _on_resume_pressed():
	level.pauseMenu()

func _on_quit_pressed():
	print("evrrgcrd")
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
