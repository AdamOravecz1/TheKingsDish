extends Sprite2D

@onready var level = get_tree().get_first_node_in_group("Level")
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	$GiveFoodFirst.material.set_shader_parameter("alpha", 0.0)
	frame = Global.current_day
	interaction_area.interact = Callable(self, "_next_day")
	
	
func _next_day():
	if Global.execution and Global.execution_text.begins_with("I have no one"):
		TransitionLayer.get_ending("res://Scenes/you_got_executed.tscn")
	elif Global.can_next_day:
		interaction_area.monitoring = false
		Global.next_day()
	else:
		var tween = create_tween()
		tween.tween_property($GiveFoodFirst, "material:shader_parameter/alpha", 1.0, 0.0)
		tween.tween_property($GiveFoodFirst, "material:shader_parameter/alpha", 0.0, 2.5)
