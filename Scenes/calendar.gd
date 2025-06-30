extends Sprite2D

@onready var level = get_tree().get_first_node_in_group("Level")
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	$GiveFoodFirst.material.set_shader_parameter("alpha", 0.0)
	frame = Global.current_day
	interaction_area.interact = Callable(self, "_next_day")
	
	
func _next_day():
	if level.can_next_day:
		Global.next_day()
	else:
		var tween = create_tween()
		tween.tween_property($GiveFoodFirst, "material:shader_parameter/alpha", 1.0, 0.0)
		tween.tween_property($GiveFoodFirst, "material:shader_parameter/alpha", 0.0, 2.5)
