extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@export_enum("forest", "castle", "dungeon", "throne_room") var level := "forest"
@export var index: int
var levels = {}

func _ready():
	if not Engine.is_editor_hint():
		levels["forest"] = "res://Scenes/forest.tscn"
		levels["castle"] = "res://Scenes/castle.tscn"
		levels["dungeon"] = "res://Scenes/dungeon.tscn"
		levels["throne_room"] = "res://Scenes/throne_room.tscn"

	interaction_area.interact = Callable(self, "_enterr")
	
	
func _enterr():
	TransitionLayer.change_scene(levels[level])
	Global.gate_index = index
	Global.can_gate = true


