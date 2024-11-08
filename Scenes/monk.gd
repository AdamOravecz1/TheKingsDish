extends Entity

func _ready():
	health = Global.animal_parameters["monk"]["health"]


func trigger_death():
	if alive:
		$AnimatedSprite2D.play("death")
		set_collision_layer_value(3, false)
