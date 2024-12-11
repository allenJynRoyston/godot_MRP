extends AppWrapper

@onready var VList:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VList

# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	super._ready()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func after_ready() -> void:	
	WindowUI.window_label = app_props.window_label
	
	VList.data = [
		{
			"section": "Options",
			"opened": true,
			"items": app_props.items
		}
	]
	
	bind_events()
	
	var offset_x:int = app_props.offset.x
	var offset_y:int = app_props.offset.y
	var vp_size:Vector2 = get_viewport().get_visible_rect().size
	await get_tree().process_frame
	
	if offset_x + WindowUI.size.x > vp_size.x:
		offset_x = offset_x - WindowUI.size.x
		
	if offset_y + WindowUI.size.y > vp_size.y:
		offset_y = offset_y - WindowUI.size.y
	
	WindowUI.window_position = Vector2(offset_x, offset_y)
# ------------------------------------------------------------------------------	
