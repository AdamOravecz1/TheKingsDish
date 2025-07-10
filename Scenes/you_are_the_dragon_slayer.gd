extends Node2D


func _ready():
	Music.stop()
	for npc in $Main/Characters/MightBeDead.get_children():
		if npc.name in Global.perma_death:
			npc.visible = false
	$Main/Characters/BloodSpatter.frame = len(Global.perma_death)
	$CanvasLayer/ColorRect.modulate = Color(0, 0)
	$CanvasLayer/Label.modulate = Color(0.65, 0, 0, 0)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	await get_tree().create_timer(2.0).timeout
	$Sound/Jingle.play()

	await get_tree().create_timer(5.0).timeout
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "modulate", Color(0, 1), 1)
	tween.tween_property($CanvasLayer/Label, "modulate", Color(0.65, 0, 0, 1), 1)
	tween.tween_property($CanvasLayer/Label, "modulate", Color(0.65, 0, 0, 0), 1)
	tween.tween_callback(Callable(self, "end"))

