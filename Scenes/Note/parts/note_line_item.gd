extends Control

@onready var TextLabel:Label = $HBoxContainer/Label
@onready var SelectIcon:Control = $HBoxContainer/MarginContainer/SVGIcon
@onready var LockedContainer:Control = $HBoxContainer/MarginContainer2
@onready var LockIcon:Control = $HBoxContainer/MarginContainer2/LockIcon

var label_settings_copy:LabelSettings 

var content:String = "" : 
	set(val):
		content = val
		if !is_node_ready():return
		on_content_update()
		
var is_selected:bool : 
	set(val):
		is_selected = val
		on_is_selected_update()
		
var is_locked:bool : 
	set(val):
		is_locked = val
		on_is_locked_update()		
		
func _ready() -> void:
	label_settings_copy = TextLabel.label_settings.duplicate()
	TextLabel.label_settings = label_settings_copy	
	on_content_update()
	on_is_selected_update()
	on_is_locked_update()

func on_is_selected_update() -> void:
	if !is_node_ready():return
	show() if is_selected else hide()

	
func on_is_locked_update() -> void:
	if !is_node_ready():return
	#LockedContainer.show() if is_locked else LockedContainer.hide()

func on_content_update() -> void:
	if !is_node_ready():return
	TextLabel.text = content
