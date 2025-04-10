extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControlPanel:MarginContainer = $BtnControl/MarginContainer
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList

@onready var PurchaseBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/PurchaseBtn
@onready var PlacementBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/PlacementBtn
@onready var BackBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn
@onready var LessBtn:BtnBase = $MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/LessBtn
@onready var MoreBtn:BtnBase = $MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MoreBtn

@onready var Tabs:HBoxContainer = $HeaderControl/HeaderPanel/MarginContainer/Categories/Tabs
@onready var GridContent:GridContainer = $MainControl/MainPanel/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer
@onready var HeaderPanel:PanelContainer = $HeaderControl/HeaderPanel
@onready var MainPanel:PanelContainer = $MainControl/MainPanel

@onready var DetailPanel:PanelContainer = $DetailControl/DetailPanel

enum MODE {HIDE, CONTENT_SELECT, PLACEMENT}

const cards_on_screen:int = 4

@export var allow_placement:bool = false

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
	[0, 1, 2, 3],
	[4, 5, 6, 7],
	[8, 9, 10, 11],
]



var await_confirm:bool = false
signal on_confirm

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	PurchaseBtn.onClick = func() -> void:
		if current_mode == MODE.CONTENT_SELECT:
			await U.tick()
			current_mode = MODE.PLACEMENT
		
	PlacementBtn.onClick = func() -> void:
		if current_mode == MODE.PLACEMENT:
			purchase_room()
			if !allow_placement:
				end()
	
	BackBtn.onClick = func() -> void:
		match current_mode:
			MODE.CONTENT_SELECT:
				end()
			MODE.PLACEMENT:
				await U.tick()
				current_mode = MODE.CONTENT_SELECT
	

	await U.set_timeout(1.0)	

	
	is_setup = true
	on_current_mode_update()	
	on_grid_index_update()	

func start() -> void:
	await U.tick()
	current_mode = MODE.CONTENT_SELECT
	update_grid_content()
	
