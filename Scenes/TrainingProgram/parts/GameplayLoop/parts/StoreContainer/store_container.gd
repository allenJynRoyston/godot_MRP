extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnMarginContainer:MarginContainer = $BtnControl/MarginContainer
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList

@onready var UnlockBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/UnlockBtn
@onready var PurchaseBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/PurchaseBtn
@onready var PlacementBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/PlacementBtn
@onready var SelectTabBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/SelectTabBtn
@onready var BackBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn


@onready var Tabs:HBoxContainer = $HeaderControl/HeaderPanel/MarginContainer/Categories/Tabs
@onready var ActiveHeaderLabel:Label = $ActiveHeader/ActiveHeaderPanel/MarginContainer/HBoxContainer/ActiveHeaderLabel
@onready var GridContent:GridContainer = $MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer
@onready var ActiveHeaderPanel:PanelContainer = $ActiveHeader/ActiveHeaderPanel
@onready var HeaderPanel:PanelContainer = $HeaderControl/HeaderPanel
@onready var MainPanel:PanelContainer = $MainControl/MainPanel

@onready var DetailPanel:PanelContainer = $DetailControl/DetailPanel

enum MODE {HIDE, TAB_SELECT, CONTENT_SELECT, PLACEMENT}

const ShopMiniCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ShopMiniCard/ShopMiniCard.tscn")

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

var grid_list_data:Array

var control_pos:Dictionary
var is_setup:bool = false
var is_animating:bool = false 

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	SelectTabBtn.onClick = func() -> void:		
		if current_mode == MODE.TAB_SELECT:
			await U.tick()
			current_mode = MODE.CONTENT_SELECT
	
	UnlockBtn.onClick = func() -> void:
		if current_mode == MODE.CONTENT_SELECT:
			unlock_room()
	
	PurchaseBtn.onClick = func() -> void:
		if current_mode == MODE.CONTENT_SELECT:
			await U.tick()
			current_mode = MODE.PLACEMENT
		
	PlacementBtn.onClick = func() -> void:
		if current_mode == MODE.PLACEMENT:
			purchase_room()
			


	BackBtn.onClick = func() -> void:
		match current_mode:
			MODE.TAB_SELECT:
				user_response.emit({"action": ACTION.BACK})
			MODE.CONTENT_SELECT:
				await U.tick()
				current_mode = MODE.TAB_SELECT
			MODE.PLACEMENT:
				await U.tick()
				current_mode = MODE.CONTENT_SELECT
	
	for child in GridContent.get_children():
		child.queue_free()
		
	await U.set_timeout(1.0)	
	control_pos[HeaderPanel]  = {"show": HeaderPanel.position.y, "hide": HeaderPanel.position.y - HeaderPanel.size.y}
	control_pos[ActiveHeaderPanel] = {"show": ActiveHeaderPanel.position.x, "hide": ActiveHeaderPanel.position.x - ActiveHeaderPanel.size.x - 20}
	control_pos[MainPanel] = {"show": MainPanel.position.x, "hide": MainPanel.position.x - MainPanel.size.x - 20}
	control_pos[DetailPanel] = {"show": DetailPanel.position.x, "hide": DetailPanel.position.x + DetailPanel.size.x + 20}
	control_pos[BtnMarginContainer] = {"show": BtnMarginContainer.position.y, "hide": BtnMarginContainer.position.y + BtnMarginContainer.size.y}
	
	is_setup = true
	on_is_showing_update(true)
	on_tab_index_update()
	on_current_mode_update()	
	on_grid_index_update()	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func start() -> void:
	await U.tick()
	current_mode = MODE.TAB_SELECT
	
