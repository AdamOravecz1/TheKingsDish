extends Control

@export var sprite_sheet: Texture2D
@export var hframes: int = 2
@export var vframes: int = 3
@export var flip: bool = 0
@export_range(0, 255) var frame_index: int = 0

@onready var npc := get_parent().get_parent()

var current_node = "start"
@onready var npc_label = $DialogueRich
@onready var option_buttons = [$Option1, $Option2] 

var hovering_option1 := false
var hovering_option2 := false

func _ready():
	$Head.texture = get_frame_texture()
	$Head.flip_h = flip
	prepare_dialogue()

func prepare_dialogue():
	if npc.name not in Global.food_given:
		if "good_bye" in npc.dialogue and npc.name in Global.give_dialogues:
			# Add the "give" node if missing
			if "give" not in npc.dialogue:
				print(npc.dialogue)
				npc.dialogue["give"] = Global.give_dialogues[npc.name]

			# Avoid duplicate "give" options
			var options = npc.dialogue["good_bye"].get("options", [])
			var has_give := false
			for opt in options:
				if opt.get("next") == "give":
					has_give = true
					break

			if not has_give:
				options.append({
					"text": ">Give " + Global.npc_food[npc.name] + ".",
					"next": "give"
				})
				npc.dialogue["good_bye"]["options"] = options


func get_frame_texture() -> Texture2D:
	if not sprite_sheet:
		return null

	var frame_width = sprite_sheet.get_width() / hframes
	var frame_height = sprite_sheet.get_height() / vframes
	var x = frame_index % hframes
	var y = frame_index / hframes

	var region = Rect2(
		Vector2(x * frame_width, y * frame_height),
		Vector2(frame_width, frame_height)
	)

	var atlas := AtlasTexture.new()
	atlas.atlas = sprite_sheet
	atlas.region = region
	atlas.filter_clip = true  # Optional: ensures clean borders

	return atlas

	
func show_node(node_name: String):
	current_node = node_name
	var node = npc.dialogue.get(node_name, null)
	if node == null:
		end_dialogue()
		return

	npc_label.clear()
	npc_label.append_text(node.get("text", ""))

	# Optional function call
	if node.has("action"):
		call_action(node["action"])

	# End dialogue if marked
	if node.get("end", false):
		hide_options()
		return

	# Show options
	var options = node.get("options", [])
	for i in range(option_buttons.size()):
		if i < options.size():
			option_buttons[i].text = options[i]["text"]
			option_buttons[i].show()
		else:
			option_buttons[i].hide()

func select_option(index: int):
	var options = npc.dialogue[current_node].get("options", [])
	if index >= options.size():
		return

	var selected = options[index]

	if selected.has("action"):
		call_action(selected["action"])

	if selected.has("next"):
		show_node(selected["next"])
		if not Global.dialogue_progress.has(npc.name):
			Global.dialogue_progress[npc.name] = ""
		if Global.dialogue_progress[npc.name] != "good_bye":
			Global.dialogue_progress[npc.name] = selected["next"]
		if Global.dialogue_progress[npc.name] == "shop":
			Global.dialogue_progress[npc.name] = "good_bye"

	elif selected.get("end", false):
		end_dialogue()

func call_action(action_name: String):
	if npc.has_method(action_name):
		npc.call(action_name)
	else:
		print("Unknown action:", action_name)

func end_dialogue():
	npc_label.text = "Dialogue ended."
	hide_options()

func hide_options():
	for button in option_buttons:
		button.hide()
	
#func wrap_text(text: String, max_line_length: int) -> String:
	#var words = text.split(" ")
	#var lines := []
	#var current_line := ""
#
	#for word in words:
		#if current_line.length() + word.length() + 1 <= max_line_length:
			#if current_line != "":
				#current_line += " "
			#current_line += word
		#else:
			#lines.append(current_line)
			#current_line = word
#
	#if current_line != "":
		#lines.append(current_line)
#
	#return "\n".join(lines)

func _on_option_1_mouse_entered():
	hovering_option1 = true
	$Option1.add_theme_color_override("font_color", Color.RED)

func _on_option_1_mouse_exited():
	hovering_option1 = false
	$Option1.add_theme_color_override("font_color", Color.BLACK)

func _on_option_1_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and hovering_option1:
		select_option(0)

func _on_option_2_mouse_entered():
	hovering_option2 = true
	$Option2.add_theme_color_override("font_color", Color.RED)

func _on_option_2_mouse_exited():
	hovering_option2 = false
	$Option2.add_theme_color_override("font_color", Color.BLACK)

func _on_option_2_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and hovering_option2:
		select_option(1)
		


