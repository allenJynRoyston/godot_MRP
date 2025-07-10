@tool
extends Control

@onready var RootPanel:PanelContainer = $"."
@onready var IconBtn:Control = $MarginContainer/HBoxContainer/SVGIcon
@onready var TitleLabel:Label = $MarginContainer/HBoxContainer/Label
		
@export var is_negative:bool = false : 
	set(val):
		is_negative = val
		on_is_negative_update()

@export var is_checked:bool = false : 
	set(val):
		is_checked = val
		on_is_checked_update()
		
@export var title:String = "" : 
	set(val):
		title = val
		on_title_update()

# ------------------------------------------------------------------------------
func _ready() -> void:
	on_is_checked_update()
	on_title_update()
	on_is_negative_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func on_is_negative_update() -> void:
	if !is_node_ready():return
	var label_settings_copy:LabelSettings = TitleLabel.label_settings.duplicate()
	var use_color:Color = COLORS.disabled_color if is_negative else COLORS.primary_black
	label_settings_copy.font_color = use_color
	print(is_negative)
	IconBtn.icon_color = use_color
	TitleLabel.label_settings = label_settings_copy

func on_is_checked_update() -> void:
	if !is_node_ready():return
	IconBtn.icon = SVGS.TYPE.CHECKBOX if is_checked else SVGS.TYPE.EMPTY_CHECKBOX
	
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.hide() if title.is_empty() else TitleLabel.show()
	TitleLabel.text = title
# ------------------------------------------------------------------------------	
	
