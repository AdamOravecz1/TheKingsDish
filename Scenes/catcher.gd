@tool

extends Area2D

func _on_body_entered(body):
	if "back" in body:
		body.back()
		body.health -= 10
		get_tree().get_first_node_in_group("Level").update_health(body.health)
		
	elif "remove" in body:
		body.remove()
