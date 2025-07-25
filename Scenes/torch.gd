@tool
extends Node2D

@export_enum("Torch", "Candle", "Chandelier")
var type: int = 0:
	set(value):
		type = value
		_update_animation()

@onready var animation := $AnimatedSprite2D
@onready var light := $PointLight2D

func _ready():
	_update_animation()

func _update_animation():
	if not is_instance_valid(animation):
		return
	match type:
		0:
			animation.play("torch")
			animation.scale = Vector2(1, 1)
		1:
			animation.play("candle")
			animation.scale = Vector2(1, 1)
		2:
			animation.play("chandelier")
			animation.scale = Vector2(2, 2)
			

