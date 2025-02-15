@tool
extends GameContainer

@onready var ResourceItemMoney:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ResourceItemMoney
@onready var ResourceItemEnergy:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer/ResourceItemEnergy

@onready var ResourceItemLeadResearchers:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer2/ResourceItemLeadResearchers
@onready var ResourceItemStaff:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer2/ResourceItemStaff
@onready var ResourceItemSecurity:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer2/ResourceItemSecurity
@onready var ResourceItemDClass:Control = $SubViewport/PanelContainer/MarginContainer/HBoxContainer/HBoxContainer2/ResourceItemDClass

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
	
	for node in [ResourceItemMoney, ResourceItemEnergy, ResourceItemLeadResearchers, ResourceItemStaff, ResourceItemSecurity, ResourceItemDClass]:
		node.onClick = func() -> void:
			if suppress_click:return
			match node:
				ResourceItemMoney:
					DetailPanel.show_details(RESOURCE.TYPE.MONEY)
				ResourceItemEnergy:
					DetailPanel.show_details(RESOURCE.TYPE.ENERGY)
				ResourceItemLeadResearchers:
					DetailPanel.show_details(RESOURCE.TYPE.LEAD_RESEARCHERS)
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
func open_detail_panel(node:Control) -> void:
	var x_pos:float = (node.get_global_rect().position.x + node.get_global_rect().size.x/2)*1.0
	DetailPanel.position.x = x_pos - (DetailPanel.get_global_rect().size.x / 2)
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
			RESOURCE.TYPE.LEAD_RESEARCHERS:
				ResourceItemLeadResearchers.title = "%s" % [data.amount]
			RESOURCE.TYPE.STAFF:
				ResourceItemStaff.title = "%s%s/%s" % [data.amount, "/%s" % [data.utilized] if data.utilized > 0 else "",  data.capacity]
			RESOURCE.TYPE.SECURITY:
				ResourceItemSecurity.title = "%s%s/%s" % [data.amount, "/%s" % [data.utilized] if data.utilized > 0 else "",  data.capacity]
			RESOURCE.TYPE.DCLASS:
				ResourceItemDClass.title = "%s%s/%s" % [data.amount, "/%s" % [data.utilized] if data.utilized > 0 else "",  data.capacity]
# --------------------------------------------------------------------------------------------------
