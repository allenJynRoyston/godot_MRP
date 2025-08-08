@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var TitleLabel:Label = $MarginContainer/VBoxContainer/Title
@onready var ValueLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/Value
@onready var MaxLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/Max
@onready var CapacityLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/Capacity

@export var value:int = 0 : 
	set(val):
		value = val
		on_value_update()
		
@export var max_val:int = 0 : 
	set(val): 
		max_val = val 
		on_max_val_update()
		
@export var title:String = ""	: 
	set(val):
		title = val
		on_title_update()	
		
@export var capacity_val:int = -1 :
	set(val):
		capacity_val = val
		on_capacity_val_update()
		
@export var capacity_only:bool = false :
	set(val):
		capacity_only = val
		on_capacity_only_update()		
		
@export var invert_color:bool = false : 
	set(val):
		invert_color = val
		on_invert_color_update()		

var hint_title:String = "HINT"
var hint_description:String = ""
var hint_icon:SVGS.TYPE = SVGS.TYPE.INFO

# --------------------------------------
func _ready() -> void:
	on_title_update()
	on_value_update()
	on_max_val_update()
	on_capacity_val_update()
	on_capacity_only_update()
	on_invert_color_update()
# --------------------------------------

# --------------------------------------
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title
	

func on_max_val_update() -> void:
	if !is_node_ready():return
	U.debounce( str(self.name, "_update"), update)
	
func on_value_update() -> void:
	if !is_node_ready():return
	U.debounce( str(self.name, "_update"), update)
	
func on_capacity_val_update() -> void:
	if !is_node_ready():return
	U.debounce( str(self.name, "_update"), update)

func on_invert_color_update() -> void:
	if !is_node_ready():return
	U.debounce( str(self.name, "_update"), update)

func on_capacity_only_update() -> void:
	if !is_node_ready():return
	CapacityLabel.show() if capacity_only else CapacityLabel.hide()
	ValueLabel.show() if !capacity_only else ValueLabel.hide()
	MaxLabel.show() if !capacity_only else MaxLabel.hide()	
# --------------------------------------

# --------------------------------------
func update() -> void:
	if !is_node_ready():return	
	var font_color:Color = COLORS.disabled_color if value <= 0 else (COLORS.primary_black if !invert_color else Color.WHITE)
	var outline_color:Color =  Color(font_color.r, font_color.g, font_color.b, 0.2)	
	var title_label_settings_copy:LabelSettings = TitleLabel.label_settings.duplicate()
	var value_label_setting_copy:LabelSettings = ValueLabel.label_settings.duplicate()
	
	for node in [TitleLabel, ValueLabel, MaxLabel, CapacityLabel]:
		var label_settings_copy:LabelSettings = node.label_settings.duplicate()
		label_settings_copy.font_color = font_color
		label_settings_copy.outline_color =  Color(font_color.r, font_color.g, font_color.b, 0.2)	
		node.label_settings = label_settings_copy
	
	ValueLabel.text = str(value)	
	MaxLabel.text =  str("/", max_val)
	CapacityLabel.text = str("+" if capacity_val > 0 else "-", capacity_val)
# --------------------------------------
