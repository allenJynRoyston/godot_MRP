extends MouseInteractions

@onready var LogoBtn:Control = $MarginContainer/LogoBtn
@onready var TrackNameLabel:Label = $TrackNameScrollContainer/PanelContainer/MarginContainer/TrackName
@onready var TrackNameScrollContainer:ScrollContainer = $TrackNameScrollContainer
@onready var AudioStreamPlayerUI:AudioStreamPlayer = $AudioStreamPlayer

@onready var PlayPauseBtn:MarginContainer = $HBoxContainer/PlayPauseBtn
@onready var NextBtn:MarginContainer = $HBoxContainer/NextBtn

var frames_to_skip: int = 5
var frame_counter: int = 0

var hover_nodes:Array = []
var track_list:Array = []
var selected_track:int = 0
var scroll_name:bool = false
var BtnControls:Control 
var data:Dictionary = {} : 
	set(val): 
		data = val
		on_data_update()


# --------------------------------------	
func _ready() -> void:
	super._ready()
	on_focus(false)	
	on_pause_or_play_update()
	
	for node in [PlayPauseBtn, NextBtn]:
		node.onBlur = func(node:Control):
			hover_nodes.erase(node)
			
		node.onFocus = func(node:Control):
			if node not in hover_nodes:
				hover_nodes.push_back(node)
	
	PlayPauseBtn.onClick = func():
		AudioStreamPlayerUI.playing = !AudioStreamPlayerUI.playing
		on_pause_or_play_update()
		
	NextBtn.onClick = func():
		selected_track = (selected_track + 1) % track_list.size()
		play_selected_track()
		
	BtnControls = GBL.find_node(REFS.BTN_CONTROLS)
# --------------------------------------	

# --------------------------------------	
func skip_to_track(track_data:Dictionary) -> void:
	selected_track = 1
	play_selected_track()
# --------------------------------------		

# --------------------------------------		
func activate() -> void:
	BtnControls.add_to_itemlist([PlayPauseBtn, NextBtn])
		
func deactivate() -> void:
	BtnControls.remove_from_itemlist([PlayPauseBtn, NextBtn])
# --------------------------------------		


# --------------------------------------	
func on_pause_or_play_update() -> void:
	PlayPauseBtn.icon = SVGS.TYPE.MEDIA_PLAY if !AudioStreamPlayerUI.playing else SVGS.TYPE.MEDIA_PAUSE	
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
	
	TrackNameLabel.text = " Playing %s by %s" % [details.name, details.author]
	
	if "file" not in track_data:
		print("No file in track_data")
		return
	
	AudioStreamPlayerUI.stream = track_data.file
	AudioStreamPlayerUI.play()
	on_pause_or_play_update()
	check_track_scroll.call_deferred()
	
func check_track_scroll() -> void:
	if TrackNameLabel.size.x >= TrackNameScrollContainer.size.x:		
		TrackNameLabel.text = "                                          %s                                          " % [TrackNameLabel.text]
		scroll_name = true
		var start_at_halfway:Callable = func():
			TrackNameScrollContainer.scroll_horizontal = TrackNameLabel.size.x/3
		start_at_halfway.call_deferred()
	else:
		scroll_name = false	
# --------------------------------------	

# --------------------------------------	
func on_focus(state:bool) -> void:
	#var shader_material:ShaderMaterial = Logo.material.duplicate()	
	#shader_material.set_shader_parameter("tint_color", COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE) if state else COLOR_UTIL.get_text_color(COLORS.TEXT.INACTIVE))
	#Logo.material = shader_material
	
	var label_setting:LabelSettings = TrackNameLabel.label_settings.duplicate()
	label_setting.font_color = COLOR_UTIL.get_window_color(COLORS.WINDOW.ACTIVE) if state else COLOR_UTIL.get_window_color(COLORS.WINDOW.SHADING)
	TrackNameLabel.label_settings = label_setting

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and hover_nodes.is_empty():
		var layout_node:Control = GBL.find_node(REFS.OS_LAYOUT)
		layout_node.open_media_player_mini(self)
# --------------------------------------		

# --------------------------------------		
func on_process_update(delta: float) -> void:
	super.on_process_update(delta)
	if scroll_name:
		frame_counter += 1
		
		if frame_counter >= frames_to_skip:
			frame_counter = 0		
			TrackNameScrollContainer.scroll_horizontal += 1
			var amount_left:int = TrackNameLabel.size.x - (TrackNameScrollContainer.custom_minimum_size.x + TrackNameScrollContainer.scroll_horizontal)
			if amount_left < 10:
				TrackNameScrollContainer.scroll_horizontal = 0
# --------------------------------------		
