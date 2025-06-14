extends gen_shop

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var recipes = get_tree().get_first_node_in_group("Recipes")

func _ready():
	$NinePatchRect/GridContainer/TrapLabel.text = "   " + str(Global.weapon_price["TRAP"])
	$NinePatchRect/GridContainer/RecipeLabel.text = "   " + str(Global.recipe_price["Rabbit stew"])

func _on_trap_pressed():
	if player.coin >= Global.weapon_price["TRAP"]:
		player.trap_calculate(1)
		player.pay(Global.weapon_price["TRAP"])
	else:
		flash_text()

func _on_recipe_pressed():
	if player.coin >= Global.recipe_price["Rabbit stew"]:
		var key := "res://inventory/Items/rabbit_stew.tres"
		if key not in Global.found_recipes:
			player.pay(Global.recipe_price["Rabbit stew"])
			if Global.recipes.has(key):
				Global.found_recipes[key] = Global.recipes[key]
			recipes.setup()
		else:
			flash_owned()
	else:
		flash_text()
