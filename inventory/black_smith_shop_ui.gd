extends gen_shop

@onready var player = get_tree().get_first_node_in_group("Player")

func _on_axe_pressed():
	if player.coin >= Global.weapon_price["AXE"]:
		if Global.weapons.AXE not in Global.unlocked_weapons:
			Global.unlocked_weapons.append(Global.weapons.AXE)
			player.pay( Global.weapon_price["AXE"])
	else:
		flash_text()


func _on_crossbow_pressed():
	if player.coin >= Global.weapon_price["CROSSBOW"]:
		if Global.weapons.CROSSBOW not in Global.unlocked_weapons:
			Global.unlocked_weapons.append(Global.weapons.CROSSBOW)
			player.pay( Global.weapon_price["CROSSBOW"])
	else:
		flash_text()
