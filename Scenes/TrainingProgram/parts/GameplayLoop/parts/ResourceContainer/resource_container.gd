extends GameContainer

@onready var ResourcePanel:MarginContainer = $Control2/ResourcePanel
@onready var ScpPanel:PanelContainer = $Control2/ScpPanel

@onready var DetailPanel:Control = $Control/DetailPanel

var detail_panel_is_focused:bool = false
var detail_panel_is_busy:bool = false
var scp_available:bool = false
var show_details:bool = false : 
	set(val):
		show_details = val
		on_show_details_update()

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	on_show_details_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()
	
	control_pos_default[ResourcePanel] = ResourcePanel.position
	
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos() -> void:	
	await U.tick()
	var h_diff:int = (1080 - 720) # difference between 1080 and 720 resolution - gives you 360
	var y_diff =  (0 if !GBL.is_fullscreen else h_diff) if !initalized_at_fullscreen else (0 if GBL.is_fullscreen else -h_diff)
	
	# for eelements in the top right
	control_pos[ResourcePanel] = {
		"show": control_pos_default[ResourcePanel].y, 
		"hide": control_pos_default[ResourcePanel].y - ResourcePanel.size.y
	}	
	
	on_is_showing_update(true)
# --------------------------------------------------------------------------------------------------	

# -----------------------------------------------
func on_is_showing_update(skip_animation:bool = false) -> void:	
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return
	U.tween_node_property(ResourcePanel, "position:y", control_pos[ResourcePanel].show if is_showing else control_pos[ResourcePanel].hide, 0 if skip_animation else 0.7)
# -----------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_show_details_update() -> void:
	pass
# --------------------------------------------------------------------------------------------------
#
## --------------------------------------------------------------------------------------------------
#func open_detail_panel(node:Control) -> void:
	#pass
	##DetailPanel.position.y = node.global_position.y + 100
## --------------------------------------------------------------------------------------------------	
#
## --------------------------------------------------------------------------------------------------	
#func on_scp_data_update(new_val:Dictionary) -> void:
	#super.on_scp_data_update(new_val)
	#if !is_node_ready():return
	#scp_available = scp_data.available_list.size() > 0	
	#if scp_available:
		#ScpPanel.ref = scp_data.available_list[0].ref
	#on_is_showing_update()
## --------------------------------------------------------------------------------------------------	
#
## --------------------------------------------------------------------------------------------------
#func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	#resources_data = new_val
	#if !is_node_ready() or resources_data.is_empty():return
	#DetailPanel.resources_data = resources_data
#
	#for key in resources_data:
		#var data:Dictionary = resources_data[key]
		#
		#match key:
			#RESOURCE.TYPE.MONEY:
				#ResourceItemMoney.title = "%s" % [data.amount]
			#RESOURCE.TYPE.ENERGY:
				#ResourceItemEnergy.title = "%s" % [data.amount]
			#RESOURCE.TYPE.SCIENCE:
				#ResourceItemScience.title = "%s" % [data.amount]
#
			#RESOURCE.TYPE.STAFF:
				#ResourceItemStaff.title = "%s/%s" % [data.amount, data.capacity]
			#RESOURCE.TYPE.SECURITY:
				#ResourceItemSecurity.title = "%s/%s" % [data.amount, data.capacity]
			#RESOURCE.TYPE.DCLASS:
				#ResourceItemDClass.title = "%s/%s" % [data.amount, data.capacity]
## --------------------------------------------------------------------------------------------------
