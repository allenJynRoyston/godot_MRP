extends GameContainer

@onready var ActiveMenu:PanelContainer = $Control/ActiveMenu
@onready var LeftSideBtnList:HBoxContainer = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList
@onready var RightSideBtnList:HBoxContainer = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var Backdrop:ColorRect = $Backdrop

var KeyBtnPreload:PackedScene = preload("res://UI/Buttons/KeyBtn/KeyBtn.tscn")

var disable_inputs_while_menu_is_open:bool = false
var previous_camera_type:int

var ref_btn:Control
var left_btn_list:Array = [] 
var right_btn_list:Array = []

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	for child in [RightSideBtnList, LeftSideBtnList]:
		for node in child.get_children():
			node.queue_free()	
	
	set_btn_disabled_state(false)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func toggle_camera_view() -> void:
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			camera_settings.type = CAMERA.TYPE.ROOM_SELECT
		CAMERA.TYPE.ROOM_SELECT:
			camera_settings.type = CAMERA.TYPE.FLOOR_SELECT
	SUBSCRIBE.camera_settings = camera_settings				
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_is_showing_update() -> void:
	super.on_is_showing_update()
	show() if is_showing else hide()
# --------------------------------------------------------------------------------------------------		
	

# --------------------------------------------------------------------------------------------------		
func on_close_active_menu() -> void:
	pass
	#set_btn_disabled_state(false)	
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------		
func open_hr_menu() -> void:
	# setup cloes behavior
	ActiveMenu.onClose = func() -> void:	
		GBL.find_node(REFS.ROOM_NODES).is_active = false	
		on_close_active_menu()
	
	# make room nodes active
	GBL.find_node(REFS.ROOM_NODES).is_active = true
	
	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	# update room_extract
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)	
	
	# local vars
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var options_list := []
	var room_is_empty:bool = room_extract.room.is_empty()	
	
	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
	})

	options_list.push_back({
		"title": "RECRUIT",
		"is_disabled": !can_take_action, 
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true				
			await GameplayNode.recruit()				
			ActiveMenu.freeze_inputs = false
	})
	
	options_list.push_back({
		"title": "RESEARCHER DETAILS",
		"is_disabled": !can_take_action, 
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true				
			await GameplayNode.open_researcher_details()
			ActiveMenu.freeze_inputs = false
	})	

	ActiveMenu.options_list = options_list			
	await U.tick()
	ActiveMenu.size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, ref_btn.global_position.y - ActiveMenu.size.y - 10)	
	ActiveMenu.open()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func open_scp_details() -> void:
	# setup cloes behavior
	ActiveMenu.onClose = func() -> void:	
		GBL.find_node(REFS.ROOM_NODES).is_active = false	
		on_close_active_menu()
	
	# make room nodes active
	GBL.find_node(REFS.ROOM_NODES).is_active = true
	
	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	
	# pull data, create the options list
	var options_list := []

	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
	})

	options_list.push_back({
		"title": "VIEW DETAILS",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true				
			await GameplayNode.view_scp_details()				
			ActiveMenu.freeze_inputs = false
	})
	

	ActiveMenu.options_list = options_list			
	await U.tick()
	ActiveMenu.size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, ref_btn.global_position.y - ActiveMenu.size.y - 10)	
	ActiveMenu.open()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------		
