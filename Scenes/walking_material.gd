extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")
@export_enum("grass", "stone", "wood", "none") var ground := "grass"

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player.set_walk_surface(ground)
