@tool
extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@export_enum("forest", "castle", "dungeon") var level := "forest"
var levels = {}
func _ready():
	if not Engine.is_editor_hint():
		levels["forest"] = "res://Scenes/forest.tscn"
		levels["castle"] = "res://Scenes/castle.tscn"
		levels["dungeon"] = "res://Scenes/dungeon.tscn"

	interaction_area.interact = Callable(self, "_enter")
	
	
func _enter():
	
	TransitionLayer.change_scene(levels[level])
