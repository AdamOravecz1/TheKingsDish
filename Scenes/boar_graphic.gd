extends Node2D

@onready var boar := get_parent()

func death():
	$Torso.play("death")
	$Legs.play("death")
	
func dig():
	$Torso.play("dig")
	$Legs.play("dig")
	
func run():
	$Torso.play("run")
	$Legs.play("run")

func _on_torso_animation_finished():
	if boar.alive:
		$Torso.play("walk")
		$Legs.play("walk")
		boar.speed_modifier = 1
