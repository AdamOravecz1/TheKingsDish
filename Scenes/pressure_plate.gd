extends Area2D


func _on_body_entered(body):
	$Sprite2D.visible = false
	



func _on_body_exited(body):
	$Sprite2D.visible = true
