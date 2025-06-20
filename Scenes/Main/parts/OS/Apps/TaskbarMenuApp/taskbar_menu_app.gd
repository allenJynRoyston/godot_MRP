extends AppWrapper

@onready var VList:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VList

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

# ------------------------------------------------------------------------------
func _ready() -> void:
	on_data_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func on_data_update() -> void:
	if is_node_ready():
		VList.data = data.list_data
# ------------------------------------------------------------------------------	
	
