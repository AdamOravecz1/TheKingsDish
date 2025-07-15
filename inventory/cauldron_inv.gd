extends gen_inv

@onready var recipes = get_tree().get_first_node_in_group("Recipes")

func _on_cook_pressed():
	var cauldron_content: Array = []
	var poisoned_item: InvItem = null
	var target_item: InvItem = null

	# Collect items and detect poison logic
	for i in range(4):
		var current_item = inv.slots[i].item
		if current_item:
			cauldron_content.append(current_item.name)

			if "poison" in current_item.types:
				poisoned_item = current_item
			else:
				target_item = current_item

	cauldron_content.sort()

	# Try to match a full recipe
	for recipe_name in Global.recipes.keys():
		var ingredients = Global.recipes[recipe_name].duplicate()
		var ingredients_name = []
		for i in ingredients:
			var item_res = load(i)
			ingredients_name.append(item_res.name)
		ingredients_name.sort()

		if ingredients_name == cauldron_content:
			add_recipe(recipe_name)
			found_recipe(recipe_name)
			$Success.play()
			inv.initialize_inv(4)
			inv.insert_to_place(load(recipe_name), 0)
			
			return
		else:
			$Fail.play()

	# Special case: 2 items, one poisoned and one not
	if cauldron_content.size() == 2 and poisoned_item and target_item:
		$Success.play()
		# Clone the item to preserve its resource (optional)
		var new_item := target_item.duplicate()
		
		# Add poison if not already present
		if "poison" not in new_item.types:
			new_item.types.append("poison")
			new_item.name = "Poisoned %s" % new_item.name

		# Reinitialize inventory and insert modified item
		inv.initialize_inv(4)
		inv.insert_to_place(new_item, 0)
		
func add_recipe(key):
	if key not in Global.found_recipes:
		if Global.recipes.has(key):
			Global.found_recipes[key] = Global.recipes[key]
		
func found_recipe(key):
	if key not in BigGlobal.made_recipes:
		if Global.recipes.has(key):
			BigGlobal.made_recipes[key] = Global.recipes[key]
		recipes.setup()
