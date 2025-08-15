@tool
extends PanelContainer

@onready var ValLabel:Label = $HBoxContainer/Control/Slider/PanelContainer/MarginContainer/Label
@onready var SliderControl:Control = $HBoxContainer/Control/Slider
@onready var ResultLabel:Label = $HBoxContainer/VBoxContainer2/ResultLabel

@onready var LabelSettingCopy:LabelSettings = ValLabel.get("label_settings").duplicate()
@onready var ResultLabelLabelSetting:LabelSettings = ResultLabel.get("label_settings").duplicate()

@export_range(0, 3, 1) var slider_val:int = 0 : 
	set(val):
		slider_val = val
		on_slider_val_update()
		
func _ready() -> void:
	on_slider_val_update()
	ValLabel.label_settings = LabelSettingCopy	
	ResultLabel.label_settings = ResultLabelLabelSetting
	
func on_slider_val_update() -> void:
	if !is_node_ready():return
	ValLabel.text = str(absi(slider_val))
	ValLabel.label_settings.font_color = Color.WHITE if absi(slider_val) != 3 else Color.RED
	
	U.tween_node_property(SliderControl, "position:y", 99 + (slider_val * -25), 0.3, 0, Tween.TRANS_SINE, Tween.EASE_OUT )

	match slider_val:
		3:
			ResultLabelLabelSetting.font_color = Color.RED			
			ResultLabel.text = "EXTREME HEAT"
		2:
			ResultLabelLabelSetting.font_color = Color.BLACK
			ResultLabel.text = "HOT"
		1:
			ResultLabelLabelSetting.font_color = Color.BLACK
			ResultLabel.text = "WARM"
		0:
			ResultLabelLabelSetting.font_color = Color.BLACK
			ResultLabel.text = "NEUTRAL"
		-1:
			ResultLabelLabelSetting.font_color = Color.BLACK
			ResultLabel.text = "COOL"
		-2:
			ResultLabelLabelSetting.font_color = Color.BLACK
			ResultLabel.text = "COLD"
		-3:
			ResultLabelLabelSetting.font_color = Color.RED			
			ResultLabel.text = "EXTREME COLD"

	ResultLabelLabelSetting.outline_color = ResultLabelLabelSetting.font_color
	ResultLabelLabelSetting.outline_color.a = 0.2
