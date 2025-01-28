@tool
extends GameContainer

@onready var CheckBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/CheckBtn

@onready var ContainBtn:Control = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ContainBtn
@onready var RecruitBtn:Control = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/RecruitBtn
@onready var ResearchersBtn:Control = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ResearchersBtn

@onready var NextBtn:Control = $PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/NextBtn

var parentNode:Control

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	parentNode = get_parent()
	
	ContainBtn.onClick = func() -> void:
		open_contain()
		
	RecruitBtn.onClick = func() -> void:
		open_recruit()
	
	ResearchersBtn.onClick = func() -> void:
		open_researchers()
	
	NextBtn.onClick = func() -> void:
		on_next_day()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_next_day() -> void:
	parentNode.next_day()

func open_recruit() -> void:
	parentNode.current_recruit_step = parentNode.RECRUIT_STEPS.START

func open_contain() -> void:
	parentNode.current_contain_step = parentNode.CONTAIN_STEPS.START	

func open_researchers() -> void:
	parentNode.current_researcher_step = parentNode.RESEARCHERS_STEPS.START
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			pass
		CAMERA.TYPE.ROOM_SELECT:
			pass
# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_showing or parentNode.is_occupied():return
	var key:String = input_data.key
	var keycode:int = input_data.keycode

	match key:
		"ENTER":
			on_next_day()
# --------------------------------------------------------------------------------------------------	
