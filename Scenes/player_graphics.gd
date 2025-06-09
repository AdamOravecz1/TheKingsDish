extends Node2D

@onready var weapon = get_parent().current_weapon
var fired := 0
var dir := 1
var can_hit := true

func update_legs(direction, on_floor):
	#flip
	if direction.x:
		$Legs.flip_h = direction.x > 0
		
	#state
	var state := "idle"
	if on_floor and direction.x:
		state = "run"
	if not on_floor:
		state = "jump"
	$Legs.animation = state
	
func update_torso(direction, current_weapon, ducking):
	#duck
	$Torso.position.y = 8 if ducking else 1
	#flip
	if direction.x:
		dir = direction.x
		$Torso.flip_h = direction.x > 0
		$KnifeHit.flip_h = direction.x > 0
		$AxeHit.flip_h = direction.x > 0
	if current_weapon == 2:
		$Torso.frame = current_weapon * 6 + fired
	else:
		$Torso.frame = current_weapon * 6
	weapon = current_weapon
	
func hit():
	if weapon == 0 and can_hit:
		can_hit = false
		$Torso.visible = false
		$KnifeHit.show()
		$KnifeSlash.play()
		$KnifeHit.play("hit")
		if dir < 0:
			$Knife/KnifeHitboxAnimationLeft.play("hit")
		else:
			$Knife/KnifeHitboxAnimationRight.play("hitright")
		await get_tree().create_timer(0.1).timeout
		$Knife/KnifeHitbox.disabled = false
	elif weapon == 1 and can_hit:
		can_hit = false
		$Torso.visible = false
		$AxeHit.show()
		$AxeSlash.play()
		$AxeHit.play("hit")
		if dir < 0:
			$Axe/AxeHitboxAnimationLeft.play("hit")
		else:
			$Axe/AxeHitboxAinamationRight.play("hitright")
		await get_tree().create_timer(0.1).timeout
		$Axe/AxeHitbox.disabled = false
	elif weapon == 2:
		print("Srtrybbtrd")
	
func _on_knife_hit_animation_finished():
	$KnifeHit.hide()
	$Torso.show()
	can_hit = true

func _on_axe_hit_animation_finished():
	$AxeHit.hide()
	$Torso.show()
	can_hit = true
	

func shoot():
	fired = 1
	
func relode():
	fired = 0
	

func _on_knife_body_entered(body):
	if "hit" in body:
		body.hit(Global.weapon_data[0]["damage"], global_position, Global.weapon_data[0]["knockback"])

func _on_knife_hitbox_animation_left_animation_finished(anim_name):
	$Knife/KnifeHitbox.disabled = true

func _on_knife_hitbox_animation_right_animation_finished(anim_name):
	$Knife/KnifeHitbox.disabled = true


func _on_axe_body_entered(body):
	if "hit" in body:
		body.hit(Global.weapon_data[1]["damage"], global_position, Global.weapon_data[1]["knockback"])


func _on_axe_hitbox_animation_left_animation_finished(anim_name):
	$Axe/AxeHitbox.disabled = true

func _on_axe_hitbox_ainamation_right_animation_finished(anim_name):
	$Axe/AxeHitbox.disabled = true
	
func wetSlashSound():
	$KnifeSlash.volume_db = -20
	$KnifeSlash.pitch_scale = 0.6
	$AxeSlash.volume_db = -20
	$AxeSlash.pitch_scale = 0.6
	
func drySlashSound():
	$KnifeSlash.volume_db = 0
	$KnifeSlash.pitch_scale = 1
	$AxeSlash.volume_db = 0
	$AxeSlash.pitch_scale = 1
