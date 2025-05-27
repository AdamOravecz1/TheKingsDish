extends Node

const hunter_dialogue: Dictionary = {
	"start": {
		"text": "Hey there, traveler!",
		"options": [
			{"text": ">Hi!", "next": "greeting"},
			{"text": ">Leave me alone.", "next": "rude", "action": "reduce_rep"}
		]
	},
	"greeting": {
		"text": "Nice to meet you. Need something?",
		"options": [
			{"text": ">Show me your wares.", "next": "shop"},
			{"text": ">Just passing by.", "next": "good_bye"}
		]
	},
	"rude": {
		"text": "...Suit yourself.",
		"options": [
			{"text": ">Sorry...", "next": "greeting"}
		]
	},
	"shop": {
		"text": "Here are my goods.",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "Have a nice day.",
		"action": "close_shop",
		"options": [
			{"text": ">Show me your wares.", "next": "shop"}
		]
	}
}


enum weapons {KNIFE, AXE, CROSSBOW}

const animal_parameters = {
	"rabbit": {"speed": 110, "health": 20},
	"boar": {"speed": 50, "health": 1000},
	"fish": {"speed": 0.1, "health": 20},
	"duck": {"speed": 30, "health": 20},
	"dragon": {"health": 2000},
	"miller": {"health": 50},
	"black_smith": {"health": 60},
	"hunter": {"health": 50},
	"fisher": {"health": 50},
	"butler": {"health": 50},
	"monk": {"health": 20},
	"zombie": {"speed": 20, "health": 500}
}

var unlocked_weapons = [weapons.KNIFE, weapons.CROSSBOW, weapons.AXE]

const weapon_price = {
	"AXE" : 5,
	"CROSSBOW" : 10 ,
	"BOLT" : 1,
	"TRAP" : 1
}

const weapon_data = {
	weapons.KNIFE: {'damage': 20, 'knockback': 5000.0},
	weapons.AXE: {'damage': 400, 'knockback': 10000.0},
	weapons.CROSSBOW: {'damage': 30, 'knockback': 1000.0, 'speed': 300, 'texture': preload("res://Sprites/Bolt4.png")}
}
var player_data: Dictionary = {
	"health": 100,
	"coin": 10,
	"bolt": 100,
	"trap": 1
}

var animal_data: Dictionary

var vega_data: Dictionary

var trap_data: Dictionary

var chest_inv: Dictionary

var found_recipes: Dictionary = {
	"res://inventory/Items/tomato sauce.tres": ["res://inventory/Items/tomato.tres", "res://inventory/Items/tomato.tres"],
	"res://inventory/Items/bread.tres": ["res://inventory/Items/flour.tres", "res://inventory/Items/water.tres"],
	"res://inventory/Items/fishers_soup.tres": ["res://inventory/Items/fish.tres", "res://inventory/Items/water.tres", "res://inventory/Items/onion.tres", "res://inventory/Items/bell_pepper.tres"],
	"res://inventory/Items/fisher_soup.tres": ["res://inventory/Items/fisher.tres", "res://inventory/Items/water.tres", "res://inventory/Items/onion.tres", "res://inventory/Items/bell_pepper.tres"],
	"res://inventory/Items/mac_n_cheese.tres": ["res://inventory/Items/pasta.tres", "res://inventory/Items/milk.tres", "res://inventory/Items/cheese.tres"],
	"res://inventory/Items/pancake.tres": ["res://inventory/Items/flour.tres", "res://inventory/Items/milk.tres", "res://inventory/Items/oil.tres", "res://inventory/Items/sugar.tres"],
	"res://inventory/Items/blueberry_pancake.tres": ["res://inventory/Items/flour.tres", "res://inventory/Items/milk.tres", "res://inventory/Items/oil.tres", "res://inventory/Items/blue_berry.tres"],
	"res://inventory/Items/salad.tres": ["res://inventory/Items/lettuce.tres", "res://inventory/Items/tomato.tres", "res://inventory/Items/bell_pepper.tres"],
	"res://inventory/Items/fries.tres": ["res://inventory/Items/oil.tres", "res://inventory/Items/potato.tres"],
	"res://inventory/Items/arabiata.tres": ["res://inventory/Items/pasta.tres", "res://inventory/Items/tomato sauce.tres", "res://inventory/Items/chilli_pepper.tres"]

}

