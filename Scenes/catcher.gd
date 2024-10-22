@tool

extends Area2D



func _on_body_entered(body):
	if "back" in body:
		body.back()
		
	elif "remove" in body:
		body.remove()
