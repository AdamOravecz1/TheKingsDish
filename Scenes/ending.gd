class_name ending
extends Node2D

func end():
	for key in Global.found_recipes.keys():
		if not BigGlobal.found_recipes.has(key):
			BigGlobal.found_recipes[key] = Global.found_recipes[key]
	BigGlobal.save_game()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CanvasLayer/VBoxContainer.show()

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
