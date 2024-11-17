extends Entity

var item = load("res://inventory/Items/fish.tres") as InvItem

var speed = Global.animal_parameters["fish"]["speed"]
var speed_modifier := 1
var can_move := true
var floating := false
@onready var player = get_tree().get_first_node_in_group("Player")

@onready var pos = $Path2D/PathFollow2D
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	health = Global.animal_parameters["fish"]["health"]
	interaction_area.interact = Callable(self, "_pickup")
	$InteractionArea.monitoring = false
	
func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		remove()
	
func _process(delta):
	pos.progress_ratio += delta*speed*speed_modifier
	if alive:
		$AnimatedSprite2D.global_position = pos.global_position
		$CollisionShape2D.global_position = pos.global_position
		$InteractionArea.global_position = pos.global_position

	if pos.progress_ratio <= 0.5:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	if floating:
		global_position -= Vector2(0, speed)

func trigger_death():
	if alive:
		speed_modifier = 0
		$AnimatedSprite2D.play("death")
		$AnimatedSprite2D.position.y = 5
		$InteractionArea.monitoring = true
		alive = false
		floating = true
		#set_collision_layer_value(3, false)
		
func top_of_water():
	floating = false
	
