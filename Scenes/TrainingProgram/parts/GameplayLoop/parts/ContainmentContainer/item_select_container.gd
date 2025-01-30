@tool
extends GameContainer

@onready var AvailableTabBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer3/HBoxContainer/AvailableTabBtn
@onready var ContainTabBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer3/HBoxContainer/ContainedTabBtn
@onready var BackBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer3/BackBtn

@onready var NothingAvailable:Control = $SubViewport/PanelContainer/NothingAvailable
@onready var List:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/List
@onready var Details:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/Details
@onready var Actions:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/Actions

enum LIST_TYPE {CONTAINED, AVAILABLE}

var filter_for_data:Dictionary = {} : 
	set(val):
		filter_for_data = val
		on_filter_for_data_update()

var list_type:LIST_TYPE = LIST_TYPE.AVAILABLE : 
	set(val):
		list_type = val
		on_list_type_update()

var assign_only:bool = false : 
	set(val):
		assign_only = val 
		on_assign_only_update()

var selected_scp_data:Dictionary = {}

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	BackBtn.onClick = func() -> void:
		on_back()
		
	AvailableTabBtn.onClick = func() -> void:
		list_type = LIST_TYPE.AVAILABLE
		
	ContainTabBtn.onClick = func() -> void:
		list_type = LIST_TYPE.CONTAINED
		
	List.onUpdate = func(scp_data:Dictionary) -> void:
		Details.data = scp_data
		Actions.data = scp_data
		selected_scp_data = scp_data
	
	Actions.onAction = func(action:ACTION.CONTAINED) -> void:
		user_response.emit({"action": action, "data": selected_scp_data})
	
			
	on_list_type_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_list_type_update() -> void:
	if !is_node_ready():return
	
	match list_type:
		LIST_TYPE.AVAILABLE:
			AvailableTabBtn.icon = SVGS.TYPE.DOT
			ContainTabBtn.icon = SVGS.TYPE.NONE
		list_type:
			AvailableTabBtn.icon = SVGS.TYPE.NONE
			ContainTabBtn.icon = SVGS.TYPE.DOT
	
	Actions.list_type = list_type	
	List.list_type = list_type
	Details.list_type = list_type
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_assign_only_update() -> void:
	if !is_node_ready():return
	
	if assign_only:
		list_type = LIST_TYPE.CONTAINED
		AvailableTabBtn.hide()
		ContainTabBtn.hide()
	else:
		AvailableTabBtn.show()
		ContainTabBtn.show()
		
	Actions.assign_only = assign_only
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_filter_for_data_update() -> void:
	if !is_node_ready() or filter_for_data.is_empty():return
	list_type = LIST_TYPE.AVAILABLE
	AvailableTabBtn.hide()
	ContainTabBtn.hide()
	
	List.filter_for_data = filter_for_data
	Actions.assign_only = true
# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------		
func check_for_reset() -> void:
	if scp_data.is_empty() or selected_scp_data.is_empty():return
	
	var reset:bool = scp_data.available_list.filter(func(i): return i.ref == selected_scp_data.ref).size() == 0
	if reset:
		List.on_reset()
# --------------------------------------------------------------------------------------------------		
		
# --------------------------------------------------------------------------------------------------		
func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
	if scp_data.is_empty():
		return
		
	NothingAvailable.show() if scp_data.available_list.size() == 0 and scp_data.contained_list.size() == 0 else NothingAvailable.hide()
	
	if selected_scp_data.is_empty():
		return
	
	check_for_reset()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_is_showing_update() -> void:
	if !is_node_ready():return
	super.on_is_showing_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func on_back() -> void:
	user_response.emit({"action": ACTION.CONTAINED.BACK})
	List.on_reset()
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
