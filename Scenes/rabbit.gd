extends Entity

var item = load("res://inventory/Items/rabbit.tres") as InvItem

var x_direction := 1
var speed = Global.animal_parameters["rabbit"]["speed"]
var speed_modifier := 1
var can_move := true
var can_hide := false
@onready var player = get_tree().get_first_node_in_group("Player")

@export var gravity := 600
@export var terminal_velocity := 500
var faster_fall := false
var gravity_multiplier := 1

var hiding_area: Area2D = null

@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	health = Global.animal_parameters["rabbit"]["health"]
	interaction_area.interact = Callable(self, "_pickup")
	$InteractionArea.monitoring = false
	
func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		remove()


func _process(delta):
	
	if health > 0 and can_move:
		velocity.x = x_direction * speed * speed_modifier
		apply_gravity(delta)
		check_cliff()
		check_wall()
		check_player_distance()
		animate()
		move_and_slide()

func check_player_distance():
	var distance_to_player = position.distance_to(player.global_position)
	var delta_x = global_position.x - player.global_position.x


	if distance_to_player < 60:
		speed_modifier = 2
		if (delta_x > 0 and x_direction < 0) or (delta_x < 0 and x_direction > 0):
			x_direction *= -1
			
		if can_hide:
			hiding_area.jump_in()
			gravity = 0
			position.y += 10000
			can_move = false
			
	else:
		speed_modifier = 1

		
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = velocity.y / 2 if faster_fall and velocity.y < 0 else velocity.y
	velocity.y = velocity.y * gravity_multiplier
	velocity.y = min(velocity.y, terminal_velocity)
	
	
func animate():
	$AnimatedSprite2D.flip_h = x_direction < 0
	
func trigger_death():
	if alive:
		$AnimatedSprite2D.play("death")
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
		
func able_to_hide(area: Area2D):
	hiding_area = area
	can_hide = true
	
func unable_to_hide():
	hiding_area = null
	can_hide = false
	


