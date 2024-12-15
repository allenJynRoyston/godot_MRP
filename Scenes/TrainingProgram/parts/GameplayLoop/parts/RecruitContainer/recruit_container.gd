@tool
extends GameContainer

enum TAB_OPTIONS {LEAD_RESEARCHERS, SUPPORT}

@onready var LeadBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/LeadBtn
@onready var SupportBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer3/SupportBtn

@onready var NextBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnContainer/NextBtn
@onready var BackBtn:BtnBase = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnContainer/BackBtn

@onready var LeadResearchPanel:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/LeadResearcherPanel
@onready var SupportPanel:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/SupportPanel

@onready var tab_open:TAB_OPTIONS = TAB_OPTIONS.LEAD_RESEARCHERS : 
	set(val):
		tab_open = val
		on_tab_open_update()

signal user_response

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	NextBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.NEXT})		
		
	BackBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.BACK})		
		
	LeadBtn.onClick = func() -> void:
		tab_open = TAB_OPTIONS.LEAD_RESEARCHERS
		
	SupportBtn.onClick = func() -> void:
		tab_open = TAB_OPTIONS.SUPPORT
		
	on_tab_open_update()
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