func end() -> void:
	current_mode = MODE.HIDE
	is_showing = false
	await on_is_showing_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func unlock_room() -> void:
	# ADD PROMPT
	var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
	if room_details.ref not in shop_unlock_purchases:
		shop_unlock_purchases.push_back(room_details.ref)
		
	SUBSCRIBE.resources_data = ROOM_UTIL.calculate_unlock_cost(room_details.ref)
	SUBSCRIBE.shop_unlock_purchases = shop_unlock_purchases
	
	await U.tick()
	on_grid_index_update()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func purchase_room() -> void:
	var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
	GameplayNode.add_timeline_item({
		"action": ACTION.AQ.BUILD_ITEM,
		"ref": room_details.ref,
		"title": room_details.name,
		"icon": SVGS.TYPE.BUILD,
		"completed_at": room_details.get_build_time.call(),
		"description": "CONSTRUCTING",
		"location": current_location.duplicate()
	})
	SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(room_details.ref)		
	await U.tick()
	
	on_grid_index_update()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if !is_node_ready():return
	match current_mode:
		MODE.PLACEMENT:	
			on_grid_index_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func on_tab_index_update() -> void:
	if !is_node_ready():return
	for index in Tabs.get_child_count():
		var node:Control = Tabs.get_child(index)
		node.is_selected = index == tab_index
		if index == tab_index:
			ActiveHeaderLabel.text = node.title		
			update_grid_content(index)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func update_grid_content(index:int = tab_index) -> void:

	match index:
		0:
			grid_list_data = ROOM_UTIL.get_paginated_list(TIER.VAL.ZERO, 0, 9, purchased_facility_arr).list
		1:
			grid_list_data = ROOM_UTIL.get_paginated_list(TIER.VAL.ONE, 0, 9, purchased_facility_arr).list
			
	for child in GridContent.get_children():
		child.queue_free()	
	
	for list_index in grid_list_data.size():
		var item:Dictionary = grid_list_data[list_index]
		var card_node:Control = ShopMiniCardPreload.instantiate()
		card_node.ref = item.ref
		card_node.index = list_index
		GridContent.add_child(card_node)
	
	grid_index = 0
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func can_afford_check(cost_arr:Array) -> bool:
	for item in cost_arr:				
		if abs(item.amount) > resources_data[item.resource.ref].amount:
			return false
	return true
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func on_grid_index_update() -> void:
	if !is_node_ready() or room_config.is_empty() or grid_index == -1:return
	var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
	var at_max_capacity:bool = ROOM_UTIL.at_own_limit(room_details.ref)
	print(at_max_capacity)

	match current_mode:
		# -----------
		MODE.CONTENT_SELECT:
			if room_details.requires_unlock:
				if room_details.ref not in shop_unlock_purchases:
					PurchaseBtn.hide()
					UnlockBtn.is_disabled = !can_afford_check( ROOM_UTIL.return_unlock_costs(room_details.ref) ) or at_max_capacity
					UnlockBtn.show()	
				else:
					PurchaseBtn.is_disabled = !can_afford_check( ROOM_UTIL.return_purchase_cost(room_details.ref) ) or at_max_capacity
					PurchaseBtn.show()
					UnlockBtn.hide()
			else:
				PurchaseBtn.is_disabled = !can_afford_check( ROOM_UTIL.return_purchase_cost(room_details.ref) ) or at_max_capacity
				PurchaseBtn.show()
				UnlockBtn.hide()
		# -----------
		MODE.PLACEMENT:
			var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
			var allow_build:bool = room_extract.is_room_empty and !room_extract.is_room_under_construction
			PlacementBtn.is_disabled = !allow_build or at_max_capacity
		_:
			PlacementBtn.is_disabled = false
	
	for index in GridContent.get_child_count():
		var card_node:Control = GridContent.get_child(index)
		card_node.is_highlighted = index == grid_index
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------	
func on_is_showing_update(fast:bool = false) -> void:
	super.on_is_showing_update()
	var duration:float = 0.02 if fast else 0.3
	if !is_setup:return
	
	if is_showing:
		self.modulate = Color(1, 1, 1, 1 if is_showing else 0)
	
	for btn in RightSideBtnList.get_children():
		btn.is_disabled = !is_showing
	
	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1 if is_showing else 0), duration)
	
	
	U.tween_node_property(BtnMarginContainer, "position:y", control_pos[BtnMarginContainer].show if is_showing else control_pos[BtnMarginContainer].hide, duration)
	U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].show if is_showing else control_pos[HeaderPanel].hide, duration)
	await U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].show if is_showing else control_pos[MainPanel].hide, duration)
	

	if !is_showing:
		self.modulate = Color(1, 1, 1, 1 if is_showing else 0)	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func on_current_mode_update() -> void:
	if !is_node_ready() or control_pos.is_empty():return
	is_animating = true
	match current_mode:
		# -------------------
		MODE.TAB_SELECT:
			PurchaseBtn.hide()
			UnlockBtn.hide()
			PlacementBtn.hide()
			SelectTabBtn.show()
			
			U.tween_node_property(DetailPanel, "position:x", control_pos[DetailPanel].hide)
			U.tween_node_property(ActiveHeaderPanel, "position:x", control_pos[ActiveHeaderPanel].hide)
			
			for index in GridContent.get_child_count():
				var card_node:Control = GridContent.get_child(index)
				card_node.is_highlighted = false
				card_node.is_selected = false
				card_node.is_deselected = false
					
			GridContent.modulate = Color(1, 1, 1, 0.5)			
			
			U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].show)
		# -------------------
		MODE.CONTENT_SELECT:			
			SelectTabBtn.hide()
			PlacementBtn.hide()

			GBL.find_node(REFS.ROOM_NODES).is_active = true
			GBL.find_node(REFS.ACTION_CONTAINER).set_backdrop_state(true)
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1) )
			U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].show)

			for index in GridContent.get_child_count():
				var card_node:Control = GridContent.get_child(index)
				card_node.is_highlighted = false
				card_node.is_selected = false
				card_node.is_deselected = false
			
			grid_index = grid_index if grid_list_data.size() >= 0 else -1			
			
			GridContent.modulate = Color(1, 1, 1, 1)			
			await U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].hide)
			U.tween_node_property(ActiveHeaderPanel, "position:x", control_pos[ActiveHeaderPanel].show)
			U.tween_node_property(DetailPanel, "position:x", control_pos[DetailPanel].show)
		# -------------------
		MODE.PLACEMENT:
			UnlockBtn.hide()
			PurchaseBtn.hide()
			PlacementBtn.show()
			
			for index in GridContent.get_child_count():
				var card_node:Control = GridContent.get_child(index)
				card_node.is_highlighted = false
				card_node.is_selected = false			
				card_node.is_deselected = index != grid_index
			
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			GBL.find_node(REFS.ACTION_CONTAINER).set_backdrop_state(false)
			await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0) )
			await U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].hide)
			
			on_grid_index_update()
		# -------------------
		
			
	await U.tick()
	is_animating = false
# --------------------------------------------------------------------------------------------------			



# -----------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs or is_animating: 
		return

	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"W":
			match current_mode:
				MODE.PLACEMENT:
					U.room_up()
					
		"S":
			match current_mode:
				MODE.PLACEMENT:
					U.room_down()
		"A":
			match current_mode:
				MODE.TAB_SELECT:
					tab_index = U.min_max(tab_index - 1, 0, Tabs.get_child_count() - 1, true)	
				MODE.CONTENT_SELECT:
					if grid_list_data.size() > 0:
						grid_index = U.min_max(grid_index - 1, 0, grid_list_data.size() - 1, true)
				MODE.PLACEMENT:
					U.room_left()
		"D":
			match current_mode:
				MODE.TAB_SELECT:
					tab_index = U.min_max(tab_index + 1, 0, Tabs.get_child_count() - 1, true)	
				MODE.CONTENT_SELECT:
					if grid_list_data.size() > 0:
						grid_index = U.min_max(grid_index + 1, 0, grid_list_data.size() - 1, true)	
				MODE.PLACEMENT:
					U.room_right()
	

#  -----------------------------------		
