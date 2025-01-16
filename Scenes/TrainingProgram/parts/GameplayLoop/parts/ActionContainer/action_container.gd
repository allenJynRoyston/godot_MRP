@tool
extends GameContainer

@onready var CheckBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/CheckBtn

@onready var BuildBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/BuildBtn
@onready var ContainBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ContainBtn
@onready var RecruitBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/RecruitBtn

@onready var NextBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/NextBtn

var parentNode:Control

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	parentNode = get_parent()
	
	BuildBtn.onClick = func() -> void:
		parentNode.current_shop_step = parentNode.SHOP_STEPS.START
	
	ContainBtn.onClick = func() -> void:
		parentNode.current_contain_step = parentNode.CONTAIN_STEPS.START
		
	RecruitBtn.onClick = func() -> void:
		parentNode.current_recruit_step = parentNode.RECRUIT_STEPS.START
	
	NextBtn.onClick = func() -> void:
		parentNode.next_day()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_showing or parentNode.is_occupied():return
	var key:String = input_data.key
	var keycode:int = input_data.keycode

	match key:
		"ENTER":
			parentNode.next_day()
		"B":
			parentNode.current_shop_step = parentNode.SHOP_STEPS.START
		"R":
			parentNode.current_recruit_step = parentNode.RECRUIT_STEPS.START
		"C":
			parentNode.current_contain_step = parentNode.CONTAIN_STEPS.START
# --------------------------------------------------------------------------------------------------	
