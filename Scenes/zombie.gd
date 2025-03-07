extends Entity

var item = load("res://inventory/Items/rabbit.tres") as InvItem

var x_direction := 1
var speed = 30
var speed_modifier := 1
var can_move := true
var can_hide := false
@onready var player = get_tree().get_first_node_in_group("Player")

@export var gravity := 600
@export var terminal_velocity := 500
var faster_fall := false
var gravity_multiplier := 1

var hiding_area: Area2D = null

#@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	health = Global.animal_parameters["rabbit"]["health"]
	#interaction_area.interact = Callable(self, "_pickup")
	#$InteractionArea.monitoring = false
	
func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		remove()


func _process(delta):
	apply_gravity(delta)
	if health > 0 and can_move:
		velocity.x = x_direction * speed * speed_modifier
		animate()
		move_and_slide()


		
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = velocity.y / 2 if faster_fall and velocity.y < 0 else velocity.y
	velocity.y = velocity.y * gravity_multiplier
	velocity.y = min(velocity.y, terminal_velocity)
	
	
func animate():
	$AnimatedSprite2D.flip_h = x_direction > 0
	
func trigger_death():
	if alive:
		$AnimatedSprite2D.play("death")
		$InteractionArea.monitoring = true
		alive = false
		set_collision_layer_value(3, false)

	


