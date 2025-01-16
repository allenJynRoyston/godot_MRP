@tool
extends GameContainer

@onready var AvailableTabBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer3/HBoxContainer/AvailableTabBtn
@onready var ContainTabBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer3/HBoxContainer/ContainedTabBtn
@onready var BackBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/HBoxContainer3/BackBtn

@onready var List:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/List
@onready var Details:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/Details
@onready var Actions:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/Actions

enum LIST_TYPE {CONTAINED, AVAILABLE}

var list_type:LIST_TYPE = LIST_TYPE.AVAILABLE : 
	set(val):
		list_type = val
		on_list_type_update()

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
	
	Actions.onContain = func() -> void:
		user_response.emit({"action": ACTION.CONTAIN_START, "data": selected_scp_data})
	
	Actions.onReject = func() -> void:
		user_response.emit({"action": ACTION.CONTAIN_REJECT, "data": selected_scp_data})
	
	Actions.onCancelTransfer = func(action:int) -> void:
		user_response.emit({"action": action, "data": selected_scp_data})
		
	Actions.onTransfer = func() -> void:
		user_response.emit({"action": ACTION.TRANSFER_SCP_TO_NEW_LOCATION, "data": selected_scp_data})
	
	on_list_type_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_list_type_update() -> void:
	if !is_node_ready():return
	
	match list_type:
		LIST_TYPE.AVAILABLE:
			AvailableTabBtn.icon = SVGS.TYPE.DOT
			ContainTabBtn.icon = SVGS.TYPE.NONE
		LIST_TYPE.CONTAINED:
			AvailableTabBtn.icon = SVGS.TYPE.NONE
			ContainTabBtn.icon = SVGS.TYPE.DOT
	
	Actions.list_type = list_type	
	List.list_type = list_type
	Details.list_type = list_type
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
	if selected_scp_data.is_empty() or scp_data.is_empty():return
	check_for_reset()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_is_showing_update() -> void:
	if !is_node_ready():return
	super.on_is_showing_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func on_back() -> void:
	user_response.emit({"action": ACTION.BACK})
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
