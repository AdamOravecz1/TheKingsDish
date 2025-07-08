extends Node2D

func _ready():
	Music.stop()
	await get_tree().create_timer(1.0).timeout
	$Sound/Jingle.play()
	$Main/Characters/King/Label.text = Global.execution_text
	$CanvasLayer/ColorRect.modulate = Color(0, 0)
	$CanvasLayer/Label.modulate = Color(0.65, 0, 0, 0)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	await get_tree().create_timer(6.0).timeout
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "modulate", Color(0, 1), 1)
	tween.tween_property($CanvasLayer/Label, "modulate", Color(0.65, 0, 0, 1), 1)
