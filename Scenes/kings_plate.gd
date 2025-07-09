extends Node2D

@export var inv: Inv 
@export var chest_name: String  # A unique identifier for this chest

@onready var interaction_area: InteractionArea = $InteractionArea

@onready var shop = $CanvasLayer/KingsPlateInv
@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var main = get_tree().current_scene

@onready var player = get_tree().get_first_node_in_group("Player")

var is_open := false

var all_strings := true

func _ready():
	if Global.chests_load:
		if Global.chest_inv.has(chest_name):
			# Assuming Global.chest_inv[chest_name][0] is a path to the resource
			var inv_resource_path = Global.chest_inv[chest_name]
			if typeof(inv_resource_path) == TYPE_ARRAY:
				var all_strings = inv_resource_path.all(func(item): return typeof(item) == TYPE_STRING)
			if not all_strings:
				inv = inv_resource_path
		elif !inv.slots:
			inv.initialize_inv(1)
	elif !inv.slots:
		inv.initialize_inv(1)
	shop.inv = inv
	shop._ready()
	$PlayerLeft.set_deferred("monitoring", false)

	interaction_area.interact = Callable(self, "_serve")

	
func initialize():
	inv.initialize_inv(1)
	
func _serve():
	if is_open:
		close()
		player.can_attack = true
	else:
		open()
		player.can_attack = false
	
func open():
	shop.visible = true
	playerinv.position.x = 450
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.can_attack = false
	$PlayerLeft.monitoring = true
	is_open = true
	main.open()
	
func close():
	shop.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	player.can_attack = true
	is_open = false
	main.close()
	$PlayerLeft.set_deferred("monitoring", false)
	
func _on_player_left_body_exited(body):
	close()
	main.close()


func _on_kings_plate_inv_send_food(food):
	if food:
		if "meat" in food.types and Global.current_day == 4:
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
			pass
			#Global.execution = true
			#Global.execution_text = "The dish you made killed my butler when he tested it.\nFor the assassination attempt your sentence\nis death by hanging."
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
		Global.previous_day_value = food.value
		$Food.texture = food.texture
		Global.can_next_day = true

	else:
		Global.previous_day_value = 0
		$Food.texture = null
		Global.can_next_day = false
		
