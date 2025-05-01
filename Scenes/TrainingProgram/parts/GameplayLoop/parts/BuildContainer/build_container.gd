extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls
@onready var LessBtn:BtnBase = $MainControl/MainPanel/MarginContainer/VBoxContainer/HBoxContainer/LessBtn
@onready var MoreBtn:BtnBase = $MainControl/MainPanel/MarginContainer/VBoxContainer/HBoxContainer/MoreBtn

@onready var Tabs:HBoxContainer = $HeaderControl/HeaderPanel/MarginContainer/Categories/Tabs
@onready var GridContent:GridContainer = $MainControl/MainPanel/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/MarginContainer/GridContainer
@onready var MainPanel:PanelContainer = $MainControl/MainPanel

@onready var RoomMiniPanel:Control = $MiniCardControl/PanelContainer
@onready var RoomMiniMargin:MarginContainer = $MiniCardControl/PanelContainer/MarginContainer
@onready var RoomMiniCard:Control = $MiniCardControl/PanelContainer/MarginContainer/VBoxContainer/RoomMiniCard

@onready var CostResourceItem:Control = $MiniCardControl/PanelContainer/MarginContainer/VBoxContainer/CostResourceItem

@onready var SplashPanelContainer:PanelContainer = $SplashControl/SplashPanelContainer
@onready var SplashLabel:Label = $SplashControl/SplashPanelContainer/PanelContainer/MarginContainer/SplashLabel


@onready var DetailPanel:Control = $DetailPanel

enum MODE {HIDE, CONTENT_SELECT, PURCHASE}


var current_mode:MODE = MODE.HIDE : 
	set(val):
		current_mode = val
		on_current_mode_update()

var grid_index:int = 0 : 
	set(val):
		grid_index = val
		on_grid_index_update()

var has_more:bool = false
var grid_list_data:Array

var is_setup:bool = false
var is_animating:bool = false 

var page_tracker:int = 0

var grid_as_array:Array = [
	[0, 1, 2],
	[3, 4, 5],
	[6, 7, 8],
]


var await_confirm:bool = false
signal on_confirm
signal on_hide_complete

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	hide()
	self.modulate = Color(1, 1, 1, 0)
	BtnControls.onDirectional = on_key_press

	is_setup = true
	on_current_mode_update()	
	on_grid_index_update()	
	on_resources_data_update()

func start() -> void:
	await U.tick()
	current_mode = MODE.CONTENT_SELECT
	update_grid_content()
	
func end() -> void:	
	current_mode = MODE.HIDE
	await on_hide_complete
	user_response.emit()
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()	
	await U.tick()
	
	control_pos_default[MainPanel] = MainPanel.position
	control_pos_default[RoomMiniPanel] = RoomMiniPanel.position
	control_pos_default[SplashPanelContainer] = SplashPanelContainer.position

	update_control_pos()	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos() -> void:	
	await U.tick()

	control_pos[MainPanel] = {
		"show": control_pos_default[MainPanel].x, 
		"hide": control_pos_default[MainPanel].x - MainPanel.size.x
	}
	
	control_pos[RoomMiniPanel] = {
		"show": control_pos_default[RoomMiniPanel].x, 
		"hide": control_pos_default[RoomMiniPanel].x - RoomMiniMargin.size.x
	}	
	
	control_pos[SplashPanelContainer] = {
		"show": control_pos_default[SplashPanelContainer].y, 
		"hide": control_pos_default[SplashPanelContainer].y + SplashPanelContainer.size.y
	}	
	
	on_current_mode_update(true)
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------	
func purchase_room() -> void:	
	current_mode = MODE.PURCHASE
	var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
	SplashLabel.text = "Purchase %s?" % [room_details.name]
# --------------------------------------------------------------------------------------------------	



