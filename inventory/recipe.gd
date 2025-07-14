extends Control

func setup(recipe_name):
	var hbox = $NinePatchRect/HBoxContainer
	var hbox2 = $NinePatchRect/HBoxContainer2
	var fog := false
	
	# Get the ingredient textures
	var ingredients = ""
	if get_tree().current_scene.name == "MainMenu":
		ingredients = Global.recipes[recipe_name]
	else:
		ingredients = Global.found_recipes[recipe_name]
	#print("Recipe:", recipe_name)
	
	#Add recipe icon and name to the second HBox
	var recipe_texture = load(recipe_name).texture  # recipe_name is the path to the recipe icon
	if recipe_texture:
		var recipe_icon = TextureRect.new()
		recipe_icon.texture = recipe_texture
		if get_tree().current_scene.name == "MainMenu":
			if recipe_name not in BigGlobal.made_recipes:
				fog = true
				recipe_icon.modulate = Color(0, 0, 0)
		recipe_icon.custom_minimum_size = Vector2(32, 32)
		recipe_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		hbox2.add_child(recipe_icon)
	else:
		print("⚠️ Failed to load recipe texture from:", recipe_name)
		
	#Add ingredients to the first HBox
	for ingredient_path in ingredients:
		#print("Ingredient texture path:", ingredient_path)
		
		var texture = load(ingredient_path).texture
		if texture:
			var texture_rect = TextureRect.new()
			texture_rect.texture = texture
			if fog:
				texture_rect.modulate = Color(0, 0, 0)
			texture_rect.custom_minimum_size = Vector2(32, 32)
			texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			hbox.add_child(texture_rect)
		else:
			print("⚠️ Failed to load texture from:", ingredient_path)
	

