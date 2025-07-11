extends Control

@onready var label = $MarginContainer/TutorialFrame/Label

func show_tutorial(action, action_name):
	if action not in Global.tutorial:
		$MarginContainer.position.x = 0
		label.text = "[" + str(InputMap.action_get_events(action)[0].as_text().trim_suffix(" (Physical)")) + "]\nto " + action_name
		var tween = create_tween()
		tween.tween_property($MarginContainer, "position", Vector2(-464, 0), 1)
		await get_tree().create_timer(3.0).timeout
		tween = create_tween()
		tween.tween_property($MarginContainer, "position", Vector2(0, 0), 1)
		Global.tutorial.append(action)
	

