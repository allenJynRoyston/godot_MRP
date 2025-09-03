extends GameContainer

@onready var PanelContainerUI:Control = $Control/PanelContainer
@onready var MarginContainerUI:MarginContainer = $Control/PanelContainer/MarginContainer

func _ready() -> void:
	super._ready()
	await U.tick()
	control_pos[PanelContainerUI] = {
		"show": 0,
		"hide": -MarginContainerUI.size.y
	}
	
	PanelContainerUI.position.y = control_pos[PanelContainerUI].hide

func on_is_showing_update() -> void:	
	super.on_is_showing_update()
	reveal(is_showing)

# --------------------------------------------------------------------------------------------------
func reveal(state:bool, instant:bool = false) -> void:
	if control_pos.is_empty():return
	
	var new_pos:int = control_pos[PanelContainerUI].show if state else control_pos[PanelContainerUI].hide
	
	if state:
		show()
	
	if instant:
		PanelContainerUI.position.y = new_pos
		return
	
	await U.tween_node_property(PanelContainerUI, "position:y", new_pos)

	if !state:
		hide()
# --------------------------------------------------------------------------------------------------
