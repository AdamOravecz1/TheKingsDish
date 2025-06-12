class_name gen_inv
extends Control

@onready var inv: Inv
@onready var main = get_tree().current_scene

signal send_food(food)

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
		if inv.slots[i].item:
			send_food.emit(inv.slots[i].item.texture)
		else:
			send_food.emit(null)

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
		if "poisoned" not in new_item.types:
			new_item.types.append("poisoned")
			new_item.name = "Poisoned %s" % new_item.name

		# Reinitialize inventory and insert modified item
		inv.initialize_inv(4)
		inv.insert_to_place(new_item, 0)

					

