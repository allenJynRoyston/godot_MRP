extends PanelContainer

@onready var RootPanel = $CenterContainer/Panel
@onready var DayLabel = $CenterContainer/Panel/MarginContainer/VBoxContainer/day
@onready var PhaseLabel = $CenterContainer/Panel/MarginContainer/VBoxContainer/phase
@onready var SummaryLabel = $CenterContainer/Panel/MarginContainer/VBoxContainer/summary

var is_active:bool = false : 
	set(val):
		if is_active != val:
			is_active = val
			update_panel()
			
var day_text = "":
	set(val):
		day_text = val
		DayLabel.text = day_text
		
var phase_text = "" : 
	set(val):
		phase_text = val
		PhaseLabel.text = phase_text
		
var summary_text = "" : 
	set(val):
		summary_text = val
		SummaryLabel.text = summary_text		

# -----------------------------------
func _ready() -> void:
	update_panel()
# -----------------------------------

# -----------------------------------
func update_panel() -> void:
	var new_stylebox = StyleBoxFlat.new()
	new_stylebox.bg_color = "5531b8" if is_active else "3a3a3a"
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)
# -----------------------------------
