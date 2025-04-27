@tool
extends PanelContainer

@onready var TextLabel:Label = $MarginContainer/Label

@export var val:int = 0 : 
	set(new_val):
		val = new_val
		on_label_update()

@export var use_icon:bool : 
	set(new_val):
		use_icon = new_val
		on_use_icon_update()
		
func _ready() -> void:
	on_label_update()
	on_use_icon_update()
	
func on_label_update() -> void:
	if !is_node_ready():return
	on_use_icon_update()
	
func on_use_icon_update() -> void:
	if !is_node_ready():return
	var label_settings_copy:LabelSettings = TextLabel.label_settings.duplicate()
	
	self.modulate = Color(1, 1, 1, 0 if val == 0 else 1)
	
	if use_icon:
		label_settings_copy.font_size = 10
		label_settings_copy.font_color = Color.WHITE
		TextLabel.text = "★" if val > 0 else ""
	else:
		label_settings_copy.font_size = 16
		label_settings_copy.font_color = Color(0.0, 1.0, 0.184) if val >=0 else Color(0.999, 0.0, 0.184)
		TextLabel.text = "%s%s" % ["+" if val >= 0 else "", val]
		
	TextLabel.label_settings = label_settings_copy
