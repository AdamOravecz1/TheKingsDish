extends Node

const basic_recipes: Dictionary = {
	"res://inventory/Items/tomato sauce.tres": ["res://inventory/Items/tomato.tres", "res://inventory/Items/tomato.tres"],
	"res://inventory/Items/bread.tres": ["res://inventory/Items/flour.tres", "res://inventory/Items/water.tres"],
	"res://inventory/Items/fries.tres": ["res://inventory/Items/oil.tres", "res://inventory/Items/potato.tres"],
	"res://inventory/Items/sugar.tres": ["res://inventory/Items/carrot.tres"],
	"res://inventory/Items/mashed_potatoes.tres": ["res://inventory/Items/potato.tres", "res://inventory/Items/milk.tres"]
}

var made_recipes: Dictionary = {}

var found_endings: Array = []

func _ready():
	load_game()

var input_actions = {
	"jump": "Jump",
	"left": "Walk Left",
	"right": "Walk Right",
	"switch": "Switch Weapon",
	"hit": "Hit/Shoot",
	"relode": "Relode",
	"interact": "Interact",
	"inventory": "Inventory",
	"pause": "Pause Game",
	"duck": "Crouch",
	"trap": "Place Trap",
	"recipes": "Open/Close Recipes"
}

var saved_inputs = {}

var save_path := "user://save_big_data.json"

func save_game():
	var serializable_inputs = {}
	for action in saved_inputs.keys():
		var event = saved_inputs[action]
		
		# Manually handle InputEventKey (expand for other types!)
		if event is InputEventKey:
			var event_dict = {
				"class": "InputEventKey",
				"keycode": event.keycode,
				"physical_keycode": event.physical_keycode,
				"pressed": event.pressed,
				"echo": event.echo
			}
			serializable_inputs[action] = event_dict
		
		# Add other InputEvent types here if you need
		
	var save_data: Dictionary = {
		"saved_inputs": serializable_inputs,
		"made_recipes": made_recipes,
		"found_endings": found_endings
	}

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		print("Saved successfully.")


func load_game():
	if not FileAccess.file_exists(save_path):
		print("Nincs mentési fájl.")
		return

	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var result = JSON.parse_string(content)
		if result:
			if "made_recipes" in result:
				made_recipes = result["made_recipes"]
			if "found_endings" in result:
				found_endings = result["found_endings"]
			saved_inputs.clear()
			for action in result["saved_inputs"].keys():
				var event_dict = result["saved_inputs"][action]
				var event = build_input_event(event_dict)
				saved_inputs[action] = event
			print("Mentés betöltve.")
		else:
			print("Hiba a mentési fájl feldolgozásakor.")
		file.close()

func build_input_event(dict: Dictionary) -> InputEvent:
	var event: InputEvent = null

	if dict.has("class"):
		match dict["class"]:
			"InputEventKey":
				event = InputEventKey.new()
				event.keycode = dict.get("keycode", 0)
				event.physical_keycode = dict.get("physical_keycode", 0)
				event.pressed = dict.get("pressed", true)
				event.echo = dict.get("echo", false)
			_:
				print("Unknown class: ", dict["class"])
	else:
		print("Invalid input event dictionary")

	return event


