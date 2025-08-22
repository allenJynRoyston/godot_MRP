@tool
extends PanelContainer

@onready var HeaderLabel:Label = $HBoxContainer/VBoxContainer2/Label
@onready var ValLabel:Label = $HBoxContainer/Control/Slider/PanelContainer/MarginContainer/Label
@onready var SliderControl:Control = $HBoxContainer/Control/Slider
@onready var SliderIcon:Control = $HBoxContainer/Control/Slider/SVGIcon
@onready var ResultLabel:Label = $HBoxContainer/VBoxContainer2/ResultLabel

@onready var header_label_settings:LabelSettings = HeaderLabel.get("label_settings").duplicate()
@onready var val_label_settings:LabelSettings = ValLabel.get("label_settings").duplicate()
@onready var result_label_settings:LabelSettings = ResultLabel.get("label_settings").duplicate()

@export_range(0, 3, 1) var slider_val:int = 0 : 
	set(val):
		slider_val = val
		on_slider_val_update()
		
@export var mini:bool = false : 
	set(val):
		mini = val
		on_mini_update()

		
func _ready() -> void:
	HeaderLabel.label_settings = header_label_settings
	ValLabel.label_settings = val_label_settings	
	ResultLabel.label_settings = result_label_settings	
	
	on_slider_val_update()
	on_mini_update()
	
func on_mini_update() -> void:
	U.debounce(str(self, "_update_node"), update_node)

func on_slider_val_update() -> void:
	U.debounce(str(self, "_update_node"), update_node)
	
func update_node() -> void:
	if !is_node_ready():return
	ValLabel.text = str(absi(slider_val))
	
	U.tween_node_property(SliderControl, "position:y", 99 + (slider_val * -25), 0.3, 0, Tween.TRANS_SINE, Tween.EASE_OUT )

	match slider_val:
		3:
			result_label_settings.font_color =  Color.WHITE if mini else Color.RED			
			ResultLabel.text = "EXTREME HEAT"
		2:
			result_label_settings.font_color =  Color.WHITE if mini else Color.BLACK
			ResultLabel.text = "HOT"
		1:
			result_label_settings.font_color =  Color.WHITE if mini else Color.BLACK
			ResultLabel.text = "WARM"
		0:
			result_label_settings.font_color =  Color.WHITE if mini else Color.BLACK
			ResultLabel.text = "NEUTRAL"
		-1:
			result_label_settings.font_color =  Color.WHITE if mini else Color.BLACK
			ResultLabel.text = "COOL"
		-2:
			result_label_settings.font_color =  Color.WHITE if mini else Color.BLACK
			ResultLabel.text = "COLD"
		-3:
			result_label_settings.font_color =  Color.WHITE if mini else Color.RED			
			ResultLabel.text = "EXTREME COLD"

	result_label_settings.outline_color = result_label_settings.font_color
	result_label_settings.outline_color.a = 0.2
	val_label_settings.font_color = Color.WHITE if mini else Color.WHITE if absi(slider_val) != 3 else Color.RED	
	header_label_settings.font_color = Color.WHITE
	
	SliderIcon.icon_color =  Color.WHITE if mini else Color.BLACK
	