func open_room_menu() -> void:
	# setup cloes behavior
	ActiveMenu.onClose = func() -> void:	
		GBL.find_node(REFS.ROOM_NODES).is_active = false	
		set_btn_disabled_state(false)
	
	# make room nodes active
	GBL.find_node(REFS.ROOM_NODES).is_active = true
	
	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	# pull data, create the options list
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var room_is_empty:bool = room_extract.is_room_empty
	var is_room_under_construction:bool = room_extract.is_room_under_construction
	var is_room_active:bool = room_extract.is_room_active
	var room_category:int = room_extract.room_category
	var researchers_count:int = room_extract.researchers_count
	var is_scp_empty:bool = room_extract.is_scp_empty
	var options_list:Array = []
	
	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
			set_btn_disabled_state(false)
	})
	
	if room_is_empty:
		if !is_room_under_construction:
			options_list.push_back({
				"title": "CONSTRUCT ROOM...",
				"onSelect": func() -> void:
					ActiveMenu.freeze_inputs = true				
					var response:Dictionary = await GameplayNode.construct_room(current_location.duplicate())
					ActiveMenu.freeze_inputs = false
					if response.has_changes:
						open_room_menu()
			})
		else:
			options_list.push_back({
				"title": "CANCEL CONSTRUCTION",
				"onSelect": func() -> void:
					ActiveMenu.freeze_inputs = true			
					var response:Dictionary = await GameplayNode.cancel_construction(current_location.duplicate())
					ActiveMenu.freeze_inputs = false
					if response.has_changes:
						open_room_menu()
			})		

	if !room_is_empty:
		if !is_room_active:
			options_list.push_back({
				"title": "ACTIVATE ROOM",
				"onSelect": func() -> void:
					ActiveMenu.freeze_inputs = true	
					var response:Dictionary =  await GameplayNode.activate_room(current_location.duplicate(), room_extract.room.details.ref, true)
					ActiveMenu.freeze_inputs = false
					if response.has_changes:
						open_room_menu()
			})		
		else:
			options_list.push_back({
				"title": "DEACTIVATE ROOM" if researchers_count == 0 and is_scp_empty else "DEACTIVATE ROOM (ROOM IS BUSY)",
				"is_disabled": researchers_count > 0 or !is_scp_empty,
				"onSelect": func() -> void:
					ActiveMenu.freeze_inputs = true	
					var response:Dictionary =  await GameplayNode.activate_room(current_location.duplicate(), room_extract.room.details.ref, false)
					ActiveMenu.freeze_inputs = false
					if response.has_changes:
						open_room_menu()
			})				

		options_list.push_back({
			"title": "DESTROY AND CLEAR ROOM",
			"is_disabled": !is_scp_empty,
			"onSelect": func() -> void:
				ActiveMenu.freeze_inputs = true	
				var response:Dictionary = await GameplayNode.reset_room(current_location.duplicate())
				ActiveMenu.freeze_inputs = false	
				if response.has_changes:
					open_room_menu()
		})		

	ActiveMenu.options_list = options_list		
	await U.tick()
	ActiveMenu.size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, ref_btn.global_position.y - ActiveMenu.size.y - 10)	
	ActiveMenu.open()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func open_scp_menu() -> void:
	# setup cloes behavior
	ActiveMenu.onClose = func() -> void:	
		GBL.find_node(REFS.ROOM_NODES).is_active = false	
		set_btn_disabled_state(false)
	
	# make room nodes active
	GBL.find_node(REFS.ROOM_NODES).is_active = true
	
	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	# pull data, create the options list
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var room_is_empty:bool = room_extract.is_room_empty
	var is_room_under_construction:bool = room_extract.is_room_under_construction
	var is_room_active:bool = room_extract.is_room_active
	var room_category:int = room_extract.room_category
	var is_scp_empty:bool = room_extract.is_scp_empty
	var	is_scp_transfering:bool = room_extract.is_scp_transfering
	var is_scp_contained:bool = room_extract.is_scp_contained
	var researchers_count:int = room_extract.researchers_count	
	var options_list:Array = []
			
	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
			set_btn_disabled_state(false)
	})
	
	if is_scp_empty:
		options_list.push_back({
			"title": "ASSIGN SCP..." if researchers_count > 0 else "ASSIGN SCP (REQUIRES RESEARCHER)",
			"is_disabled": researchers_count == 0,
			"onSelect": func() -> void:
				ActiveMenu.freeze_inputs = true
				var response:Dictionary = await GameplayNode.contain_scp(current_location.duplicate())
				ActiveMenu.freeze_inputs = false
				if response.has_changes:
					open_scp_menu(),
		})		
		
	if is_scp_transfering:
		options_list.push_back({
			"title": "CANCEL CONTAINMENT",
			"onSelect": func() -> void:
				ActiveMenu.freeze_inputs = true
				var response:Dictionary = await GameplayNode.contain_scp_cancel(current_location.duplicate(), ACTION.AQ.CONTAIN)
				ActiveMenu.freeze_inputs = false
				if response.has_changes:
					open_scp_menu(),
		})							

	if is_scp_contained:
		if is_scp_transfering:
			options_list.push_back({
				"title": "CANCEL TRANSFER" ,
				"onSelect": func() -> void:
					ActiveMenu.freeze_inputs = true
					var response:Dictionary = await GameplayNode.contain_scp_cancel(current_location.duplicate(), ACTION.ROOM_NODE.CANCEL_TRANSFER_SCP)
					ActiveMenu.freeze_inputs = false
					if response.has_changes:
						open_scp_menu(),
			})
		else:
			options_list.push_back({
				"title": "TRANSFER TO...",
				"onSelect": func() -> void:
					ActiveMenu.freeze_inputs = true
					var response:Dictionary = await GameplayNode.transfer_scp(current_location.duplicate())
					ActiveMenu.freeze_inputs = false
					if response.has_changes:
						open_scp_menu(),
			})			

	options_list.push_back({
		"title": "UPGRADE",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var response:Dictionary = await GameplayNode.upgrade_scp(current_location.duplicate())
			ActiveMenu.freeze_inputs = false
			if response.has_changes:
				open_scp_menu(),
	})			

	ActiveMenu.options_list = options_list		
	await U.tick()
	ActiveMenu.size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, ref_btn.global_position.y - ActiveMenu.size.y - 10)	
	ActiveMenu.open()				
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------				
func open_researcher_menu() -> void:
	# setup cloes behavior
	ActiveMenu.onClose = func() -> void:	
		GBL.find_node(REFS.ROOM_NODES).is_active = false	
		set_btn_disabled_state(false)
	
	# make room nodes active
	GBL.find_node(REFS.ROOM_NODES).is_active = true
	
	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	# pull data, create the options list
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var room_is_empty:bool = room_extract.is_room_empty
	var researchers_count:int = room_extract.researchers_count
	var is_room_active:bool = room_extract.is_room_active
	var room_is_active
	
	var options_list := []
	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:	
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
			set_btn_disabled_state(false)
	})

	options_list.push_back({
		"title": "HIRE",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true				
			await GameplayNode.recruit()				
			ActiveMenu.freeze_inputs = false
			open_researcher_menu()
	})
	
	options_list.push_back({
		"title": "RESEARCHER DETAILS",		
		"is_disabled": hired_lead_researchers_arr.size() == 0,
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true				
			await GameplayNode.open_researcher_details()
			ActiveMenu.freeze_inputs = false
	})	

	options_list.push_back({
		"title": "ASSIGN RESEARCHER..." if is_room_active else "ASSIGN RESEARCHER (ROOM IS INACTIVE)",
		"is_disabled": !is_room_active or room_is_empty or researchers_count >= 2,
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var response:Dictionary = await GameplayNode.assign_researcher(current_location.duplicate())
			ActiveMenu.freeze_inputs = false
			if response.has_changes:
				open_researcher_menu(),
	})		
	
	for researcher in room_extract.researchers:
		options_list.push_back({
			"title": "REMOVE %s" % [researcher.name],
			"onSelect": func() -> void:
				ActiveMenu.freeze_inputs = true
				var response:Dictionary = await GameplayNode.unassign_researcher(researcher, room_extract.room.details)
				ActiveMenu.freeze_inputs = false
				if response.has_changes:
					open_researcher_menu(),
		})
				
	ActiveMenu.options_list = options_list		
	await U.tick()
	ActiveMenu.size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, ref_btn.global_position.y - ActiveMenu.size.y - 10)	
	ActiveMenu.open()				
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------
func open_alarm_setting() -> void:
	# setup cloes behavior
	ActiveMenu.onClose = func() -> void:			
		set_btn_disabled_state(false)

	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	# pull data, create the options list
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)	
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var options_list := []
	var is_scp_empty:bool = room_extract.scp.is_empty()
	
	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:
			ActiveMenu.close()
			set_btn_disabled_state(false)
	})	
	
	options_list.push_back({
		"title": "NORMAL",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), ROOM.EMERGENCY_MODES.NORMAL)
			ActiveMenu.freeze_inputs = false
			if response.has_changes:
				open_alarm_setting()
	})		
						
	options_list.push_back({
		"title": "CAUTION",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), ROOM.EMERGENCY_MODES.CAUTION)
			ActiveMenu.freeze_inputs = false
			if response.has_changes:
				open_alarm_setting()			
	})
	
	options_list.push_back({
		"title": "WARNING",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), ROOM.EMERGENCY_MODES.WARNING)
			ActiveMenu.freeze_inputs = false
			if response.has_changes:
				open_alarm_setting()			
	})	

	options_list.push_back({
		"title": "DANGER",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), ROOM.EMERGENCY_MODES.DANGER)
			ActiveMenu.freeze_inputs = false
			if response.has_changes:
				open_alarm_setting()	
	})	

	ActiveMenu.options_list = options_list		
	await U.tick()
	ActiveMenu.size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, ref_btn.global_position.y - ActiveMenu.size.y - 10)	
	ActiveMenu.open()				
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func auto_order() -> void:
	set_btn_disabled_state(true)
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var room_is_empty:bool = room_extract.is_room_empty
	var is_room_under_construction:bool = room_extract.is_room_under_construction
	var is_room_active:bool = room_extract.is_room_active
	var room_category:int = room_extract.room_category
	var researchers_count:int = room_extract.researchers_count
	var is_scp_empty:bool = room_extract.is_scp_empty
	
	# first add the room - either a containment cell or a facility
	if room_is_empty:
		if is_room_under_construction:
			await GameplayNode.cancel_construction(current_location.duplicate())
		else:
			await GameplayNode.construct_room(current_location.duplicate())
		set_btn_disabled_state(false)
		return
	
	# if it's not activated, activate it 
	if !is_room_active:
		await GameplayNode.activate_room(current_location.duplicate(), room_extract.room.details.ref, true)
		set_btn_disabled_state(false)
		return
		
	match room_category:
		# if it's a containment cell
		ROOM.CATEGORY.CONTAINMENT_CELL:
			# ... assign researcher first
			if researchers_count == 0:	
				await GameplayNode.assign_researcher(current_location.duplicate())
				set_btn_disabled_state(false)
				return	
						
			# then add an scp
			if is_scp_empty:
				await GameplayNode.contain_scp(current_location.duplicate())
				set_btn_disabled_state(false)
				return			
			
			# no other actions available
			set_btn_disabled_state(false)
			return							
			

		# if the room is a facility, add a researcher
		ROOM.CATEGORY.FACILITY:
			if researchers_count < 2:	
				await GameplayNode.assign_researcher(current_location.duplicate())
				set_btn_disabled_state(false)
				return	
			
			# no other actions available
			set_btn_disabled_state(false)
			return					
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	U.debounce("build_btns", buildout_btns)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	U.debounce("build_btns", buildout_btns)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	U.debounce("build_btns", buildout_btns)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func buildout_btns() -> void:
	if !is_node_ready() or camera_settings.is_empty() or room_config.is_empty() or current_location.is_empty() or freeze_inputs:return
	var end_of_turn_metrics_event_count:int = GameplayNode.end_of_turn_metrics_event_count()
	
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var room_is_empty:bool = room_extract.room.is_empty()	
	var is_room_under_construction:bool = room_extract.is_room_under_construction
	var can_contain:bool =  room_extract.room.can_contain if !room_extract.room.is_empty() else false	
	var room_step_complete:bool = !room_is_empty and !is_room_under_construction
	var room_category:int = room_extract.room_category
	var scp_is_empty:bool = room_extract.is_scp_empty
	#var scp_is_testing:bool = !room_extract.scp.testing.is_empty() if !scp_is_empty else false
	
	var new_right_btn_list:Array = [] 
	var new_left_btn_list:Array = []
	var reload:bool = false
	
	if camera_settings.type != previous_camera_type:
		previous_camera_type = camera_settings.type	
		reload = true
		
	
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			new_left_btn_list.push_back({
				"title": "PLANNING",
				"assigned_key": "TAB",
				"icon": SVGS.TYPE.TARGET,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						toggle_camera_view()
			})
			
			new_left_btn_list.push_back({
				"title": "UPGRADE",
				"assigned_key": "1",
				"icon": SVGS.TYPE.TARGET,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						open_hr_menu()
			})			
			
			new_left_btn_list.push_back({
				"title": "PROMOTE",
				"assigned_key": "2",
				"icon": SVGS.TYPE.TARGET,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						open_hr_menu()
			})
			
			new_left_btn_list.push_back({
				"title": "SCP",
				"assigned_key": "3",
				"icon": SVGS.TYPE.TARGET,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						open_scp_details()
			})
			
			# ---- RIGHT SIDE
			
			new_right_btn_list.push_back({
				"title": "NEXT (%s)" % [end_of_turn_metrics_event_count] if end_of_turn_metrics_event_count > 0 else "NEXT",
				"assigned_key": "ENTER",
				"icon": SVGS.TYPE.CAUTION if end_of_turn_metrics_event_count > 0 else SVGS.TYPE.NEXT,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						GameplayNode.next_day(),
			})
			
			
		CAMERA.TYPE.ROOM_SELECT:
			new_left_btn_list.push_back({
				"title": "ADMIN",
				"assigned_key": "TAB",
				"icon": SVGS.TYPE.TARGET,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
					
						toggle_camera_view()
			})
			
			new_left_btn_list.push_back({
				"title": "AUTO",
				"assigned_key": "E",
				"icon": SVGS.TYPE.TARGET,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied():  
						auto_order(),
			})						
			
			new_left_btn_list.push_back({
				"title": "FACILITY",
				"assigned_key": "1",
				"icon": SVGS.TYPE.MONEY,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						open_room_menu()
			})

			new_left_btn_list.push_back({
				"title": "RESEARCHER",
				"assigned_key": "2",
				"icon": SVGS.TYPE.CONTAIN,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						open_researcher_menu()
			})
			
			new_left_btn_list.push_back({
				"title": "CONTAINMENT",
				"assigned_key": "3",
				"is_hidden": room_category != ROOM.CATEGORY.CONTAINMENT_CELL,
				"icon": SVGS.TYPE.CONTAIN,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						open_scp_menu()
			})
			


			
			# ---- RIGHT SIDE
			new_right_btn_list.push_back({
				"title": "ALARM",
				"assigned_key": "X",
				"icon": SVGS.TYPE.CAUTION,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						open_alarm_setting()
			})
			
			
			new_right_btn_list.push_back({
				"title": "NEXT (%s)" % [end_of_turn_metrics_event_count] if end_of_turn_metrics_event_count > 0 else "NEXT",
				"assigned_key": "ENTER",
				"icon": SVGS.TYPE.CAUTION if end_of_turn_metrics_event_count > 0 else SVGS.TYPE.NEXT,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						GameplayNode.next_day(),
			})
	

	on_left_btn_list_update(new_left_btn_list, reload)
	on_right_btn_list_update(new_right_btn_list, reload)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func set_btn_disabled_state(state:bool) -> void:
	await U.tick() # DO NOT REMOVE
	for child in [LeftSideBtnList, RightSideBtnList]:
		for node in child.get_children():
			node.is_disabled = state
	disable_inputs_while_menu_is_open = state
	U.tween_node_property(Backdrop, 'color', Color(0, 0.1, 0, 0.4 if state else 0.0))

