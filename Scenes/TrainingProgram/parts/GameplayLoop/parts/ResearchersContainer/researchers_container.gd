@tool
extends GameContainer

@onready var BackBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer3/BackBtn

@onready var List:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/List
@onready var Details:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/Details
@onready var Actions:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/Actions
#
var selected_researcher:Dictionary = {} : 
	set(val):
		selected_researcher = val
		on_selected_researcher_update()

var assign_only:bool = false : 
	set(val):
		assign_only = val 
		on_assign_only_update()

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	BackBtn.onClick = func() -> void:
		on_back()
		
	List.onSelect = func(_selected_researcher:Dictionary) -> void:
		selected_researcher = _selected_researcher
		
	Actions.onAction = func(action:ACTION.RESEARCHERS) -> void:
		user_response.emit({"action": action, "data": selected_researcher})
		
	on_selected_researcher_update()
	on_assign_only_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_assign_only_update() -> void:
	if !is_node_ready():return
	
	Actions.assign_only = assign_only
# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------		
func on_selected_researcher_update() -> void:
	if !is_node_ready():return
	
	Details.researcher_details = selected_researcher.details if "details" in selected_researcher else {}
	Actions.researcher_details = selected_researcher.details if "details" in selected_researcher else {}
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func on_back() -> void:
	List.reset()
	selected_researcher = {} 
	user_response.emit({"action": ACTION.RESEARCHERS.BACK})
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_showing:return
	var key:String = input_data.key
	var keycode:int = input_data.keycode

	match key:
		"BACK":
			on_back()
		"B":
			on_back()
# --------------------------------------------------------------------------------------------------	
