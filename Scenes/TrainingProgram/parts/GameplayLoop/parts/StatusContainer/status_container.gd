@tool
extends GameContainer

@onready var DayLabel:Label = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/VBoxContainer/DayLabel

@onready var ResourceItemMoney:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/ResourceItemMoney
@onready var ResourceItemEnergy:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/ResourceItemEnergy

@onready var ResourceItemStaff:Control =  $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/ResourceItemStaff
@onready var ResourceItemSecurity:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/ResourceItemSecurity
@onready var ResourceItemDClass:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer2/ResourceItemDClass

@onready var ReportBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/MarginContainer/ReportProgressContainer/ProgressBar/ReportBtn
@onready var ReportProgressLabel:Label = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/MarginContainer/ReportProgressContainer/ReportProgressLabel
@onready var ReportProgressBar:ProgressBar = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/PanelContainer/MarginContainer/ReportProgressContainer/ProgressBar

@onready var DetailPanel:Control = $Control/DetailPanel

var detail_panel_is_focused:bool = false
var detail_panel_is_busy:bool = false



# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	DetailPanel.onFocus = func() -> void:
		detail_panel_is_focused = true
	
	DetailPanel.onBlur = func() -> void:
		detail_panel_is_focused = false
	# ResourceItemLeadResearchers, 
	for node in [ResourceItemMoney, ResourceItemEnergy, ResourceItemStaff, ResourceItemSecurity, ResourceItemDClass]:
		node.onClick = func() -> void:
			if suppress_click:return
			match node:
				ResourceItemMoney:
					DetailPanel.show_details(RESOURCE.TYPE.MONEY)
				ResourceItemEnergy:
					DetailPanel.show_details(RESOURCE.TYPE.ENERGY)
				#ResourceItemLeadResearchers:
					#DetailPanel.show_details(RESOURCE.TYPE.LEAD_RESEARCHERS)
				ResourceItemStaff:
					DetailPanel.show_details(RESOURCE.TYPE.STAFF)
				ResourceItemSecurity:
					DetailPanel.show_details(RESOURCE.TYPE.SECURITY)
				ResourceItemDClass:
					DetailPanel.show_details(RESOURCE.TYPE.DCLASS)
					
			detail_panel_is_busy = true
			DetailPanel.show()
			open_detail_panel(node)
			await U.set_timeout(0.1)
			detail_panel_is_busy = false
		node.onDismiss = func() -> void:
			if detail_panel_is_busy:
				return
			if !detail_panel_is_focused and DetailPanel.is_visible_in_tree():
				DetailPanel.hide()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func on_progress_data_update(new_val:Dictionary = progress_data) -> void:
	progress_data = new_val
	if !is_node_ready():return
	DayLabel.text = "DAY %s" % [progress_data.day]
	
	ReportProgressLabel.text = "NEXT REPORT IN %s DAYS" % [progress_data.days_till_report] if progress_data.days_till_report > 0 else "REPORT READY"
	ReportBtn.title = "PREPARING REPORT..." if progress_data.days_till_report > 0 else "VIEW REPORT"
	ReportProgressBar.value = 1 - progress_data.days_till_report / 6.0
	ReportBtn.onClick = func() -> void:
		if progress_data.days_till_report == 0:
			var GameplayNode:Control = GBL.find_node(REFS.GAMEPLAY_LOOP)
			GameplayNode.current_summary_step = GameplayNode.SUMMARY_STEPS.START
			
	
# --------------------------------------------------------------------------------------------------			


# --------------------------------------------------------------------------------------------------
func open_detail_panel(node:Control) -> void:
	DetailPanel.position.y = node.global_position.y
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_purchased_facility_arr_update(new_val:Array = purchased_facility_arr) -> void:
	purchased_facility_arr = new_val
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_hired_lead_researchers_arr_update(new_val:Array = hired_lead_researchers_arr) -> void:
	hired_lead_researchers_arr = new_val
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
	if !is_node_ready() or resources_data.is_empty():return
	DetailPanel.resources_data = resources_data

	for key in resources_data:
		var data:Dictionary = resources_data[key]
		
		match key:
			RESOURCE.TYPE.MONEY:
				ResourceItemMoney.title = "%s" % [data.amount]
			RESOURCE.TYPE.ENERGY:
				ResourceItemEnergy.title = "%s" % [data.amount]
			#RESOURCE.TYPE.LEAD_RESEARCHERS:
				#ResourceItemLeadResearchers.title = "%s" % [data.amount]
			RESOURCE.TYPE.STAFF:
				ResourceItemStaff.title = "%s/%s" % [data.amount, data.capacity]
			RESOURCE.TYPE.SECURITY:
				ResourceItemSecurity.title = "%s/%s" % [data.amount, data.capacity]
			RESOURCE.TYPE.DCLASS:
				ResourceItemDClass.title = "%s/%s" % [data.amount, data.capacity]
# --------------------------------------------------------------------------------------------------
