extends Entity

var item = load("res://inventory/Items/king.tres") as InvItem

@onready var recipes = get_tree().get_first_node_in_group("Recipes")

@onready var interaction_area_shop: InteractionArea = $InteractionAreaShop
@onready var interaction_area: InteractionArea = $InteractionArea

@onready var talk = $CanvasLayer/Speech
@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var main = get_tree().current_scene

@onready var player = get_tree().get_first_node_in_group("Player")

var is_open := false
var talked := true

var king_dialogues = Global.dialogue["King"]
var dialogue = king_dialogues[Global.king_counter] 

func _ready():
	$HitLabel.material = $HitLabel.material.duplicate()
	$HitLabel.material.set_shader_parameter("alpha", 0.0)
	if self.name in Global.dialogue_progress:
		talk.show_node(Global.dialogue_progress[self.name])
	else:
		talk.show_node("start")
	$PlayerLeft.set_deferred("monitoring", false)
	health = Global.animal_parameters["king"]["health"]
	interaction_area_shop.interact = Callable(self, "_talk")
	interaction_area.interact = Callable(self, "_pickup")
	$InteractionArea.monitoring = false
	
func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		remove()
		
func _talk():
	if talked:
		Global.king_counter += 1
		talked = false
	if is_open:
		close()
	else:
		open()

func trigger_death():
	if alive:
		Global.king_killer = true
		if self.name not in Global.perma_death:
			get_tree().get_first_node_in_group("Level").lightning()
		if self.name not in Global.perma_death:
			Global.perma_death.append(self.name)
		$AnimatedSprite2D.play("death")
		$InteractionAreaShop.monitoring = false
		$InteractionArea.monitoring = true
		alive = false
		set_collision_layer_value(3, false)

func _on_animated_sprite_2d_animation_finished():
	$AnimatedSprite2D.play("after_death")
	
func open():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	player.can_attack = false
	$PlayerLeft.monitoring = true
	talk.visible = true
	is_open = true
	
func close():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	player.can_attack = true
	talk.visible = false
	is_open = false
	$PlayerLeft.set_deferred("monitoring", false)

func _on_player_left_body_exited(body):
	close()
	
func add_recipe():
	var key = "res://inventory/Items/the_kings_dish.tres"
	if key not in Global.found_recipes:
		if Global.recipes.has(key):
			Global.found_recipes[key] = Global.recipes[key]
		recipes.setup()
		

