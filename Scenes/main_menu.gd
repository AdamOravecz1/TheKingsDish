extends Control

@onready var parallax = $ParallaxBackground
@export var scroll_speed: float = 30.0

func _process(delta):
	if parallax:
		parallax.scroll_offset.x += scroll_speed * delta


func _on_button_pressed():
	print("haaaaaaaa")
	TransitionLayer.change_scene("res://Scenes/castle.tscn")

