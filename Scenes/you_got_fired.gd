extends Node2D

@onready var player = $Main/Characters/Player
@onready var left = $Sound/Left
@onready var right = $Sound/Right
var walk := false

var play_left_next := true
var is_playing := false

func _process(delta):
	if walk:
		play_alternating_sound()
		$Main/Characters/Player/AnimatedSprite2D.play("walk")
		player.velocity.x = 50
		player.move_and_slide()

func _ready():
	Music.stop()
	$Main/Characters/BloodSpatter.frame = len(Global.perma_death)
	$CanvasLayer/ColorRect.modulate = Color(0, 0)
	$CanvasLayer/Label.modulate = Color(0.65, 0, 0, 0)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	await get_tree().create_timer(5.0).timeout
	$Sound/Jingle.play()
	$Main/Characters/Player/AnimatedSprite2D.flip_h = false
	walk = true
	await get_tree().create_timer(3.0).timeout
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "modulate", Color(0, 1), 1)
	tween.tween_property($CanvasLayer/Label, "modulate", Color(0.65, 0, 0, 1), 1)
	tween.tween_property($CanvasLayer/Label, "modulate", Color(0.65, 0, 0, 0), 1)
	tween.tween_callback(Callable(self, "end"))
	walk = false
	
func play_alternating_sound():
	if is_playing:
		return  # Don't play if something is already playing

	is_playing = true
	var sound = left if play_left_next else right
	play_left_next = !play_left_next

	# Random pitch
	sound.pitch_scale = randf_range(0.9, 1.1)

	# Connect to finished signal
	sound.finished.connect(_on_sound_finished, CONNECT_ONE_SHOT)
	sound.play()


func _on_sound_finished():
	is_playing = false
