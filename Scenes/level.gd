extends Node2D

const bolt_scene := preload("res://Scenes/bolt.tscn")
const trap_scene := preload("res://Scenes/trap.tscn")
@onready var playerinv = $CanvasLayer/PlayerInv
@onready var pause_menu = $CanvasLayer/CanvasLayer/PauseMenu
@onready var inv_type = $CanvasLayer/PlayerInv
var paused = false
var current_item: InvItem
var current_slot := 100
var shop_slot := 100
var dragging := false
var buying := false
var is_open = false
var is_recipes_open = false
var can_save := true

@export var rain: bool = false

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	if rain:
		if self.name == "Forest":
			player.rain_on()
		$DirectionalLight2D.color = Color(0.3, 0.3, 0.3)
		for picture in $BG/ParallaxBackground.get_children():
			if picture.name == "Sky":
				picture.modulate = Color(0.32, 0.41, 0.4)
			else:
				picture.modulate = Color(0.5, 0.5, 0.5)
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if Global.can_gate:
		for gate in $TransitionGates.get_children():
			if gate.index == Global.gate_index and Global.can_gate:
				player.position = gate.global_position
	elif get_tree().current_scene.name in Global.player_data:
		player.position = Global.player_data[get_tree().current_scene.name][0]

	InteractionManager.set_player()
	var scene_name = get_tree().current_scene.name
	var entity_names: Array
	for i in $Main/Entities.get_child_count():
		entity_names.append($Main/Entities.get_child(i))
	for i in $Main/Entities.get_child_count():
		if scene_name in Global.animal_data:
			entity_names[i].setup(Global.animal_data[scene_name][i])
	for i in $Main/Vega.get_child_count():
		var vega = $Main/Vega.get_child(i)
		if scene_name in Global.vega_data:
			if Global.vega_data[scene_name][i]:
				vega.harvest()
	for chest in $Main/Objects.get_children():
		if "inv" in chest and chest.inv != null and chest.chest_name in Global.chest_inv and not Global.chests_load:
			var inv_data = Global.chest_inv[chest.chest_name]
			chest.initialize()
			for entry in inv_data:
				var item_path = entry["item"]
				var index = entry["index"]
				var item = load(item_path)
				if item:
					chest.inv.insert_to_place(item, index)
	if not Global.chests_load:
		player.inv.initialize_inv(12)
		var inv_data = Global.player_inv
		for entry in inv_data:
			var item_path = entry["item"]
			var index = entry["index"]
			var item = load(item_path)
			if item:
				player.inv.insert_to_place(item, index)
		

	if scene_name in Global.trap_data:
		for i in range(Global.trap_data[scene_name].size()):
			var pos = Global.trap_data[scene_name][i][0]
			var caught = Global.trap_data[scene_name][i][1]
			create_trap(pos, caught)
	
	if player.has_signal("shoot"):
		player.connect("shoot", create_bolt)
	if player.has_signal("place_trap"):
		player.connect("place_trap", create_trap)
	_exit_tree()

func create_bolt(pos, dir, bolt_type):
	var bolt := bolt_scene.instantiate()
	$Main/Projectiles.add_child(bolt)
	bolt.setup(pos, dir, bolt_type)
	
func create_trap(pos, caught):
	var trap :=  trap_scene.instantiate()
	$Main/Projectiles.add_child(trap)
	trap.setup(pos, caught)

func _exit_tree():
	if can_save:
		var current_animal_data: Array
		for entity in $Main/Entities.get_children():
			current_animal_data.append([entity.position, entity.velocity, entity.health])
		var current_vega_data: Array
		for vega in $Main/Vega.get_children():
			current_vega_data.append(vega.harvested)
		for chest in $Main/Objects.get_children():
			if "inv" in chest and chest.inv != null:
				Global.chest_inv[chest.chest_name] = chest.inv
		var current_trap_data: Array
		for trap in $Main/Projectiles.get_children():
			if trap is CharacterBody2D:
				current_trap_data.append([trap.position, trap.caught])
		var current_player_data = [player.position, player.velocity]
		Global.animal_data[get_tree().current_scene.name] = current_animal_data
		Global.vega_data[get_tree().current_scene.name] = current_vega_data
		Global.trap_data[get_tree().current_scene.name] = current_trap_data
		Global.player_data["health"] = player.health
		Global.player_data["coin"] = player.coin
		Global.player_data["bolt"] = player.bolt
		Global.player_data["trap"] = player.trap
		Global.player_data[get_tree().current_scene.name] = current_player_data
		Global.get_items_from_player(player.inv)
		Global.scene = get_tree().current_scene.name
	else:
		can_save = true
	
func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		playerinv.position.x = 625
		if is_open:
			close()
		else:
			open()

func open():
	player.can_attack = false
	playerinv.visible = true
	is_open = true
	
func close():
	player.can_attack = true
	playerinv.visible = false
	is_open = false

func openRecipes():
	is_recipes_open = !is_recipes_open
	$CanvasLayer/Recipes.visible = is_recipes_open


func pauseMenu():
	if paused:
		pause_menu.hide()
		#Engine.time_scale = 1
		get_tree().paused = false
		player.can_move = true
	else:
		pause_menu.show()
		#Engine.time_scale = 0
		get_tree().paused = true
		player.can_move = false
	paused = !paused
	
func get_inv(i):
	if inv_type != i and dragging:
		pass
		#inv_type.remove_slot()
	inv_type = i
	
func get_dragging(i: bool):
	dragging = i
	
func update_health(health):
	$CanvasLayer/PlayerHealthBar.value = health
	
func update_coin(coin):
	$CanvasLayer/CoinAmount.text = coin
	
func update_bolt(bolt):
	$CanvasLayer/BoltAmount.text = bolt
	
func update_trap(trap):
	$CanvasLayer/TrapAmount.text = trap
