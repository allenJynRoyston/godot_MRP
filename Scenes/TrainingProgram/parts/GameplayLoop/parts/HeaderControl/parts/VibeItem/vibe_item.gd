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

var hint_title:String = "HINT"
var hint_description:String = ""
var hint_icon:SVGS.TYPE = SVGS.TYPE.INFO

# --------------------------------------
func _ready() -> void:
	on_title_update()
	on_value_update()
	on_metric_update()
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


func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title

func on_value_update() -> void:
	if !is_node_ready():return
	ValueLabel.text = str(value)
	update_vibe_color(ValueLabel, value)
# --------------------------------------

# --------------------------------------
func update_vibe_color(node:Control, val:int) -> void:
	var label_setting_copy:LabelSettings = node.label_settings.duplicate()
	label_setting_copy.font_color = COLORS.disabled_color if val < 0 else COLORS.primary_black
	node.label_settings = label_setting_copy
# --------------------------------------
