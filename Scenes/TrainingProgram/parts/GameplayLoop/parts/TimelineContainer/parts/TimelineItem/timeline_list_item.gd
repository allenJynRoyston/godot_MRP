extends PanelContainer

@onready var IconBtn:BtnBase = $HBoxContainer/IconBtn
@onready var TitleLabel:Label = $HBoxContainer/VBoxContainer/TitleLabel
@onready var DescriptionLabel:Label = $HBoxContainer/VBoxContainer/DescriptionLabel

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()
		
var show_details:bool = false : 
	set(val): 
		show_details = val
		on_show_details_update()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_data_update()
	on_show_details_update()

# ------------------------------------------------------------------------------
func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	TitleLabel.text = data.title
	DescriptionLabel.text = data.description
	IconBtn.icon = data.icon
	
func on_show_details_update() -> void:
	if !is_node_ready() or data.is_empty():return
	TitleLabel.show() if show_details else TitleLabel.hide()
	DescriptionLabel.show() if show_details else DescriptionLabel.hide()
# ------------------------------------------------------------------------------
