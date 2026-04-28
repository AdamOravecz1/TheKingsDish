extends GutTest

var DragonScene = preload("res://Scenes/dragon.tscn")
var dragon


func before_each():
	dragon = DragonScene.instantiate()
	add_child(dragon)
	await get_tree().process_frame


func after_each():
	if is_instance_valid(dragon):
		dragon.queue_free()


# ------------------------
# TESTS
# ------------------------

func test_stagger_disables_damage():
	dragon.can_damage = true
	dragon.stagger()
	
	assert_false(dragon.can_damage)


func test_stagger_disables_monitoring():
	dragon.stagger()
	
	assert_false(dragon.get_node("DamageZone").monitoring)
	assert_false(dragon.get_node("PlayerDetect").monitoring)


func test_stagger_sets_animation():
	dragon.stagger()
	
	assert_eq(dragon.get_node("AnimatedSprite2D").animation, "stagger")
