extends Control

const recipe_scene := preload("res://inventory/recipe.tscn")
var added_recipes = []
@onready var vbox = $ScrollContainer/VBoxContainer

func _ready():
	setup()
		
func setup():
	for recipe_name in Global.found_recipes.keys():
		if recipe_name not in added_recipes:
			create_recipe(recipe_name)
			added_recipes.append(recipe_name)
		
func create_recipe(recipe_name):
	if recipe_scene:
		var recipe = recipe_scene.instantiate()
		
		# Ensure recipe is a Control node
		if recipe is Control:
			vbox.add_child(recipe)
			if recipe.has_method("setup"):
				recipe.setup(recipe_name)
			else:
				print("⚠️ 'setup' method not found in recipe scene.")
		else:
			print("⚠️ Recipe scene root must be a Control node.")
	else:
		print("⚠️ 'recipe_scene' is null. Check your preload or load call.")

