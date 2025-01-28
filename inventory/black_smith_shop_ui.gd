extends gen_shop

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	$NinePatchRect/GridContainer/AxeLabel.text = "  " + str(Global.weapon_price["AXE"])
	$NinePatchRect/GridContainer/CrossbowLabel.text = "  " + str(Global.weapon_price["CROSSBOW"])
	$NinePatchRect/GridContainer/BoltLabel.text = "  " + str(Global.weapon_price["BOLT"])

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
	
