extends Control

@onready var inv: Inv
@onready var main = get_tree().current_scene

var slots: Array
var controls := 0.0
var inv_ui_slot_scene = preload("res://inventory/inv_ui_slot.tscn")

var is_open := false

func _ready():
	for i in $NinePatchRect/GridContainer.get_children():
		if "Inv_UI_Slot" in i.name:
			slots.append(i)
		else:
			controls += 0.5
	if inv:
		inv.update.connect(update_slots)
		update_slots()
	
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func get_item(item: InvItem, i):
	main.current_item = item
	main.current_slot = i
	
func change_item(i):
	inv.remove_from_place(main.current_slot)
	inv.insert_to_place(main.current_item, i)

func remove_slot():
	inv.remove_from_place(main.current_slot)
	
func insert_slot():
	inv.insert_to_place(main.current_item, main.current_slot)


func remove_item():
	main.current_item = null
	main.current_slot = 100
	
func _on_button_pressed():
	main.get_dragging(false)
	main.buying = false
	remove_item()
	
func send_inv():
	main.get_inv(self)

func _on_cook_pressed():
	var cauldron_content: Array = []  # Initialize the array properly
	for i in range(4):
		if inv.slots[i].item:
			cauldron_content.append(inv.slots[i].item.name)

	cauldron_content.sort()  # Sort the cauldron content for comparison

	for recipe_name in Global.recipes.keys():
		var ingredients = Global.recipes[recipe_name].duplicate()
		var ingredients_name = []
		print(ingredients)
		for i in ingredients:
			ingredients_name.append(i.name)
		ingredients_name.sort()  # Sort the ingredients_name from the recipe

		if ingredients_name == cauldron_content:
			inv.initialize_inv(4)
			inv.insert_to_place(recipe_name, 0)
			return  # Exit once the match is found

