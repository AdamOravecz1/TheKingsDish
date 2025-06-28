extends Entity

@export var inv: Inv 
@export var chest_name: String  # A unique identifier for this chest

var x_direction := -1
var speed = 100
var speed_modifier := 0

@export var gravity := 600
@export var terminal_velocity := 500
var faster_fall := false
var gravity_multiplier := 1

var item = load("res://inventory/Items/butler.tres") as InvItem

@onready var interaction_area_shop: InteractionArea = $InteractionAreaShop
@onready var interaction_area: InteractionArea = $InteractionArea

@onready var shop = $CanvasLayer/ButlerInv
@onready var talk = $CanvasLayer/Speech
@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var main = get_tree().current_scene

@onready var player = get_tree().get_first_node_in_group("Player")

var is_open := false
var is_shop_visible := false

var all_strings := true

var dialogue := Global.butler_dialogue1

func _process(delta):
	if global_position.x < -510:
		remove()
	velocity.x = x_direction * speed * speed_modifier
	apply_gravity(delta)
	move_and_slide()
		
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = velocity.y / 2 if faster_fall and velocity.y < 0 else velocity.y
	velocity.y = velocity.y * gravity_multiplier
	velocity.y = min(velocity.y, terminal_velocity)

func _ready():
	if self.name in Global.dialogue_progress:
		print(Global.dialogue_progress[self.name])
		talk.show_node(Global.dialogue_progress[self.name])
	else:
		talk.show_node("start")
	if Global.chests_load:
		if Global.chest_inv.has(chest_name):
			# Assuming Global.chest_inv[chest_name][0] is a path to the resource
			var inv_resource_path = Global.chest_inv[chest_name]
			if typeof(inv_resource_path) == TYPE_ARRAY:
				var all_strings = inv_resource_path.all(func(item): return typeof(item) == TYPE_STRING)
			if not all_strings:
				inv = inv_resource_path
		else:
			inv.initialize_inv(1)
	shop.inv = inv
	shop._ready()
	$PlayerLeft.set_deferred("monitoring", false)
	health = Global.animal_parameters["butler"]["health"]
	interaction_area_shop.interact = Callable(self, "_talk")
	interaction_area.interact = Callable(self, "_pickup")
	$InteractionArea.monitoring = false
	
func initialize():
	inv.initialize_inv(1)
	
func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		remove()
		
func _talk():
	if is_open:
		close()
		player.can_attack = true
	else:
		open()
		player.can_attack = false
		
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
		speed_modifier = 0
		set_collision_layer_value(3, false)

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("after_death")
	
func open():
	player.can_attack = false
	$PlayerLeft.monitoring = true
	talk.visible = true
	if is_shop_visible:
		open_shop()
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
	shop.buy()
	playerinv.position.x = 450
	main.open()
	
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

func _on_player_left_body_exited(body):
	close()
	main.close()
	
func _on_tree_exited():
	if inv != null:
		# Save the Inv instance to the global dictionary
		Global.chest_inv[chest_name] = inv
		print("Inventory saved to global dictionary with key: ", chest_name)


func _on_butler_inv_send_food(food):
	$Food.texture = food
	if food:
		speed_modifier = 1
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = false
		x_direction = -1

