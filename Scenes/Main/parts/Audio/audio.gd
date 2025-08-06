extends Control

# AUDIO STREAM
@onready var AudioStreamPlayerMaster:AudioStreamPlayer = $AudioStreamPlayerMaster
@onready var AudioStreamPlayerReverb:AudioStreamPlayer = $AudioStreamPlayerReverb

var audio_stream_dict:Dictionary = {}

var AudioNode:Control
var current_audio_stream_player:AudioStreamPlayer
var spectrum:AudioEffectSpectrumAnalyzerInstance

var track_data:Dictionary	

var max_db:float = 0.0
var fade_out_db:float = -60

# --------------------------------------	
func _init() -> void:
	GBL.register_node(REFS.AUDIO, self)
	SUBSCRIBE.subscribe_to_music_player(self)

func _exit_tree() -> void:
	GBL.unregister_node(REFS.AUDIO)
	SUBSCRIBE.unsubscribe_to_music_player(self)
	
func _ready() -> void:
	AudioNode = GBL.find_node(REFS.AUDIO_BG)
	current_audio_stream_player = AudioStreamPlayerMaster
	
	await U.tick()
	audio_stream_dict = {
		AudioStreamPlayerMaster: {
			"max_db": fade_out_db if DEBUG.get_val(DEBUG.AUDIO_MUTE) else AudioStreamPlayerMaster.volume_db 
		},
		AudioStreamPlayerReverb: {
			"max_db": fade_out_db if DEBUG.get_val(DEBUG.AUDIO_MUTE) else AudioStreamPlayerReverb.volume_db
		}
	}	
	
# --------------------------------------	

# --------------------------------------	
func change_bus(bus:OS_AUDIO.CHANNEL) -> void:
	if track_data.is_empty():return
	
	var stream_position:float = current_audio_stream_player.get_playback_position()
	# fade out old one
	var old_audio_player:AudioStreamPlayer = current_audio_stream_player
	U.tween_range(old_audio_player.volume_db, fade_out_db, 0.3, 
		func(val):
			old_audio_player.volume_db = val
	).finished	
	
	match bus:
		OS_AUDIO.CHANNEL.MAIN:
			AudioStreamPlayerMaster.stream = track_data.file
			AudioStreamPlayerMaster.play(stream_position)
			current_audio_stream_player = AudioStreamPlayerMaster
		OS_AUDIO.CHANNEL.REVERB:
			AudioStreamPlayerReverb.stream = track_data.file
			AudioStreamPlayerReverb.play(stream_position)
			current_audio_stream_player = AudioStreamPlayerReverb
	
	current_audio_stream_player.volume_db = audio_stream_dict[current_audio_stream_player].max_db

# --------------------------------------	

# --------------------------------------	
func play_track(fade_out_duration:float, fade_in_duration:float, channel:OS_AUDIO.CHANNEL) -> void:
	track_data.file.loop = true
	
	match channel:
		OS_AUDIO.CHANNEL.MAIN:
			AudioStreamPlayerMaster.stream = track_data.file
			AudioStreamPlayerMaster.play()
			current_audio_stream_player = AudioStreamPlayerMaster
		
		OS_AUDIO.CHANNEL.REVERB:
			AudioStreamPlayerReverb.stream = track_data.file
			AudioStreamPlayerReverb.play()
			current_audio_stream_player = AudioStreamPlayerReverb
	
	current_audio_stream_player.volume_db = audio_stream_dict[current_audio_stream_player].max_db
# --------------------------------------	

# --------------------------------------	
func stop() -> void:
	if current_audio_stream_player.playing:
		current_audio_stream_player.stop()
# --------------------------------------		

# --------------------------------------	
func fade_in(duration:float = 0.3) -> void:
	U.tween_range(current_audio_stream_player.volume_db, audio_stream_dict[current_audio_stream_player].max_db, duration, 
		func(val):
			current_audio_stream_player.volume_db = val
	).finished
	
func fade_out(duration:float = 3.0, and_stop:bool = true) -> void:
	U.tween_range(current_audio_stream_player.volume_db, fade_out_db, duration, 
		func(val):
			current_audio_stream_player.volume_db = val
	).finished
	
	if and_stop:
		stop()
# --------------------------------------	

# --------------------------------------	
func get_current_audio_stream_player() -> AudioStreamPlayer:
	return current_audio_stream_player
# --------------------------------------	

## --------------------------------------	
#func is_already_playing(channel) -> bool:
	#return current_audio_stream_player.playing
## --------------------------------------	

# --------------------------------------		
var previous_track:int = -1
func on_music_data_update(music_data:Dictionary) -> void:	
	if music_data.is_empty():
		stop()
		return
	
	if previous_track != music_data.track:
		previous_track = music_data.track
		
		# setup next track
		track_data = OS_AUDIO.track_data[0].list[music_data.track]
		
		# set defaults
		var channel:int = music_data.channel if music_data.has("channel") else OS_AUDIO.CHANNELS.MAIN
		var fade_in_duration:float = music_data.fade_in_duration if music_data.has("fade_in_duration") else 0
		var fade_out_duration:float = music_data.fade_out_duration if music_data.has("fade_out_duration") else 0.3
		var loop:bool = music_data.loop if music_data.has("loop") else true
		
		# play
		play_track(fade_in_duration, fade_out_duration, channel)

# --------------------------------------		
