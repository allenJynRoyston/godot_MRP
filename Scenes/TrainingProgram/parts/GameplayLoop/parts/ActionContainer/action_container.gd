extends GameContainer

@onready var ActiveMenu:PanelContainer = $Control/ActiveMenu
@onready var LeftSideBtnList:HBoxContainer = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList
@onready var RightSideBtnList:HBoxContainer = $PanelContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var Backdrop:ColorRect = $Backdrop

var KeyBtnPreload:PackedScene = preload("res://UI/Buttons/KeyBtn/KeyBtn.tscn")

var freeze_inputs_local:bool = false

var ref_btn:Control

var left_btn_list:Array = [] : 
	set(val):
		left_btn_list = val
		on_left_btn_list_update()

var right_btn_list:Array = [] : 
	set(val):
		right_btn_list = val
		on_right_btn_list_update()
		
# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	on_left_btn_list_update()
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
	
	# pull data, create the options list
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var is_testing:bool = !room_extract.scp.testing.is_empty() if !room_extract.scp.is_empty() else false		
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
		"is_disabled": is_testing or !can_take_action, 
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true				
			await GameplayNode.recruit()				
			ActiveMenu.freeze_inputs = false
	})
	
	options_list.push_back({
		"title": "RESEARCHER DETAILS",
		"is_disabled": is_testing or !can_take_action, 
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
func on_close_active_menu() -> void:
	set_btn_disabled_state(false)	
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------		
func open_room_menu() -> void:
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
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var is_testing:bool = !room_extract.scp.testing.is_empty() if !room_extract.scp.is_empty() else false		
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var options_list := []
	var room_is_empty:bool = room_extract.room.is_empty()	
	
	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
	})

	if room_is_empty:
		options_list.push_back({
			"title": "CONSTRUCT ROOM...",
			"is_disabled": is_testing or !can_take_action, 
			"onSelect": func() -> void:
				ActiveMenu.freeze_inputs = true				
				var response:Dictionary = await GameplayNode.construct_room(current_location.duplicate())				
				ActiveMenu.freeze_inputs = false
				if response.has_changes:
					open_room_menu()
		})							
	
	else:
		if room_extract.room.under_construction:
			options_list.push_back({
				"title": "CANCEL CONSTRUCTION",
				"onSelect": func() -> void:
					ActiveMenu.freeze_inputs = true			
					var response:Dictionary = await GameplayNode.cancel_construction(current_location.duplicate())
					ActiveMenu.freeze_inputs = false
					if response.has_changes:
						open_room_menu()
			})		

		else:
			if !room_extract.room.is_activated:
				options_list.push_back({
					"title": "ACTIVATE ROOM",
					"is_disabled": !room_extract.room.can_activate or is_testing or !can_take_action,
					"onSelect": func() -> void:
						ActiveMenu.freeze_inputs = true	
						var response:Dictionary =  await GameplayNode.activate_room(current_location.duplicate(), room_extract.room.details.ref, true)
						ActiveMenu.freeze_inputs = false
						if response.has_changes:
							open_room_menu()
				})		
			else:
				options_list.push_back({
					"title": "DEACTIVATE ROOM",
					"is_disabled": is_testing or !can_take_action,
					"onSelect": func() -> void:
						ActiveMenu.freeze_inputs = true	
						var response:Dictionary =  await GameplayNode.activate_room(current_location.duplicate(), room_extract.room.details.ref, false)
						ActiveMenu.freeze_inputs = false
						if response.has_changes:
							open_room_menu()
				})		
										
			options_list.push_back({
				"title": "DESTROY ROOM",
				"is_disabled": is_testing or !can_take_action,
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
		on_close_active_menu()
	
	# make room nodes active
	GBL.find_node(REFS.ROOM_NODES).is_active = true
	
	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	# pull data, create the options list
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var is_testing:bool = !room_extract.scp.testing.is_empty() if !room_extract.scp.is_empty() else false		
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var options_list := []
	var is_scp_empty:bool = room_extract.scp.is_empty()

	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
	})

	if is_scp_empty:
		options_list.push_back({
			"title": "ASSIGN SCP...",
			"is_disabled": !can_take_action,
			"onSelect": func() -> void:
				ActiveMenu.freeze_inputs = true
				var response:Dictionary = await GameplayNode.contain_scp(current_location.duplicate())
				ActiveMenu.freeze_inputs = false
				if response.has_changes:
					open_room_menu(),
		})		
	else:
		if room_extract.scp.is_transfer:
			options_list.push_back({
				"title": "CANCEL CONTAINMENT" if !room_extract.scp.is_contained else "CANCEL TRANSFER" ,
				"is_disabled": is_testing or !can_take_action,
				"onSelect": func() -> void:
					ActiveMenu.freeze_inputs = true
					var response:Dictionary = await GameplayNode.contain_scp_cancel(current_location.duplicate(), ACTION.AQ.CONTAIN if !room_extract.scp.is_contained else ACTION.ROOM_NODE.CANCEL_TRANSFER_SCP)
					ActiveMenu.freeze_inputs = false
					if response.has_changes:
						open_room_menu(),
			})		
		else:
			options_list.push_back({
				"title": "TRANSFER TO...",
				"is_disabled": is_testing or !can_take_action,
				"onSelect": func() -> void:
					ActiveMenu.freeze_inputs = true
					var response:Dictionary = await GameplayNode.transfer_scp(current_location.duplicate())
					ActiveMenu.freeze_inputs = false
					if response.has_changes:
						open_room_menu(),
			})	
			
			var testing:Dictionary = room_extract.scp.testing
			var can_test:bool = room_extract.researchers.size() > 0  
			
			if testing.is_empty():
				options_list.push_back({
					"title": "START TESTING",
					"is_disabled": !can_test or !can_take_action,
					"onSelect": func() -> void:
						ActiveMenu.freeze_inputs = true
						var response:Dictionary = await GameplayNode.set_scp_testing_state(current_location.duplicate(), true)
						ActiveMenu.freeze_inputs = false
						if response.has_changes:
							open_room_menu(),
				})		
			else:
				options_list.push_back({
					"title": "END TESTING",
					"is_disabled": !can_take_action,
					"onSelect": func() -> void:
						ActiveMenu.freeze_inputs = true
						var response:Dictionary = await GameplayNode.set_scp_testing_state(current_location.duplicate(), false)
						ActiveMenu.freeze_inputs = false
						if response.has_changes:
							open_room_menu(),
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
		on_close_active_menu()
	
	# make room nodes active
	GBL.find_node(REFS.ROOM_NODES).is_active = true
	
	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	# pull data, create the options list
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var is_testing:bool = !room_extract.scp.testing.is_empty() if !room_extract.scp.is_empty() else false		
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var options_list := []
	var is_scp_empty:bool = room_extract.scp.is_empty()

	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:	
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
	})

	options_list.push_back({
		"title": "ASSIGN RESEARCHER...",
		"is_disabled": is_testing or !can_take_action,
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var response:Dictionary = await GameplayNode.assign_researcher(current_location.duplicate())
			ActiveMenu.freeze_inputs = false
			if response.has_changes:
				open_room_menu(),
	})		
	
	if room_extract.researchers.size() > 0:
		for researcher in room_extract.researchers:
			options_list.push_back({
				"title": "REMOVE %s" % [researcher.name],
				"is_disabled": is_testing or !can_take_action,
				"onSelect": func() -> void:
					ActiveMenu.freeze_inputs = true
					var response:Dictionary = await GameplayNode.unassign_researcher(room_extract.researcher, room_extract.room_details)
					ActiveMenu.freeze_inputs = false
					if response.has_changes:
						open_room_menu(),
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
		GBL.find_node(REFS.ROOM_NODES).is_active = false	
		on_close_active_menu()
	
	# make room nodes active
	GBL.find_node(REFS.ROOM_NODES).is_active = true
	
	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	# pull data, create the options list
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var is_testing:bool = !room_extract.scp.testing.is_empty() if !room_extract.scp.is_empty() else false		
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var options_list := []
	var is_scp_empty:bool = room_extract.scp.is_empty()
	
	options_list.push_back({
		"title": "NORMAL",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), ROOM.EMERGENCY_MODES.NORMAL)
			ActiveMenu.freeze_inputs = false
			if response.has_changes:
				open_room_menu(),
	})		
						
	options_list.push_back({
		"title": "CAUTION",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), ROOM.EMERGENCY_MODES.CAUTION)
			ActiveMenu.freeze_inputs = false
			if response.has_changes:
				open_room_menu(),
	})
	
	options_list.push_back({
		"title": "WARNING",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), ROOM.EMERGENCY_MODES.WARNING)
			ActiveMenu.freeze_inputs = false
			if response.has_changes:
				open_room_menu(),
	})				

	
	options_list.push_back({
		"title": "DANGER",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), ROOM.EMERGENCY_MODES.DANGER)
			ActiveMenu.freeze_inputs = false
			if response.has_changes:
				open_room_menu(),
	})	

	ActiveMenu.options_list = options_list		
	await U.tick()
	ActiveMenu.size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, ref_btn.global_position.y - ActiveMenu.size.y - 10)	
	ActiveMenu.open()				
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
	await U.tick()
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			left_btn_list = [
				{
					"title": "PLANNING",
					"assigned_key": "TAB",
					"icon": SVGS.TYPE.TARGET,
					"onClick": toggle_camera_view
				},
				{
					"title": "HR",
					"assigned_key": "1",
					"icon": SVGS.TYPE.TARGET,
					"onClick": open_hr_menu
				},
				{
					"title": "SCP",
					"assigned_key": "2",
					"icon": SVGS.TYPE.TARGET,
					"onClick": open_scp_details
				},				
			]
			
			right_btn_list = [
				{
					"title": "NEXT DAY",
					"assigned_key": "ENTER",
					"icon": SVGS.TYPE.TARGET,
					"onClick": func() -> void:
						GameplayNode.next_day(),
				}
			]
			
		CAMERA.TYPE.ROOM_SELECT:
			left_btn_list = [
				{
					"title": "ADMIN",
					"assigned_key": "TAB",
					"icon": SVGS.TYPE.TARGET,
					"onClick": toggle_camera_view
				},				
				{
					"title": "ROOM",
					"assigned_key": "1",
					"icon": SVGS.TYPE.MONEY,
					"onClick": open_room_menu
				},
				{
					"title": "CONTAINMENT",
					"assigned_key": "2",
					"icon": SVGS.TYPE.CONTAIN,
					"onClick": open_scp_menu
				},
				{
					"title": "RESEARCHERS",
					"assigned_key": "3",
					"icon": SVGS.TYPE.CONTAIN,
					"onClick": open_researcher_menu
				},
				{
					"title": "TESTING",
					"assigned_key": "4",
					"icon": SVGS.TYPE.CONTAIN,
					"is_disabled": true,
					"onClick": open_researcher_menu
				},
				{
					"title": "ALARM",
					"assigned_key": "5",
					"icon": SVGS.TYPE.CAUTION,
					"onClick": open_alarm_setting
				},				
			]			
			
			right_btn_list = [
				{
					"title": "NEXT DAY",
					"assigned_key": "ENTER",
					"icon": SVGS.TYPE.TARGET,
					"onClick": func() -> void:
						GameplayNode.next_day(),
				}
			]			
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func set_btn_disabled_state(state:bool) -> void:
	for child in [LeftSideBtnList, RightSideBtnList]:
		for node in child.get_children():
			node.is_disabled = state
	freeze_inputs_local = state
	U.tween_node_property(Backdrop, 'color', Color(0, 0, 0, 0.4 if state else 0.0))

