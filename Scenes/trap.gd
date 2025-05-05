extends CharacterBody2D

var item = load("res://inventory/Items/rabbit.tres") as InvItem

var terminal_velocity := 500  # Max falling speed
var gravity := 600  # Define gravity strength
var faster_fall := false
var gravity_multiplier := 1
var health := 1

var caught = false

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("Player")

func setup(pos, c):
	position = pos
	caught = c
	interaction_area.interact = Callable(self, "_pickup")
	if caught:
		$Trap.frame = 1
		$AnimationPlayer.play("cought")
		
func _pickup():
	if caught:
		player.collect(item)
		if player.free_inv_slot:
			queue_free()
	else:
		queue_free()
		player.trap_calculate(1)

func _process(delta):
	apply_gravity(delta)
	move_and_slide()

func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = velocity.y / 2 if faster_fall and velocity.y < 0 else velocity.y
	velocity.y = velocity.y * gravity_multiplier
	velocity.y = min(velocity.y, terminal_velocity)

func _on_catcher_body_entered(body):
	if body.name == "Rabbit":
		if "remove" in body:
			body.remove()
			$Trap.frame = 1
			caught = true
			$AnimationPlayer.play("cought")
			

