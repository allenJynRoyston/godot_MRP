extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls

@onready var CostResourceItem:Control = $MiniCardControl/PanelContainer/MarginContainer/VBoxContainer/CostResourceItem

@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var LessBtn:BtnBase = $MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/LessBtn
@onready var MoreBtn:BtnBase = $MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MoreBtn

@onready var Tabs:HBoxContainer = $HeaderControl/HeaderPanel/MarginContainer/Categories/Tabs
@onready var ActiveHeaderLabel:Label = $ActiveHeader/ActiveHeaderPanel/MarginContainer/HBoxContainer/ActiveHeaderLabel
@onready var GridContent:GridContainer = $MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer
@onready var ActiveHeaderPanel:PanelContainer = $ActiveHeader/ActiveHeaderPanel
@onready var ActiveHeaderMargin:MarginContainer = $ActiveHeader/ActiveHeaderPanel/MarginContainer
@onready var HeaderPanel:PanelContainer = $HeaderControl/HeaderPanel
@onready var MainPanel:PanelContainer = $MainControl/MainPanel

@onready var RoomMiniPanel:Control = $MiniCardControl/PanelContainer
@onready var RoomMiniMargin:MarginContainer = $MiniCardControl/PanelContainer/MarginContainer
@onready var RoomMiniCard:Control = $MiniCardControl/PanelContainer/MarginContainer/VBoxContainer/RoomMiniCard

@onready var SplashPanelContainer:PanelContainer = $SplashControl/SplashPanelContainer
@onready var SplashLabel:Label = $SplashControl/SplashPanelContainer/PanelContainer/MarginContainer/SplashLabel

@onready var DetailPanel:Control = $DetailPanel

@onready var TransitionScreen:Control = $TransistionScreen

enum MODE {HIDE, TAB_SELECT, CONTENT_SELECT, UNLOCK}

var current_mode:MODE = MODE.HIDE : 
	set(val):
		current_mode = val
		on_current_mode_update()

var tab_index:int = 0 : 
	set(val):
		tab_index = val
		on_tab_index_update()
		
var tab_btn_nodes:Array = []

var grid_index:int = 0 : 
	set(val):
		grid_index = val
		on_grid_index_update()

var has_more:bool = false
var grid_list_data:Array
var made_changes:bool = false
var is_animating:bool = false 
var made_a_purchase:bool = false

var page_tracker:Dictionary = {
	0:0,
	1:0,
	2:0
}

var grid_as_array:Array = [
	[0, 1, 2],
	[3, 4, 5],
	[6, 7, 8],
]

signal on_confirm

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
	BtnControls.onDirectional = on_key_press
	on_resources_data_update()	
	
func activate() -> void:
	await U.tick()
	control_pos_default[HeaderPanel] = HeaderPanel.position
	control_pos_default[ActiveHeaderPanel] = ActiveHeaderPanel.position
	control_pos_default[MainPanel] = MainPanel.position
	control_pos_default[SplashPanelContainer] = SplashPanelContainer.position
	control_pos_default[RoomMiniPanel] = RoomMiniPanel.position
	update_control_pos()
	
func start() -> void:
	await U.tick()
	current_mode = MODE.TAB_SELECT
	on_tab_index_update()
	on_grid_index_update()	
	update_grid_content()
	await TransitionScreen.start()
	
	
