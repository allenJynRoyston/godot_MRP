@tool
extends GameContainer

@onready var CheckBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/CheckBtn

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
	#var GameplayNode:Control = GBL.find_node(REFS.GAMEPLAY_LOOP)
	#
	#ReportBtn.title = "NEXT REPORT IN %s DAYS" % [progress_data.days_till_report] if !progress_data.show_report  else "VIEW REPORT"
	#ReportProgressBar.value = 1 - (progress_data.days_till_report / (GameplayNode.days_till_report_limit * 1.0))
	#ReportBtn.is_hoverable = progress_data.show_report	
	#
	#if previous_show_report != progress_data.show_report:
		#previous_show_report = progress_data.show_report
		#var new_stylebox:StyleBox = StyleBoxFlat.new() 
		#new_stylebox.bg_color =  Color(0, 0.529, 0.278) if !progress_data.show_report else Color(0.712, 0.207, 0)
		#ReportProgressBar.add_theme_stylebox_override('fill', new_stylebox)
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
