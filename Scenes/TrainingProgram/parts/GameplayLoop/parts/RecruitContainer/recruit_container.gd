@tool
extends GameContainer

enum TAB_OPTIONS {LEAD_RESEARCHERS, SUPPORT}

@onready var LeadBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnContainer/HBoxContainer3/LeadBtn
@onready var SupportBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnContainer/HBoxContainer3/SupportBtn
@onready var BackBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnContainer/BackBtn

@onready var LeadResearchPanel:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/LeadResearcherPanel
@onready var SupportPanel:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/SupportPanel

@onready var tab_open:TAB_OPTIONS = TAB_OPTIONS.LEAD_RESEARCHERS : 
	set(val):
		tab_open = val
		on_tab_open_update()
		
# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	LeadResearchPanel.addHire = func(data:Dictionary) -> void:
		user_response.emit({"action": ACTION.HIRE_LEAD, "data": data})		
	
	SupportPanel.addHire = func(data:Dictionary) -> void:
		user_response.emit({"action": ACTION.HIRE_SUPPORT, "data": data})		
	
	BackBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.BACK})		
		
	LeadBtn.onClick = func() -> void:
		tab_open = TAB_OPTIONS.LEAD_RESEARCHERS
		
	SupportBtn.onClick = func() -> void:
		tab_open = TAB_OPTIONS.SUPPORT
		
	on_tab_open_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_tab_open_update() -> void:
	if is_node_ready():
		match tab_open:
			TAB_OPTIONS.LEAD_RESEARCHERS:
				LeadResearchPanel.show()
				SupportPanel.hide()
			TAB_OPTIONS.SUPPORT:
				LeadResearchPanel.hide()
				SupportPanel.show()
		
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_showing:return
	var key:String = input_data.key
	var keycode:int = input_data.keycode

	match key:
		"BACK":
			user_response.emit({"action": ACTION.BACK})
		"B":
			user_response.emit({"action": ACTION.BACK})
# --------------------------------------------------------------------------------------------------	