func end() -> void:	
	for btn in RightSideBtnList.get_children():
		btn.is_disabled = true	

	U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0))
	U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].hide)
	U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].hide)	
	U.tween_node_property(DetailPanel, "position:x", control_pos[DetailPanel].hide)
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide, 0.3, 0.3)
	
	current_mode = MODE.HIDE
	grid_index = 0
	
	user_response.emit()
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()

	control_pos_default[HeaderPanel] = HeaderPanel.position
	control_pos_default[MainPanel] = MainPanel.position
	control_pos_default[DetailPanel] = DetailPanel.position
	control_pos_default[BtnControlPanel] = BtnControlPanel.position
	
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
	
	control_pos[HeaderPanel]  = {
		"show": control_pos_default[HeaderPanel].y, 
		"hide": control_pos_default[HeaderPanel].y - HeaderPanel.size.y
	}

	control_pos[MainPanel] = {
		"show": control_pos_default[MainPanel].x, 
		"hide": control_pos_default[MainPanel].x - MainPanel.size.x - 20
	}
	
	control_pos[DetailPanel] = {
		"show": control_pos_default[DetailPanel].x,
		"hide": control_pos_default[DetailPanel].x + DetailPanel.size.x
	}

	control_pos[BtnControlPanel] = {
		"show": control_pos_default[BtnControlPanel].y + y_diff, 
		"hide": control_pos_default[BtnControlPanel].y + y_diff + BtnControlPanel.size.y
	}

	on_current_mode_update(true)
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------	
func purchase_room() -> void:	
	var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
	# update
	purchased_facility_arr.push_back({
		"ref": room_details.ref,
		"type_ref": room_details.type_ref,
		"location": current_location.duplicate()
	})
	SUBSCRIBE.purchased_facility_arr = purchased_facility_arr	
	SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(room_details.ref)		
	
	await U.tick()
	
	GameplayNode.ToastContainer.add("%s purchased!" % [room_details.name])
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
func update_grid_content() -> void:
	var query:Dictionary
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
							
		else:			
			var room_details:Dictionary = grid_list_data[n]
			var is_locked:bool = false

			if room_details.details.requires_unlock:		
				if room_details.ref not in shop_unlock_purchases:	
					is_locked = true
			
			card_node.index = n
			card_node.no_animation = true	
			card_node.flip = is_locked
			card_node.ref = room_details.ref
			
			card_node.onHover = func() -> void:
				if await_confirm:return
				match current_mode:
					MODE.CONTENT_SELECT:
						grid_index = n
				
			card_node.onClick = func() -> void:
				if await_confirm:return
				match current_mode:
					MODE.CONTENT_SELECT:
						grid_index = n
						await U.tick()
						current_mode = MODE.PLACEMENT
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
	if !is_node_ready() or room_config.is_empty() or grid_index == -1 or grid_list_data.is_empty():return
	var room_details:Dictionary = ROOM_UTIL.return_data(grid_list_data[grid_index].ref)
	var at_max_capacity:bool = ROOM_UTIL.at_own_limit(room_details.ref)
	
	match current_mode:
		# -----------
		MODE.CONTENT_SELECT:
			DetailPanel.ref = grid_list_data[grid_index].ref
	
		# -----------
		MODE.PLACEMENT:
			var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
			var allow_build:bool = room_extract.is_room_empty and !room_extract.is_room_under_construction
			PlacementBtn.is_disabled = !allow_build or at_max_capacity
		_:
			PlacementBtn.is_disabled = false
	
	if current_mode == MODE.CONTENT_SELECT:
		for index in GridContent.get_child_count():
			var card_node:Control = GridContent.get_child(index)
			card_node.is_highlighted = index == grid_index
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------		
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	is_animating = true
	var duration:float = 0 if skip_animation else 0.3
	match current_mode:
		# -------------------
		MODE.HIDE:
			for btn in RightSideBtnList.get_children():
				btn.is_disabled = true
					
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0), duration)
			U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide, duration)
			U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].hide, duration)
			U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].hide, duration)	
			U.tween_node_property(DetailPanel, "position:x", control_pos[DetailPanel].hide, duration)
		# -------------------
		MODE.CONTENT_SELECT:		
			for btn in RightSideBtnList.get_children():
				btn.is_disabled = true
							
			PurchaseBtn.show()	
			PlacementBtn.hide()

			#GBL.find_node(REFS.ROOM_NODES).is_active = true
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1), duration )
			U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].show, duration)

			for index in GridContent.get_child_count():
				var card_node:Control = GridContent.get_child(index)
				card_node.reset()
				card_node.is_deselected = false
			
			grid_index = grid_index if grid_list_data.size() >= 0 else -1			
			
			GridContent.modulate = Color(1, 1, 1, 1)			
			U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show, duration)
			await U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].hide, duration)
			U.tween_node_property(DetailPanel, "position:x", control_pos[DetailPanel].show, duration)
			for btn in RightSideBtnList.get_children():
				btn.is_disabled = false			
		# -------------------
		MODE.PLACEMENT:
			PurchaseBtn.hide()
			PlacementBtn.show()
			
			for index in GridContent.get_child_count():
				var card_node:Control = GridContent.get_child(index)
				card_node.is_highlighted = false
				card_node.is_selected = false			
				card_node.is_deselected = index != grid_index
			
			#GBL.find_node(REFS.ROOM_NODES).is_active = false
			U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0), duration )
			U.tween_node_property(MainPanel, "position:x", control_pos[MainPanel].hide, duration)
			
			on_grid_index_update()
		# -------------------
		
			
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
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs or is_animating: 
		return

	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"W":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in grid_as_array[0] and has_valid_ref(grid_index - 4):
						grid_index = grid_index - 4
				MODE.PLACEMENT:
					if allow_placement:
						U.room_up()
					
		"S":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in grid_as_array[2] and has_valid_ref(grid_index + 4):
						grid_index = grid_index + 4
				MODE.PLACEMENT:
					if allow_placement:
						U.room_down()
		"A":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in [0, 4, 8]:
						if has_valid_ref(grid_index - 1):
							grid_index = grid_index - 1
					elif page_tracker > 0:
						page_tracker = page_tracker - 1
						update_grid_content()
						find_nearest_valid(grid_index, true)
				MODE.PLACEMENT:
					if allow_placement:
						U.room_left()
		"D":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in [3, 7, 11]:
						if has_valid_ref(grid_index + 1):
							grid_index = grid_index + 1
					elif has_more:
						page_tracker = page_tracker + 1
						update_grid_content()
						find_nearest_valid(grid_index, false)
				MODE.PLACEMENT:
					if allow_placement:
						U.room_right()
# --------------------------------------------------------------------------------------------------
