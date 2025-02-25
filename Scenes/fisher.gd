extends Entity

var item = load("res://inventory/Items/fisher.tres") as InvItem

@onready var interaction_area_shop: InteractionArea = $InteractionAreaShop
@onready var interaction_area: InteractionArea = $InteractionArea

@onready var shop = $CanvasLayer/FisherShop_UI
@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var main = get_tree().current_scene

@onready var player = get_tree().get_first_node_in_group("Player")

var is_open := false
var should_close := false

func _process(delta):
	if Input.is_action_just_pressed("inventory") and is_open:
		_talk()

func _ready():
	close()
	health = Global.animal_parameters["fisher"]["health"]
	interaction_area_shop.interact = Callable(self, "_talk")
	interaction_area.interact = Callable(self, "_pickup")
	$InteractionArea.monitoring = false
	
func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		remove()
		
func _talk():
	if is_open:
		should_close = false
		main.close()
		close()
	else:
		should_close = true
		playerinv.position.x = 450
		main.open()
		open()

func trigger_death():
	if alive:
		$AnimatedSprite2D.play("death")
		$InteractionAreaShop.monitoring = false
		$InteractionArea.monitoring = true
		alive = false
		set_collision_layer_value(3, false)

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("after_death")
	
func open():
	shop.visible = true
	playerinv.visible = true
	is_open = true
	
func close():
	should_close = false
	shop.visible = false
	playerinv.visible = false
	is_open = false

func _on_player_left_body_exited(body):
	if should_close:
		close()
		main.close()

