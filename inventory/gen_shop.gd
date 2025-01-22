class_name gen_shop
extends Control

@onready var main = get_tree().current_scene
var controls := 0.0

func _ready():
	$Label.material.set_shader_parameter("alpha", 0.0)
	for i in $NinePatchRect/GridContainer.get_children():
		if "Control" in i.name:
			controls += 1

func remove_item():
	main.current_item = null
	main.current_slot = 100
	
func _on_button_pressed():
	main.get_dragging(false)
	main.buying = false
	remove_item()
	
func flash_text():
	var tween = create_tween()
	tween.tween_property($Label, "material:shader_parameter/alpha", 1.0, 0.0)
	tween.tween_property($Label, "material:shader_parameter/alpha", 0.0, 1.0)


