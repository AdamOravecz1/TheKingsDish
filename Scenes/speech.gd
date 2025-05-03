extends Control

@export var sprite_sheet: Texture2D
@export var hframes: int = 3
@export var vframes: int = 2
@export_range(0, 255) var frame_index: int = 0

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

func _on_option_1_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_parent().get_parent().select_option(0)


func _on_option_2_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_parent().get_parent().select_option(1)
