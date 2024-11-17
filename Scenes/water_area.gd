extends Area2D
@onready var player = get_tree().get_first_node_in_group("Player")

func _on_body_entered(body):
	if "swim" in body:
		body.swim()
		
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
