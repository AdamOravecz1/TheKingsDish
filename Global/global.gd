extends Node

enum weapons {KNIFE, AXE, CROSSBOW}

const animal_parameters = {
	"rabbit": {"speed": 110, "health": 20},
	"boar": {"speed": 50, "health": 100}
}

const weapon_data = {
	weapons.KNIFE: {'damage': 20, 'knockback': 10000.0},
	weapons.AXE: {'damage': 60, 'knockback': 15000.0},
	weapons.CROSSBOW: {'damage': 30, 'knockback': 1000.0, 'speed': 300, 'texture': preload("res://Sprites/Bolt4.png")}
}

var animal_data: Dictionary

var vega_data: Dictionary

var chest_inv: Dictionary

var recipes: Dictionary = {
	preload("res://inventory/Items/tomato sauce.tres"): ["tomato", "tomato"],
	preload("res://inventory/Items/rabbit, with pumpkin.tres"): ["rabbit", "pumpkin"]
}