func end() -> void:
	current_mode = MODE.HIDE
	await hide_complete
	await TransitionScreen.end()
	user_response.emit(made_changes)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos() -> void:	
	await U.tick()

	control_pos[HeaderPanel]  = {
		"show": control_pos_default[HeaderPanel].y, 
		"hide": control_pos_default[HeaderPanel].y - HeaderPanel.size.y
	}
	control_pos[ActiveHeaderPanel] = {
		"show": control_pos_default[ActiveHeaderPanel].y, 
		"hide": control_pos_default[ActiveHeaderPanel].y - ActiveHeaderMargin.size.y
	}
	
	control_pos[MainPanel] = {
		"show": control_pos_default[MainPanel].y, 
		"hide": control_pos_default[MainPanel].y - MainPanel.size.y
	}

	control_pos[SplashPanelContainer] = {
		"show": control_pos_default[SplashPanelContainer].y, 
		"hide": control_pos_default[SplashPanelContainer].y + SplashPanelContainer.size.y
	}	

	control_pos[RoomMiniPanel] = {
		"show": control_pos_default[RoomMiniPanel].x, 
		"hide": control_pos_default[RoomMiniPanel].x - RoomMiniMargin.size.x
	}	
	
	on_current_mode_update(true)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func unlock_room() -> void:
	current_mode = MODE.UNLOCK
	var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
	SplashLabel.text = "Research %s?" % [room_details.name]
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func purchase_room() -> void:	
	var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
	SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(room_details.ref)		
	await U.tick()
	GameplayNode.ToastContainer.add("%s purchased!" % [room_details.name])
	made_a_purchase = true
	on_grid_index_update()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
	if !is_node_ready():return
	CostResourceItem.title = str(resources_data[RESOURCE.CURRENCY.SCIENCE].amount)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_tab_index_update() -> void:
	if !is_node_ready():return
	for index in Tabs.get_child_count():
		var tab:Control = Tabs.get_child(index)
		
		tab.onFocus = func(node:Control) -> void:
			if current_mode != MODE.TAB_SELECT:return
			tab.is_selected = true
			tab_index = index
			update_grid_content(index)
			
		tab.onBlur = func(node:Control) -> void:
			if current_mode != MODE.TAB_SELECT:return
			tab.is_selected = false
			
		tab.onClick = func() -> void:
			if current_mode != MODE.TAB_SELECT:return
			ActiveHeaderLabel.text = tab.title
			current_mode = MODE.CONTENT_SELECT
			
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func update_grid_content(index:int = tab_index) -> void:
	var query:Dictionary
	var grid_size:int = GridContent.get_child_count() 
	var start_at:int = page_tracker[index] * grid_size
	var end_at:int = start_at + grid_size
	
	match index:
		0:
			query = ROOM_UTIL.get_category(ROOM.CATEGORY.STANDARD, start_at, end_at)
		1:
			query = ROOM_UTIL.get_category(ROOM.CATEGORY.CONTAINMENT, start_at, end_at)
		2:
			query = ROOM_UTIL.get_category(ROOM.CATEGORY.SPECIAL, start_at, end_at)
	

	# reset show/hide more buttons	
	has_more = query.has_more
	MoreBtn.modulate = Color(1, 1, 1, 1 if has_more else 0) 
	MoreBtn.is_hoverable = has_more
	
	MoreBtn.onClick = func() -> void:
		page_tracker[index] = page_tracker[index] + 1
		update_grid_content()
	
	LessBtn.onClick = func() -> void:
		if page_tracker[index] > 0:
			page_tracker[index] = page_tracker[index] - 1
			update_grid_content()	
			
	LessBtn.modulate = Color(1, 1, 1, 0 if page_tracker[index] == 0 else 1) 
	LessBtn.is_hoverable = page_tracker[index] > 0

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
			if "requires_unlock" in room_details.details:
				if room_details.details.requires_unlock:		
					if room_details.ref not in shop_unlock_purchases:	
						is_locked = true
			
			card_node.index = n
			card_node.ref = room_details.ref
			card_node.is_hoverable = true
			
			#card_node.onHover = func() -> void:
				#if current_mode != MODE.CONTENT_SELECT:return
				#grid_index = n
				
			card_node.onClick = func() -> void:
				if current_mode != MODE.CONTENT_SELECT:return
				grid_index = n
				await U.tick()
				if room_details.ref not in shop_unlock_purchases:
					unlock_room()
	

# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func can_afford_check(cost:int) -> bool:
	return resources_data[RESOURCE.CURRENCY.MONEY].amount > abs(cost)
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func on_grid_index_update() -> void:
	if !is_node_ready() or room_config.is_empty() or grid_index == -1 or grid_list_data.is_empty():return
	var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
	BtnControls.item_index = grid_index
	
	DetailPanel.room_ref = grid_list_data[grid_index].ref
	if room_details.requires_unlock:
		if room_details.ref not in shop_unlock_purchases:
			BtnControls.disable_active_btn = !can_afford_check( ROOM_UTIL.return_unlock_costs(room_details.ref) )
		else:
			BtnControls.disable_active_btn = true
	else:
		BtnControls.disable_active_btn = true

	
	if current_mode == MODE.CONTENT_SELECT:
		for index in GridContent.get_child_count():
			var card_node:Control = GridContent.get_child(index)
			card_node.is_highlighted = index == grid_index
		
		RoomMiniCard.ref = grid_list_data[grid_index].ref
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------		
var previous_grid_index:int = 0
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	var duration:float = 0 if skip_animation else 0.3
	is_animating = true
	
	match current_mode:
		# -------------------
		MODE.HIDE:		
			U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].hide, duration)
			U.tween_node_property(RoomMiniPanel, "position:x", control_pos[RoomMiniPanel].hide, duration)	
			U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].hide, duration)	
			U.tween_node_property(ActiveHeaderPanel, "position:y", control_pos[ActiveHeaderPanel].hide, duration)

			DetailPanel.reveal(false)
			BtnControls.reveal(false)
			await U.tick()
			
			hide_complete.emit()
		# -------------------
		MODE.TAB_SELECT:			
			U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), duration)			
			
			U.tween_node_property(ActiveHeaderPanel, "position:y", control_pos[ActiveHeaderPanel].hide, duration)
			U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].show, duration)
			U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].hide, duration)
			U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].show, duration)
			U.tween_node_property(RoomMiniPanel, "position:x", control_pos[RoomMiniPanel].hide, duration)
			
			DetailPanel.reveal(false)
			
			BtnControls.reveal(true)
			BtnControls.itemlist = Tabs.get_children()
			BtnControls.directional_pref = "LR"
			BtnControls.disable_active_btn = false
			BtnControls.onBack = func() -> void:end()
			BtnControls.onAction = func() -> void:pass			
				
			await U.tick()
			
			BtnControls.item_index = tab_index			

			for n in GridContent.get_child_count():
				var card_node:Control = GridContent.get_child(n)			
				card_node.is_hoverable = false

		# -------------------
		MODE.CONTENT_SELECT:
			DetailPanel.reveal(true)
			
			BtnControls.directional_pref = "NONE"
			BtnControls.itemlist = GridContent.get_children()
			BtnControls.onBack = func() -> void:
				await U.tween_node_property(ActiveHeaderPanel, "position:y", control_pos[ActiveHeaderPanel].hide, duration)
				current_mode = MODE.TAB_SELECT
			BtnControls.onAction = func() -> void:
				previous_grid_index = grid_index
			await U.tick()
			BtnControls.item_index = previous_grid_index
			
			U.tween_node_property(RoomMiniPanel, "position:x", control_pos[RoomMiniPanel].show, duration)
			await U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].hide, duration)
			U.tween_node_property(ActiveHeaderPanel, "position:y", control_pos[ActiveHeaderPanel].show, duration)

			for n in GridContent.get_child_count():
				var card_node:Control = GridContent.get_child(n)
				card_node.is_hoverable = true			
		# -------------------
		MODE.UNLOCK:
			BtnControls.itemlist = []
			
			BtnControls.onBack = func() -> void:
				await U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].hide)	
				current_mode = MODE.CONTENT_SELECT
				
			BtnControls.onAction = func() -> void:
				await U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].hide)	
				var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
				if room_details.ref not in shop_unlock_purchases:
					shop_unlock_purchases.push_back(room_details.ref)

				ROOM_UTIL.calculate_unlock_cost(room_details.ref)
				SUBSCRIBE.shop_unlock_purchases = shop_unlock_purchases
				
				GameplayNode.ToastContainer.add("Unlocked %s!" % [room_details.name])
				
				current_mode = MODE.CONTENT_SELECT
				made_changes = true
							
			U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].show)	
		
			
	await U.tick()
	is_animating = false
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func has_valid_ref(index:int) -> bool:
	if index > GridContent.get_child_count() or index < 0:
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
# --------------------------------------------------------------------------------------------------				

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
					elif page_tracker[tab_index] > 0:
						page_tracker[tab_index] = page_tracker[tab_index] - 1
						update_grid_content()
						find_nearest_valid(grid_index, true)

		"D":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in [2, 5, 8]:
						if has_valid_ref(grid_index + 1):
							grid_index = grid_index + 1
					elif has_more:
						page_tracker[tab_index] = page_tracker[tab_index] + 1
						update_grid_content()
						find_nearest_valid(grid_index, false)

# --------------------------------------------------------------------------------------------------
