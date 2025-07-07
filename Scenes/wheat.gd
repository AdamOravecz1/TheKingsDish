@tool
extends Area2D

@export var type: int = 0:
	set(value):
		type = value
		update_tile_visibility()

@onready var tilemap_holder: Node2D = $TileMaps # change to match your scene

func _ready():
	if Engine.is_editor_hint():
		update_tile_visibility()
	update_tile_visibility()

func update_tile_visibility():
	if tilemap_holder == null:
		return

	for i in tilemap_holder.get_child_count():
		var child = tilemap_holder.get_child(i)
		child.visible = (i == type)

func _on_body_entered(body):
	var dir = body.velocity.x
	bend(dir)

func _on_area_entered(area):
	var dir = area.direction.x
	bend(dir)

func bend(dir):
	if dir > 0:
		$AnimationPlayer.play("bend_right")
	else:
		$AnimationPlayer.play("bend_left")
