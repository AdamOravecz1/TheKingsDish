@tool
extends Node2D

var item = InvItem
var items := ["res://inventory/Items/tree_mushroom.tres", "res://inventory/Items/tomato.tres", "res://inventory/Items/pumpkin.tres"]
var harvested := false

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var inv: Inv = preload("res://inventory/playerinv.tres")

@export var type: int:
		set(value):
			type = value
			$Sprite2D.frame = type * 2
			
			
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "_pickup")
	$Sprite2D.frame = type * 2
	item = load(items[type]) as InvItem

	
func harvest():
	$Sprite2D.frame = type * 2 + 1
	$InteractionArea.monitoring = false
	harvested = true
	
func _pickup():
	player.collect(item)
	if player.free_inv_slot:
		harvest()
