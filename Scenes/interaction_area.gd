extends Area2D
class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass


func _on_body_entered(_body):
	IntearctionManager.register_area(self)



func _on_body_exited(_body):
	IntearctionManager.unregister_area(self)


