extends Area2D


func _on_body_entered(body):
	if "swim" in body:
		body.swim()
		
		
		



func _on_body_exited(body):
	if "not_swim" in body:
		body.not_swim()
