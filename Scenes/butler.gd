extends Entity

@export var inv: Inv 
@export var chest_name: String  # A unique identifier for this chest

@onready var recipes = get_tree().get_first_node_in_group("Recipes")

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

var butler_dialogues = Global.dialogue["Butler"]
var dialogue = butler_dialogues[Global.current_day] 

var is_butler_here := true
var did_send_food := false

var extra_drop: InvItem = null

func _process(delta):
	if global_position.x < -510:
		speed_modifier = 0
		global_position.x = -500
		if extra_drop:
			$Sound/Door.play()
		extra_drop = null
		Global.butlers_inv = null
		visible = false
		$InteractionAreaShop.monitoring = false
		$CollisionShape2D.disabled = true
		if global_position.x > -530:
			is_butler_here = false
			Global.can_next_day = true
			await get_tree().create_timer(1.0).timeout
	velocity.x = x_direction * speed * speed_modifier
	apply_gravity(delta)
	move_and_slide()
		
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = velocity.y / 2 if faster_fall and velocity.y < 0 else velocity.y
	velocity.y = velocity.y * gravity_multiplier
	velocity.y = min(velocity.y, terminal_velocity)

func _ready():
	if Global.butlers_inv:
		$AnimatedSprite2D.flip_h = false
		$Food.texture = Global.butlers_inv.texture
		extra_drop = Global.butlers_inv
	if Global.can_next_day:
		visible = false
		$InteractionAreaShop.monitoring = false
		$CollisionShape2D.disabled = true
	$HitLabel.material = $HitLabel.material.duplicate()
	$HitLabel.material.set_shader_parameter("alpha", 0.0)
	if self.name in Global.dialogue_progress:
		talk.show_node(Global.dialogue_progress[self.name])
	else:
		if Global.current_day > 0:
			if Global.remember_dialogue:
				talk.show_node(Global.remember_dialogue)
			elif Global.good_food_counter == 2:
				Global.good_food_counter += 1
				Global.gates_satutus.append(3)
				talk.show_node("start4")
				Global.remember_dialogue = "start4"
			elif Global.previous_day_value == 0:
				talk.show_node("start0")
				Global.remember_dialogue = "start0"
			elif Global.previous_day_value > 0 and Global.previous_day_value <= 5:
				talk.show_node("start1")
				Global.remember_dialogue = "start1"
			elif Global.previous_day_value > 5 and Global.previous_day_value <= 10:
				talk.show_node("start2")
				Global.remember_dialogue = "start2"
			else:
				if Global.good_food_counter > 2:
					talk.show_node("start5")
					Global.remember_dialogue = "start5"
				else:
					talk.show_node("start3")
					Global.remember_dialogue = "start3"
		else:
			talk.show_node("start")
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
	if extra_drop:
		Global.butlers_inv = null
		player.collect(extra_drop)
		extra_drop = null
		$Food.texture = null
	player.collect(item)
	if player.free_inv_slot:
		remove()
		
func _talk():
	player.pay(-Global.previous_day_value)
	Global.previous_day_value = 0
	if is_open:
		close()
		player.can_attack = true
	else:
		open()
		player.can_attack = false
		
func trigger_death():
	if alive:
		if Global.good_food_counter < 2:
			Global.execution = true
			Global.execution_text = "I have no one to serve food for me now.\nIt was a bad idea to kill my butler."
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
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.can_attack = false
	$PlayerLeft.monitoring = true
	talk.visible = true
	if is_shop_visible:
		open_shop()
	is_open = true
	
func close():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
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

func _on_butler_inv_send_food(food):
	if food and not extra_drop:
		if did_send_food:
			return  # Already sent, ignore
		did_send_food = true
		extra_drop = food
		$Food.texture = food.texture
		if "king" in food.types:
			Global.king_killer = false
			Global.king_taker = true
		elif "meat" in food.types and Global.current_day == 4:
			Global.execution = true
			Global.execution_text = "You think you can serve meat on lent?\nGod will punish you now."
		elif "dragon" in food.types:
			Global.execution = true
			Global.execution_text = "YOU! Somehow managed to fell a Dragon and\nYOU have the audacity to serv it raw??"
		elif "zombie" in food.types:
			Global.execution = true
			Global.execution_text = "It was a sick joke to serve up a dead persons head.\nYou got what you deserved."
		elif "ritual" in food.types:
			Global.ritual = true
		elif "pure_poison" in food.types:
			Global.execution = true
			Global.execution_text = "You think I can't read the label on the bottle you gave me?\nFor the assassination attempt your sentence\nis death by hanging."
		elif "poison" in food.types:
			Global.execution = true
			Global.execution_text = "The dish you made killed my butler when he tested it.\nFor the assassination attempt your sentence\nis death by hanging."
		elif "dragon_slayer" in food.types:
			Global.dragon_slayer = true
		elif "npc" in food.types:
			Global.execution = true
			Global.execution_text = "Your sentence for killing the " + food.name + "\nis death by hanging."
		elif "sick" in food.types:
			Global.execution = true
			Global.execution_text = "The thing you served made me and my butler sick.\nYou will never do that again."
		elif food.value == 0:
			Global.bad_food_counter += 1
		elif food.value > 10:
			Global.good_food_counter += 1
		Global.previous_day_value = food.value
		speed_modifier = 1
		main.close_throne_door()
		$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = false
		x_direction = -1
		$InteractionAreaShop.monitoring = false

func _on_tree_exited():
	if extra_drop:
		Global.butlers_inv = extra_drop
		visible = false
		$InteractionAreaShop.monitoring = false
		$CollisionShape2D.disabled = true
	if is_butler_here and extra_drop:
		Global.butlers_inv = null
		Global.can_next_day = true
		is_butler_here = false
		
		
func thanks_dialogue():
	dialogue = Global.thank_dialogues
	talk.show_node(self.name)

func resume_dialogue():
	var npc_dialogues = Global.dialogue[self.name]
	dialogue = npc_dialogues[Global.current_day] 
	var options = dialogue["good_bye"]["options"]

	for i in options.size():
		if options[i]["next"] == "give":
			options.remove_at(i)
			break 
			
	dialogue["good_bye"]["options"] = options

	talk.show_node("good_bye")

func add_recipe():
	var key = "res://inventory/Items/lamb_chops_with_mashed_potatoes.tres"
	if key not in Global.found_recipes:
		if Global.recipes.has(key):
			Global.found_recipes[key] = Global.recipes[key]
		recipes.setup()