func on_left_btn_list_update(list:Array, reload:bool) -> void:
	if !is_node_ready():return
		
	if reload or LeftSideBtnList.get_child_count() != list.size():
		for node in LeftSideBtnList.get_children():
			U.tween_node_property(node, "modulate", Color(1, 1, 1, 0), 0.3)
		await U.set_timeout(0.5)
		for node in LeftSideBtnList.get_children():
			node.queue_free()
		
		for item in list:
			var new_btn:BtnBase = KeyBtnPreload.instantiate()
			new_btn.title = item.title
			new_btn.assigned_key = item.assigned_key
			new_btn.icon = item.icon
			new_btn.is_disabled = item.is_disabled if "is_disabled" in item else false
			new_btn.hide() if ("is_hidden" in item and item.is_hidden) else new_btn.show()
			new_btn.onClick = func() -> void:
				if !new_btn.is_disabled:
					ref_btn = new_btn
					item.onClick.call()
			
			LeftSideBtnList.add_child(new_btn)
	
	else:
		for index in list.size():
			var item:Dictionary = list[index]
			var btn_node:BtnBase = LeftSideBtnList.get_child(index)
			btn_node.title = item.title
			btn_node.icon = item.icon
			btn_node.is_disabled = (item.is_disabled if "is_disabled" in item else false) if !disable_inputs_while_menu_is_open else btn_node.is_disabled
			btn_node.hide() if ("is_hidden" in item and item.is_hidden) else btn_node.show()
	

