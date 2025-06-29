extends Node

var current_day: int = 0

var food_given: Array = []

var dialogue_progress: Dictionary = {}

var hunter_dialogue1: Dictionary = {
	"start": {
		"text": "Hey! You are the new new cook. Have you seen this [color=red]rabbit[/color]? Realy hard to catch it with just your hand.",
		"options": [
			{"text": ">Can you catch it?", "next": "catch"},
			{"text": ">Whats your favorite food?", "next": "food"}
		]
	},
	"catch": {
		"text": "Of course I can. I can sell you some [color=red]traps[/color] so you can catch some too. I also sell the [color=red]recipe[/color] for my dish, it would be much apriciated if you can meke it for me.",
		"options": [
			{"text": ">Buy", "next": "shop"},
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"food": {
		"text": "I realy like [color=red]rabbit stew[/color]. Loved it you could make some for me. You can buy some [color=red]traps[/color] to help you catch that rabbit to.",
		"options": [
			{"text": ">Buy", "next": "shop"},
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"shop": {
		"text": "Here it is.",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "Have a nice day.",
		"action": "close_shop",
		"options": [
			{"text": ">Buy", "next": "shop"},
		]
	}
}

var hunter_dialogue2: Dictionary = {
	"start": {
		"text": "New day new rabbit.",
		"options": [
			{"text": ">Thats right.", "next": "right"},
			{"text": ">Any new recipes?", "next": "recipes"}
		]
	},
	"recipes": {
		"text": "I found some at home I can sell you if you're intrested.",
		"options": [
			{"text": ">Sure.", "next": "shop"},
			{"text": ">Not now.", "next": "good_bye"}
		]
	},
	"right": {
		"text": "Would you be intrested in some new recipes?",
		"options": [
			{"text": ">Sure.", "next": "shop"},
			{"text": ">Not now.", "next": "good_bye"}
		]
	},
	"shop": {
		"text": "Take a look.",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"}
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

var miller_dialogue1: Dictionary = {
	"start":{
		"text": "Greatings. Haven't seen you yet.",
		"options":[
			{"text": ">I'm the cook.", "next": "the_cook"}
		]
	},
	"the_cook":{
		"text": "So you can make me some [color=red]duck confit[/color]? Sorry. I just love duck so much and I dont have time to make it myself. I can [color=red]sell[/color] you some ingredients.",
		"options":[
			{"text": ">How do I make it?", "next": "recipe"}
		]
	},
	"recipe": {
		"text": "Oh yes totaly forgot, here is the [color=red]recipe[/color].",
		"action": "add_duck_confit",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"},
			{"text": ">Buy", "next": "shop"}
		]
	},
	"shop": {
		"text": "It's all fresh, locally sourced.",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "See you next time.",
		"action": "close_shop",
		"options": [
			{"text": ">Buy", "next": "shop"},
		]
	}
}

var miller_dialogue2: Dictionary = {
	"start":{
		"text": "Hello. Today I have some pasta to sell. You could make some [color=red]arabiata[/color] with it.",
		"options":[
			{"text": ">Buy.", "next": "shop"},
			{"text": ">Do you have a recipe?", "next": "recipe"}
		]
	},
	"recipe":{
		"text": "Here you go.",
		"action": "add_arabiata",
		"options":[
			{"text": ">Buy.", "next": "shop"},
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"shop": {
		"text": "It's all fresh, locally sourced.",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "See you next time.",
		"action": "close_shop",
		"options": [
			{"text": ">Buy.", "next": "shop"},
		]
	}
}

var monk_dialogue1: Dictionary = {
	"start":{
		"text": "Fuck you want",
		"options": [
			{"text": ">Poison", "action": "open_shop"}
		]
	}
}

var blacksmith_dialogue1: Dictionary = {
	"start":{
		"text": "Be carefull. That [color=red]boar[/color] is dangerous.",
		"options": [
			{"text": ">I want to cook it.", "next": "me"},
			{"text": ">Do you want me to cook it for you?", "next": "you"}
		]
	},
	"me":{
		"text": "You won't be able to take it with just that knife of yours.",
		"options": [
			{"text": ">Then sell me something stronger.", "next": "shop"},
			{"text": ">We'll see.", "next": "see"}
		]
	},
	"you":{
		"text": "Yeah I do. It's my favorite meat in this whole wide world. Here take this [color=red]recipe[/color], best way to prepare this beast.",
		"action": "add_recipe",
		"options": [
			{"text": ">How will I kill it?", "next": "shop"} 
		]
	},
	"shop":{
		"text": "Here. The [color=red]axe[/color] should do the job.",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "Suit yourself.",
		"action": "close_shop",
		"options": [
			{"text": ">Buy", "next": "shop"},
		]
	},
	"see": {
		"text": "Your choice.",
		"options": [
			{"text": ">Yeah... the knife doesn't work.", "next": "told_you"}
		]
	},
	"told_you":{
		"text": "Told you soo. Here, if you're ready to buy something better from me.",
		"options": [
			{"text": ">Ready.", "next": "shop"}
		]
	}
}

var blacksmith_dialogue2: Dictionary = {
	"start":{
		"text": "Hello!",
		"options": [
			{"text": ">What can I do with that crossbow?.", "next": "crossbow"},
			{"text": ">Buy.", "next": "shop"}
		]
	},
	"crossbow":{
		"text": "It doesnt do a lot of damage but it is great to pick of fast and small animals.",
		"options": [
			{"text": ">Buy.", "next": "shop"},
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"shop":{
		"text": "What are you intrested in today?",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "Take care.",
		"action": "close_shop",
		"options": [
			{"text": ">Buy", "next": "shop"},
		]
	},
}

var fisher_dialogue1: Dictionary = {
	"start":{
		"text": "...",
		"options": [
			{"text": ">Hello.", "next": "hello"}
		]
	},
	"hello":{
		"text": "Shhh... You scare the fish.",
		"options": [
			{"text": ">Sorry...", "next": "shop"}
		]
	},
	"shop": {
		"text": "You should apologize by buying this [color=red]recipe[/color] from me. If you make it you can bring me some.",
		"action": "open_shop",
		"options":[
			{"text": ">Good bye...", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "...",
		"action": "close_shop",
		"options": [
			{"text": ">Buy", "next": "shop"},
		]
	}
}

var fisher_dialogue2: Dictionary = {
	"start":{
		"text": "...",
		"options": [
			{"text": ">Hello.", "next": "hello"},
			{"text": ">...", "next": "..."},
		]
	},
	"hello":{
		"text": "You don't learn. Do you?",
		"options":[
			{"text": ">You got new recipes?", "next": "shop"}
		]
	},
	"...":{
		"text": "...",
		"options": [
			{"text": ">Buy.", "next": "shop"},
		]
	},
	"shop": {
		"text": "...",
		"action": "open_shop",
		"options":[
			{"text": ">Good bye...", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "...",
		"action": "close_shop",
		"options": [
			{"text": ">Buy.", "next": "shop"},
		]
	}
}

var butler_dialogue1: Dictionary = {
	"start": {
		"text": "Congartulation on your new position as head (and only) chef of the King. Your job will be to find ingredients and cook for his Majesty each and every day. The better the dish is the more gold you will be payed.",
		"options": [
			{"text": ">What can I buy with the gold?", "next": "gold"},
			{"text": ">Understood.", "next": "good_bye"}
		]
	},
	"gold": {
		"text": "You can buy new recipes, ingredients and tools from the villagers.",
		"options": [
			{"text": ">Understood.", "next": "good_bye"},
			{"text": ">Do you want something to eat to?", "next": "eat"}
		]
	},
	"good_bye": {
		"text": "Whenever you're ready, simply hand me what you wish to serve the king, and I shall deliver it to him.",
		"action": "close_shop",
		"options": [
			{"text": ">Ready.", "next": "give_to_king"},
		]
	},
	"eat": {
		"text": "No thank you I also taste test for the king. I can try every dish you make. But... there is this legend about a [color=red]plant that taste like meat[/color]. I would like to try that some time.",
		"options": [
			{"text": ">Understood.", "next": "good_bye"}
		]
	},
	"give_to_king":{
		"text": "  ",
		"action": "open_shop",
		"options": [
			{"text": ">Close.", "next": "good_bye"}
		]
	}
}

var give_dialogues = {
	"Hunter": {
		"text": "You already made it?",
		"action": "open_give",
		"options": [
			{"text": ">Not yet.", "next": "good_bye"}
		]
	},
	"Miller": {
		"text": "Thank you so much.",
		"action": "open_give",
		"options": [
			{"text": ">Not yet.", "next": "good_bye"}
		]
	},
	"BlackSmith": {
		"text": "That was fast.",
		"action": "open_give",
		"options": [
			{"text": ">Not yet.", "next": "good_bye"}
		]
	},
	"Fisher": {
		"text": "...",
		"action": "open_give",
		"options": [
			{"text": ">Not yet.", "next": "good_bye"}
		]
	},
	"Butler": {
		"text": "No way! It's real?",
		"action": "open_give",
		"options": [
			{"text": ">Not yet.", "next": "good_bye"}
		]
	}
}

var thank_dialogues: Dictionary = {
	"Hunter": {
		"text": "THANK YOU",
		"action": "close_shop"
	}
}

var dialogue: Dictionary = {
	"Hunter": [hunter_dialogue1, hunter_dialogue2],
	"Miller": [miller_dialogue1, miller_dialogue2],
	"BlackSmith": [blacksmith_dialogue1, blacksmith_dialogue2],
	"Fisher": [fisher_dialogue1, fisher_dialogue2],
	"Butler": [butler_dialogue1],
	"Monk": [monk_dialogue1],
	"King": []
}

var npc_food: Dictionary = {
	"Hunter": "rabbit stew",
	"Miller": "duck confit",
	"BlackSmith": "boar steak",
	"Fisher": "fishers soup",
	"Butler": "lamb chops with mashed potatoes"
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
	"Rabbit stew": 2,
	"Fishers soup": 4,
	"Rabbit stew with mushroom": 3,
	"Vegetable soup": 5
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

var perma_death: Array

var found_recipes: Dictionary = {
	"res://inventory/Items/tomato sauce.tres": ["res://inventory/Items/tomato.tres", "res://inventory/Items/tomato.tres"],
	"res://inventory/Items/bread.tres": ["res://inventory/Items/flour.tres", "res://inventory/Items/water.tres"],
	"res://inventory/Items/fries.tres": ["res://inventory/Items/oil.tres", "res://inventory/Items/potato.tres"],
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
		"scene": scene,
		"perma_death": perma_death,
		"current_day": current_day
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
			perma_death = result["perma_death"]
			current_day = result["current_day"]
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
		
func next_day():
	current_day += 1

	save_game()
	load_game()

	vega_data = {}
	animal_data = {}
	dialogue_progress = {}
	player_data["health"] = 100


