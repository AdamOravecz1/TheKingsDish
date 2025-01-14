extends Area2D
@onready var player = get_tree().get_first_node_in_group("Player")

func _on_body_entered(body):
	if "swim" in body:
		body.swim()
	if "snap_to_surface" in body:
		# Try to find the CollisionShape2D as the first child
		var collision_shape = get_child(0)
		if collision_shape and collision_shape is CollisionShape2D:
			var water_surface_y = global_position.y - collision_shape.shape.extents.y
			body.snap_to_surface(water_surface_y)
func _on_body_exited(body):
	if "not_swim" in body:
		body.not_swim()
	if "top_of_water" in body:
		body.top_of_water()

func _on_area_entered(area):
	if area.name == "Nose":
		player.bubble_animation()

func _on_area_exited(area):
	if area.name == "Nose":
		player.bubble_stop()
