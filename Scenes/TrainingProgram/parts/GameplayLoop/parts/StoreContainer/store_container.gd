extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls
#@onready var BtnControlPanel:MarginContainer = $BtnControl/MarginContainer
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList

#@onready var UnlockBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/UnlockBtn
#@onready var SelectTabBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/SelectTabBtn
#@onready var BackBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn
@onready var LessBtn:BtnBase = $MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/LessBtn
@onready var MoreBtn:BtnBase = $MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MoreBtn

@onready var Tabs:HBoxContainer = $HeaderControl/HeaderPanel/MarginContainer/Categories/Tabs
@onready var ActiveHeaderLabel:Label = $ActiveHeader/ActiveHeaderPanel/MarginContainer/HBoxContainer/ActiveHeaderLabel
@onready var GridContent:GridContainer = $MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer
@onready var ActiveHeaderPanel:PanelContainer = $ActiveHeader/ActiveHeaderPanel
@onready var HeaderPanel:PanelContainer = $HeaderControl/HeaderPanel
@onready var MainPanel:PanelContainer = $MainControl/MainPanel

@onready var SplashPanelContainer:PanelContainer = $SplashControl/SplashPanelContainer
@onready var SplashLabel:Label = $SplashControl/SplashPanelContainer/PanelContainer/MarginContainer/SplashLabel

@onready var DetailPanel:Control = $DetailPanel

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

var is_setup:bool = false
var is_animating:bool = false 
var made_a_purchase:bool = false

var page_tracker:Dictionary = {
	0:0,
	1:0,
	2:0
}

var grid_as_array:Array = [
	[0, 1, 2, 3],
	[4, 5, 6, 7],
	[8, 9, 10, 11],
]

signal on_confirm

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
		
	BtnControls.onDirectional = on_key_press
	
	#SelectTabBtn.onClick = func() -> void:		
		#if current_mode == MODE.TAB_SELECT:
			#await U.tick()
			#current_mode = MODE.CONTENT_SELECT
	
	#UnlockBtn.onClick = func() -> void:
		#if await_confirm:
			#on_confirm.emit(true)
			#return
			#
		#if current_mode == MODE.CONTENT_SELECT:
			#unlock_room()
#
	#BackBtn.onClick = func() -> void:
		#if await_confirm:
			#on_confirm.emit(false)
			#return
		#match current_mode:
			#MODE.TAB_SELECT:
				#user_response.emit(made_a_purchase)
			#MODE.CONTENT_SELECT:
				#await U.tick()
				#current_mode = MODE.TAB_SELECT
	
	is_setup = true
	on_current_mode_update(true)

func start() -> void:
	on_tab_index_update()
	on_current_mode_update(true)	
	on_grid_index_update()
	
	await U.tick()
	current_mode = MODE.TAB_SELECT
	
