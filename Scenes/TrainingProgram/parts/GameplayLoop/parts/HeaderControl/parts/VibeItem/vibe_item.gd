@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var TitleLabel:Label = $MarginContainer/VBoxContainer/Title
@onready var ValueLabel:Label = $MarginContainer/VBoxContainer/Value

@export var metric:RESOURCE.METRICS : 
	set(val):
		metric = val
		on_metric_update()

@export var value:int = 0 : 
	set(val):
		value = val
		on_value_update()
		
@export var title:String = ""	: 
	set(val):
		title = val
		on_title_update()	
		
@export var invert_color:bool = false : 
	set(val):
		invert_color = val
		on_invert_color_update()
		
@export var big_numbers:bool = false : 
	set(val):
		big_numbers = val
		on_big_numbers_update()		

var hint_title:String = "HINT"
var hint_description:String = ""
var hint_icon:SVGS.TYPE = SVGS.TYPE.INFO

# --------------------------------------
func _ready() -> void:
	on_title_update()
	on_value_update()
	on_metric_update()
	on_invert_color_update()
	on_big_numbers_update()
# --------------------------------------

# --------------------------------------
func on_metric_update() -> void:
	if !is_node_ready():return
	match metric:
		RESOURCE.METRICS.MORALE:
			title = 'MORALE'
			hint_description = "Morale description."

		RESOURCE.METRICS.SAFETY:
			title = 'SAFETY'
			hint_description = "Safety description."

		RESOURCE.METRICS.READINESS:
			title = 'READINESS'
			hint_description = "Readiness description."

func on_invert_color_update() -> void:
	if !is_node_ready():return


func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title

func on_value_update() -> void:
	if !is_node_ready():return
	ValueLabel.text = str(value)
	update_vibe_color(ValueLabel, value)
	
func on_big_numbers_update() -> void:
	if !is_node_ready():return
	update_vibe_color(ValueLabel, value)
# --------------------------------------

# --------------------------------------
func update_vibe_color(node:Control, val:int) -> void:
	var label_setting_copy:LabelSettings = node.label_settings.duplicate()
	label_setting_copy.font_color = COLORS.disabled_color if val < 0 else COLORS.primary_black
	node.label_settings = label_setting_copy
	
	var title_label_font_settings:LabelSettings = TitleLabel.label_settings.duplicate()
	title_label_font_settings.font_color = Color.BLACK if invert_color else Color.WHITE
	title_label_font_settings.outline_color = Color(title_label_font_settings.font_color.r, title_label_font_settings.font_color.g, title_label_font_settings.font_color.b, 0.2)	
	TitleLabel.label_settings = title_label_font_settings
	
	var value_label_font_settings:LabelSettings = ValueLabel.label_settings.duplicate()
	value_label_font_settings.font_size = 24 if big_numbers else 16
	value_label_font_settings.font_color = Color.BLACK if invert_color else Color.WHITE
	value_label_font_settings.outline_color = Color(value_label_font_settings.font_color.r, value_label_font_settings.font_color.g, value_label_font_settings.font_color.b, 0.2)
	ValueLabel.label_settings = value_label_font_settings
		
# --------------------------------------
