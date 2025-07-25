extends Control

const recipe_scene := preload("res://inventory/recipe.tscn")
var added_recipes = []
var buffer_node: Control

@onready var vbox := $ScrollContainer/VBoxContainer
@onready var scroll := $ScrollContainer

var sorted_recipe_names := Global.found_recipes.keys()
var from_ready := false 

@onready var main = get_tree().get_first_node_in_group("Level")

func _ready():
	setup()
	from_ready = true

func setup():
	if from_ready and get_tree().current_scene.name != "MainMenu":
		get_tree().get_first_node_in_group("Player").flash_recipe()
		main.show_tutorial("recipes", "open recipes")
	clear_recipes()

	# Get and sort recipe names alphabetically
	if get_tree().current_scene.name == "MainMenu":
		sorted_recipe_names = Global.recipes.keys()
	else:
		sorted_recipe_names = Global.found_recipes.keys()
	sorted_recipe_names.sort()  # Sorts in-place, alphabetical by default

	for recipe_name in sorted_recipe_names:
		if recipe_name not in added_recipes:
			create_recipe(recipe_name)
			added_recipes.append(recipe_name)

	add_buffer()


func create_recipe(recipe_name):
	if recipe_scene:
		var recipe = recipe_scene.instantiate()

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

func clear_recipes():
	for child in vbox.get_children():
		vbox.remove_child(child)
		child.queue_free()
	added_recipes.clear()
	buffer_node = null

func add_buffer():
	buffer_node = Control.new()
	buffer_node.custom_minimum_size = Vector2(0, 24) # You can tweak this height
	buffer_node.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
	vbox.add_child(buffer_node)
