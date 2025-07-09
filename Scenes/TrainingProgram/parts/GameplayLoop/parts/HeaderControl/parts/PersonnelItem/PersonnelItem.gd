@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var TitleLabel:Label = $MarginContainer/VBoxContainer/Title
@onready var ValueLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/Value
@onready var MaxLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/Max

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

var hint_title:String = "HINT"
var hint_description:String = ""
var hint_icon:SVGS.TYPE = SVGS.TYPE.INFO

# --------------------------------------
func _ready() -> void:
	on_title_update()
	on_value_update()
	on_max_val_update()
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
# --------------------------------------

# --------------------------------------
func update() -> void:
	if !is_node_ready():return	
	var label_setting_copy:LabelSettings = ValueLabel.label_settings.duplicate()
	label_setting_copy.font_color = COLORS.disabled_color if value < 0 else COLORS.primary_black
	ValueLabel.label_settings = label_setting_copy
	ValueLabel.text = str(value)	
	MaxLabel.text =  str("/", max_val)
# --------------------------------------