func on_right_btn_list_update(list:Array, reload:bool) -> void:
	if !is_node_ready():return
	
	if reload or RightSideBtnList.get_child_count() != list.size():
		for node in RightSideBtnList.get_children():
			U.tween_node_property(node, "modulate", Color(1, 1, 1, 0), 0.3)
		await U.set_timeout(0.5)
		for node in RightSideBtnList.get_children():
			node.queue_free()
		
		for item in list:
			var new_btn:BtnBase = KeyBtnPreload.instantiate()
			new_btn.title = item.title
			new_btn.assigned_key = item.assigned_key
			new_btn.icon = item.icon
			new_btn.is_disabled = item.is_disabled if "is_disabled" in item else false
			new_btn.onClick = func() -> void:			
				ref_btn = new_btn
				item.onClick.call()
			
			RightSideBtnList.add_child(new_btn)
	else:
		for index in list.size():
			var item:Dictionary = list[index]
			var btn_node:BtnBase = RightSideBtnList.get_child(index)
			btn_node.title = item.title
			btn_node.icon = item.icon
			btn_node.is_disabled = (item.is_disabled if "is_disabled" in item else false) if !disable_inputs_while_menu_is_open else btn_node.is_disabled
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func room_up() -> void:
	var room_index:int = U.location_lookup(current_location.room, U.DIR.UP)
	if room_index == -1:
		if current_location.floor - 1 >= 0:
			var next_val:int = clampi(current_location.floor - 1, 0, room_config.floor.size() - 1)
			current_location.floor = next_val
			current_location.room = 4
	else:
		current_location.room = room_index	

