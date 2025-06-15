extends Panel

@export var slot_sprite: Texture
@export var item: InvItem
@export var price: int

@onready var drag_sprite: Sprite2D = $CanvasLayer/DragSprite  # A Sprite2D to display the texture that follows the mouse
@onready var drag_label: Label = $CanvasLayer/DragLabel
@onready var main = get_tree().current_scene
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var inv_ui = get_parent().get_parent().get_parent()

var dragged_item: InvItem
var dragging: bool = false  # To check if an item is being dragged

func _ready():
	$SlotBG.texture = slot_sprite
	$CenterContainer/Panel/ItemDisplay.texture = item.texture
	$PriceTag.text = str(price)
	
func _process(delta):
	# If dragging, make the sprite follow the mouse
	if dragging:
		drag_sprite.global_position = get_global_mouse_position()
		drag_label.text = item.name.capitalize()
		drag_label.global_position = get_global_mouse_position() + Vector2(8, 8)

# Start dragging the item (make the texture follow the mouse)
func start_dragging(item_texture: Texture2D):
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

func _on_button_pressed():
	main.get_dragging(false)
	main.buying = false
	inv_ui.remove_item()
	if main.dragging:
		main.dragging = false
		main.buying = false
	if not main.dragging and player.coin >= price:
		main.shop_slot = get_index() - inv_ui.controls
		start_dragging(item.texture)
		main.current_item = item
		main.dragging = true
		main.buying = true
	else:
		inv_ui.flash_text()
		
func buy():
	player.pay(price)
