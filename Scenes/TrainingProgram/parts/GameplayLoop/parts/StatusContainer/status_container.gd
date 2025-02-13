@tool
extends GameContainer

@onready var MainPanel:PanelContainer = $PanelContainer
@onready var DayLabel:Label = $PanelContainer/VBoxContainer/Status/MarginContainer/PanelContainer/HBoxContainer/VBoxContainer2/PanelContainer/DayLabel

@onready var ResourceItemMoney:Control = $PanelContainer/VBoxContainer/Resources/MarginContainer/HBoxContainer2/ResourceItemMoney
@onready var ResourceItemEnergy:Control = $PanelContainer/VBoxContainer/Resources/MarginContainer/HBoxContainer2/ResourceItemEnergy

@onready var ResourceItemStaff:Control =  $PanelContainer/VBoxContainer/Resources/MarginContainer/HBoxContainer2/ResourceItemStaff
@onready var ResourceItemSecurity:Control = $PanelContainer/VBoxContainer/Resources/MarginContainer/HBoxContainer2/ResourceItemSecurity
@onready var ResourceItemDClass:Control = $PanelContainer/VBoxContainer/Resources/MarginContainer/HBoxContainer2/ResourceItemDClass

@onready var DetailPanel:Control = $Control/DetailPanel

var detail_panel_is_focused:bool = false
var detail_panel_is_busy:bool = false
var show_details:bool = false : 
	set(val):
		show_details = val
		on_show_details_update()

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	on_show_details_update()

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
			show_details = true	
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
				show_details = false
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_show_details_update() -> void:
	pass
	#var AQNode:Control = GBL.find_node(REFS.ACTION_QUEUE_CONTAINER)
	#await U.tick()
	#AQNode.add_theme_constant_override("margin_top", MainPanel.global_position.y + MainPanel.size.y)	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func on_progress_data_update(new_val:Dictionary = progress_data) -> void:
	progress_data = new_val
	if !is_node_ready():return
	DayLabel.text = "DAY %s" % [progress_data.day]
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------
func open_detail_panel(node:Control) -> void:
	pass
	#DetailPanel.position.y = node.global_position.y + 100
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
