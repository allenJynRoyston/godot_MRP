@tool
extends PanelContainer

@onready var TitleLabel:Label = $MarginContainer/MarginContainer/VBoxContainer/Label
@onready var SVGIcon:Control = $MarginContainer/MarginContainer/VBoxContainer/SVGIcon
@onready var InnerMargin:MarginContainer = $MarginContainer/MarginContainer

@export var title:String = "" : 
	set(val):
		title = val
		on_title_update()
		
@export var icon:SVGS.TYPE = SVGS.TYPE.NONE : 
	set(val):
		icon = val
		on_icon_update()
		
@export var use_color:Color = Color.WHITE : 
	set(val):
		use_color = val
		on_use_color_update()
		
@export var v_offset:int = 40 : 
	set(val):
		v_offset = val
		on_v_offset_update()
		
func _ready() -> void:	
	on_title_update()
	on_icon_update()
	on_use_color_update()
	on_v_offset_update()
		
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title
	
func on_icon_update() -> void:
	if !is_node_ready():return
	SVGIcon.icon = icon
	
func on_v_offset_update() -> void:
	if !is_node_ready():return
	InnerMargin.set('theme_override_constants/margin_top', v_offset)

func on_use_color_update() -> void:
	if !is_node_ready():return	
	var label_setting_copy:LabelSettings = TitleLabel.label_settings.duplicate()
	label_setting_copy.font_color = use_color
	
	TitleLabel.label_settings = label_setting_copy
	SVGIcon.icon_color = use_color
