extends Area2D

@export var bolt_scene: PackedScene
@export_enum("down", "up", "left", "right") var shoot_direction := "down"

func _on_body_entered(body):
	if body.is_in_group("Player"):
		call_deferred("_shoot_bolts")

func _shoot_bolts():
	if bolt_scene:
		var direction = _get_direction_vector(shoot_direction)
		var rotation_angle = direction.angle()
		var offset = 10

		for x_offset in [-offset, offset]:
			var bolt = bolt_scene.instantiate()
			var spawn_pos = global_position
			if direction.x != 0:
				spawn_pos += Vector2(0, x_offset)
			else:
				spawn_pos += Vector2(x_offset, 0)

			bolt.setup(spawn_pos, direction, Global.weapons.CROSSBOW)
			bolt.rotation = rotation_angle

			var projectiles = get_tree().current_scene.get_node("Main/Projectiles")
			projectiles.add_child(bolt)

func _get_direction_vector(dir: String) -> Vector2:
	match dir:
		"down": return Vector2.DOWN
		"up": return Vector2.UP
		"left": return Vector2.LEFT
		"right": return Vector2.RIGHT
		_: return Vector2.DOWN
