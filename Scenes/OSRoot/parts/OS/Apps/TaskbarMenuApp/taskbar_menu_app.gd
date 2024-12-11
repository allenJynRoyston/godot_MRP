extends AppWrapper

@onready var VList:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VList

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	super._ready()
	on_data_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func after_ready() -> void:
	WindowUI.window_position = offset
	bind_events()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func on_data_update() -> void:
	if is_node_ready():
		VList.data = data.list_data
# ------------------------------------------------------------------------------	
	
