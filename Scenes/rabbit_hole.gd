extends Area2D

var has_place = true

func jump_in():
	has_place  = false
	$AnimatedSprite2D.play("rabbit")
	


func _on_body_entered(body):
	if "able_to_hide" in body and has_place:
		body.able_to_hide(self)


func _on_body_exited(body):
	if "unable_to_hide" in body:
		body.unable_to_hide()

