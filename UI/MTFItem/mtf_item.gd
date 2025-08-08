@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var SvgIcon:Control = $VBoxContainer/SVGIcon
@onready var NameLabel:Label = $VBoxContainer/PanelContainer/NameLabel

@export var primary_color:Color = COLORS.primary_black  
@export var negative_color:Color = COLORS.disabled_color  
		
@export var icon:SVGS.TYPE = SVGS.TYPE.DOT : 
	set(val):
		icon = val
		on_icon_update()
		
@export var title:String = "" : 
	set(val):
		title = val
		on_title_update()
		
@export var is_negative: bool = false : 
	set(val):
		is_negative = val
		on_is_negative_update()
		
@export var icon_size:Vector2 = Vector2(25, 25) : 
	set(val):
		icon_size = val
		on_icon_size_update()


# --------------------------------------
func _ready() -> void:
	on_icon_size_update()
	on_icon_update()
	update()

func on_icon_update() -> void:
	if !is_node_ready():return
	SvgIcon.icon = 	icon

func on_icon_size_update() -> void:
	if !is_node_ready():return	
	SvgIcon.icon_size = icon_size

func on_title_update() -> void:
	if !is_node_ready():return	
	U.debounce( str(self, "_update_all"), update)

func on_is_negative_update() -> void:
	if !is_node_ready():return
	U.debounce( str(self, "_update_all"), update)
	
func update() -> void:
	var label_settings_copy:LabelSettings = NameLabel.label_settings.duplicate()
	var use_color:Color = negative_color if is_negative else primary_color
	label_settings_copy.font_color = use_color
	label_settings_copy.outline_color = use_color
	label_settings_copy.outline_color.a = 0.5
	
	SvgIcon.icon_color = use_color
	NameLabel.label_settings = label_settings_copy
	
	NameLabel.text = title
# --------------------------------------
