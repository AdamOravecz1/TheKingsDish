extends Entity

@export var inv: Inv 
var item = load("res://inventory/Items/hunter.tres") as InvItem

@onready var interaction_area_shop: InteractionArea = $InteractionAreaShop
@onready var interaction_area: InteractionArea = $InteractionArea

@onready var talk = $CanvasLayer/Speech
@onready var shop = $CanvasLayer/HunterShopUI
@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var main = get_tree().current_scene

@onready var player = get_tree().get_first_node_in_group("Player")

var is_open := false
var is_shop_visible := false

var hunter_dialogues = Global.dialogue["Hunter"]
var dialogue = hunter_dialogues[Global.current_day] 

func _ready():
	$HitLabel.material = $HitLabel.material.duplicate()
	$HitLabel.material.set_shader_parameter("alpha", 0.0)
	if self.name in Global.dialogue_progress:
		talk.show_node(Global.dialogue_progress[self.name])
	else:
		talk.show_node("start")
	$PlayerLeft.set_deferred("monitoring", false)
	health = Global.animal_parameters["hunter"]["health"]
	interaction_area_shop.interact = Callable(self, "_talk")
	interaction_area.interact = Callable(self, "_pickup")
	$InteractionArea.monitoring = false

func open_shop():
	main.can_open = false
	is_shop_visible = true
	shop.position.x = 653
	shop.buy()
	shop.visible = true
	main.playerinv.visible = false
	
func open_give():
	is_shop_visible = true
	shop.position.x = 753
	shop.give()
	shop.visible = true
	playerinv.position.x = 450
	main.open()
	
func close_shop():
	is_shop_visible = false
	shop.visible = false
	main.close()
	player.can_attack = false
	
func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		remove()
		
func _talk():
	if is_open:
		close()
	else:
		open()

func trigger_death():
	if alive:
		if self.name not in Global.perma_death:
			get_tree().get_first_node_in_group("Level").lightning()
		if self.name not in Global.perma_death:
			Global.perma_death.append(self.name)
		$AnimatedSprite2D.play("death")
		$InteractionAreaShop.monitoring = false
		$InteractionArea.monitoring = true
		alive = false
		set_collision_layer_value(3, false)

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("after_death")
	
func open():
	if self.name in Global.dialogue_progress:
		talk.show_node(Global.dialogue_progress[self.name])
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.can_attack = false
	$PlayerLeft.monitoring = true
	talk.visible = true
	shop.visible = is_shop_visible
	is_open = true
	
func close():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	player.can_attack = true
	talk.visible = false
	shop.visible = false
	is_open = false
	$PlayerLeft.set_deferred("monitoring", false)

func _on_player_left_body_exited(body):
	close()
	main.close()
	
func thanks_dialogue():
	dialogue = Global.thank_dialogues
	talk.show_node(self.name)

