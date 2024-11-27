extends ControlPanel

@onready var DayLabel = $CenterContainer/Panel/MarginContainer/VBoxContainer/day
@onready var PhaseLabel = $CenterContainer/Panel/MarginContainer/VBoxContainer/phase
@onready var SummaryLabel = $CenterContainer/Panel/MarginContainer/VBoxContainer/summary
			
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
# -----------------------------------		

# -----------------------------------		
func on_data_update(_previous_state:Dictionary) -> void:
	day_text = data.day_text
	phase_text = data.phase_text
	summary_text = data.summary_text
# -----------------------------------		

# -----------------------------------	
func on_key_input(keycode:int) -> void:
	match keycode: 
		# space
		32: 
			get_parent().next()
# -----------------------------------		
