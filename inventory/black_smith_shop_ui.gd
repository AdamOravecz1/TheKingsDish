extends gen_shop

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	$NinePatchRect/GridContainer/AxeLabel.text = str(Global.weapon_price["AXE"])
	$NinePatchRect/GridContainer/CrossbowLabel.text = str(Global.weapon_price["CROSSBOW"])
	$NinePatchRect/GridContainer/BoltLabel.text = str(Global.weapon_price["BOLT"])

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


func _on_bolt_pressed():
	if player.coin >= Global.weapon_price["BOLT"]:
		player.bolt_calculate(1)
		player.pay( Global.weapon_price["BOLT"])
	else:
		flash_text()
	
