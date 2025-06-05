extends Entity

@export var inv: Inv

@export_group('move')
@export var speed := 200
@export var acceleration := 700
@export var friction := 900
var direction := Vector2.ZERO
var can_move := true
var can_attack := true
var ducking := false

@export_group('jump')
@export var jump_strength := 300
@export var gravity := 600
@export var terminal_velocity := 500
var jump := false
var faster_fall := false
var gravity_multiplier := 1
var in_water := false
var current_animation_index := 0  # Tracks which animation to play next
var last_pos := Vector2.ZERO 

var knockback_force: Vector2 = Vector2.ZERO
var knockback_duration: float = 0.0
var knockback_strength: float = 15000.0
var knocked_back: bool = false

var current_weapon = Global.weapons.KNIFE
var current_weapon_index = 0
var aim_direction := Vector2.LEFT
var reloded := true

@onready var walk_sounds = [
	$Sound/WalkingLeft,
	$Sound/WalkingRight
]
var current_step = 0
var landing_sound = false

@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
var free_inv_slot := true

@onready var level = get_tree().get_first_node_in_group("Level")

var coin := 0
var bolt := 0
var trap := 0

func _ready():
	health = Global.player_data["health"]
	coin = Global.player_data["coin"]
	bolt = Global.player_data["bolt"]
	trap = Global.player_data["trap"]
	if get_tree().current_scene.name in Global.player_data:
		#position = Global.player_data[get_tree().current_scene.name][0]
		velocity = Global.player_data[get_tree().current_scene.name][1]
	$Label.material.set_shader_parameter("alpha", 0.0)
	$Bubbles.visible = false
	if inv == null:
		inv = load("res://inventory/playerinv.tres") as Inv
	playerinv.inv = inv
	playerinv._ready()
	level.update_health(health)
	level.update_coin(str(coin))
	level.update_bolt(str(bolt))
	level.update_trap(str(trap))
	# Connect `animation_finished` signals for all children AnimationPlayer2D nodes
	for child in $Bubbles.get_children():
		child.animation_finished.connect(_on_animation_finished)
	

func _process(delta):
	if knockback_duration > 0 and alive:
		# Apply knockback force
		var motion = knockback_force * delta
		velocity = motion
		# Decrease knockback duration over time
		knockback_duration -= delta
		if knockback_duration <= 0:
			knockback_force = Vector2.ZERO # Reset knockback force when duration is over
	else:
		check_pos()
		if can_move:
			get_input()
			apply_movement(delta)
			animate()
	apply_gravity(delta)
	move_and_slide()
	if knocked_back and is_on_floor():
		can_move = true
		knocked_back = false
		
	#walking sound
	if is_on_floor() and abs(velocity.x) > 0.1:
		if not $Timers/WalkingTimer.is_stopped():
			return  # already running
		$Timers/WalkingTimer.start()
	else:
		$Timers/WalkingTimer.stop()
		walk_sounds[0].stop()
		walk_sounds[1].stop()
		
	if is_on_floor() and landing_sound:
		$Sound/Land.play()
		landing_sound = false
	elif not is_on_floor():
		landing_sound = true

		
func animate():
	$PlayerGraphics.update_legs(direction, is_on_floor())
	$PlayerGraphics.update_torso(direction, current_weapon, ducking)
	
func get_input():
	# horizontal movement 
	direction.x = Input.get_axis("left", "right")
	#aim
	if direction.x > 0:
		aim_direction = Vector2.RIGHT
	elif direction.x < 0:
		aim_direction = Vector2.LEFT
	
	# jump 
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or $Timers/Coyote.time_left:
			jump = true
		
		if velocity.y > 0 and not is_on_floor():
			$Timers/JumpBuffer.start()
		
	if Input.is_action_just_released("jump") and not is_on_floor() and velocity.y < 0:
		faster_fall = true
		
	#switch
	if Input.is_action_just_pressed("switch"):
		current_weapon_index = (current_weapon_index + 1) % Global.unlocked_weapons.size()
		current_weapon = Global.unlocked_weapons[current_weapon_index]
		#correct crosbow graphic that if player has no bolt
		if current_weapon == 2 and bolt < 1:
			$PlayerGraphics.shoot()

		
	#hit
	if Input.is_action_just_pressed("hit") and can_attack:
		$PlayerGraphics.hit()
		slash()
		
	#relode
	if Input.is_action_just_pressed("relode"):
		if bolt > 0:
			reloded = true
			$PlayerGraphics.relode()
		
	# ducking
	ducking = Input.is_action_pressed("duck") and is_on_floor()
	
	#trap
	if Input.is_action_just_pressed("trap"):
		if trap > 0:
			place_trap.emit(position, false)
			trap_calculate(-1)
			
	#recipes
	if Input.is_action_just_pressed("recipes"):
		level.openRecipes()

