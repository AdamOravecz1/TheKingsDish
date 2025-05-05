extends Control

@export var sprite_sheet: Texture2D
@export var hframes: int = 3
@export var vframes: int = 2
@export_range(0, 255) var frame_index: int = 0

@onready var hunter := get_parent().get_parent()

var current_node = "start"
@onready var npc_label = $Dialogue
@onready var option_buttons = [$Option1, $Option2] 

var hovering_option1 := false
var hovering_option2 := false

func _ready():
	$Head.texture = get_frame_texture()

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
	return atlas
	
func show_node(node_name: String):
	current_node = node_name
	var node = Global.hunter_dialogue.get(node_name, null)
	if node == null:
		end_dialogue()
		return

	npc_label.text = node.get("text", "")

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
	var options = Global.hunter_dialogue[current_node].get("options", [])
	if index >= options.size():
		return

	var selected = options[index]

	if selected.has("action"):
		call_action(selected["action"])

	if selected.has("next"):
		show_node(selected["next"])
	elif selected.get("end", false):
		end_dialogue()

func call_action(action_name: String):
	if hunter.has_method(action_name):
		hunter.call(action_name)
	else:
		print("Unknown action:", action_name)

func end_dialogue():
	npc_label.text = "Dialogue ended."
	hide_options()

func hide_options():
	for button in option_buttons:
		button.hide()
	
func wrap_text(text: String, max_line_length: int) -> String:
	var words = text.split(" ")
	var lines := []
	var current_line := ""

	for word in words:
		if current_line.length() + word.length() + 1 <= max_line_length:
			if current_line != "":
				current_line += " "
			current_line += word
		else:
			lines.append(current_line)
			current_line = word

	if current_line != "":
		lines.append(current_line)

	return "\n".join(lines)

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


