extends GameContainer

@onready var MainPanel:PanelContainer = $Control2/PanelContainer

@onready var ResourceItemMoney:Control = $Control2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItemMoney
@onready var ResourceItemEnergy:Control = $Control2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItemEnergy
@onready var ResourceItemScience:Control = $Control2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItemScience

@onready var ResourceItemStaff:Control =  $Control2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItemStaff
@onready var ResourceItemSecurity:Control = $Control2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItemSecurity
@onready var ResourceItemDClass:Control = $Control2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItemDClass

@onready var DetailPanel:Control = $Control/DetailPanel

var control_pos:Dictionary
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
	
	DetailPanel.onFocus = func() -> void:
		detail_panel_is_focused = true
	
	DetailPanel.onBlur = func() -> void:
		detail_panel_is_focused = false
		
	# ResourceItemLeadResearchers, 
	for node in [ResourceItemMoney, ResourceItemEnergy, ResourceItemScience, ResourceItemStaff, ResourceItemSecurity, ResourceItemDClass]:
		node.onClick = func() -> void:
			if suppress_click:return
			match node:
				ResourceItemMoney:
					DetailPanel.show_details(RESOURCE.TYPE.MONEY)
				ResourceItemEnergy:
					DetailPanel.show_details(RESOURCE.TYPE.ENERGY)
				ResourceItemScience:
					DetailPanel.show_details(RESOURCE.TYPE.SCIENCE)					
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
				
	await U.set_timeout(1.0)
	control_pos[MainPanel] = {"show": MainPanel.position.y, "hide": MainPanel.position.y - MainPanel.size.y - 20}

# --------------------------------------------------------------------------------------------------

# -----------------------------------------------
func on_is_showing_update() -> void:	
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return
	print(control_pos)
	U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].show if is_showing else control_pos[MainPanel].hide, 0.7)
# -----------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_show_details_update() -> void:
	pass
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func open_detail_panel(node:Control) -> void:
	pass
	#DetailPanel.position.y = node.global_position.y + 100
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
			RESOURCE.TYPE.SCIENCE:
				ResourceItemScience.title = "%s" % [data.amount]

			RESOURCE.TYPE.STAFF:
				ResourceItemStaff.title = "%s/%s" % [data.amount, data.capacity]
			RESOURCE.TYPE.SECURITY:
				ResourceItemSecurity.title = "%s/%s" % [data.amount, data.capacity]
			RESOURCE.TYPE.DCLASS:
				ResourceItemDClass.title = "%s/%s" % [data.amount, data.capacity]
# --------------------------------------------------------------------------------------------------