func end() -> void:
	BtnControls.reveal(false)
	DetailPanel.reveal(false)

	U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].hide)
	U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].hide)
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 0) )

	user_response.emit(true)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()

	control_pos_default[HeaderPanel] = HeaderPanel.position
	control_pos_default[ActiveHeaderPanel] = ActiveHeaderPanel.position
	control_pos_default[MainPanel] = MainPanel.position
	control_pos_default[SplashPanelContainer] = SplashPanelContainer.position
	
	update_control_pos()
	on_is_showing_update()
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
		"show": control_pos_default[ActiveHeaderPanel].x, 
		"hide": control_pos_default[ActiveHeaderPanel].x - ActiveHeaderPanel.size.x - 20
	}
	control_pos[MainPanel] = {
		"show": control_pos_default[MainPanel].x, 
		"hide": control_pos_default[MainPanel].x - MainPanel.size.x - 20
	}

	control_pos[SplashPanelContainer] = {
		"show": control_pos_default[SplashPanelContainer].y, 
		"hide": control_pos_default[SplashPanelContainer].y + SplashPanelContainer.size.y
	}	

	on_current_mode_update(true)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func unlock_room() -> void:
	current_mode = MODE.UNLOCK
	var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
	SplashLabel.text = "UNLOCK %s?" % [room_details.name]
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
func on_tab_index_update() -> void:
	if !is_node_ready():return
	for index in Tabs.get_child_count():
		var tab:Control = Tabs.get_child(index)
		
		tab.onFocus = func(node:Control) -> void:
			tab.is_selected = true
			tab_index = index
			update_grid_content(index)
			
		tab.onBlur = func(node:Control) -> void:
			tab.is_selected = false
			
		tab.onClick = func() -> void:
			ActiveHeaderLabel.text = tab.title
			current_mode = MODE.CONTENT_SELECT
			
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func update_grid_content(index:int = tab_index) -> void:
	var query:Dictionary
	var start_at:int = page_tracker[index] * 12
	var end_at:int = start_at + 12

	match index:
		0:
			query = ROOM_UTIL.get_paginated_list(TIER.VAL.ZERO, start_at, end_at)
		1:
			query = ROOM_UTIL.get_paginated_list(TIER.VAL.ONE, start_at, end_at)
		2:
			query = ROOM_UTIL.get_paginated_list(TIER.VAL.TWO, start_at, end_at)

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
			card_node.no_animation = true	
			card_node.ref = room_details.ref
			card_node.is_hoverable = true
			
			card_node.onHover = func() -> void:
				grid_index = n
				
			card_node.onClick = func() -> void:
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
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------	
func on_is_showing_update(fast:bool = false) -> void:
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return
	var duration:float = 0.02 if fast else 0.3
	if !is_setup:return
	
	if is_showing:
		self.modulate = Color(1, 1, 1, 1 if is_showing else 0)
	
	for btn in RightSideBtnList.get_children():
		btn.is_disabled = !is_showing

	#
	if !is_showing:
		self.modulate = Color(1, 1, 1, 1 if is_showing else 0)	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	var duration:float = 0 if skip_animation else 0.3
	is_animating = true
	
	
	match current_mode:
		# -------------------
		MODE.HIDE:
			BtnControls.freeze_and_disable(true)
			BtnControls.reveal(false)
			BtnControls.onBack = func() -> void:pass
			BtnControls.onAction = func() -> void:pass			
			
			DetailPanel.reveal(false)
						
			U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].hide, duration)
			U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].hide, duration)
			U.tween_node_property(ActiveHeaderPanel, "position:x", control_pos[ActiveHeaderPanel].hide, duration)
			U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].hide, duration)
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0), 0 )
		# -------------------
		MODE.TAB_SELECT:			
			U.tween_node_property(ActiveHeaderPanel, "position:x", control_pos[ActiveHeaderPanel].hide, duration)
			U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].show, duration)
			U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].hide, duration)
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1), 1 )
			U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].show, duration)
			
			DetailPanel.reveal(false)
			
			await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), duration)
			BtnControls.itemlist = Tabs.get_children()

			await BtnControls.reveal(true)
			
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
			BtnControls.directional_pref = "NONE"
			BtnControls.itemlist = GridContent.get_children()
			BtnControls.onBack = func() -> void:
				current_mode = MODE.TAB_SELECT
			BtnControls.onAction = func() -> void:pass
			
			DetailPanel.reveal(true)
			
			#if !skip_animation:
			GBL.find_node(REFS.ACTION_CONTAINER).set_backdrop_state(true)
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1) )
					
			U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].hide, 0 if skip_animation else 0.3)
			U.tween_node_property(ActiveHeaderPanel, "position:x", control_pos[ActiveHeaderPanel].show, 0 if skip_animation else 0.3)
			await U.tick()
			grid_index = grid_index if grid_list_data.size() >= 0 else -1			
			BtnControls.item_index = grid_index			
			
			for n in GridContent.get_child_count():
				var card_node:Control = GridContent.get_child(n)
				card_node.is_hoverable = true			
		# -------------------
		MODE.UNLOCK:
			BtnControls.itemlist = []
			
			BtnControls.onBack = func() -> void:
				current_mode = MODE.CONTENT_SELECT
				await U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].hide)	
				
			BtnControls.onAction = func() -> void:
				await U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].hide)	
				var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)

				if room_details.ref not in shop_unlock_purchases:
					shop_unlock_purchases.push_back(room_details.ref)

				SUBSCRIBE.resources_data = ROOM_UTIL.calculate_unlock_cost(room_details.ref)
				SUBSCRIBE.shop_unlock_purchases = shop_unlock_purchases
				
				GameplayNode.ToastContainer.add("Unlocked %s!" % [room_details.name])
				
				var card_node:Control = GridContent.get_child(grid_index)
				card_node.no_animation = false
				#card_node.flip = false
				#card_node.show_already_unlocked = true

				await U.tick()
				current_mode = MODE.CONTENT_SELECT
							
			U.tween_node_property(SplashPanelContainer, "position:y", control_pos[SplashPanelContainer].show)	
			await U.tick()
			BtnControls.item_index = 0	

			
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
	for n in range(start_at + 3, 0, -1) if reverse else [start_at - 3, 8, 4, 0]:
		if has_valid_ref(n):
			grid_index = n
			break
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------
func on_key_press(key:String) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs or is_animating: 
		return
		
	match key:
		"W":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in grid_as_array[0] and has_valid_ref(grid_index - 4):
						grid_index = grid_index - 4
					
		"S":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in grid_as_array[2] and has_valid_ref(grid_index + 4):
						grid_index = grid_index + 4

		"A":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in [0, 4, 8]:
						if has_valid_ref(grid_index - 1):
							grid_index = grid_index - 1
					elif page_tracker[tab_index] > 0:
						page_tracker[tab_index] = page_tracker[tab_index] - 1
						update_grid_content()
						find_nearest_valid(grid_index, true)

		"D":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in [3, 7, 11]:
						if has_valid_ref(grid_index + 1):
							grid_index = grid_index + 1
					elif has_more:
						page_tracker[tab_index] = page_tracker[tab_index] + 1
						update_grid_content()
						find_nearest_valid(grid_index, false)

# --------------------------------------------------------------------------------------------------
