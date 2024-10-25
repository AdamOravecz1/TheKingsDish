extends Entity

var item = load("res://inventory/Items/boar.tres") as InvItem

var x_direction := 1
var speed = Global.animal_parameters["boar"]["speed"]
var speed_modifier := 1
var can_move := true
@onready var player = get_tree().get_first_node_in_group("Player")

var knockback_force: Vector2 = Vector2.ZERO
var knockback_duration: float = 0.0
var knockback_strength: float = 15000.0
var knocked_back: bool = false

@export var gravity := 600
@export var terminal_velocity := 500
var faster_fall := false
var gravity_multiplier := 1

var charge := false
var tusk_damage := 20
var tusk_knocback:= 10000.0

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	health = Global.animal_parameters["boar"]["health"]
	interaction_area.interact = Callable(self, "_pickup")
	$InteractionArea.monitoring = false
	
func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		remove()
		
		
func _process(delta):
	if knockback_duration > 0 and alive:
		# Apply knockback force
		var motion = knockback_force * delta
		velocity = motion
		# Decrease knockback duration over time
		knockback_duration -= delta
		if knockback_duration <= 0:
			knockback_force = Vector2.ZERO # Reset knockback force when duration is over
	
	elif health > 0 and can_move:
		velocity.x = x_direction * speed * speed_modifier
		check_cliff()
		check_wall()
		check_player()
		animate()
	
	if alive or not is_on_floor():
		move_and_slide()
	apply_gravity(delta)
	
	if knocked_back and is_on_floor():
		can_move = true
		knocked_back = false
		x_direction *= -1
		
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = velocity.y / 2 if faster_fall and velocity.y < 0 else velocity.y
	velocity.y = velocity.y * gravity_multiplier
	velocity.y = min(velocity.y, terminal_velocity)
	
func animate():
	$BoarGraphic.scale.x = x_direction
	$Agro.scale.x = -x_direction
	$Tusk.position.x = 23 * x_direction
	
func trigger_death():
	if alive:
		$Tusk/TuskHitbox.queue_free()
		$BoarGraphic.death()
		$InteractionArea.monitoring = true
		alive = false
		set_collision_layer_value(3, false)
	
func check_cliff():
	if x_direction > 0 and not $FloorRays/Right.get_collider():
		x_direction = -1
	if x_direction < 0 and not $FloorRays/Left.get_collider():
		x_direction = 1

func check_wall():
	if x_direction > 0 and $WallRays/Right.is_colliding():
		x_direction = -1
	if x_direction < 0 and $WallRays/Left.is_colliding():
		x_direction = 1
		
func check_player():
	if $Agro/AgroRay.is_colliding():
		$Timer.start()
		$ChargeTimer.start()
		charge = true
		$Tusk/TuskHitbox.disabled = false
	if charge:
		speed_modifier = 4
		$BoarGraphic.run()


func _on_timer_timeout():
	if alive and not charge:
		speed_modifier = 0
		$BoarGraphic.dig()
		
func _on_knock_back(source, force):
	can_move = false
	knocked_back = true
	$Timer.start()
	knockback_strength = force
	knockback_duration = 0.1

	# Calculate direction from source of impact to the character
	var direction = (global_position - source).normalized()

	# Apply force based on direction and strength
	knockback_force.x = direction.x * knockback_strength 
	
	# Apply upward force (positive Y direction in Godot is down, so subtract to go up)
	knockback_force.y -= 4000.0

func _on_charge_timer_timeout():
	charge = false
	speed_modifier = 1
	if $Tusk/TuskHitbox:
		$Tusk/TuskHitbox.disabled = true
	
func _on_tusk_body_entered(body):
	if body != self and "hit" in body:
		body.hit(tusk_damage, $Tusk.global_position, tusk_knocback)
