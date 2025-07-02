class_name Entity
extends CharacterBody2D

signal shoot(pos, dir, bullet_type)
signal place_trap(pos, caught)
signal knock_back(pos, force)

var alive := true
var died := false
var health := 0:
	set(value):
		health = value
		if health <= 0:
			trigger_death()
			
func trigger_death():
	pass
	
func hit(damage, pos, force):
	if self.name.begins_with("Fish") and self.name != "Fisher":
		$Sound/Hit.pitch_scale = 0.6
		$Sound/Hit.volume_db = -20
	
	$Sound/Hit.play()
	health -= damage
	knock_back.emit(pos, force)
	if self.name == "Player":
		get_tree().get_first_node_in_group("Level").update_health(health)
	if health > 0:
		var tween = create_tween()
		tween.tween_property($HitLabel, "material:shader_parameter/alpha", 1.0, 0.0)
		tween.tween_property($HitLabel, "material:shader_parameter/alpha", 0.0, 2.0)
	
		
func remove():
	# Load and instance the scene dynamically
	var entity_scene = load("res://Scenes/entity.tscn")  # Load the scene
	var entity_instance = entity_scene.instantiate()  # Create an instance of the scene
	var index = get_index()
	entity_instance.health = -10000
	# Add the new entity instance to the parent
	get_parent().add_child(entity_instance)
	get_parent().move_child(entity_instance, index)
	
	queue_free()
	
func setup(data): 
	if data[2] == -10000:
		remove()

	if self.is_in_group("Animal"):
		if int(data[0][1]) > 9000:
			position.x = data[0][0]
			position.y = data[0][1] - 10000
		else:
			position = Vector2(float(data[0][0]), float(data[0][1]))
		velocity = Vector2(float(data[1][0]), float(data[1][1]))
		if data[2] < 0:
			died = true
		health = data[2]
		

