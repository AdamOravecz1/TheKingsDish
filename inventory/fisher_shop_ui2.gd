extends gen_shop

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var recipes = get_tree().get_first_node_in_group("Recipes")

func _ready():
	$NinePatchRect/GridContainer/RecipeLabel.text = "   " + str(Global.recipe_price["Fishers soup"])

func _on_recipe_pressed():
	if player.coin >= Global.recipe_price["Fishers soup"]:
		var key := "res://inventory/Items/fishers_soup.tres"
		if key not in Global.found_recipes:
			player.pay(Global.recipe_price["Fishers soup"])
			if Global.recipes.has(key):
				Global.found_recipes[key] = Global.recipes[key]
			recipes.setup()
		else:
			flash_owned()
	else:
		flash_text()
