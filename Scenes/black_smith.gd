extends Entity

var item = load("res://inventory/Items/black_smith.tres") as InvItem
@onready var recipes = get_tree().get_first_node_in_group("Recipes")

@onready var interaction_area_shop: InteractionArea = $InteractionAreaShop
@onready var interaction_area: InteractionArea = $InteractionArea

@onready var talk = $CanvasLayer/Speech
@onready var shop = $CanvasLayer/BlackSmithShop_UI
#@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var main = get_tree().current_scene

@onready var player = get_tree().get_first_node_in_group("Player")

var is_open := false
var is_shop_visible := false

var dialogue := Global.blacksmit_dialogue

func _ready():
	close()
	if self.name in Global.dialogue_progress:
		print(Global.dialogue_progress[self.name])
		talk.show_node(Global.dialogue_progress[self.name])
	else:
		talk.show_node("start")
	health = Global.animal_parameters["black_smith"]["health"]
	interaction_area_shop.interact = Callable(self, "_talk")
	interaction_area.interact = Callable(self, "_pickup")
	$InteractionArea.monitoring = false
	
func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		remove()
		
func _talk():
	if is_open:
		#main.close()
		player.can_attack = true
		close()
	else:
		#playerinv.position.x = 450
		#main.open()
		player.can_attack = false
		open()

func trigger_death():
	if alive:
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
	shop.visible = is_shop_visible
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
	
func close_shop():
	is_shop_visible = false
	shop.visible = false

func _on_player_left_body_exited(body):
	close()
	
func add_recipe():
	var key := "res://inventory/Items/boar_steak.tres"
	if key not in Global.found_recipes:
		if Global.recipes.has(key):
			Global.found_recipes[key] = Global.recipes[key]
		recipes.setup()

