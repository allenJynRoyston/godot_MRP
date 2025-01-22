@tool
extends GameContainer

@onready var CheckBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/CheckBtn

@onready var BuildBtn:Control = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/BuildBtn
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
	
	BuildBtn.onClick = func() -> void:
		open_shop()
	
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

func open_shop() -> void:
	parentNode.current_shop_step = parentNode.SHOP_STEPS.START

func open_recruit() -> void:
	parentNode.current_recruit_step = parentNode.RECRUIT_STEPS.START

func open_contain() -> void:
	parentNode.current_contain_step = parentNode.CONTAIN_STEPS.START	

func open_researchers() -> void:
	parentNode.current_researcher_step = parentNode.RESEARCHERS_STEPS.START
# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_showing or parentNode.is_occupied():return
	var key:String = input_data.key
	var keycode:int = input_data.keycode

	match key:
		"ENTER":
			on_next_day()
		"B":
			open_shop()
		"E":
			open_researchers()
		"R":
			open_recruit()
		"C":
			open_contain()
			
# --------------------------------------------------------------------------------------------------	
