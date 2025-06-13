extends Node

var dialogue_progress: Dictionary = {}

const hunter_dialogue: Dictionary = {
	"start": {
		"text": "Hey! You are the new new cook. Have you seen this rabbit? Realy hard to catch it with just your hand.",
		"options": [
			{"text": ">Can you catch it?", "next": "catch"},
			{"text": ">Whats your favorite food?.", "next": "food"}
		]
	},
	"catch": {
		"text": "Of course I can. I can sell you some traps so youu can catch some too. I also sell the recipe for my dish, it would be much apriciated if you can meke it for me.",
		"options": [
			{"text": ">Buy", "next": "shop"},
			{"text": ">Good bye.", "next": "good_bye", "action": "finish_dialogue"}
		]
	},
	"food": {
		"text": "I realy like rabbit stew. Loved it you could make some for me. You can buy some traps to help you catch that rabbit to.",
		"options": [
			{"text": ">Buy", "next": "shop"},
			{"text": ">Good bye.", "next": "good_bye", "action": "finish_dialogue"}
		]
	},
	"shop": {
		"text": "Here it is.",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye", "action": "finish_dialogue"}
		]
	},
	"good_bye": {
		"text": "Have a nice day.",
		"action": "close_shop",
		"options": [
			{"text": ">Buy", "next": "shop"}
		]
	}
}

const miller_dialogue: Dictionary = {
	"start":{
		"text": "Greatings. Haven't seen you yet.",
		"options":[
			{"text": ">I'm the cook.", "next": "the_cook"}
		]
	},
	"the_cook":{
		"text": "So you can make me some duck confit? Sorry. I just love duck so much and I dont have time to make it myself. I can sell you some ingredients.",
		"options":[
			{"text": ">How do I make it?", "next": "recipe"},
			{"text": ">Buy", "next": "shop_not_recipe"}
		]
	},
	"recipe": {
		"text": "Oh yes totaly forgot, here is the recipe.",
		"action": "add_recipe",
		"options": [
			{"text": ">Good bye.", "next": "good_bye", "action": "finish_dialogue"},
			{"text": ">Buy", "next": "shop"}
		]
	},
	"shop_not_recipe": {
		"text": "It's all fresh, locally sourced.",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye", "action": "finish_dialogue"},
			{"text": ">How do I make that duck confit?", "next": "recipe"}
		]
	},
	"shop": {
		"text": "It's all fresh, locally sourced.",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye", "action": "finish_dialogue"}
		]
	},
	"good_bye": {
		"text": "See you next time.",
		"action": "close_shop",
		"options": [
			{"text": ">Buy", "next": "shop"}
		]
	}
}

const monk_dialogue: Dictionary = {
	"start":{
		"text": "Fuck you want",
		"options": [
			{"text": ">Poison", "action": "open_shop"}
		]
	}
}

