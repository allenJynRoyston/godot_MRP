@tool
extends CardDrawerClass

@onready var ContentLabel:Label = $MarginContainer/MarginContainer/ContentLabel

@export var is_small:bool = false : 
	set(val):
		is_small = val
		update_label_settings()
		
@export var outline_color:Color = Color(0.162, 0.162, 0.162) : 
	set(val):
		outline_color = val
		update_label_settings()

@export var content:String = "CONTENT" :
	set(val):
		content = val 
		on_content_update()

func _ready() -> void:
	super._ready()
	on_content_update()
	update_label_settings()

func on_content_update() -> void:
	if !is_node_ready():return
	ContentLabel.text = str(content)

func update_label_settings() -> void:
	if !is_node_ready():return
	var label_settings_copy:LabelSettings = ContentLabel.label_settings.duplicate()
	label_settings_copy.font_size = 16 if is_small else 32
	#label_settings_copy.outline_size = label_settings_copy.font_size/2
	#label_settings_copy.outline_color = outline_color
	ContentLabel.label_settings = label_settings_copy
	
