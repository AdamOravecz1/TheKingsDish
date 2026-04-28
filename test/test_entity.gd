extends GutTest

# --- Test Double ---
class TestEntity extends Entity:
	var death_called := false
	
	func trigger_death():
		death_called = true


var entity: TestEntity


func before_each():
	entity = TestEntity.new()
	add_child(entity)
	await get_tree().process_frame


func after_each():
	if is_instance_valid(entity):
		entity.queue_free()


# --- TESTS ---

func test_health_setter_triggers_death_when_zero():
	entity.health = 0
	assert_true(entity.death_called)


func test_health_setter_triggers_death_when_negative():
	entity.health = -5
	assert_true(entity.death_called)


func test_setup_marks_entity_dead_if_health_negative():
	entity.add_to_group("Animal")
	
	var data = [
		[0, 0],
		[0, 0],
		-10
	]
	
	entity.setup(data)
	
	assert_true(entity.died)
