extends Entity

var item = load("res://inventory/Items/hunter.tres") as InvItem

@onready var interaction_area_shop: InteractionArea = $InteractionAreaShop
@onready var interaction_area: InteractionArea = $InteractionArea

@onready var talk = $CanvasLayer/Speech
@onready var shop = $CanvasLayer/HunterShop_UI
@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var main = get_tree().current_scene

@onready var player = get_tree().get_first_node_in_group("Player")

var is_open := false

var current_node = "start"
@onready var npc_label = $CanvasLayer/Speech/Dialogue
@onready var option_buttons = [$CanvasLayer/Speech/Option1, $CanvasLayer/Speech/Option2] 

func _process(delta):
	if Input.is_action_just_pressed("inventory") and is_open:
		_talk()

func _ready():
	show_node("start")
	$PlayerLeft.set_deferred("monitoring", false)
	health = Global.animal_parameters["hunter"]["health"]
	interaction_area_shop.interact = Callable(self, "_talk")
	interaction_area.interact = Callable(self, "_pickup")
	$InteractionArea.monitoring = false
	
func show_node(node_name: String):
	current_node = node_name
	var node = Global.hunter_dialogue.get(node_name, null)
	if node == null:
		end_dialogue()
		return

	npc_label.text = node.get("text", "")

	# Optional function call
	if node.has("action"):
		call_action(node["action"])

	# End dialogue if marked
	if node.get("end", false):
		hide_options()
		return

	# Show options
	var options = node.get("options", [])
	for i in range(option_buttons.size()):
		if i < options.size():
			option_buttons[i].text = options[i]["text"]
			option_buttons[i].show()
		else:
			option_buttons[i].hide()

func select_option(index: int):
	var options = Global.hunter_dialogue[current_node].get("options", [])
	if index >= options.size():
		return

	var selected = options[index]

	if selected.has("action"):
		call_action(selected["action"])

	if selected.has("next"):
		show_node(selected["next"])
	elif selected.get("end", false):
		end_dialogue()

func call_action(action_name: String):
	if has_method(action_name):
		call(action_name)
	else:
		print("Unknown action:", action_name)

func end_dialogue():
	npc_label.text = "Dialogue ended."
	hide_options()

func hide_options():
	for button in option_buttons:
		button.hide()

func open_shop():
	print("Opening shop UI...")
	shop.visible = true
	
func close_shop():
	print("Closing shop UI...")
	shop.visible = false
	
	
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
		$AnimatedSprite2D.play("death")
		$InteractionAreaShop.monitoring = false
		$InteractionArea.monitoring = true
		alive = false
		set_collision_layer_value(3, false)

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("after_death")
	
func open():
	player.can_attack = false
	$PlayerLeft.monitoring = true
	talk.visible = true
	is_open = true
	
func close():
	player.can_attack = true
	talk.visible = false
	shop.visible = false
	is_open = false
	$PlayerLeft.set_deferred("monitoring", false)

func _on_player_left_body_exited(body):
	close()

