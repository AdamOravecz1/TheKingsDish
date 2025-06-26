extends gen_shop

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var recipes = get_tree().get_first_node_in_group("Recipes")

func _ready():
	$NinePatchRect/GridContainer/VBoxContainer/RecipeLabel.text = "   " + str(Global.recipe_price["Fishers soup"])

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
	if food == "Boar Steak":
		get_tree().get_first_node_in_group("PlayerInv").inv.remove_from_place(place)
		_on_button_pressed()
	else:
		_on_button_pressed()

func _on_button_2_pressed():
	print("dewfraetrdgd")
	main.get_dragging(false)
	main.buying = false
	main.current_item = null
	main.current_slot = 100