# --------------------------------------------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
	if !is_node_ready():return
	CostResourceItem.title = str(resources_data[RESOURCE.CURRENCY.MONEY].amount)
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------	
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if !is_node_ready():return
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func update_grid_content() -> void:
	var query:Dictionary
	var cards_on_screen:int = GridContent.get_child_count()
	var start_at:int = page_tracker * cards_on_screen

	query = ROOM_UTIL.get_all_unlocked_paginated_list(start_at, cards_on_screen)

	# reset show/hide more buttons	
	has_more = query.has_more
	MoreBtn.modulate = Color(1, 1, 1, 1 if has_more else 0) 
	MoreBtn.is_hoverable = has_more
	
	MoreBtn.onClick = func() -> void:
		page_tracker = page_tracker + 1
		update_grid_content()
	
	LessBtn.onClick = func() -> void:
		if page_tracker > 0:
			page_tracker = page_tracker - 1
			update_grid_content()	
			
	LessBtn.modulate = Color(1, 1, 1, 0 if page_tracker == 0 else 1) 
	LessBtn.is_hoverable = page_tracker > 0

	grid_list_data = query.list
	for n in GridContent.get_child_count():
		var card_node:Control = GridContent.get_child(n)		
		if grid_list_data.size() - 1 < n:
			card_node.ref = -1
			card_node.onHover = func() -> void: pass
			card_node.onClick = func() -> void: pass
			
		else:			
			var room_details:Dictionary = grid_list_data[n]
			var is_locked:bool = false

			if room_details.details.requires_unlock:		
				if room_details.ref not in shop_unlock_purchases:	
					is_locked = true
			
			card_node.index = n
			card_node.ref = room_details.ref
			card_node.is_hoverable = true
			
			#card_node.onHover = func() -> void:
				#if current_mode == MODE.CONTENT_SELECT:
					#grid_index = n
				
			card_node.onClick = func() -> void:
				if current_mode == MODE.CONTENT_SELECT:
					grid_index = n
					await U.tick()
					purchase_room()

						
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func on_grid_index_update() -> void:
	if !is_node_ready() or room_config.is_empty() or grid_index == -1 or grid_list_data.is_empty():return
	var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
	var at_max_capacity:bool = ROOM_UTIL.at_own_limit(room_details.ref)
	var cannot_afford:bool = room_details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount
	BtnControls.item_index = grid_index
	RoomMiniCard.ref = grid_list_data[grid_index].ref
	

	match current_mode:
		# -----------
		MODE.CONTENT_SELECT:
			DetailPanel.room_ref = grid_list_data[grid_index].ref
			BtnControls.disable_active_btn = at_max_capacity or cannot_afford

	if current_mode == MODE.CONTENT_SELECT:
		for index in GridContent.get_child_count():
			var card_node:Control = GridContent.get_child(index)
			card_node.is_highlighted = index == grid_index
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------		
var previous_grid_index:int = 0
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	is_animating = true
	var duration:float = 0 if skip_animation else 0.3
	
	match current_mode:
		# -------------------
		MODE.HIDE:
			BtnControls.freeze_and_disable(true)
			BtnControls.reveal(false)
			BtnControls.onBack = func() -> void:pass
			BtnControls.onAction = func() -> void:pass			
			
			DetailPanel.reveal(false)

			U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].hide, duration)
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0), duration)
			U.tween_node_property(RoomMiniPanel, "position:x", control_pos[RoomMiniPanel].hide, duration)	
			await U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].hide, duration)	
			
			on_hide_complete.emit()
		# -------------------
		MODE.CONTENT_SELECT:
			await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), duration )
			
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1), duration )
			U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].show, duration)
			U.tween_node_property(RoomMiniPanel, "position:x", control_pos[RoomMiniPanel].show, duration)	
			await BtnControls.reveal(true)
			await DetailPanel.reveal(true)

			BtnControls.directional_pref = "NONE"
			BtnControls.itemlist = GridContent.get_children()
			BtnControls.onBack = func() -> void:
				end()
			BtnControls.onAction = func() -> void:
				previous_grid_index = grid_index
			await U.tick()
			BtnControls.item_index = previous_grid_index
			
			on_grid_index_update()				
		# -------------------
		MODE.PURCHASE:
			BtnControls.itemlist = []
			
			BtnControls.onBack = func() -> void:
				await U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].hide)	
				current_mode = MODE.CONTENT_SELECT
				
			BtnControls.onAction = func() -> void:
				await U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].hide)	
				var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
				# update
				purchased_facility_arr.push_back({
					"ref": room_details.ref,
					"type_ref": room_details.type_ref,
					"location": current_location.duplicate()
				})
				
				SUBSCRIBE.purchased_facility_arr = purchased_facility_arr	
				SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(room_details.ref)		
				end()
							
			U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].show)	
		
			
	await U.tick()
	is_animating = false
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func has_valid_ref(index:int) -> bool:
	if index > GridContent.get_child_count() - 1 or index < 0:
		return false
	return GridContent.get_child(index).ref != -1
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func find_nearest_valid(start_at:int, reverse:bool = false) -> void:
	var nearest_val:int = GridContent.columns - 1
	
	for n in range(start_at + nearest_val, 0, -1) if reverse else [start_at - nearest_val, 8, 4, 0]:
		if has_valid_ref(n):
			grid_index = n
			break
# -----------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------
func on_key_press(key:String) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs or is_animating: 
		return
	
	var columns:int = GridContent.columns
		
	match key:
		"W":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in grid_as_array[0] and has_valid_ref(grid_index - columns):
						grid_index = grid_index - columns
					
		"S":
			match current_mode:
				MODE.CONTENT_SELECT:
					
					if grid_index not in grid_as_array[2] and has_valid_ref(grid_index + columns):
						grid_index = grid_index + columns

		"A":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in [0, 3, 6]:
						if has_valid_ref(grid_index - 1):
							grid_index = grid_index - 1
					elif page_tracker > 0:
						page_tracker = page_tracker - 1
						update_grid_content()
						find_nearest_valid(grid_index, true)
		"D":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in [2, 5, 8]:
						if has_valid_ref(grid_index + 1):
							grid_index = grid_index + 1
					elif has_more:
						page_tracker = page_tracker + 1
						update_grid_content()
						find_nearest_valid(grid_index, false)
# --------------------------------------------------------------------------------------------------
