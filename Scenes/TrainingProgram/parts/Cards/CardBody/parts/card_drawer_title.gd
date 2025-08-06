@tool
extends CardDrawerClass

@onready var ContentLabel:Label = $MarginContainer/MarginContainer/ContentLabel

@export var hollow:bool = false : 
	set(val):
		hollow = val
		on_hollow_update()

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

@export var center_text:bool = true : 
	set(val):
		center_text = val
		on_center_text_update()
		
var OrangePanelPreload:StyleBoxFlat = preload("res://Styles/OrangePanel.tres").duplicate()

func _ready() -> void:
	super._ready()
	on_content_update()
	update_label_settings()
	on_center_text_update()
	on_hollow_update()

func on_hollow_update() -> void:
	if !is_node_ready():return
	var label_settings_copy:LabelSettings = ContentLabel.label_settings.duplicate()
	label_settings_copy.font_color = Color.WHITE if hollow else Color.BLACK
	label_settings_copy.outline_color = Color(label_settings_copy.font_color.r, label_settings_copy.font_color.g, label_settings_copy.font_color.b, 0.2)
	ContentLabel.label_settings = label_settings_copy
	
	
	var new_flat:StyleBoxFlat = StyleBoxFlat.new()
	new_flat.bg_color = Color.TRANSPARENT
	$".".set('theme_override_styles/panel', new_flat if hollow else OrangePanelPreload)

func on_center_text_update() -> void:
	if !is_node_ready():return
	ContentLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if center_text else HORIZONTAL_ALIGNMENT_LEFT

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
	
