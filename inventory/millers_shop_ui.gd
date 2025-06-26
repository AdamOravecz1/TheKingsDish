extends gen_shop

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
	print("Dfgtdft")
	main.get_dragging(false)
	main.buying = false
	main.current_item = null
	main.current_slot = 100
