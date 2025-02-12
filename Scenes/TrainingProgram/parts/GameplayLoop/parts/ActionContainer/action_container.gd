extends GameContainer

@onready var LeftSideBtnList:HBoxContainer = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList
#
#@onready var CheckBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/CheckBtn
#
#@onready var ContextBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ContextBtn
#@onready var SCPBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/SCPBtn
#@onready var RecruitBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/RecruitBtn
#@onready var ResearchersBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ResearchersBtn
#@onready var BuildBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/BuildBtn
#@onready var NextBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/NextBtn
#@onready var ObjectivesBtn:BtnBase = $PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/ObjectivesBtn
#

var KeyBtnPreload:PackedScene = preload("res://UI/Buttons/KeyBtn/KeyBtn.tscn")

var left_btn_list:Array = [] : 
	set(val):
		left_btn_list = val
		on_left_btn_list_update()

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	on_left_btn_list_update()

	#SCPBtn.onClick = func() -> void:
		#open_contain()
		#
	#ResearchersBtn.onClick = func() -> void:
		#open_researchers()
	#
	#RecruitBtn.onClick = func() -> void:
		#open_recruit()
#
	#NextBtn.onClick = func() -> void:
		#on_next_day()
		#
	#ObjectivesBtn.onClick = func() -> void:
		#pass
		
	#ReportBtn.onClick = func() -> void:
		#if !progress_data.show_report: return
		#GameplayNode = GBL.find_node(REFS.GAMEPLAY_LOOP)
		#GameplayNode.current_summary_step = GameplayNode.SUMMARY_STEPS.START			
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
#func on_next_day() -> void:
	#GameplayNode.next_day()
#
#func open_recruit() -> void:
	#GameplayNode.current_recruit_step = GameplayNode.RECRUIT_STEPS.START
#
#func open_contain() -> void:
	#GameplayNode.current_contain_step = GameplayNode.CONTAIN_STEPS.START	
#
#func open_researchers() -> void:
	#GameplayNode.current_researcher_step = GameplayNode.RESEARCHERS_STEPS.START
	#
#func on_progress_data_update(new_val:Dictionary = progress_data) -> void:
	#progress_data = new_val
	if !is_node_ready():return
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
	
	#var nodes:Array = [ContextBtn, RecruitBtn, ResearchersBtn, SCPBtn]
	
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			left_btn_list = [
				{
					"title": "FLOOR LEVEL",
					"assigned_key": "TAB",
					"icon": SVGS.TYPE.TARGET,
					"onClick": func() -> void:
						print("tabbed!"),
				}
			]
			
			#ContextBtn.title = "INVESTIGATE"
		#CAMERA.TYPE.ROOM_SELECT:
			#ContextBtn.title = "BACK"
# --------------------------------------------------------------------------------------------------		


func on_left_btn_list_update() -> void:
	if !is_node_ready():return
	
	for node in LeftSideBtnList.get_children():
		node.queue_free()
	
	for item in left_btn_list:
		var new_btn:BtnBase = KeyBtnPreload.instantiate()
		new_btn.title = item.title
		new_btn.assigned_key = item.assigned_key
		new_btn.icon = item.icon
		new_btn.onClick = item.onClick
		LeftSideBtnList.add_child(new_btn)
## --------------------------------------------------------------------------------------------------	
#func on_control_input_update(input_data:Dictionary) -> void:
	#if !is_showing or parentNode.is_occupied():return
	#var key:String = input_data.key
	#var keycode:int = input_data.keycode
#
	#match key:
		#"ENTER":
			#on_next_day()
## --------------------------------------------------------------------------------------------------	
