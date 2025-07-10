class_name ending
extends Node2D

func end():
	BigGlobal.found_recipes = Global.found_recipes
	BigGlobal.save_game()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CanvasLayer/VBoxContainer.show()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()
