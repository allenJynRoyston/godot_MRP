extends MouseInteractions

@onready var TrackNameScrollContainer:ScrollContainer = $MarginContainer/HBoxContainer/TrackNameScrollContainer
@onready var TrackNameLabel:Label = $MarginContainer/HBoxContainer/TrackNameScrollContainer/PanelContainer/MarginContainer/TrackName

@onready var PlayPauseBtn:MarginContainer = $MarginContainer/HBoxContainer/HBoxContainer/PlayPauseBtn
@onready var NextBtn:MarginContainer = $MarginContainer/HBoxContainer/HBoxContainer/NextBtn

const VU_COUNT:int = 30
const FREQ_MAX:float = 11050.0
const MIN_DB:int = 60
const SMOOTHING_FACTOR:float = 0.3
const HEIGHT_SCALE:float = 9.0
const ANIMATION_SPEED:float = 0.1

var min_values:Array = []
var max_values:Array = []

var frames_to_skip: int = 5
var frame_counter: int = 0

#var current_audio_stream_player:AudioStreamPlayer
var spectrum:AudioEffectSpectrumAnalyzerInstance

var hover_nodes:Array = []
var track_data:Array = OS_AUDIO.track_data
var selected_track:int = 0
var scroll_name:bool = false
		
# --------------------------------------	
func _init() -> void:
	GBL.register_node(REFS.MEDIA_PLAYER, self)
	SUBSCRIBE.subscribe_to_music_player(self)

func _exit_tree() -> void:
	GBL.unregister_node(REFS.MEDIA_PLAYER)
	SUBSCRIBE.unsubscribe_to_music_player(self)

	
func _ready() -> void:
	super._ready()

	min_values.resize(VU_COUNT)
	min_values.fill(0.0)
	max_values.resize(VU_COUNT)
	max_values.fill(0.0)
	
	await U.tick()
	on_pause_or_play_update()
	update_track_data()
# --------------------------------------	

# --------------------------------------	
func on_pause() -> void:
	if track_data.is_empty():return	
	GBL.find_node(REFS.AUDIO).current_audio_stream_player.playing = !GBL.find_node(REFS.AUDIO).current_audio_stream_player.playing
	on_pause_or_play_update()	
# --------------------------------------	

# --------------------------------------	
func on_next() -> void:
	if track_data.is_empty():return
	selected_track = (selected_track + 1) % track_data[0].size()
	
	# play music	
	OS_AUDIO.play(OS_AUDIO.TRACK.OS_TRACK_ONE, OS_AUDIO.CHANNEL.MAIN)
# --------------------------------------	

## --------------------------------------	
#func on_stop() -> void:
	#GBL.find_node(REFS.AUDIO).current_audio_stream_player.stop()
## --------------------------------------	

# --------------------------------------	
func is_already_playing() -> bool:
	return GBL.find_node(REFS.AUDIO).get_current_audio_stream_player().playing
# --------------------------------------	

# --------------------------------------	
func on_pause_or_play_update() -> void:
	if !is_node_ready():return
	PlayPauseBtn.icon = SVGS.TYPE.MEDIA_PLAY if !GBL.find_node(REFS.AUDIO).get_current_audio_stream_player().playing else SVGS.TYPE.MEDIA_PAUSE
# --------------------------------------	

# --------------------------------------	
func on_music_data_update(new_val:Dictionary) -> void:
	selected_track = -1 if new_val.is_empty() else OS_AUDIO.get_track_index( new_val.track )
	update_track_data()	
# --------------------------------------	

# --------------------------------------	
func update_track_data() -> void:
	if selected_track == -1:
		printerr("ERROR: selected track not found")
		return
	var track_data:Dictionary = track_data[0].list[selected_track]
	var details:Dictionary = track_data.details if "details" in track_data else {"name": "No details...", "author": "unknown"}
	TrackNameLabel.text = "%s by %s" % [details.name, details.author]
	
	on_pause_or_play_update()
	check_track_scroll.call_deferred()
	
func check_track_scroll() -> void:
	if TrackNameLabel.size.x >= TrackNameScrollContainer.size.x:		
		TrackNameScrollContainer.scroll_horizontal = 0
		var padding:String = " "	
		var padded_text:String = padding.repeat(50) + TrackNameLabel.text + padding.repeat(TrackNameScrollContainer.custom_minimum_size.x)
		TrackNameLabel.text = padded_text		
		scroll_name = true
		return
	
	scroll_name = false	
# --------------------------------------	

# --------------------------------------		
func on_process_update(delta: float, _time_passed:float) -> void:
	super.on_process_update(delta, _time_passed)
	
	var current_audio_stream_player:AudioStreamPlayer = GBL.find_node(REFS.AUDIO).get_current_audio_stream_player()
	spectrum = AudioServer.get_bus_effect_instance(0, 0)

	if spectrum != null and current_audio_stream_player.playing:
		var prev_hz = 0.0
		var data:Array = []
	
		data.resize(VU_COUNT)
		data.fill(0.0)	
	
		for i in range(VU_COUNT):
			var hz = ((i + 1) * FREQ_MAX) / VU_COUNT
			var f = spectrum.get_magnitude_for_frequency_range(prev_hz, hz)
			var energy = clamp((MIN_DB + linear_to_db(f.length())) / MIN_DB, 0.0, 1.0)
			data[i] = (energy * HEIGHT_SCALE)
			prev_hz = hz
		for i in range(VU_COUNT):
			if data[i] > max_values[i]:
				max_values[i] = data[i]
			else:
				max_values[i] = lerp(max_values[i], data[i], ANIMATION_SPEED)
			if data[i] <= 0.0:
				min_values[i] = lerp(min_values[i], data[i], ANIMATION_SPEED)
		var fft = []
		for i in range(VU_COUNT):
			fft.append(lerp(min_values[i], max_values[i], ANIMATION_SPEED))
		
		SUBSCRIBE.audio_data = {
			"data": fft, 
			"pos": current_audio_stream_player.get_playback_position()
		}
		#GBL.find_node(REFS.AUDIO_BG).update_music_shader(fft, current_audio_stream_player.get_playback_position())

	#if scroll_name:
	frame_counter += 1
	
	if frame_counter >= frames_to_skip:
		frame_counter = 0		
		TrackNameScrollContainer.scroll_horizontal += 5
		if TrackNameScrollContainer.scroll_horizontal >= ((TrackNameScrollContainer.custom_minimum_size.x + TrackNameLabel.text.length())):
			TrackNameScrollContainer.scroll_horizontal = 0
# --------------------------------------		