const blacksmit_dialogue: Dictionary = {
	"start":{
		"text": "Fuck you want",
		"options": [
			{"text": ">weapon", "action": "open_shop"}
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

const weapon_price = {
	"AXE" : 5,
	"CROSSBOW" : 10 ,
	"BOLT" : 1,
	"TRAP" : 1
}

const recipe_price = {
	"Rabbit stew": 2
}

const weapon_data = {
	weapons.KNIFE: {'damage': 20, 'knockback': 5000.0},
	weapons.AXE: {'damage': 400, 'knockback': 10000.0},
	weapons.CROSSBOW: {'damage': 30, 'knockback': 1000.0, 'speed': 300, 'texture': preload("res://Sprites/Bolt4.png")}
}

var unlocked_weapons = [weapons.KNIFE, weapons.AXE, weapons.CROSSBOW]

var player_data: Dictionary = {
	"health": 100,
	"coin": 10,
	"bolt": 100,
	"trap": 1
}

var gate_index: int
var can_gate := false 

var player_inv: Array

var animal_data: Dictionary

var vega_data: Dictionary

var trap_data: Dictionary

var chest_inv: Dictionary

var scene: String

var found_recipes: Dictionary = {
	"res://inventory/Items/tomato sauce.tres": ["res://inventory/Items/tomato.tres", "res://inventory/Items/tomato.tres"],
	"res://inventory/Items/bread.tres": ["res://inventory/Items/flour.tres", "res://inventory/Items/water.tres"]
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
	"res://inventory/Items/mushroom_stir_fry.tres": ["res://inventory/Items/mushroom.tres", "res://inventory/Items/bad_mushroom.tres", "res://inventory/Items/tree_mushroom.tres", "res://inventory/Items/oil.tres"],
	"res://inventory/Items/the_kings_dish.tres": ["res://inventory/Items/dragon.tres", "res://inventory/Items/potato.tres", "res://inventory/Items/onion.tres", "res://inventory/Items/carrot.tres"],
	"res://inventory/Items/the_gods_dish.tres": ["res://inventory/Items/the_kings_dish.tres", "res://inventory/Items/king.tres"],
	"res://inventory/Items/death_wish.tres": ["res://inventory/Items/tentacle.tres", "res://inventory/Items/zombie.tres"]
}

var chests_load := true

func _convert_vectors(data):
	if typeof(data) == TYPE_DICTIONARY:
		for key in data.keys():
			data[key] = _convert_vectors(data[key])
	elif typeof(data) == TYPE_ARRAY:
		for i in data.size():
			data[i] = _convert_vectors(data[i])
	elif typeof(data) == TYPE_STRING:
		var vector = _string_to_vector2(data)
		if vector != null:
			return vector
	return data

func _string_to_vector2(s: String) -> Variant:
	# Match pattern like "(123, -456)"
	var regex = RegEx.new()
	regex.compile("^\\((-?\\d+(?:\\.\\d+)?),\\s*(-?\\d+(?:\\.\\d+)?)\\)$")
	var result = regex.search(s)
	if result:
		var x = result.get_string(1).to_float()
		var y = result.get_string(2).to_float()
		return Vector2(x, y)
	return null

var save_path := "user://save_data.json"

func get_items(chest_inv: Dictionary) -> Dictionary:
	var items: Dictionary = {}
	for key in chest_inv.keys():
		var chest = chest_inv[key]
		var chest_items: Array = []
		for index in chest.slots.size():
			var slot = chest.slots[index]
			if slot.item != null and slot.item.resource_path != "":
				chest_items.append({
					"index": index,
					"item": slot.item.resource_path
				})
		items[key] = chest_items
	return items
	
func get_items_from_player(inv: Inv):
	var result: Array = []
	for index in inv.slots.size():
		var slot = inv.slots[index]
		if slot.item != null and slot.item.resource_path != "":
			result.append({
				"index": index,
				"item": slot.item.resource_path
			})
	player_inv = result



#Mentés funkció
func save_game():
	get_tree().get_first_node_in_group("Level")._exit_tree()
	var save_data: Dictionary = {
		"unlocked_weapons": unlocked_weapons,
		"player_data": player_data,
		"player_inv": player_inv,
		"animal_data": animal_data,
		"vega_data": vega_data,
		"trap_data": trap_data,
		"chest_inv": get_items(chest_inv) if chests_load else chest_inv,
		"found_recipes": found_recipes,
		"scene": scene
	}

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		print("Mentés sikeres.")


#Betöltés funkció
func load_game():
	can_gate = false
	chests_load = false
	if not FileAccess.file_exists(save_path):
		print("Nincs mentési fájl.")
		return

	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var result = JSON.parse_string(content)
		_convert_vectors(result)
		if result:
			unlocked_weapons = result["unlocked_weapons"]
			player_data = result["player_data"]
			player_inv = result["player_inv"]
			animal_data = result["animal_data"]
			vega_data = result["vega_data"]
			trap_data = result["trap_data"]
			chest_inv = result["chest_inv"]
			found_recipes = result["found_recipes"]
			scene = result["scene"]
			print("Mentés betöltve.")
			get_tree().get_first_node_in_group("Level").pauseMenu()
			get_tree().get_first_node_in_group("Level").can_save = false
			if scene == "Forest":
				TransitionLayer.change_scene("res://Scenes/forest.tscn")
			elif scene == "Castle":
				TransitionLayer.change_scene("res://Scenes/castle.tscn")
			elif scene == "Dungeon":
				TransitionLayer.change_scene("res://Scenes/dungeon.tscn")
			elif scene == "ThroneRoom":
				TransitionLayer.change_scene("res://Scenes/throne_room.tscn")
			#get_tree().get_first_node_in_group("Level")._ready()
			#get_tree().get_first_node_in_group("Player")._ready()

		else:
			print("Hiba a mentési fájl feldolgozásakor.")
		file.close()