const recipes: Dictionary = {
	"res://inventory/Items/tomato sauce.tres": ["res://inventory/Items/tomato.tres", "res://inventory/Items/tomato.tres"],
	"res://inventory/Items/bread.tres": ["res://inventory/Items/flour.tres", "res://inventory/Items/water.tres"],
	"res://inventory/Items/fishers_soup.tres": ["res://inventory/Items/fish.tres", "res://inventory/Items/water.tres", "res://inventory/Items/onion.tres", "res://inventory/Items/bell_pepper.tres"],
	"res://inventory/Items/fisher_soup.tres": ["res://inventory/Items/fisher.tres", "res://inventory/Items/water.tres", "res://inventory/Items/onion.tres", "res://inventory/Items/bell_pepper.tres"],
	"res://inventory/Items/mac_n_cheese.tres": ["res://inventory/Items/pasta.tres", "res://inventory/Items/milk.tres", "res://inventory/Items/cheese.tres"],
	"res://inventory/Items/pancake.tres": ["res://inventory/Items/flour.tres", "res://inventory/Items/milk.tres", "res://inventory/Items/oil.tres", "res://inventory/Items/sugar.tres"],
	"res://inventory/Items/blueberry_pancake.tres": ["res://inventory/Items/flour.tres", "res://inventory/Items/milk.tres", "res://inventory/Items/oil.tres", "res://inventory/Items/blue_berry.tres"],
	"res://inventory/Items/salad.tres": ["res://inventory/Items/lettuce.tres", "res://inventory/Items/tomato.tres", "res://inventory/Items/bell_pepper.tres"],
	"res://inventory/Items/fries.tres": ["res://inventory/Items/oil.tres", "res://inventory/Items/potato.tres"],
	"res://inventory/Items/arabiata.tres": ["res://inventory/Items/pasta.tres", "res://inventory/Items/tomato sauce.tres", "res://inventory/Items/chilli_pepper.tres"],
	"res://inventory/Items/boar_steak.tres": ["res://inventory/Items/boar.tres", "res://inventory/Items/fries.tres"],
	"res://inventory/Items/sugar.tres": ["res://inventory/Items/carrot.tres"],
	"res://inventory/Items/rabbit_stew.tres": ["res://inventory/Items/rabbit.tres", "res://inventory/Items/potato.tres", "res://inventory/Items/onion.tres"],
	"res://inventory/Items/rabbit_stew_with_mushroom.tres": ["res://inventory/Items/rabbit.tres", "res://inventory/Items/potato.tres", "res://inventory/Items/onion.tres", "res://inventory/Items/mushroom.tres"],
	"res://inventory/Items/rabbit_stew_with_kick.tres": ["res://inventory/Items/rabbit.tres", "res://inventory/Items/potato.tres", "res://inventory/Items/onion.tres", "res://inventory/Items/bad_mushroom.tres"],
	"res://inventory/Items/capital_stew.tres": ["res://inventory/Items/hunter.tres", "res://inventory/Items/potato.tres", "res://inventory/Items/onion.tres"],
	"res://inventory/Items/hammer_and_nails.tres": ["res://inventory/Items/black_smith.tres", "res://inventory/Items/fries.tres"],
	"res://inventory/Items/fruit_salad.tres": ["res://inventory/Items/plum.tres", "res://inventory/Items/pear.tres", "res://inventory/Items/blue_berry.tres"],
	"res://inventory/Items/mushroom_soup.tres": ["res://inventory/Items/mushroom.tres", "res://inventory/Items/water.tres", "res://inventory/Items/flour.tres", "res://inventory/Items/onion.tres"],
	"res://inventory/Items/mushroom_soup_in_bread.tres": ["res://inventory/Items/mushroom_soup.tres", "res://inventory/Items/bread.tres"],
	"res://inventory/Items/mushroom_soup_with_kick.tres": ["res://inventory/Items/bad_mushroom.tres", "res://inventory/Items/water.tres", "res://inventory/Items/flour.tres", "res://inventory/Items/onion.tres"],
	"res://inventory/Items/mushroom_soup_with_kick_in_bread.tres": ["res://inventory/Items/mushroom_soup_with_kick.tres", "res://inventory/Items/bread.tres"],
	"res://inventory/Items/cake.tres": ["res://inventory/Items/flour.tres", "res://inventory/Items/sugar.tres", "res://inventory/Items/water.tres"],
	"res://inventory/Items/carrot_cake.tres": ["res://inventory/Items/cake.tres", "res://inventory/Items/carrot.tres"],
	"res://inventory/Items/blueberry_cake.tres": ["res://inventory/Items/cake.tres", "res://inventory/Items/blue_berry.tres"],
	"res://inventory/Items/pear_cake.tres": ["res://inventory/Items/cake.tres", "res://inventory/Items/pear.tres"],
	"res://inventory/Items/plum_cake.tres": ["res://inventory/Items/cake.tres", "res://inventory/Items/plum.tres"],
	"res://inventory/Items/fruit_cake.tres": ["res://inventory/Items/cake.tres", "res://inventory/Items/plum.tres", "res://inventory/Items/blue_berry.tres", "res://inventory/Items/pear.tres"],
	"res://inventory/Items/vegetable_soup.tres": ["res://inventory/Items/water.tres", "res://inventory/Items/onion.tres", "res://inventory/Items/carrot.tres", "res://inventory/Items/potato.tres"],
	"res://inventory/Items/vegetable_soup_in_bread.tres": ["res://inventory/Items/vegetable_soup.tres", "res://inventory/Items/bread.tres"],
	"res://inventory/Items/meat_soup.tres": ["res://inventory/Items/water.tres", "res://inventory/Items/duck.tres", "res://inventory/Items/boar.tres", "res://inventory/Items/rabbit.tres"],
	"res://inventory/Items/meat_soup_in_bread.tres": ["res://inventory/Items/meat_soup.tres", "res://inventory/Items/bread.tres"],
	"res://inventory/Items/spaghetti_meatball.tres": ["res://inventory/Items/pasta.tres", "res://inventory/Items/tomato.tres", "res://inventory/Items/boar.tres", "res://inventory/Items/cheese.tres"],
	"res://inventory/Items/sandwich.tres": ["res://inventory/Items/bread.tres", "res://inventory/Items/tomato.tres", "res://inventory/Items/lettuce.tres", "res://inventory/Items/boar.tres"],
	"res://inventory/Items/duck_confit_with_side_of_bread.tres": ["res://inventory/Items/bread.tres", "res://inventory/Items/duck.tres"],
	"res://inventory/Items/duck_salad.tres": ["res://inventory/Items/lettuce.tres", "res://inventory/Items/duck.tres"],
	"res://inventory/Items/comfy_peasant.tres": ["res://inventory/Items/bread.tres", "res://inventory/Items/miller.tres"],
	"res://inventory/Items/mashed_potatoes.tres": ["res://inventory/Items/potato.tres", "res://inventory/Items/milk.tres"],
	"res://inventory/Items/lamb_chops_with_mashed_potatoes.tres": ["res://inventory/Items/mashed_potatoes.tres", "res://inventory/Items/oil.tres", "res://inventory/Items/vegan_lamb.tres"],
	"res://inventory/Items/butter_chops_with_mashed_potatoes.tres": ["res://inventory/Items/mashed_potatoes.tres", "res://inventory/Items/oil.tres", "res://inventory/Items/butler.tres"],
	"res://inventory/Items/pumpkin_pie.tres": ["res://inventory/Items/pumpkin.tres", "res://inventory/Items/flour.tres", "res://inventory/Items/milk.tres"],
	"res://inventory/Items/mushroom_stir_fry.tres": ["res://inventory/Items/mushroom.tres", "res://inventory/Items/bad_mushroom.tres", "res://inventory/Items/tree_mushroom.tres", "res://inventory/Items/oil.tres"]

}
