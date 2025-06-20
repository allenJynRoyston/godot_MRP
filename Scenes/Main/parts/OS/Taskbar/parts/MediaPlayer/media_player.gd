extends MouseInteractions

@onready var AudioStreamPlayerMaster:AudioStreamPlayer = $AudioStreamPlayerMaster
@onready var AudioStreamPlayerReverb:AudioStreamPlayer = $AudioStreamPlayerReverb

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

var AudioNode:Control
var current_audio_stream_player:AudioStreamPlayer
var spectrum:AudioEffectSpectrumAnalyzerInstance

var hover_nodes:Array = []
var track_list:Array = []
var selected_track:int = 0
var scroll_name:bool = false
var data:Dictionary = {} : 
	set(val): 
		data = val
		on_data_update()
		
# --------------------------------------	
func _init() -> void:
	GBL.register_node(REFS.MEDIA_PLAYER, self)

func _exit_tree() -> void:
	GBL.unregister_node(REFS.MEDIA_PLAYER)
	
func _ready() -> void:
	super._ready()
	current_audio_stream_player = AudioStreamPlayerMaster	
	AudioNode = GBL.find_node(REFS.AUDIO_BG)
	
	min_values.resize(VU_COUNT)
	min_values.fill(0.0)
	max_values.resize(VU_COUNT)
	max_values.fill(0.0)
	
	on_focus(false)	
	on_pause_or_play_update()
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
func on_pause() -> void:
	current_audio_stream_player.playing = !current_audio_stream_player.playing
	on_pause_or_play_update()	
# --------------------------------------	

# --------------------------------------	
func on_next() -> void:
	selected_track = (selected_track + 1) % track_list.size()
	play_selected_track()	
# --------------------------------------	

# --------------------------------------	
func on_stop() -> void:
	current_audio_stream_player.stop()
# --------------------------------------	

# --------------------------------------	
func is_already_playing() -> bool:
	return current_audio_stream_player.playing
# --------------------------------------	

# --------------------------------------	
func skip_to_track(track_data:Dictionary) -> void:
	selected_track = 1
	play_selected_track()
# --------------------------------------		

# --------------------------------------	
func on_pause_or_play_update() -> void:
	PlayPauseBtn.icon = SVGS.TYPE.MEDIA_PLAY if !current_audio_stream_player.playing else SVGS.TYPE.MEDIA_PAUSE	
# --------------------------------------	

# --------------------------------------	
func on_data_update() -> void:	
	if "track_list" in data and data.track_list.size() > 0:		
		track_list = data.track_list.filter(func(item):
			if "unlocked" in item:
				return item.unlocked.call(item.details)
			return true
		)
		
		selected_track = data.selected if "selected" in data else 0
		play_selected_track()
# --------------------------------------	

# --------------------------------------	
func play_selected_track() -> void:
	var track_data:Dictionary = track_list[selected_track]
	var details:Dictionary = track_data.details if "details" in track_data else {"name": "No details...", "author": "unknown"}
	
	TrackNameLabel.text = "%s by %s" % [details.name, details.author]
	
	if "file" not in track_data:
		print("No file in track_data")
		return
		
	current_audio_stream_player.stream = track_data.file
	current_audio_stream_player.play()
	
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


func on_process_update(delta: float) -> void:
	super.on_process_update(delta)
	
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
			
		AudioNode.update_music_shader(fft)

	#if scroll_name:
	frame_counter += 1
	
	if frame_counter >= frames_to_skip:
		frame_counter = 0		
		TrackNameScrollContainer.scroll_horizontal += 5
		if TrackNameScrollContainer.scroll_horizontal >= ((TrackNameScrollContainer.custom_minimum_size.x + TrackNameLabel.text.length())):
			TrackNameScrollContainer.scroll_horizontal = 0
# --------------------------------------		
