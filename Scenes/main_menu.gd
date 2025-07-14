extends Control

@onready var parallax = $ParallaxBackground
@export var scroll_speed: float = 30.0

@onready var music = $CanvasLayer/MarginContainer/SoundControls/Music
@onready var sfx = $CanvasLayer/MarginContainer/SoundControls/SFX

func _ready():
	endings_list()
	Music.play_level_music()
	if FileAccess.file_exists(Global.save_path):
		$CanvasLayer/MarginContainer/VBoxContainer/Resume.show()
	music.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sfx.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

func _process(delta):
	if parallax:
		parallax.scroll_offset.x += scroll_speed * delta

func _on_start_pressed():
	TransitionLayer.change_scene("res://Scenes/castle.tscn")
	
func _on_settings_pressed():
	$CanvasLayer/MarginContainer/VBoxContainer.hide()
	$CanvasLayer/MarginContainer/Settings.show()

func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	$CanvasLayer/MarginContainer/VBoxContainer.show()
	$CanvasLayer/MarginContainer/Settings.hide()

func _on_sound_pressed():
	$CanvasLayer/MarginContainer/Settings.hide()
	$CanvasLayer/MarginContainer/SoundControls.show()

func _on_controls_pressed():
	$CanvasLayer/MarginContainer/InputSettings.show()
	$CanvasLayer/MarginContainer/Settings.hide()
	$CanvasLayer/Title.hide()

func _on_full_screen_pressed():
	if Global.full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Global.full_screen = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Global.full_screen = true

func _on_back_setting_pressed():
	$CanvasLayer/MarginContainer/SoundControls.hide()
	$CanvasLayer/MarginContainer/Settings.show()


func _on_music_value_changed(value):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)


func _on_sfx_value_changed(value):
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)


func _on_back_controls_pressed():
	$CanvasLayer/MarginContainer/InputSettings.hide()
	$CanvasLayer/MarginContainer/Settings.show()
	$CanvasLayer/Title.show()
	InteractionManager.change_text()
	BigGlobal.save_game()


func _on_recipes_pressed():
	$CanvasLayer/MarginContainer.hide()
	$CanvasLayer/Recipes.show()
	$CanvasLayer/Title.hide()

func _on_back_recipes_pressed():
	$CanvasLayer/MarginContainer.show()
	$CanvasLayer/Recipes.hide()
	$CanvasLayer/Title.show()

func _on_resume_pressed():
	Global.load_game()


func _on_recipe_reset_pressed():
	BigGlobal.made_recipes = {}
	BigGlobal.save_game()
	$CanvasLayer/Recipes.setup()

func _on_endings_pressed():
	$CanvasLayer/MarginContainer.hide()
	$CanvasLayer/Title.hide()
	$CanvasLayer/Endings.show()

func endings_list():
	$CanvasLayer/Endings/EndingCount.text = str(len(BigGlobal.found_endings)) + "/7"
	for ending_text in BigGlobal.found_endings:
		var label = Label.new()
		
		label.text = ending_text
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_override("font", load("res://Fonts/OldLondon.ttf"))
		label.add_theme_font_size_override("font_size", 50)
		label.add_theme_color_override("font_color", Color.RED)

		$CanvasLayer/Endings/Endings.add_child(label)


func _on_back_endings_pressed():
	$CanvasLayer/Endings.hide()
	$CanvasLayer/Title.show()
	$CanvasLayer/MarginContainer.show()


func _on_endings_reset_pressed():
	BigGlobal.found_endings = []
	$CanvasLayer/Endings/EndingCount.text = "0/7"
	BigGlobal.save_game()
	for endings in $CanvasLayer/Endings/Endings.get_children():
		endings.queue_free()
		

