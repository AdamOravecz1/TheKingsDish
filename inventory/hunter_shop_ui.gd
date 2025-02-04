extends gen_shop

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	$NinePatchRect/GridContainer/TrapLabel.text = "  " + str(Global.weapon_price["TRAP"])

func _on_trap_pressed():
	if player.coin >= Global.weapon_price["TRAP"]:
		player.trap_calculate(1)
		player.pay( Global.weapon_price["TRAP"])
	else:
		flash_text()
