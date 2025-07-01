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
			send_food.emit(inv.slots[i].item)
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



