extends gen_shop

func _ready():
	$NoCoinLabel.material.set_shader_parameter("alpha", 0.0)
	$OwnedLabel.material.set_shader_parameter("alpha", 0.0)
	for i in $NinePatchRect/GridContainer.get_children():
		if "Control" in i.name:
			controls += 1
	if Global.current_day == 0:
		$NinePatchRect/GridContainer/Shop_UI_Slot.item = preload("res://inventory/Items/water.tres")
		$NinePatchRect/GridContainer/Shop_UI_Slot2.item = preload("res://inventory/Items/flour.tres")
		$NinePatchRect/GridContainer/Shop_UI_Slot3.item = preload("res://inventory/Items/oil.tres")
	elif Global.current_day == 1:
		$NinePatchRect/GridContainer/Shop_UI_Slot.item = load("res://inventory/Items/water.tres")
		$NinePatchRect/GridContainer/Shop_UI_Slot2.item = load("res://inventory/Items/flour.tres")
		$NinePatchRect/GridContainer/Shop_UI_Slot3.item = load("res://inventory/Items/pasta.tres")
	else:
		$NinePatchRect/GridContainer/Shop_UI_Slot.item = load("res://inventory/Items/water.tres")
		$NinePatchRect/GridContainer/Shop_UI_Slot2.item = load("res://inventory/Items/flour.tres")
		$NinePatchRect/GridContainer/Shop_UI_Slot3.item = load("res://inventory/Items/oil.tres")
	$NinePatchRect/GridContainer/Shop_UI_Slot._ready()
	$NinePatchRect/GridContainer/Shop_UI_Slot2._ready()
	$NinePatchRect/GridContainer/Shop_UI_Slot3._ready()


func _on_shop_button_pressed():
	$NinePatchRect/VBoxContainer.hide()
	$NinePatchRect/Dialoge.hide()
	$NinePatchRect/GridContainer.show()
	$NinePatchRect/Back.show()
	
func _on_back_pressed():
	$NinePatchRect/VBoxContainer.show()
	$NinePatchRect/Dialoge.show()
	$NinePatchRect/GridContainer.hide()
	$NinePatchRect/Back.hide()
	
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
	if food == "Duck Confit with side of Bread":
		get_tree().get_first_node_in_group("PlayerInv").inv.remove_from_place(place)
		_on_button_pressed()
	else:
		_on_button_pressed()


func _on_button_2_pressed():
	main.get_dragging(false)
	main.buying = false
	main.current_item = null
	main.current_slot = 100
