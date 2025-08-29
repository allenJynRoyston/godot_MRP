@tool
extends Control

@onready var RootPanel:PanelContainer = $"."
@onready var IconBtn:Control = $MarginContainer/HBoxContainer/SVGIcon
@onready var TitleLabel:Label = $MarginContainer/HBoxContainer/Label

@onready var title_label_settings:LabelSettings = TitleLabel.get("label_settings").duplicate()

@export var default_color:Color = COLORS.primary_black : 
	set(val):
		default_color = val
		on_default_color_update()

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
	TitleLabel.set("label_settings", title_label_settings)
	on_is_checked_update()
	on_title_update()
	on_is_negative_update()
	on_default_color_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func on_default_color_update() -> void:
	U.debounce( str(self, "_update_node"), update_node )
	
func on_is_negative_update() -> void:
	U.debounce( str(self, "_update_node"), update_node )


func on_is_checked_update() -> void:
	U.debounce( str(self, "_update_node"), update_node )

func on_title_update() -> void:
	U.debounce( str(self, "_update_node"), update_node )
	
func update_node() -> void:
	if !is_node_ready():return
	var use_color:Color = COLORS.disabled_color if is_negative else default_color
	title_label_settings.font_color = use_color
	
	TitleLabel.hide() if title.is_empty() else TitleLabel.show()
	TitleLabel.text = title	
	
	IconBtn.icon = SVGS.TYPE.CHECKBOX if is_checked else SVGS.TYPE.EMPTY_CHECKBOX
	IconBtn.icon_color = use_color
		
# ------------------------------------------------------------------------------	
	
