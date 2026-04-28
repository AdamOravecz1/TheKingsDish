extends "res://addons/gut/test.gd"

# Use the actual scene path
var PlayerScene = load("res://Scenes/player.tscn")
var _player = null

func before_each():
	# 1. Create a mock for the Inventory Node
	# We use a Node and give it a script that has the 'inv' variable
	var mock_inv = Node.new()
	var inv_script = GDScript.new()
	inv_script.source_code = "extends Node\nvar inv\nfunc _ready(): pass"
	inv_script.reload()
	mock_inv.set_script(inv_script)
	mock_inv.add_to_group("PlayerInv")
	add_child(mock_inv)
	
	# 2. Create the mock for the Level
	# We create a dummy script so the player's _ready doesn't crash on update_health etc.
	var mock_level = Node.new()
	var level_script = GDScript.new()
	level_script.source_code = "extends Node\nfunc update_health(v): pass\nfunc update_coin(v): pass\nfunc update_bolt(v): pass\nfunc update_trap(v): pass\nfunc show_tutorial(a, b): pass"
	level_script.reload()
	mock_level.set_script(level_script)
	mock_level.add_to_group("Level")
	add_child(mock_level)

	# 3. Instantiate Player
	_player = PlayerScene.instantiate()
	add_child(_player)

func after_each():
	if is_instance_valid(_player):
		_player.free()
	
	for node in get_tree().get_nodes_in_group("Level"):
		node.free()
	for node in get_tree().get_nodes_in_group("PlayerInv"):
		node.free()

## --- TESTS ---

func test_initial_stats_load_from_global():
	assert_eq(_player.health, Global.player_data["health"], "Health should initialize from Global")
	assert_eq(_player.coin, Global.player_data["coin"], "Coins should initialize from Global")

func test_apply_gravity_increases_downward_velocity():
	var initial_y = _player.velocity.y
	_player.apply_gravity(0.1) 
	assert_gt(_player.velocity.y, initial_y, "Gravity should increase downward velocity")

func test_jump_logic():
	_player.velocity.y = 0
	_player.jump = true 
	_player.apply_movement(0.1)
	
	assert_eq(_player.velocity.y, -_player.jump_strength, "Velocity should be negative jump_strength")
	assert_false(_player.jump, "Jump flag should be reset")

func test_swim_physics_changes():
	_player.swim()
	assert_eq(_player.speed, 100, "Speed reduced in water")
	assert_eq(_player.gravity, 300, "Gravity reduced in water")
	assert_true(_player.in_water)

func test_knockback_applies_force():
	var source_pos = _player.global_position + Vector2(100, 0)
	_player._on_knock_back(source_pos, 500)
	
	assert_lt(_player.knockback_force.x, 0, "Knockback should push player away")
	assert_true(_player.knocked_back)
	assert_false(_player.can_move)
