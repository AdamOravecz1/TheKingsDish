extends Entity

var item = load("res://inventory/Items/miller.tres") as InvItem
@onready var recipes = get_tree().get_first_node_in_group("Recipes")

@onready var interaction_area_shop: InteractionArea = $InteractionAreaShop
@onready var interaction_area: InteractionArea = $InteractionArea

@onready var talk = $CanvasLayer/Speech
@onready var shop = $CanvasLayer/MillersShop_UI
@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var main = get_tree().current_scene

@onready var player = get_tree().get_first_node_in_group("Player")

var is_open := false
var is_shop_visible := false

var miller_dialogues = Global.dialogue["Miller"]
var dialogue = miller_dialogues[Global.current_day] 


func _ready():
	if self.name in Global.dialogue_progress:
		print(Global.dialogue_progress[self.name])
		talk.show_node(Global.dialogue_progress[self.name])
	else:
		talk.show_node("start")
	$PlayerLeft.set_deferred("monitoring", false)
	health = Global.animal_parameters["miller"]["health"]
	interaction_area_shop.interact = Callable(self, "_talk")
	interaction_area.interact = Callable(self, "_pickup")
	$InteractionArea.monitoring = false
	
func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		remove()
		
func _talk():
	if is_open:
		close()
		player.can_attack = true
	else:
		open()
		player.can_attack = false
		

func trigger_death():
	if alive:
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
	player.can_attack = false
	$PlayerLeft.monitoring = true
	talk.visible = true
	if is_shop_visible:
		open_shop()
	is_open = true
	
func close():
	player.can_attack = true
	talk.visible = false
	shop.visible = false
	is_open = false
	$PlayerLeft.set_deferred("monitoring", false)
	
func open_shop():
	is_shop_visible = true
	shop.visible = true
	shop.buy()
	playerinv.position.x = 450
	main.open()
	
func open_give():
	is_shop_visible = true
	shop.position.x = 753
	shop.give()
	shop.visible = true
	playerinv.position.x = 450
	main.open()
	
func close_shop():
	is_shop_visible = false
	shop.visible = false
	main.close()
	player.can_attack = false
	
func add_duck_confit():
	add_recipe("res://inventory/Items/duck_confit_with_side_of_bread.tres")

func add_arabiata():
	add_recipe("res://inventory/Items/arabiata.tres")
		
func add_pancake():
	add_recipe("res://inventory/Items/pancake.tres")

func _on_player_left_body_exited(body):
	close()
	main.close()
	
func add_recipe(key):
	if key not in Global.found_recipes:
		if Global.recipes.has(key):
			Global.found_recipes[key] = Global.recipes[key]
		recipes.setup()



