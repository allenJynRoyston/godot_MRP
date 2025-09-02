extends Control

@onready var RootPanel:PanelContainer = $PanelContainer
@onready var MarginPanel:MarginContainer = $PanelContainer/MarginContainer

@onready var Economy:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Economy
@onready var Vibes:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Vibes
@onready var Personnel:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Personnel
@onready var MTFComponent:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/MTFComponent
@onready var WarningComponent:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WarningComponent
@onready var EnergyComponent:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/EnergyComponent

var control_pos:Dictionary = {}

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_gameplay_conditionals(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_gameplay_conditionals(self)	

func _ready() -> void:	
	await U.tick()
	
	control_pos[RootPanel] = {
		"show": 0,
		"hide": -MarginPanel.size.y
	}
		
	reveal(true, true)
# --------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_gameplay_conditionals_update(new_val:Dictionary) -> void:
	if !is_node_ready() or new_val.is_empty():return
	EnergyComponent.show() 
	Economy.show() if new_val[CONDITIONALS.TYPE.UI_ENABLE_ECONOMY] else Economy.hide()
	Personnel.show() if new_val[CONDITIONALS.TYPE.UI_ENABLE_PERSONNEL] else Personnel.hide()
	Vibes.show() if new_val[CONDITIONALS.TYPE.UI_ENABLE_VIBES] else Vibes.hide()
	MTFComponent.show() if new_val[CONDITIONALS.TYPE.UI_ENABLE_MTF] else MTFComponent.hide()
	WarningComponent.show() if new_val[CONDITIONALS.TYPE.UI_ENABLE_DANGERS] else WarningComponent.hide()
	
# ------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal(state:bool, instant:bool = false) -> void:
	if control_pos.is_empty():return
	
	var new_pos:int = control_pos[RootPanel].show if state else control_pos[RootPanel].hide
	
	if state:
		show()
	
	if instant:
		RootPanel.position.y = new_pos
		return
	
	await U.tween_node_property(RootPanel, "position:y", new_pos)
	
	if !state:
		hide()
# --------------------------------------------------------------------------------------------------
