extends Node2D

@onready var main = get_tree().get_first_node_in_group("Level")
@onready var interaction_area: InteractionArea = $InteractionArea
@export_enum("forest", "castle", "dungeon", "throne_room") var level := "forest"
@export var gate_id: int
@export var locked: bool = false
var levels = {}
var can_open = true

func _ready():
	$LockedLabel.material.set_shader_parameter("alpha", 0.0)
	if not Engine.is_editor_hint():
		levels["forest"] = "res://Scenes/forest.tscn"
		levels["castle"] = "res://Scenes/castle.tscn"
		levels["dungeon"] = "res://Scenes/dungeon.tscn"
		levels["throne_room"] = "res://Scenes/throne_room.tscn"

	interaction_area.interact = Callable(self, "_enterr")
	
func _enterr():
	if locked:
		flash_text()
	elif can_open:
		can_open = false
		main.show_tutorial("hit", "hit")
		$Door.play()
		TransitionLayer.change_scene(levels[level])
		if gate_id not in Global.gates_satutus:
			Global.gates_satutus.append(gate_id)
		Global.gate_index = gate_id
		Global.can_gate = true

func flash_text():
	var tween = create_tween()
	tween.tween_property($LockedLabel, "material:shader_parameter/alpha", 1.0, 0.0)
	tween.tween_property($LockedLabel, "material:shader_parameter/alpha", 0.0, 1.0)
