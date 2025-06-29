extends gen_shop

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var recipes = get_tree().get_first_node_in_group("Recipes")

func _ready():
	if Global.current_day == 0:
		$NinePatchRect/GridContainer/VBoxContainer/RecipeLabel.text = "   " + str(Global.recipe_price["Fishers soup"])
		$NinePatchRect/GridContainer/Recipe.visible = true
		$NinePatchRect/GridContainer/Recipe2.visible = false
	elif Global.current_day == 1:
		$NinePatchRect/GridContainer/VBoxContainer/RecipeLabel.text = "   " + str(Global.recipe_price["Vegetable soup"])
		$NinePatchRect/GridContainer/Recipe.visible = false
		$NinePatchRect/GridContainer/Recipe2.visible = true

func _on_recipe_pressed():
	give_recipe("Fishers soup", "res://inventory/Items/fishers_soup.tres")
		

func _on_recipe_2_pressed():
	give_recipe("Vegetable soup", "res://inventory/Items/vegetable_soup.tres")

func give():
	$NinePatchRect/GridContainer.visible = false
	$Inv_UI_Slot.visible = true
	$Button2.visible = true
	$Button2.disabled = false
	
func buy():
	$NinePatchRect/GridContainer.visible = true
	$Inv_UI_Slot.visible = false
	$Button2.visible = false
	$Button2.disabled = true

func _on_inv_ui_slot_send_favorite(food, place):
	if food == "Fishers Soup":
		get_tree().get_first_node_in_group("PlayerInv").inv.remove_from_place(place)
		_on_button_pressed()
	else:
		_on_button_pressed()

func _on_button_2_pressed():
	main.get_dragging(false)
	main.buying = false
	main.current_item = null
	main.current_slot = 100

func give_recipe(recipe, key):
	if player.coin >= Global.recipe_price[recipe]:
		if key not in Global.found_recipes:
			player.pay(Global.recipe_price[recipe])
			if Global.recipes.has(key):
				Global.found_recipes[key] = Global.recipes[key]
			recipes.setup()
		else:
			flash_owned()
	else:
		flash_text()

