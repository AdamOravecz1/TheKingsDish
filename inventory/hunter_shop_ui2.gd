extends gen_shop

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var recipes = get_tree().get_first_node_in_group("Recipes")

func _ready():
	if Global.current_day == 0:
		$NinePatchRect/GridContainer.position.x += 20
		$NinePatchRect/GridContainer.columns = 2
	elif Global.current_day == 1:
		$NinePatchRect/GridContainer.columns = 3
		$NinePatchRect/GridContainer/StewName2.visible = true
		$NinePatchRect/GridContainer/Stew2.visible = true
		$NinePatchRect/GridContainer/VBoxContainer3.visible = true
	elif Global.current_day == 2:
		$NinePatchRect/GridContainer.columns = 3
		$NinePatchRect/GridContainer/SoupName.visible = true
		$NinePatchRect/GridContainer/Soup.visible = true
		$NinePatchRect/GridContainer/VBoxContainer4.visible = true
	elif Global.current_day == 3:
		$NinePatchRect/GridContainer.columns = 3
		$NinePatchRect/GridContainer/StirFryName.visible = true
		$NinePatchRect/GridContainer/StirFry.visible = true
		$NinePatchRect/GridContainer/VBoxContainer5.visible = true
	elif Global.current_day == 4:
		$NinePatchRect/GridContainer.columns = 3
		$NinePatchRect/GridContainer/PumpkinPieName.visible = true
		$NinePatchRect/GridContainer/PumpkinPie.visible = true
		$NinePatchRect/GridContainer/VBoxContainer6.visible = true
	else: 
		$NinePatchRect/GridContainer.columns = 6
		for i in $NinePatchRect/GridContainer.get_children():
			i.visible = true
	$NinePatchRect/GridContainer/VBoxContainer/TrapLabel.text = "   " + str(Global.weapon_price["TRAP"])
	$NinePatchRect/GridContainer/VBoxContainer2/StewLabel.text = "   " + str(Global.recipe_price["Rabbit stew"])
	$NinePatchRect/GridContainer/VBoxContainer3/StewLabel2.text = "   " + str(Global.recipe_price["Rabbit stew with mushroom"])
	$NinePatchRect/GridContainer/VBoxContainer4/SoupLabel.text = "   " + str(Global.recipe_price["Mushroom soup"])
	$NinePatchRect/GridContainer/VBoxContainer5/StirFryLabel.text + "   " + str(Global.recipe_price["Stir fry"])
	$NinePatchRect/GridContainer/VBoxContainer6/PumpkinPieLabel.text  + "   " + str(Global.recipe_price["Pumpkin pie"])

func _on_trap_pressed():
	if player.coin >= Global.weapon_price["TRAP"]:
		player.trap_calculate(1)
		player.pay(Global.weapon_price["TRAP"])
	else:
		flash_text()
		
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

func _on_stew_pressed():
	give_recipe("Rabbit stew", "res://inventory/Items/rabbit_stew.tres")


func _on_stew_2_pressed():
	give_recipe("Rabbit stew with mushroom", "res://inventory/Items/rabbit_stew_with_mushroom.tres")
	
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
	if food == "Rabbit Stew" or food == "Tomato":
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


func _on_soup_pressed():
	give_recipe("Mushroom soup", "res://inventory/Items/mushroom_soup.tres")


func _on_stir_fry_pressed():
	give_recipe("Stir fry", "res://inventory/Items/mushroom_stir_fry.tres")


func _on_pumpkin_pie_pressed():
	give_recipe("Pumpkin pie", "res://inventory/Items/pumpkin_pie.tres")
