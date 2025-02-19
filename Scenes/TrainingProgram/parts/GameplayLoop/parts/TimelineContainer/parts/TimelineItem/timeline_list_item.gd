extends BtnBase

@onready var TitleLabel:Label = $HBoxContainer/VBoxContainer/TitleLabel
@onready var DescriptionLabel:Label = $HBoxContainer/VBoxContainer/DescriptionLabel

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	on_data_update()

func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	TitleLabel.text = data.title
	DescriptionLabel.text = data.description


# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	pass
	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
	if on_hover:		
		SUBSCRIBE.current_location = data.location.duplicate()
# ------------------------------------------------------------------------------
