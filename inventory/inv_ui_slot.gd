extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var drag_sprite: Sprite2D = $CanvasLayer/DragSprite  # A Sprite2D to display the texture that follows the mouse
@onready var drag_label: Label = $CanvasLayer/Label
@onready var inv_ui = get_parent().get_parent().get_parent()
@onready var main = get_tree().current_scene

var slot_out: InvSlot
var dragged_item: InvItem
var dragging: bool = false  # To check if an item is being dragged
var drag_across: bool = false


func _ready():
	# Hide the drag sprite initially
	drag_sprite.visible = false
	drag_label.visible = false


func update(slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture


	slot_out = slot

func _process(delta):
	# If dragging, make the sprite follow the mouse
	if dragging:
		drag_sprite.global_position = get_global_mouse_position()
		drag_label.text = dragged_item.name.capitalize()
		drag_label.global_position = get_global_mouse_position() + Vector2(8, 8)

func _on_button_pressed():
	if slot_out.item:
		if get_index() == main.current_slot and main.inv_type == inv_ui:
			drag_across = true
		inv_ui.send_inv()
		main.get_dragging(true)
		start_dragging(slot_out.item.texture)
		dragged_item = slot_out.item
		if drag_across:
			stop_dragging()
			inv_ui.remove_item()
		else:
			send_item()
	else:
		if main.dragging:
			if main.inv_type == inv_ui:
				change_item()
			else:
				inv_ui.inv.insert_to_place(main.current_item, get_index())
				main.inv_type.inv.remove_from_place(main.current_slot)
				inv_ui.remove_item()
		main.get_dragging(false)
		inv_ui.send_inv()
	drag_across = false

# Start dragging the item (make the texture follow the mouse)
func start_dragging(item_texture: Texture2D):
	item_visual.visible = false
	dragging = true
	drag_sprite.texture = item_texture
	drag_sprite.visible = true  # Show the sprite when dragging starts
	drag_label.visible = true

func _input(event):
	# Stop dragging when the mouse button is released
	if dragging and event is InputEventMouseButton and not event.pressed:
		stop_dragging()

		

# Stop dragging the item
func stop_dragging():
	dragging = false
	drag_sprite.visible = false  # Hide the sprite when dragging stops
	drag_label.visible = false
	item_visual.visible = true


	
func send_item():
	inv_ui.get_item(dragged_item, get_index())

	
func change_item():
	inv_ui.change_item(get_index())
	inv_ui.remove_item()


