class_name Entity
extends CharacterBody2D

signal shoot(pos, dir, bullet_type)
signal knock_back(pos, force)

var alive := true
var health := 0:
	set(value):
		health = value
		if health <= 0:
			trigger_death()
			
func trigger_death():
	pass
	
func hit(damage, pos, force):
	health -= damage
	knock_back.emit(pos, force)
	if self.name == "Player":
		get_tree().get_first_node_in_group("Level").update_health(health)
		
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
		if data[0][1] > 9000:
			position.x = data[0][0]
			position.y = data[0][1] - 10000
		else:
			position = data[0]
		velocity = data[1]
		health = data[2]
		

