extends Entity

@onready var interaction_area_shop: InteractionArea = $InteractionAreaShop

@onready var shop = $CanvasLayer/MonksShop_UI
@onready var talk = $CanvasLayer/Speech
@onready var playerinv = get_tree().get_first_node_in_group("PlayerInv")
@onready var main = get_tree().current_scene

@onready var player = get_tree().get_first_node_in_group("Player")

var is_open := false
var is_shop_visible := false

var monk_dialogues = Global.dialogue["Monk"]
var dialogue = monk_dialogues[Global.current_day] 


func _ready():
	if self.name in Global.dialogue_progress:
		talk.show_node(Global.dialogue_progress[self.name])
	else:
		talk.show_node("start")
	$PlayerLeft.set_deferred("monitoring", false)
	health = Global.animal_parameters["monk"]["health"]
	interaction_area_shop.interact = Callable(self, "_talk")
	
func _talk():
	if is_open:
		close()
	else:
		open()

func trigger_death():
	if alive:
		if self.name not in Global.perma_death:
			Global.perma_death.append(self.name)
		$InteractionAreaShop.monitoring = false
		$AnimatedSprite2D.play("death")
		set_collision_layer_value(3, false)
		
func open():
	player.can_attack = false
	$PlayerLeft.monitoring = true
	talk.visible = true
	shop.visible = is_shop_visible
	if is_shop_visible:
		main.playerinv.position.x = 400
		main.open()
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
	main.playerinv.position.x = 400
	main.open()
	
func close_shop():
	is_shop_visible = false
	shop.visible = false
	main.playerinv.position.x = 606
	main.close()

func _on_player_left_body_exited(body):
	close()
	main.playerinv.position.x = 606	
	main.close()