func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = velocity.y / 2 if faster_fall and velocity.y < 0 else velocity.y
	velocity.y = velocity.y * gravity_multiplier
	velocity.y = min(velocity.y, terminal_velocity)
	
func apply_movement(delta):
	# left/right movement 
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	if ducking:
		speed = 50
		jump = false
	elif not in_water:
		speed = 200
	
	# jump 
	if jump or $Timers/JumpBuffer.time_left and is_on_floor():
		velocity.y = -jump_strength
		jump = false
		faster_fall = false
	
	var on_floor = is_on_floor()
	if on_floor and not is_on_floor() and velocity.y >= 0:
		$Timers/Coyote.start()
		
func swim():
	can_move = true
	in_water = true
	speed = 100
	acceleration = 200
	terminal_velocity = 100
	friction = 1500
	faster_fall = false
	gravity = 300
	jump_strength = 200
	
func not_swim():
	in_water = false
	speed = 200
	acceleration = 700
	terminal_velocity = 500
	friction = 900
	faster_fall = true
	gravity = 600
	jump_strength = 300
	
func bubble_stop():
	$Timers/DrowningTimer.stop()
	$Bubbles.visible = false
	current_animation_index = 0
	for child in $Bubbles.get_children():
		child.play("default")
	
func bubble_animation():
	$Bubbles.visible = true
	if current_animation_index < $Bubbles.get_child_count():
		var animplayer = $Bubbles.get_child(current_animation_index)
		if animplayer:
			animplayer.play("burst")
		else:
			current_animation_index += 1  # Skip invalid players or animations
			bubble_animation()  # Try the next animation
	else:
		
		$Timers/DrowningTimer.start()
		
func _on_animation_finished():
	# Called when an animation finishes
	current_animation_index += 1
	bubble_animation()
		
func check_pos():
	if $FloorRays/Right.get_collider() and $FloorRays/Left.get_collider() and is_on_floor():
		last_pos = global_position

		
func slash():
	var pos = position + aim_direction if not ducking else position + aim_direction + Vector2(0, 8)
	if current_weapon == 0 or current_weapon == 1:
		pass
	elif reloded:
		$PlayerGraphics.shoot()
		reloded = false
		shoot.emit(pos, aim_direction, current_weapon)
		bolt_calculate(-1)
		
func block_movement():
	can_move = false
	velocity = Vector2.ZERO
	$PlayerGraphics/Legs.stop()
	
func back():
	position = last_pos
	
func collect(item):
	coin += 1
	level.update_coin(str(coin))
	var emptyslot = inv.slots.filter(func(slot): return slot.item == null)
	if emptyslot.size() > 0:
		inv.insert(item)
		free_inv_slot = true
	else:
		free_inv_slot = false
		flash_text()
		
func flash_text():
	var tween = create_tween()
	tween.tween_property($Label, "material:shader_parameter/alpha", 1.0, 0.0)
	tween.tween_property($Label, "material:shader_parameter/alpha", 0.0, 1.0)

func _on_knock_back(source, force):
	can_move = false
	knocked_back = true
	knockback_strength = force
	knockback_duration = 0.1

	# Calculate direction from source of impact to the character
	var direction = (global_position - source).normalized()

	# Apply force based on direction and strength
	knockback_force.x = direction.x * knockback_strength 
	
	# Apply upward force (positive Y direction in Godot is down, so subtract to go up)
	knockback_force.y -= 4000.0
	
func pay(price):
	coin -= price
	level.update_coin(str(coin))
	
func bolt_calculate(amount):
	bolt += amount
	level.update_bolt(str(bolt))
	
func trap_calculate(amount):
	trap += amount
	level.update_trap(str(trap))
	

func _on_drowning_timer_timeout():
	health -= 10
	get_tree().get_first_node_in_group("Level").update_health(health)


func _on_walking_timer_timeout():
	var sound = walk_sounds[current_step % 2]
	if not sound.playing:
		if not in_water:
			sound.volume_db = 0
			sound.pitch_scale = randf_range(0.85, 1.15)
		else:
			sound.volume_db = -10
			sound.pitch_scale = randf_range(0.45, 0.75)
		sound.play()
		current_step += 1
	
