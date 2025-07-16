class_name ending
extends Node2D

func end():
	if self.name not in BigGlobal.found_endings:
		BigGlobal.found_endings.append(self.name)
	BigGlobal.save_game()
	Global.delete_save()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$CanvasLayer/VBoxContainer.show()

func _on_main_menu_pressed():
	Music.play_level_music()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
