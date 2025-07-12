extends AudioStreamPlayer

var level_music = preload("res://Music/Forest_v3.wav")

func _play_music(music = AudioStream):
	bus = "Music" 
	if stream == music:
		return
	stream = music
	play()
	
func play_level_music():
	process_mode = Node.PROCESS_MODE_ALWAYS
	_play_music(level_music)

func stop_music():
	stop()
	stream = null
	
