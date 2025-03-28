extends GameContainer

@onready var DetailPanel:Control = $Control/DetailPanel

@onready var ResourcePanel:MarginContainer = $Control2/ResourcePanel
#@onready var ScpPanel:PanelContainer = $Control2/ScpPanel
@onready var Energy:PanelContainer = $Control2/ResourcePanel/HBoxContainer/HBoxContainer/Energy
@onready var Resources:PanelContainer = $Control2/ResourcePanel/HBoxContainer/HBoxContainer3/Resources
@onready var Funds:PanelContainer = $Control2/ResourcePanel/HBoxContainer/HBoxContainer/Funds
@onready var Research:PanelContainer = $Control2/ResourcePanel/HBoxContainer/HBoxContainer3/Researcher


var detail_panel_is_focused:bool = false
var detail_panel_is_busy:bool = false
var scp_available:bool = false


# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	GBL.direct_ref["EnergyPanel"] = Energy
	GBL.direct_ref["ResourcesPanel"] = Resources
	GBL.direct_ref["FundsPanel"] = Funds
	GBL.direct_ref["ResearchPanel"] = Research		
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()
	
	control_pos_default[ResourcePanel] = ResourcePanel.position
	
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos() -> void:	
	await U.tick()
	var h_diff:int = (1080 - 720) # difference between 1080 and 720 resolution - gives you 360
	var y_diff =  (0 if !GBL.is_fullscreen else h_diff) if !initalized_at_fullscreen else (0 if GBL.is_fullscreen else -h_diff)
	
	# for eelements in the top right
	control_pos[ResourcePanel] = {
		"show": control_pos_default[ResourcePanel].y, 
		"hide": control_pos_default[ResourcePanel].y - ResourcePanel.size.y
	}	
	
	on_is_showing_update(true)
# --------------------------------------------------------------------------------------------------	

# -----------------------------------------------
func on_is_showing_update(skip_animation:bool = false) -> void:	
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return
	U.tween_node_property(ResourcePanel, "position:y", control_pos[ResourcePanel].show if is_showing else control_pos[ResourcePanel].hide, 0 if skip_animation else 0.7)
# -----------------------------------------------	
