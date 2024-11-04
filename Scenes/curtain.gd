extends Area2D

@onready var curtain = get_child(0)


func _on_body_entered(body):
	var tween = create_tween()
	tween.tween_property(curtain, "material:shader_parameter/alpha", 0.0, 1.0)


func _on_body_exited(body):
	var tween = create_tween()
	tween.tween_property(curtain, "material:shader_parameter/alpha", 1.0, 1.0)