func on_left_btn_list_update() -> void:
	if !is_node_ready():return
	
	for node in LeftSideBtnList.get_children():
		node.queue_free()
	
	for item in left_btn_list:
		var new_btn:BtnBase = KeyBtnPreload.instantiate()
		new_btn.title = item.title
		new_btn.assigned_key = item.assigned_key
		new_btn.icon = item.icon
		new_btn.is_disabled = item.is_disabled if "is_disabled" in item else false
		new_btn.onClick = func() -> void:			
			ref_btn = new_btn
			item.onClick.call()
		
		LeftSideBtnList.add_child(new_btn)

func on_right_btn_list_update() -> void:
	if !is_node_ready():return
	
	for node in RightSideBtnList.get_children():
		node.queue_free()
	
	for item in right_btn_list:
		var new_btn:BtnBase = KeyBtnPreload.instantiate()
		new_btn.title = item.title
		new_btn.assigned_key = item.assigned_key
		new_btn.icon = item.icon
		new_btn.is_disabled = item.is_disabled if "is_disabled" in item else false
		new_btn.onClick = func() -> void:			
			ref_btn = new_btn
			item.onClick.call()
		
		RightSideBtnList.add_child(new_btn)
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
	if !is_showing or GameplayNode.is_occupied() or current_location.is_empty() or room_config.is_empty() or freeze_inputs or freeze_inputs_local:return
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
