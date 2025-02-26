extends Entity

@onready var interaction_area_shop: InteractionArea = $InteractionAreaShop

@onready var shop = $CanvasLayer/MonksShop_UI
@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var main = get_tree().current_scene

@onready var player = get_tree().get_first_node_in_group("Player")

var is_open := false

func _process(delta):
	if Input.is_action_just_pressed("inventory") and is_open:
		_talk()

func _ready():
	$PlayerLeft.set_deferred("monitoring", false)
	health = Global.animal_parameters["monk"]["health"]
	interaction_area_shop.interact = Callable(self, "_talk")
	
func _talk():
	if is_open:
		main.close()
		close()
	else:
		playerinv.position.x = 450
		main.open()
		open()


func trigger_death():
	if alive:
		$InteractionAreaShop.monitoring = false
		$AnimatedSprite2D.play("death")
		set_collision_layer_value(3, false)
		
func open():
	$PlayerLeft.monitoring = true
	shop.visible = true
	main.open()
	is_open = true
	
func close():
	shop.visible = false
	main.close()
	is_open = false
	$PlayerLeft.set_deferred("monitoring", false)

func _on_player_left_body_exited(body):
	close()


