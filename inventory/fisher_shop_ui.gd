extends gen_shop

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var recipes = get_tree().get_first_node_in_group("Recipes")
		
func add_recipe_to_found(recipe_key: Resource) -> void:
	# Check if the recipe exists in the 'recipes' dictionary
	if not Global.recipes.has(recipe_key):
		print("⚠️ Recipe not found:", recipe_key)
		return
	
	var ingredients = Global.recipes[recipe_key]
	var ingredient_paths: Array = []

	# Loop through the ingredients and extract their texture paths
	for ingredient in ingredients:
		if ingredient.has_method("get"):
			var texture: Texture2D = ingredient.get("texture")
			if texture and texture.resource_path != "":
				ingredient_paths.append(texture.resource_path)
			else:
				print("⚠️ No valid texture found for ingredient:", ingredient)
		else:
			print("⚠️ Ingredient does not have 'texture' property:", ingredient)

	# Add the recipe icon and ingredient texture paths to 'found_recipes'
	if recipe_key.has_method("get"):
		var recipe_icon: Texture2D = recipe_key.get("texture")
		if recipe_icon and recipe_icon.resource_path != "":
			Global.found_recipes[recipe_icon.resource_path] = ingredient_paths
			print("✅ Added recipe:", recipe_icon.resource_path, "with ingredients:", ingredient_paths)
		else:
			print("⚠️ Recipe has no valid texture:", recipe_key)


func _on_recipe_pressed():
	print(Global.found_recipes)
	add_recipe_to_found(preload("res://inventory/Items/rabbit, with pumpkin.tres"))
	recipes.setup()
	print(Global.found_recipes)
	
