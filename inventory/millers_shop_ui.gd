extends Control

@onready var main = get_tree().current_scene


func remove_item():
	main.current_item = null
	main.current_slot = 100
	
func _on_button_pressed():
	if not main.buying:
		main.get_dragging(false)
		remove_item()
