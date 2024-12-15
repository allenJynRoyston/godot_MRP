@tool
extends GameContainer

@onready var CheckBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/CheckBtn

@onready var BuildBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/BuildBtn
@onready var ContainBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ContainBtn
@onready var RecruitBtn:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/RecruitBtn

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	var parentNode:Control = get_parent()
	
	BuildBtn.onClick = func() -> void:
		parentNode.current_shop_step = parentNode.SHOP_STEPS.START
	
	ContainBtn.onClick = func() -> void:
		parentNode.current_contain_step = parentNode.CONTAIN_STEPS.START
		
	RecruitBtn.onClick = func() -> void:
		parentNode.current_recruit_step = parentNode.RECRUIT_STEPS.START
# --------------------------------------------------------------------------------------------------		
