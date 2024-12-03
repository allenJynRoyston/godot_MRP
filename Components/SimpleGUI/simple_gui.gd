extends ControlPanel

@onready var WindowUI = $WindowUI
@onready var DayLabel = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VBoxContainer/day
@onready var PhaseLabel = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VBoxContainer/phase
@onready var SummaryLabel = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VBoxContainer/summary
			
var day_text:String = "":
	set(val):
		day_text = val
		DayLabel.text = day_text
		
var phase_text:String = "" : 
	set(val):
		phase_text = val
		PhaseLabel.text = phase_text
		
var summary_text:String = "" : 
	set(val):
		summary_text = val
		SummaryLabel.text = summary_text
		
# -----------------------------------	
func _ready() -> void:
	RootPanel = $CenterContainer/Panel
	super._ready()
	WindowUI.onDragEnd = func(new_offset:Vector2) -> void:
		var GameplayNode = GBL.find_node(REFS.GAMEPLAY_LOOP)
		var window_offset = GameplayNode.window_offsets.duplicate()		
		window_offset[self.name] = new_offset		
		GameplayNode.window_offsets = window_offset
# -----------------------------------		

# -----------------------------------		
func on_data_update(_previous_state:Dictionary) -> void:
	day_text = data.day_text
	phase_text = data.phase_text
	summary_text = data.summary_text
# -----------------------------------		

# -----------------------------------		
func on_window_offset_update() -> void:
	WindowUI.window_offset = window_offset
# -----------------------------------			

# -----------------------------------		
func on_is_active_updated() -> void:
	WindowUI.window_is_active = is_active
	
	for node in [DayLabel, PhaseLabel, SummaryLabel]:
		var new_label_setting:LabelSettings = node.label_settings.duplicate()
		new_label_setting.font_color = "00f647" if is_active else "004115"
		node.label_settings = new_label_setting	
	
# -----------------------------------			

# -----------------------------------	
func on_key_input(keycode:int) -> void:
	match keycode: 
		# space
		32: 
			get_parent().next()
# -----------------------------------		
