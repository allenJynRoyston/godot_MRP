@tool
extends PanelContainer

@onready var ValLabel:Label = $HBoxContainer/Control/Slider/PanelContainer/MarginContainer/Label
@onready var SliderControl:Control = $HBoxContainer/Control/Slider

@onready var LabelSettingCopy:LabelSettings = ValLabel.get("label_settings").duplicate()

@export_range(-3, 3, 1) var slider_val:int = 0 : 
	set(val):
		slider_val = val
		on_slider_val_update()
		
func _ready() -> void:
	on_slider_val_update()
	ValLabel.label_settings = LabelSettingCopy	
	
func on_slider_val_update() -> void:
	if !is_node_ready():return
	ValLabel.text = str(absi(slider_val))
	ValLabel.label_settings.font_color = Color.WHITE if slider_val >= 0 else Color.RED
	
	await U.tween_node_property(SliderControl, "position:y", 99 + (slider_val * -25), 0.3, 0, Tween.TRANS_SINE, Tween.EASE_OUT )

	
