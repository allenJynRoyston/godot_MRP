@tool
extends GameContainer

@onready var CheckBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/CheckBtn

@onready var ContextBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ContextBtn
@onready var SCPBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/SCPBtn
@onready var RecruitBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/RecruitBtn
@onready var ResearchersBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ResearchersBtn
@onready var BuildBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/BuildBtn
@onready var NextBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/NextBtn
@onready var ObjectivesBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/ObjectivesBtn

#@onready var ReportBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer2/HBoxContainer/MarginContainer2/PanelContainer/MarginContainer/ReportProgressContainer/ProgressBar/ReportBtn
#@onready var ReportProgressBar:ProgressBar = $PanelContainer/HBoxContainer/PanelContainer2/HBoxContainer/MarginContainer2/PanelContainer/MarginContainer/ReportProgressContainer/ProgressBar

var parentNode:Control
var previous_show_report:bool = false

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	var GameplayNode:Control = GBL.find_node(REFS.GAMEPLAY_LOOP)
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	parentNode = get_parent()
	
	
	SCPBtn.onClick = func() -> void:
		open_contain()
		
	ResearchersBtn.onClick = func() -> void:
		open_researchers()
	
	RecruitBtn.onClick = func() -> void:
		open_recruit()

	NextBtn.onClick = func() -> void:
		on_next_day()
		
	ObjectivesBtn.onClick = func() -> void:
		pass
		
	#ReportBtn.onClick = func() -> void:
		#if !progress_data.show_report: return
		#GameplayNode = GBL.find_node(REFS.GAMEPLAY_LOOP)
		#GameplayNode.current_summary_step = GameplayNode.SUMMARY_STEPS.START			
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
	
func on_progress_data_update(new_val:Dictionary = progress_data) -> void:
	progress_data = new_val
	if !is_node_ready():return
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
	
	var nodes:Array = [ContextBtn, RecruitBtn, ResearchersBtn, SCPBtn]
	
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			ContextBtn.title = "INVESTIGATE"
		CAMERA.TYPE.ROOM_SELECT:
			ContextBtn.title = "BACK"
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
