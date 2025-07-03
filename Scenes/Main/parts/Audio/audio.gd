extends Control

# AUDIO STREAM
@onready var AudioStreamPlayerMaster:AudioStreamPlayer = $AudioStreamPlayerMaster
@onready var AudioStreamPlayerReverb:AudioStreamPlayer = $AudioStreamPlayerReverb

var AudioNode:Control
var current_audio_stream_player:AudioStreamPlayer
var spectrum:AudioEffectSpectrumAnalyzerInstance

var track_data:Dictionary	

var max_volumne:float = -60.0

# --------------------------------------	
func _init() -> void:
	GBL.register_node(REFS.AUDIO, self)
	SUBSCRIBE.subscribe_to_music_player(self)

func _exit_tree() -> void:
	GBL.unregister_node(REFS.AUDIO)
	SUBSCRIBE.unsubscribe_to_music_player(self)
	
func _ready() -> void:
	current_audio_stream_player = AudioStreamPlayerMaster	
	AudioNode = GBL.find_node(REFS.AUDIO_BG)
	current_audio_stream_player.stop()
	
	await U.tick()	
	max_volumne = -60 if DEBUG.get_val(DEBUG.AUDIO_MUTE) else 0
# --------------------------------------	

# --------------------------------------	
func change_bus(bus:String) -> void:
	var stream_position:float = current_audio_stream_player.get_playback_position()
	var current_track = null
	if current_audio_stream_player.playing:
		current_audio_stream_player.stop()	
		current_track = current_audio_stream_player.stream
	
	match bus:
		"Master":
			current_audio_stream_player = AudioStreamPlayerMaster
		"Reverb":
			current_audio_stream_player = AudioStreamPlayerReverb
			
			
	var effect = AudioServer.get_bus_effect_instance(0, 0)
	if effect is AudioEffectSpectrumAnalyzerInstance:
		spectrum = effect
		
	if current_track != null:
		current_audio_stream_player.stream = current_track
		current_audio_stream_player.play(stream_position)
# --------------------------------------	

# --------------------------------------	
func play_track(duration:float = 1.0) -> void:
	if is_already_playing():
		await fade_out(0.3)
		
	track_data.file.loop = true
	current_audio_stream_player.stream = track_data.file
	current_audio_stream_player.play()
	current_audio_stream_player.volume_db = max_volumne - 5
	
	await U.tween_range(current_audio_stream_player.volume_db, max_volumne, duration, 
		func(val):
			current_audio_stream_player.volume_db = val
	).finished
# --------------------------------------	


# --------------------------------------	
func stop_track() -> void:
	current_audio_stream_player.stop()
# --------------------------------------	

# --------------------------------------	
func fade_out(duration:float = 3.0) -> void:
	await U.tween_range(current_audio_stream_player.volume_db, -60, duration, 
		func(val):
			current_audio_stream_player.volume_db = val
	).finished
	stop_track()
# --------------------------------------	

# --------------------------------------	
func is_already_playing() -> bool:
	return current_audio_stream_player.playing
# --------------------------------------	

# --------------------------------------		
var previously_selected:int = -1
func on_music_data_update(music_data:Dictionary) -> void:	
	if previously_selected != music_data.selected:
		previously_selected = music_data.selected
		
		track_data = MUSIC.track_list[music_data.selected]
		# set to loop	
		play_track()

# --------------------------------------		
