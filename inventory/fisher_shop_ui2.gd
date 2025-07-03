extends gen_shop

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var recipes = get_tree().get_first_node_in_group("Recipes")

func _ready():
	if Global.current_day == 0:
		$NinePatchRect/GridContainer/VBoxContainer/RecipeLabel.text = "   " + str(Global.recipe_price["Fishers soup"])
		$NinePatchRect/GridContainer/Recipe.visible = true
	elif Global.current_day == 1:
		$NinePatchRect/GridContainer/VBoxContainer/RecipeLabel.text = "   " + str(Global.recipe_price["Vegetable soup"])
		$NinePatchRect/GridContainer/Recipe2.visible = true
	elif Global.current_day == 2:
		$NinePatchRect/GridContainer/VBoxContainer/RecipeLabel.text = "   " + str(Global.recipe_price["Meat soup"])
		$NinePatchRect/GridContainer/Recipe3.visible = true
	elif Global.current_day == 3:
		$NinePatchRect/GridContainer/VBoxContainer/RecipeLabel.text = "   " + str(Global.recipe_price["Cake"])
		$NinePatchRect/GridContainer/Recipe4.visible = true
	elif Global.current_day == 4:
		$NinePatchRect/GridContainer/VBoxContainer/RecipeLabel.text = "   " + str(Global.recipe_price["Salad"])
		$NinePatchRect/GridContainer/Recipe5.visible = true
	elif Global.current_day == 5:
		$NinePatchRect/GridContainer/VBoxContainer/RecipeLabel.text = "   " + str(Global.recipe_price["Fruit salad"])
		$NinePatchRect/GridContainer/Recipe6.visible = true

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
		Global.food_given.append(get_parent().get_parent().name)
		get_parent().get_parent().thanks_dialogue()
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



func _on_recipe_3_pressed():
	give_recipe("Meat soup", "res://inventory/Items/meat_soup.tres")


func _on_recipe_4_pressed():
	give_recipe("Cake", "res://inventory/Items/cake.tres")


func _on_recipe_5_pressed():
	give_recipe("Salad", "res://inventory/Items/salad.tres")


func _on_recipe_6_pressed():
	give_recipe("Fruit salad", "res://inventory/Items/fruit_salad.tres")
