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

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	BackBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.BACK})
		
	AvailableTabBtn.onClick = func() -> void:
		list_type = LIST_TYPE.AVAILABLE
		
	ContainTabBtn.onClick = func() -> void:
		list_type = LIST_TYPE.CONTAINED
		
	List.onUpdate = func(scp_data:Dictionary) -> void:
		Details.data = scp_data
		Actions.data = scp_data
		
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
# --------------------------------------------------------------------------------------------------		
