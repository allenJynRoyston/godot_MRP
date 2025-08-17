extends Control

@onready var RootPanel:PanelContainer = $PanelContainer
@onready var MarginPanel:MarginContainer = $PanelContainer/MarginContainer

var control_pos:Dictionary = {}

# --------------------------------------------------------------------------------------------------
func _ready() -> void:	
	await U.tick()
	
	await U.tick()
	control_pos[RootPanel] = {
		"show": 0,
		"hide": -MarginPanel.size.y
	}
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal(state:bool, instant:bool = false) -> void:
	if control_pos.is_empty():return
	
	if state:
		show()
	
	var new_pos:int = control_pos[RootPanel].show if state else control_pos[RootPanel].hide
	
	if instant:
		RootPanel.position.y = new_pos
		return
	
	await U.tween_node_property(RootPanel, "position:y", new_pos)
	
	if !state:
		hide()
# --------------------------------------------------------------------------------------------------
