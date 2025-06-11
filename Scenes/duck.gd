extends Entity

var item = load("res://inventory/Items/duck.tres") as InvItem

var x_direction := 1
var speed = Global.animal_parameters["duck"]["speed"]
var speed_modifier := 1
var can_move := true
var fly := false
var descend := false
var swimming := false
var floating := false
@export var type := 0

@onready var player = get_tree().get_first_node_in_group("Player")

@export var gravity := 600
@export var terminal_velocity := 500
var faster_fall := false
var gravity_multiplier := 1
@onready var animation := $DuckMale

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	if type == 0:
		animation = $DuckMale
		$DuckFemale.hide()
		$DuckMale.show()
	elif type == 1:
		animation = $DuckFemale
		$DuckFemale.show()
		$DuckMale.hide()
	health = Global.animal_parameters["duck"]["health"]
	interaction_area.interact = Callable(self, "_pickup")
	$InteractionArea.monitoring = false
	
func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		remove()
		
func _process(delta):
	if health > 0 and can_move:
		if fly:
			animation.play("flight")
			velocity.y = -speed * speed_modifier
		elif swimming:
			velocity.y = 0

		elif descend:
			velocity.y = speed * speed_modifier
			if is_on_floor():
				descend = false
				animation.play("walk")
				speed_modifier = 1

		velocity.x = x_direction * speed * speed_modifier
		check_cliff()
		check_wall()
		check_player_distance()
		animate()
		move_and_slide()
	if not fly and not descend and not swimming and not floating:
		apply_gravity(delta)
		if not is_on_floor():
			move_and_slide()
	if floating and not alive:
		velocity.y = 0
		
func check_player_distance():
	var distance_to_player = position.distance_to(player.global_position)
	var delta_x = global_position.x - player.global_position.x

	if distance_to_player < 120:
		if not fly:
			$Sound/Flight.play()
		$Timers/Flight.start()
		speed_modifier = 4
		fly = true
		if (delta_x > 0 and x_direction < 0) or (delta_x < 0 and x_direction > 0):
			x_direction *= -1

		
func animate():
	animation.flip_h = -x_direction < 0
		
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = velocity.y / 2 if faster_fall and velocity.y < 0 else velocity.y
	velocity.y = velocity.y * gravity_multiplier
	velocity.y = min(velocity.y, terminal_velocity)
	
func check_cliff():
	if not fly and not descend and not swimming:
		if x_direction > 0 and not $FloorRays/Right.get_collider():
			x_direction = -1
		if x_direction < 0 and not $FloorRays/Left.get_collider():
			x_direction = 1

func check_wall():
	if x_direction > 0 and $WallRays/Right.is_colliding():
		x_direction = -1
	if x_direction < 0 and $WallRays/Left.is_colliding():
		x_direction = 1
		
func trigger_death():
	fly = false
	descend = false
	if alive:
		$Sound/Death.play()
		animation.position.y += 5
		animation.play("death")
		$InteractionArea.monitoring = true
		alive = false
		set_collision_layer_value(3, false)
		set_collision_layer_value(6, true)

func _on_flight_timeout():
	if alive:
		fly = false
		descend = true
		
func swim():
	floating = true
	swimming = true
	speed_modifier = 1
	descend = false
	if alive:
		animation.play("swim")
	
func not_swim():
	swimming = false

func snap_to_surface(water_surface_y):
	if not swimming:
		return  # Avoid redundant snapping if already swimming

	# Snap the duck to the water surface
	global_position.y = water_surface_y + 11
	velocity.y = 0  # Ensure no vertical movement
	
func top_of_water():
	floating = false
