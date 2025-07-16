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
var can_open := true

@export var full_screen: bool = Global.full_screen
@export var rain_day: int = 2

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	if self.name == "Dungeon":
		Music.level_music = preload("res://Music/Dungeon_v1.wav")
	else:
		Music.level_music = preload("res://Music/Forest_v3.wav")
	Music.play_level_music()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	if Global.current_day == rain_day and self.name != "Dungeon":
		$Sound/Rain.play()
		$BG/ParallaxBackground/SheepCloud.visible = false
		if self.name == "Castle" or self.name == "ThroneRoom":
			$BG/Design/Rain.emitting = true
		if self.name == "Forest":
			player.rain_on()
		$DirectionalLight2D.color = Color(0.3, 0.3, 0.3)
		for picture in $BG/ParallaxBackground.get_children():
			if picture.name == "Sky":
				picture.modulate = Color(0.32, 0.41, 0.4)
			else:
				picture.modulate = Color(0.5, 0.5, 0.5)
	if Global.current_day != rain_day + 1 and self.name == "Forest":
		$FG/FG.set_cell(0, Vector2i(16, -8), -1)
		$FG/FG.set_cell(0, Vector2i(20, -8), -1)
		$FG/FG.set_cell(0, Vector2i(21, -8), -1)
	if full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if Global.can_gate:
		show_tutorial("hit", "hit")
		for gate in $TransitionGates.get_children():
			if gate.gate_id == Global.gate_index and Global.can_gate:
				player.position = gate.global_position
	elif get_tree().current_scene.name in Global.player_data:
		player.position = Global.player_data[get_tree().current_scene.name][0]
	
	for gate in $TransitionGates.get_children():
		if gate.gate_id in Global.gates_satutus:
			gate.locked = false

	InteractionManager.set_player()
	var scene_name = get_tree().current_scene.name
	var entity_names: Array
	for i in $Main/Entities.get_child_count():
		entity_names.append($Main/Entities.get_child(i))
	for i in $Main/Entities.get_child_count():
		if scene_name == "Dungeon":
			if i > Global.zombie_count:
				entity_names[i].remove()
		else: 
			if scene_name in Global.animal_data:
				entity_names[i].setup(Global.animal_data[scene_name][i])
			if entity_names[i].name in Global.perma_death and not Global.animal_data.has(self.name):
				entity_names[i].remove()

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
	if Global.can_save:
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
		Global.can_save = true
	
func _process(_delta):
	if Input.is_action_just_pressed("inventory") and can_open:
		
		playerinv.position.x = 625
		if is_open:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
			if player and playerinv:
				player.can_attack = true
				playerinv.visible = false
			is_open = false
		elif player.can_attack:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			if player and playerinv:
				player.can_attack = false
				playerinv.visible = true
			is_open = true

func open():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if player and playerinv:
		player.can_attack = false
		playerinv.visible = true
	is_open = true
	can_open = false
	
func close():
	if player and playerinv:
		player.can_attack = true
		playerinv.visible = false
	is_open = false
	can_open = true

func openRecipes():
	if can_open and player.can_attack:
		is_recipes_open = !is_recipes_open
		$CanvasLayer/Recipes.visible = is_recipes_open
		if is_recipes_open:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else: 
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func pauseMenu():
	if paused:
		if player.can_attack and not $CanvasLayer/Recipes.visible:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		pause_menu.hide()
		#Engine.time_scale = 1
		get_tree().paused = false
		
		player.can_move = true
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
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

func lightning():
	Global.zombie_count += 1
	$Sound/LightningStrike.play()
	# Set up blackout and lightning position
	$CanvasLayer/LightningDim.color = Color(0, 0, 0, 0)
	$CanvasLayer/LightningDim.visible = true

	var lightning = $BG/Design/Lightning
	var lightning_light = $BG/Design/LightningLight
	if self.name == "Forest":
		lightning.position = player.global_position
		lightning.position.y -= 150
		lightning_light.position = lightning.global_position
		print(lightning_light.position)
	lightning.visible = true
	lightning.modulate.a = 1.0

	lightning_light.visible = true
	lightning_light.energy = 10

	var tween = create_tween()

	# Flash to black instantly
	tween.tween_property($CanvasLayer/LightningDim, "color", Color(0, 0, 0, 1), 0.0001)

	# Wait for a moment
	tween.tween_interval(0.05)

	# Fade out blackout, lightning sprite, and light energy in parallel
	tween.parallel().tween_property($CanvasLayer/LightningDim, "color", Color(0, 0, 0, 0), 1.5)
	tween.parallel().tween_property(lightning, "modulate:a", 0.0, 1.0)
	tween.parallel().tween_property(lightning_light, "energy", 0.0, 1.0)

	tween.tween_callback(Callable(self, "_end_lightning"))



func _end_lightning():
	$CanvasLayer/LightningDim.visible = false
	$BG/Design/Lightning.visible = false
	$BG/Design/LightningLight.visible = false
	
func close_throne_door():
	$TransitionGates/Gate2.locked = true

func show_tutorial(action, action_name):
	$CanvasLayer/CanvasLayer/Tutorial.show_tutorial(action, action_name)
	
	
	
