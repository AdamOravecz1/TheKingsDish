extends ending

var move_cam := false

func _process(delta):
	if move_cam:
		$Camera2D.position.y -= delta*10
		

func _ready():
	Music.stop()
	$Main/Characters/BloodSpatter.frame = len(Global.perma_death)
	$CanvasLayer/ColorRect.modulate = Color(0, 0)
	$CanvasLayer/Label.modulate = Color(0.65, 0, 0, 0)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	await get_tree().create_timer(2.0).timeout
	$Sound/Jingle.play()
	move_cam = true
	await get_tree().create_timer(7.0).timeout
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "modulate", Color(0, 1), 1)
	tween.tween_property($CanvasLayer/Label, "modulate", Color(0.65, 0, 0, 1), 1)
	tween.tween_property($CanvasLayer/Label, "modulate", Color(0.65, 0, 0, 0), 1)
	tween.tween_callback(Callable(self, "end"))
