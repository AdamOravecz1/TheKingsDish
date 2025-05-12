extends Entity

@onready var interaction_area_shop: InteractionArea = $InteractionAreaShop

@onready var shop = $CanvasLayer/MonksShop_UI
@onready var talk = $CanvasLayer/Speech
@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var main = get_tree().current_scene

@onready var player = get_tree().get_first_node_in_group("Player")

var is_open := false
var is_shop_visible := false


func _process(delta):
	if Input.is_action_just_pressed("inventory") and is_open:
		_talk()

func _ready():
	$PlayerLeft.set_deferred("monitoring", false)
	health = Global.animal_parameters["monk"]["health"]
	interaction_area_shop.interact = Callable(self, "_talk")
	
func _talk():
	if is_open:
		close()
	else:
		open()

func trigger_death():
	if alive:
		$InteractionAreaShop.monitoring = false
		$AnimatedSprite2D.play("death")
		set_collision_layer_value(3, false)
		
func open():
	player.can_attack = false
	$PlayerLeft.monitoring = true
	talk.visible = true
	shop.visible = is_shop_visible
	is_open = true
	
func close():
	player.can_attack = true
	talk.visible = false
	shop.visible = false
	is_open = false
	$PlayerLeft.set_deferred("monitoring", false)
	
func open_shop():
	is_shop_visible = true
	shop.visible = true
	
func close_shop():
	is_shop_visible = false
	shop.visible = false

func _on_player_left_body_exited(body):
	close()


