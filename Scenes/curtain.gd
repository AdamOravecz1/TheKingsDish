extends Area2D

@onready var curtains = get_children()

func _on_body_entered(body):
	for curtain in curtains:
		if curtain.material:
			var tween = create_tween()
			tween.tween_property(curtain, "material:shader_parameter/alpha", 0.0, 1.0)


func _on_body_exited(body):
	for curtain in curtains:
		if curtain.material:
			var tween = create_tween()
			tween.tween_property(curtain, "material:shader_parameter/alpha", 1.0, 1.0)