func room_down() -> void:
	var room_index:int = U.location_lookup(current_location.room, U.DIR.DOWN)
	if room_index == -1:
		if current_location.floor + 1 < room_config.floor.size() - 1:
			var next_val:int = clampi(current_location.floor + 1, 0, room_config.floor.size() - 1)
			current_location.floor = next_val
			current_location.room = 4	
	else:
		current_location.room = room_index	

func room_right() -> void:
	var room_index:int = U.location_lookup(current_location.room, U.DIR.RIGHT)
	if room_index == -1:
		if current_location.ring < room_config.floor[current_location.floor].ring.size() - 1:
			var next_val:int = clampi(current_location.ring + 1, 0, room_config.floor[current_location.floor].ring.size() - 1)
			current_location.ring = next_val
			current_location.room = 4	
	else:
		current_location.room = room_index	

func room_left() -> void:
	var room_index:int = U.location_lookup(current_location.room, U.DIR.LEFT)
	if room_index == -1:
		if current_location.ring > 0:
			var next_val:int = clampi(current_location.ring - 1, 0, room_config.floor[current_location.floor].ring.size() - 1)
			current_location.ring = next_val
			current_location.room = 4
	else:
		current_location.room = room_index	
# --------------------------------------------------------------------------------------------------		
		
# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_showing or GameplayNode.is_occupied() or current_location.is_empty() or room_config.is_empty() or freeze_inputs or disable_inputs_while_menu_is_open:return
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"W":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					current_location.floor = clampi(current_location.floor - 1, 0, room_config.floor.size() - 1)
					SUBSCRIBE.current_location = current_location
				CAMERA.TYPE.ROOM_SELECT:
					room_up()
		"S":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					current_location.floor = clampi(current_location.floor + 1, 0, room_config.floor.size() - 1)
				CAMERA.TYPE.ROOM_SELECT:
					room_down()
		"D":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					current_location.ring = clampi(current_location.ring + 1, 0, 3)
				CAMERA.TYPE.ROOM_SELECT:
					room_right()
		"A":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					current_location.ring = clampi(current_location.ring - 1, 0, 3)				
				CAMERA.TYPE.ROOM_SELECT:
					room_left()
					
	SUBSCRIBE.current_location = current_location
# --------------------------------------------------------------------------------------------------	
