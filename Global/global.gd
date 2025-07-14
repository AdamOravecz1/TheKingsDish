extends Node

var full_screen: bool = false

var current_day: int = 0

var previous_day_value: int = 0

var food_given: Array = []

var dialogue_progress: Dictionary = {}

var monk_counter: int = 0

var king_counter: int = 0

var bad_food_counter: int = 0

var good_food_counter: int = 0

var can_next_day: bool = false

var execution: bool = false

var ritual: bool = false

var dragon_slayer: bool = false

var king_killer: bool = false

var king_taker: bool = false

var execution_text: String = ""

var hunter_dialogue1: Dictionary = {
	"start": {
		"text": "Hey! You are the new new cook. Have you seen this [color=red]rabbit[/color]? Realy hard to catch it with just your hand.",
		"options": [
			{"text": ">Can you catch it?", "next": "catch"}
		]
	},
	"catch": {
		"text": "Of course I can. I can sell you some [color=red]traps[/color] so you can catch some also.",
		"options": [
			{"text": ">Whats your favorite food?", "next": "food"}
		]
	},
	"food": {
		"text": "I realy like [color=red]rabbit stew[/color]. Loved it you could make some for me. I can sell you the [color=red]recipe[/color] too.",
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

var hunter_dialogue3: Dictionary = {
	"start": {
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

var hunter_dialogue4: Dictionary = {
	"start": {
		"text": "I've been checking out that wierd mushroom high on that tree but I have no idea how to get to it.",
		"options": [
			{"text": ">What would you make from it?", "next": "shop"},
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"shop": {
		"text": "Check out this [color=red]mushroom stir fry[/color].",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "See you next time.",
		"action": "close_shop",
		"options": [
			{"text": ">Buy.", "next": "shop"}
		]
	}
}

var hunter_dialogue5: Dictionary = {
	"start": {
		"text": "See that [color=red]pumpkin[/color] just behind me? I've got a recipe for it.",
		"options": [
			{"text": ">Buy.", "next": "shop"},
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"shop": {
		"text": "Here you go.",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "See you next time.",
		"action": "close_shop",
		"options": [
			{"text": ">Buy.", "next": "shop"}
		]
	}
}

var hunter_dialogue6: Dictionary = {
	"start": {
		"text": "Today I don't have anything new but you can purchase anything if you havn't before.",
		"options": [
			{"text": ">Buy.", "next": "shop"},
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"shop": {
		"text": "Here you go.",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "See you next time.",
		"action": "close_shop",
		"options": [
			{"text": ">Buy.", "next": "shop"}
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

var miller_dialogue3: Dictionary = {
	"start":{
		"text": "Hello. Today I'm selling milk. It is good for a lot of recipes.",
		"options":[
			{"text": ">Buy.", "next": "shop"},
			{"text": ">For example?", "next": "recipe"}
		]
	},
	"recipe":{
		"text": "Here you go. You can try adding blueberries instead of suggar.",
		"action": "add_pancake",
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

var miller_dialogue4: Dictionary = {
	"start":{
		"text": "Hello. I finally managed to get hold of some cheese. Are you interested?",
		"options":[
			{"text": ">Of course I am.", "next": "shop"},
			{"text": ">What can i make with it?", "next": "recipe"}
		]
	},
	"recipe":{
		"text": "There is this nice pasta dish that full of cheese. It's delicious.",
		"action": "add_mac_n_cheese",
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

var miller_dialogue5: Dictionary = {
	"start":{
		"text": "Hello. What can I get you today?",
		"options":[
			{"text": ">Buy.", "next": "shop"},
			{"text": ">Any new recipe?", "next": "recipe"}
		]
	},
	"recipe":{
		"text": "Sure. Here is another duck dish. There is never enough of that.",
		"action": "add_duck",
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

var miller_dialogue6: Dictionary = {
	"start":{
		"text": "Hello. What can I get you today?",
		"options":[
			{"text": ">Buy.", "next": "shop"},
			{"text": ">Any new recipe?", "next": "recipe"}
		]
	},
	"recipe":{
		"text": "Sorry but that was all I had.",
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
		"text": "Here is a secret. You can switch any mushroom with the bad kind to make the King sick. You should give it a try.",
		"options": [
			{"text": ">Who are you?", "next": "me"},
			{"text": ">Good bye", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "You will want to visit me next day too.",
		"action": "close_shop",
	},
	"me":{
		"text": "I'm your friend.",
		"options": [
			{"text": ">Good bye?", "next": "good_bye"}
		]
	}
}

var monk_dialogue2: Dictionary = {
	"start":{
		"text": "Have you noticed that all of these villagers have a favorite food. All of these dishes contain meat. But why kill poor animals when the meat can substituted with there own flesh.",
		"options": [
			{"text": ">Ok?", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "You will want to visit me again.",
		"action": "close_shop",
	}
}

var monk_dialogue3: Dictionary = {
	"start":{
		"text": "There is a [color=purple]ritual[/color]. A dish that opens ones \"eyes\". To make it take this \"plant\" and mix it with the head of those who live in dead.",
		"options": [
			{"text": ">Ok?", "next": "good_bye"},
			{"text": ">Who are those who live in death?", "next": "death"}
		]
	},
	"death":{
		"text": "Souls get recycled. After someones death another who passed long ago might get reanimated.",
		"options": [
			{"text": ">Ok?", "next": "good_bye"},
		]
	},
	"good_bye": {
		"text": "I will have more secrets next time.",
		"action": "close_shop",
	}
}

var monk_dialogue4: Dictionary = {
	"start":{
		"text": "Because you are still here I'm guessing you havn't made the King sick yet. That's good. He would have survived but you wouldn't. Dream big. Weak mushrooms wouldn't work. Get this.",
		"options": [
			{"text": ">Get what?", "next": "shop"},
			{"text": ">Good bye.", "next": "good_bye"},
		]
	},
	"shop":{
		"text": "This. You just have to add it to the dish after you made it.",
		"action": "open_shop",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "Next time.",
		"action": "close_shop",
		"options": [
			{"text": ">Buy", "next": "shop"},
		]
	}
}

var monk_dialogue5: Dictionary = {
	"start":{
		"text": "What is happening? You still havn't finished the ritual!",
		"options": [
			{"text": ">Good bye.", "next": "good_bye"},
		]
	},
	"good_bye": {
		"text": "Don't take your time!",
		"action": "close_shop"
	}
}

var blacksmith_dialogue1: Dictionary = {
	"start":{
		"text": "Be carefull. That [color=red]boar[/color] is dangerous.",
		"options": [
			{"text": ">Do you want me to cook it for you?", "next": "you"}
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

var blacksmith_dialogue3: Dictionary = {
	"start":{
		"text": "Hello! The regular?",
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

var blacksmith_dialogue4: Dictionary = {
	"start":{
		"text": "Hello! Look what I found lying around at home. [color=red]Spaghetti with meatballs recipe[/color]. You can have it if you want.",
		"options": [
			{"text": ">Buy.", "next": "shop"},
			{"text": ">Take recipe.", "next": "recipe"}
		]
	},
	"recipe":{
		"text": "Here you go",
		"action": "add_spaghetti",
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

var fisher_dialogue3: Dictionary = {
	"start":{
		"text": "...",
		"options": [
			{"text": ">Hello.", "next": "hello"},
			{"text": ">...", "next": "..."},
		]
	},
	"hello":{
		"text": "What is your problem?",
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
		"text": "Hey, I hope you realise this is just a plain cake. After you bake it you need to add some fruits or vegetables. You are the Chef I shouldn't have to telly you this.",
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

var fisher_dialogue4: Dictionary = {
	"start":{
		"text": "If you don't have anything for me you can beat it.",
		"options": [
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
			{"text": ">What can I buy with the gold?", "next": "gold"}
		]
	},
	"gold": {
		"text": "You can buy new recipes, ingredients and tools from the villagers.",
		"options": [
			{"text": ">Do you want something to eat to?", "next": "eat"}
		]
	},
	"good_bye": {
		"text": "Whenever you're ready, simply hand me what you wish to serve the king, and I shall deliver it to him.",
		"action": "close_shop",
		"options": [
			{"text": ">Give todays dish.", "next": "shop"},
		]
	},
	"eat": {
		"text": "No thank you I also taste test for the king. I can try every dish you make. But... there is this legend about a [color=red]plant that taste like meat[/color]. I would like to try that some time.",
		"action": "add_recipe",
		"options": [
			{"text": ">Understood.", "next": "good_bye"}
		]
	},
	"shop":{
		"text": "  ",
		"action": "open_shop",
		"options": [
			{"text": ">Close.", "next": "good_bye"}
		]
	}
}

var king_dialogue1: Dictionary = {
	"start": {
		"text": "Sooooo... You are the great cook who makes such a great dishes.",
		"options": [
			{"text": ">Is there a dish that his Majisty would prefer?", "next": "dish"},
		]
	},
	"dish": {
		"text": "There is this legend about a [color=red]dragon[/color] that lives in this kingdom. I want to eat that. According to the tale the one who eats it will rule for 80 and 1 year.",
		"options": [
			{"text": ">Of course your Majisty.", "next": "recipe"},
		]
	},
	"recipe": {
		"text": "Here. My hororscope told me the [color=red]dragon[/color] should be prepared like to this.",
		"action": "add_recipe",
		"options": [
			{"text": ">With your permission, I shall take my leave.", "next": "good_bye"},
		]
	},
	"good_bye": {
		"text": "Go! And make my dream come true!",
		"action": "close_shop"
	}
}

var king_dialogue2: Dictionary = {
	"start": {
		"text": "How is that [color=red]dragon[/color] coming along?",
		"options": [
			{"text": ">It is in the making.", "next": "good_be"},
		]
	},
	"good_bye": {
		"text": "Good, good. Best of luck. I'll be waiting for your greatness.",
		"action": "close_shop"
	}
}

var butler_dialogue2: Dictionary = {
	"start0": {
		"text": "What you served yesterday was absolutely horrible. His Majisty wouldn't even touch it. If you dare to pull a stunt like that again you are \"fired\".",
		"options": [
			{"text": ">Give todays dish.", "next": "shop"},
			{"text": ">Not yet.", "next": "good_bye"}
		]
	},
	"start1": {
		"text": "The King ate what you made yesterday but didn't realy enjoyed it. Here is your salary.",
		"options": [
			{"text": ">Give todays dish.", "next": "shop"},
			{"text": ">Not yet.", "next": "good_bye"}
		]
	},
	"start2": {
		"text": "The King enjoyed what you made yesterday. Keep up this good work. Here is your salary.",
		"options": [
			{"text": ">Give todays dish.", "next": "shop"},
			{"text": ">Not yet.", "next": "good_bye"}
		]
	},
	"start3": {
		"text": "The King couldn't stop praising you during yeasterdays dinner. If you keep this up you might be able to meet with him. Here is your salary.",
		"options": [
			{"text": ">Give todays dish.", "next": "shop"},
			{"text": ">Not yet.", "next": "good_bye"}
		]
	},
	"start4": {
		"text": "The King wishes to meet personally with the men who cook this well. The door to the throne room is now open. Here is your salary.",
		"options": [
			{"text": ">Give todays dish.", "next": "shop"},
			{"text": ">Not yet.", "next": "good_bye"}
		]
	},
	"good_bye": {
		"text": "Whenever you're ready, simply hand me what you wish to serve the king, and I shall deliver it to him.",
		"action": "close_shop",
		"options": [
			{"text": ">Give todays dish.", "next": "shop"},
		]
	},
	"shop":{
		"text": "  ",
		"action": "open_shop",
		"options": [
			{"text": ">Close.", "next": "good_bye"}
		]
	}
}

var butler_dialogue3: Dictionary = {
	"start0": {
		"text": "What you served yesterday was absolutely horrible. His Majisty wouldn't even touch it. If you dare to pull a stunt like that again you are \"fired\".",
		"options": [
			{"text": ">Today is lent.", "next": "lent"}
		]
	},
	"start1": {
		"text": "The King ate what you made yesterday but didn't realy enjoyed it. Here is your salary.",
		"options": [
			{"text": ">Today is lent.", "next": "lent"}
		]
	},
	"start2": {
		"text": "The King enjoyed what you made yesterday. Keep up this good work. Here is your salary.",
		"options": [
			{"text": ">Today is lent.", "next": "lent"}
		]
	},
	"start3": {
		"text": "The King couldn't stop praising you during yeasterdays dinner. If you keep this up you might be able to meet with him. Here is your salary.",
		"options": [
			{"text": ">Today is lent.", "next": "lent"}
		]
	},
	"start4": {
		"text": "The King wishes to meet personally with the men who cook this well. The door to the throne room is now open. Here is your salary.",
		"options": [
			{"text": ">Today is lent.", "next": "lent"}
		]
	},
	"good_bye": {
		"text": "Whenever you're ready, simply hand me what you wish to serve the king, and I shall deliver it to him.",
		"action": "close_shop",
		"options": [
			{"text": ">Give todays dish.", "next": "shop"},
		]
	},
	"shop":{
		"text": "  ",
		"action": "open_shop",
		"options": [
			{"text": ">Close.", "next": "good_bye"}
		]
	},
	"lent":{
		"text": "That's right. So be careful not to serv meat to his Majesty otherwise you are going to hang.",
		"options": [
			{"text": ">Give todays dish.", "next": "shop"},
			{"text": ">Not yet.", "next": "good_bye"}
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

var buffer_dialogue: Dictionary = {
	"start":{
		"text": " "
	}
}

var thank_dialogues: Dictionary = {
	"Hunter": {
		"text": "Here is a nice idea I have seen once in another kingdom. You can take any soup and put in bread bowl. I think the King might appriciate it.",
		"action": "close_shop"
	},
	"Fisher":{
		"text": "You are finally usefull for once. Why don't you take a swim in the lake. You might find something interesting in there.",
		"action": "close_shop"
	},
	"BlackSmith":{
		"text": "There is this folk lore in which the hero used a well aimed arrow to blind the dragon. I realy like that tale. It's my favorite.",
		"action": "close_shop"
	},
	"Miller":{
		"text": "I'm here. Every day. When it shines when it rains. And after every rainy day you can see these two clouds close to the mill. It's almost like you can stand on it.",
		"action": "close_shop"
	},
	"Butler":{
		"text": "Do you know the Kings favorite dish. I think he would be delighted if you could do some flare with it. Like put a crown on top of it.",
		"action": "close_shop"
	},
}

var dialogue: Dictionary = {
	"Hunter": [hunter_dialogue1, hunter_dialogue2, hunter_dialogue3, hunter_dialogue4, hunter_dialogue5, hunter_dialogue6, hunter_dialogue6, buffer_dialogue],
	"Miller": [miller_dialogue1, miller_dialogue2, miller_dialogue3, miller_dialogue4, miller_dialogue5, miller_dialogue6, miller_dialogue6, buffer_dialogue],
	"BlackSmith": [blacksmith_dialogue1, blacksmith_dialogue2, blacksmith_dialogue3, blacksmith_dialogue3, blacksmith_dialogue4, blacksmith_dialogue3, blacksmith_dialogue3, buffer_dialogue],
	"Fisher": [fisher_dialogue1, fisher_dialogue2, fisher_dialogue2, fisher_dialogue3, fisher_dialogue2, fisher_dialogue2, fisher_dialogue4, buffer_dialogue],
	"Butler": [butler_dialogue1, butler_dialogue2, butler_dialogue2, butler_dialogue2, butler_dialogue3, butler_dialogue2, butler_dialogue2, buffer_dialogue],
	"Monk": [monk_dialogue1, monk_dialogue2, monk_dialogue3, monk_dialogue4, monk_dialogue5, monk_dialogue5, monk_dialogue5, buffer_dialogue],
	"King": [king_dialogue1, king_dialogue2, king_dialogue2, king_dialogue2, king_dialogue2, king_dialogue2, king_dialogue2, buffer_dialogue]
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
	"miller": {"health": 300},
	"black_smith": {"health": 401},
	"hunter": {"health": 300},
	"fisher": {"health": 300},
	"butler": {"health": 300},
	"monk": {"health": 20},
	"king": {"health": 200},
	"zombie": {"speed": 20, "health": 1300}
}

const weapon_price = {
	"AXE" : 20,
	"CROSSBOW" : 30,
	"BOLT" : 1,
	"TRAP" : 3
}

const recipe_price = {
	"Rabbit stew": 2,
	"Fishers soup": 4,
	"Rabbit stew with mushroom": 3,
	"Vegetable soup": 5,
	"Mushroom soup": 3,
	"Meat soup": 6,
	"Stir fry": 5,
	"Cake": 5,
	"Pumpkin pie": 4,
	"Salad": 3,
	"Fruit salad": 3
}

const weapon_data = {
	weapons.KNIFE: {'damage': 20, 'knockback': 5000.0},
	weapons.AXE: {'damage': 400, 'knockback': 10000.0},
	weapons.CROSSBOW: {'damage': 30, 'knockback': 1000.0, 'speed': 300, 'texture': preload("res://Sprites/Bolt4.png")}
}

var unlocked_weapons = [weapons.KNIFE]

var player_data: Dictionary = {
	"health": 100,
	"coin": 10,
	"bolt": 0,
	"trap": 0
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

var zombie_count: int = 0

var gates_satutus: Array = []

var tutorial: Array = []

var butlers_inv: InvItem

var found_recipes: Dictionary = {
	"res://inventory/Items/tomato sauce.tres": ["res://inventory/Items/tomato.tres", "res://inventory/Items/tomato.tres"],
	"res://inventory/Items/bread.tres": ["res://inventory/Items/flour.tres", "res://inventory/Items/water.tres"],
	"res://inventory/Items/fries.tres": ["res://inventory/Items/oil.tres", "res://inventory/Items/potato.tres"],
	"res://inventory/Items/sugar.tres": ["res://inventory/Items/carrot.tres"],
	"res://inventory/Items/mashed_potatoes.tres": ["res://inventory/Items/potato.tres", "res://inventory/Items/milk.tres"]
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
	"res://inventory/Items/spaghetti_meatball.tres": ["res://inventory/Items/pasta.tres", "res://inventory/Items/tomato.tres", "res://inventory/Items/rabbit.tres", "res://inventory/Items/cheese.tres"],
	"res://inventory/Items/sandwich.tres": ["res://inventory/Items/bread.tres", "res://inventory/Items/tomato.tres", "res://inventory/Items/lettuce.tres", "res://inventory/Items/duck.tres"],
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
		"chest_inv": get_items(chest_inv) if chests_load else chest_inv,
		"found_recipes": found_recipes,
		"scene": scene,
		"perma_death": perma_death,
		"current_day": current_day,
		"previous_day_value": previous_day_value,
		"zombie_count": zombie_count,
		"monk_counter": monk_counter,
		"king_counter": king_counter,
		"gates_satutus": gates_satutus,
		"bad_food_counter": bad_food_counter,
		"good_food_counter": good_food_counter,
		"food_given": food_given
	}

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		print("Mentés sikeres.")

var can_save := true

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
			chest_inv = result["chest_inv"]
			found_recipes = result["found_recipes"]
			scene = result["scene"]
			perma_death = result["perma_death"]
			current_day = result["current_day"]
			previous_day_value = result["previous_day_value"]
			zombie_count = result["zombie_count"]
			monk_counter = result["monk_counter"]
			king_counter = result["king_counter"]
			gates_satutus = []
			for gate in result["gates_satutus"]:
				gates_satutus.append(int(gate))
			bad_food_counter = result["bad_food_counter"]
			good_food_counter = result["good_food_counter"]
			food_given = result["food_given"]
			print("Mentés betöltve.")
			#get_tree().get_first_node_in_group("Level").pauseMenu()
			if scene == "Forest":
				TransitionLayer.change_scene("res://Scenes/forest.tscn")
			elif scene == "Castle":
				TransitionLayer.change_scene("res://Scenes/castle.tscn")
			elif scene == "Dungeon":
				TransitionLayer.change_scene("res://Scenes/dungeon.tscn")
			elif scene == "ThroneRoom":
				TransitionLayer.change_scene("res://Scenes/throne_room.tscn")
			can_save = false
			#get_tree().get_first_node_in_group("Level")._ready()
			#get_tree().get_first_node_in_group("Player")._ready()

		else:
			print("Hiba a mentési fájl feldolgozásakor.")
		file.close()
		
func next_day():
	current_day += 1
	can_next_day = false
	animal_data = {}

	save_game()
	load_game()

	can_next_day = false
	vega_data = {}
	animal_data = {}
	dialogue_progress = {}
	player_data["health"] = 100
	check_ending()
	
func check_ending():
	print(current_day)
	if king_taker:
		TransitionLayer.get_ending("res://Scenes/you_are_the_king.tscn")
	elif ritual:
		TransitionLayer.get_ending("res://Scenes/it_is_here.tscn")
	elif execution:
		TransitionLayer.get_ending("res://Scenes/you_got_executed.tscn")
	elif king_killer:
		TransitionLayer.get_ending("res://Scenes/you_killed_the_king.tscn")
	elif bad_food_counter == 2:
		TransitionLayer.get_ending("res://Scenes/you_got_fired.tscn")
	elif dragon_slayer:
		TransitionLayer.get_ending("res://Scenes/you_are_the_dragon_slayer.tscn")
	elif current_day == 7:
		TransitionLayer.get_ending("res://Scenes/you_did_good.tscn")

		
func delete_save():
	if FileAccess.file_exists(save_path):
		var error = DirAccess.remove_absolute(save_path)
		if error == OK:
			print("Save file deleted successfully.")
			remove_progress()
		else:
			print("Failed to delete save file. Error code: ", error)
	else:
		print("No save file found to delete.")
		
func remove_progress():
	current_day = 0

	previous_day_value = 0

	food_given = []

	dialogue_progress = {}

	monk_counter = 0

	king_counter = 0

	bad_food_counter = 0

	good_food_counter = 0

	can_next_day = false

	execution = false

	ritual = false

	dragon_slayer = false

	king_killer = false

	king_taker = false

	execution_text = ""
	
	unlocked_weapons = [weapons.KNIFE]

	player_data = {
		"health": 100,
		"coin": 10,
		"bolt": 0,
		"trap": 0
	}

	player_inv = []

	animal_data = {}

	vega_data = {}

	trap_data = {}

	chest_inv = {}

	scene = ""

	perma_death = []

	zombie_count = 0

	gates_satutus = []

	tutorial = []

	butlers_inv = null

	found_recipes = {
		"res://inventory/Items/tomato sauce.tres": ["res://inventory/Items/tomato.tres", "res://inventory/Items/tomato.tres"],
		"res://inventory/Items/bread.tres": ["res://inventory/Items/flour.tres", "res://inventory/Items/water.tres"],
		"res://inventory/Items/fries.tres": ["res://inventory/Items/oil.tres", "res://inventory/Items/potato.tres"],
		"res://inventory/Items/sugar.tres": ["res://inventory/Items/carrot.tres"],
		"res://inventory/Items/mashed_potatoes.tres": ["res://inventory/Items/potato.tres", "res://inventory/Items/milk.tres"]
	}




