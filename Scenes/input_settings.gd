extends Control

@onready var input_button_scene = preload("res://Scenes/input_button.tscn")
@onready var action_list = $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_remapping := false
var action_to_remap = null
var remapping_button = null


func _ready():
	_remap_from_global()
	_create_action_list()
	
func _create_action_list():
	#InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
		
	for action in BigGlobal.input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.get_node("MarginContainer/HBoxContainer/LabelAction")
		var input_label = button.get_node("MarginContainer/HBoxContainer/LabelInput")
		
		action_label.text = BigGlobal.input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.get_node("MarginContainer/HBoxContainer/LabelInput").text = "Press key to bind..."
		
func _input(event):
	if is_remapping:
		if (event is InputEventKey or (event is InputEventMouseButton and event.pressed)):
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			BigGlobal.saved_inputs[action_to_remap] = event
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()
			
func _update_action_list(button, event):
	button.get_node("MarginContainer/HBoxContainer/LabelInput").text = event.as_text().trim_suffix(" (Physical)")
	

func _on_reset_button_pressed():
	BigGlobal.saved_inputs = {}
	InputMap.load_from_project_settings()
	_create_action_list()
	
func _remap_from_global():
	for action in BigGlobal.saved_inputs.keys():
		var event = BigGlobal.saved_inputs[action]
		if event:
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)


