extends gen_shop

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	$NinePatchRect/GridContainer/VBoxContainer/AxeLabel.text = "  " + str(Global.weapon_price["AXE"])
	$NinePatchRect/GridContainer/VBoxContainer2/CrossbowLabel.text = "  " + str(Global.weapon_price["CROSSBOW"])
	$NinePatchRect/GridContainer/VBoxContainer3/BoltLabel.text = "  " + str(Global.weapon_price["BOLT"])

func _on_axe_pressed():
	if Global.weapons.AXE in Global.unlocked_weapons:
		flash_owned()
	elif player.coin >= Global.weapon_price["AXE"]:
		$NinePatchRect/GridContainer/Axe.add_theme_color_override("icon_normal_color", Color(0, 0, 0))
		$NinePatchRect/GridContainer/Axe.add_theme_color_override("icon_pressed_color", Color(0, 0, 0))
		$NinePatchRect/GridContainer/Axe.add_theme_color_override("icon_hover_color", Color(0, 0, 0))
		$NinePatchRect/GridContainer/Axe.add_theme_color_override("icon_hover_pressed_color", Color(0, 0, 0))
		$NinePatchRect/GridContainer/Axe.add_theme_color_override("icon_focus_color", Color(0, 0, 0))
		Global.unlocked_weapons.append(Global.weapons.AXE)
		player.pay( Global.weapon_price["AXE"])
	else:
		flash_text()


func _on_crossbow_pressed():
	if Global.weapons.CROSSBOW in Global.unlocked_weapons:
		flash_owned()
	elif player.coin >= Global.weapon_price["CROSSBOW"]:
		$NinePatchRect/GridContainer/Crossbow.add_theme_color_override("icon_normal_color", Color(0, 0, 0))
		$NinePatchRect/GridContainer/Crossbow.add_theme_color_override("icon_pressed_color", Color(0, 0, 0))
		$NinePatchRect/GridContainer/Crossbow.add_theme_color_override("icon_hover_color", Color(0, 0, 0))
		$NinePatchRect/GridContainer/Crossbow.add_theme_color_override("icon_hover_pressed_color", Color(0, 0, 0))
		$NinePatchRect/GridContainer/Crossbow.add_theme_color_override("icon_focus_color", Color(0, 0, 0))
		Global.unlocked_weapons.append(Global.weapons.CROSSBOW)
		player.pay( Global.weapon_price["CROSSBOW"])
	else:
		flash_text()


func _on_bolt_pressed():
	if player.coin >= Global.weapon_price["BOLT"]:
		player.bolt_calculate(1)
		player.pay( Global.weapon_price["BOLT"])
	else:
		flash_text()
	
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
	if food == "Boar Steak":
		get_tree().get_first_node_in_group("PlayerInv").inv.remove_from_place(place)
		_on_button_pressed()
		Global.food_given.append(get_parent().get_parent().name)
		get_parent().get_parent().thanks_dialogue()
	else:
		_on_button_pressed()

func _on_button_2_pressed():
	main.get_dragging(false)
	main.buying = false
	main.current_item = null
	main.current_slot = 100
