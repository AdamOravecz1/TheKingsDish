extends Entity

var item = load("res://inventory/Items/dragon.tres") as InvItem

var fire_damage := 40
var fire_knockback := 20000.0
var can_damage := true  # Flag to disable damage during "stagger"

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var damage_timer: Timer = $Timers/DamageTimer

func _ready():
	health = Global.animal_parameters["dragon"]["health"]
	interaction_area.interact = Callable(self, "_pickup")
	$InteractionArea.monitoring = false
	

func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		remove()
		
	
func _process(delta):
	if alive:
		pass
		
func trigger_death():
	if alive:
		$Sound/Death.play()
		$AnimatedSprite2D.play("death")
		$PlayerDetect.queue_free()
		$DamageZone.queue_free()
		$InteractionArea.monitoring = true
		alive = false
		set_collision_layer_value(3, false)
	
func _on_player_detect_body_entered(body):
	$Fire.play("fire")
	$AnimatedSprite2D.play("fire")
	$Sound/Fire.play()
	
func _on_player_detect_body_exited(body):
	$Fire.play("default")
	$AnimatedSprite2D.play("default")
	$Sound/Fire.stop()
	
func _on_damage_zone_body_entered(body):
	if body != self and "hit" in body:
		if can_damage:  # Only hit if not in stagger mode
			body.hit(fire_damage, global_position - Vector2(1000, 0), fire_knockback)
			damage_timer.start()  # Start the timer when player enters

func _on_damage_zone_body_exited(body):
	if body != self and "hit" in body:
		damage_timer.stop()  # Stop hitting when player leaves

func _on_damage_timer_timeout():
	if alive:
		if $DamageZone.monitoring:
			if player in $DamageZone.get_overlapping_bodies() and can_damage:
				player.hit(fire_damage, global_position - Vector2(1000, 0), fire_knockback)

func stagger():
	can_damage = false  # Disable damage
	$DamageZone.monitoring = false
	$PlayerDetect.monitoring = false
	$AnimatedSprite2D.play("stagger")

func _on_animated_sprite_2d_animation_finished():
	if alive:
		$AnimatedSprite2D.play("default")
		$DamageZone.monitoring = true
		$PlayerDetect.monitoring = true
		can_damage = true  # Re-enable damage
