extends Node2D

const bolt_scene := preload("res://Scenes/bolt.tscn")
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

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	
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
	if player.has_signal("shoot"):
		player.connect("shoot", create_bolt)

func create_bolt(pos, dir, bolt_type):
	var bolt := bolt_scene.instantiate()
	$Main/Projectiles.add_child(bolt)
	bolt.setup(pos, dir, bolt_type)

func _exit_tree():
	var current_animal_data: Array
	for entity in $Main/Entities.get_children():
		current_animal_data.append([entity.position, entity.velocity, entity.health])
	var current_vega_data: Array
	for vega in $Main/Vega.get_children():
		current_vega_data.append(vega.harvested)
	var current_player_data = [player.position, player.velocity]
	Global.animal_data[get_tree().current_scene.name] = current_animal_data
	Global.vega_data[get_tree().current_scene.name] = current_vega_data
	Global.player_data["health"] = player.health
	Global.player_data["coin"] = player.coin
	Global.player_data[get_tree().current_scene.name] = current_player_data
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
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

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
		player.can_move = true
	else:
		pause_menu.show()
		Engine.time_scale = 0
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
