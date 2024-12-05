extends AppWrapper

@onready var VList:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VList

# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	super._ready()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func after_ready() -> void:	
	WindowUI.window_position = app_props.offset
	WindowUI.window_label = app_props.window_label
	
	VList.data = [
		{
			"section": "Options",
			"opened": true,
			"items": app_props.items
		}
	]
	
	bind_events()
# ------------------------------------------------------------------------------	
