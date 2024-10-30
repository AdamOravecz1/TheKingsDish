extends Control

@onready var main = get_tree().current_scene
var controls := 0.0

func _ready():
	for i in $NinePatchRect/GridContainer.get_children():
		if "Control" in i.name:
			controls += 1
	print(controls)

func remove_item():
	main.current_item = null
	main.current_slot = 100
	
func _on_button_pressed():
	main.get_dragging(false)
	main.buying = false
	remove_item()
