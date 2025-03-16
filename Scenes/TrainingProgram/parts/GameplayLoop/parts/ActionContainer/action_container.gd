extends GameContainer

@onready var RootPanel:PanelContainer = $"."
@onready var BtnControlPanel:MarginContainer = $BtnControl/MarginContainer
@onready var ActiveMenu:PanelContainer = $Control/ActiveMenu
@onready var Details:Control = $Details
@onready var DetailsPanel:PanelContainer = $Details/PanelContainer

@onready var ActionBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ActionBtn
@onready var ToggleBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSide/ToggleBtn
@onready var ConfirmBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSide/ConfirmBtn
@onready var BackBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSide/BackBtn

@onready var Researchers:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/Researchers
@onready var ResearcherCount:Label = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/Researchers/HBoxContainer/ResearcherCount
@onready var ResearcherList:VBoxContainer = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/Researchers/ResearcherList
@onready var TraitContainer:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/TraitContainer
@onready var TraitList:VBoxContainer = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/TraitContainer/VBoxContainer/TraitList
@onready var SynergyContainer:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/SynergyContainer
@onready var SynergyTraitList:VBoxContainer = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/SynergyContainer/SynergyTraitList

@onready var ScpMiniCard:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/Room/ScpMiniCard
@onready var RoomMiniCard:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/Room/RoomMiniCard

@onready var RightSideContainer:PanelContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSide/ShortcutContainer
@onready var LeftSideContainer:PanelContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ShortcutContainer

@onready var LeftSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ShortcutContainer/VBoxContainer/MarginContainer/VBoxContainer2/LeftSideBtnList
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSide/ShortcutContainer/VBoxContainer/MarginContainer/VBoxContainer2/RightSideBtnList
@onready var CenterBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList
@onready var Backdrop:ColorRect = $Backdrop

enum MODE { SELECT_BASE, BACK_ONLY, CONFIRM_AND_BACK }

const KeyBtnPreload:PackedScene = preload("res://UI/Buttons/KeyBtn/KeyBtn.tscn")
const ResearcherMiniCard:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ResearcherMiniCard/ResearcherMiniCard.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")

var disable_inputs_while_menu_is_open:bool = false
var previous_camera_type:int
var current_mode:MODE = MODE.SELECT_BASE : 
	set(val):
		current_mode = val
		on_current_mode_update()

var ref_btn:Control
var center_btn_list:Array = []
var left_btn_list:Array = [] 
var right_btn_list:Array = []
var action_list_options:Array = []
var restore_state:Dictionary 
var bookmarked:Dictionary = {}
var active_menu_is_open:bool = false
var is_setup:bool = false
var enable_update_details:bool = false
var in_clear_mode:bool = false : 
	set(val):
		in_clear_mode = val
		if in_clear_mode:
			check_if_remove_is_valid()

var ability_level_index:int = 0

signal refresh_buttons

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.ACTION_CONTAINER, self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.ACTION_CONTAINER)
	
func _ready() -> void:
	super._ready()
	
	for child in [CenterBtnList, SynergyTraitList, TraitList]:
		for node in child.get_children():
			node.queue_free()	
			
	ActionBtn.onClick = func() -> void:
		ability_level_index = 0
		show_actions()
	
	ToggleBtn.onClick = func() -> void:
		show_toggles()
		
	ActiveMenu.onNext = func() -> void:
		ability_level_index = U.min_max(ability_level_index + 1, 0, 2, true)
		show_actions(true)
		
	ActiveMenu.onPrev = func() -> void:
		ability_level_index = U.min_max(ability_level_index - 1, 0, 2, true)
		show_actions(true)
	
	hide()	
	on_current_mode_update()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()
	
	control_pos_default[BtnControlPanel] = BtnControlPanel.position
	control_pos_default[DetailsPanel] = DetailsPanel.position

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
	var h_diff:int = (1080 - 720) # difference between 1080 and 720 resolution - gives you 360
	var y_diff =  (0 if !GBL.is_fullscreen else h_diff) if !initalized_at_fullscreen else (0 if GBL.is_fullscreen else -h_diff)
	
	# for elements in the bottom left corner
	control_pos[BtnControlPanel] = {
		"global": BtnControlPanel.global_position,
		"show": control_pos_default[BtnControlPanel].y, 
		"hide": control_pos_default[BtnControlPanel].y + BtnControlPanel.size.y
	}
	
	# for eelements in the top right
	control_pos[DetailsPanel] = {
		"show": control_pos_default[DetailsPanel].y, 
		"hide": control_pos_default[DetailsPanel].y - DetailsPanel.size.y
	}	
	
	if ref_btn != null:
		ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	
	BtnControlPanel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	on_is_showing_update(true)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func toggle_camera_view() -> void:
	#set_btn_disabled_state(true)
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide)
	

	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			camera_settings.type = CAMERA.TYPE.ROOM_SELECT
			current_mode = MODE.SELECT_BASE
		CAMERA.TYPE.ROOM_SELECT:
			camera_settings.type = CAMERA.TYPE.FLOOR_SELECT
			current_mode = MODE.SELECT_BASE
	
	SUBSCRIBE.camera_settings = camera_settings	
	
	await refresh_buttons
	BtnControlPanel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show)

# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_is_showing_update(skip_animation:bool = false) -> void:	
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return
		
	U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show if is_showing else control_pos[BtnControlPanel].hide, 0 if skip_animation else 0.3)
	U.tween_node_property(DetailsPanel, "position:y", control_pos[DetailsPanel].hide, 0.3 if !skip_animation else 0)

# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func get_menu_y_pos() -> int:
	return self.size.y - 60 - ActiveMenu.size.y
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func onSelect(index:int) -> void:
	await action_list_options[index].action.call()
# --------------------------------------------------------------------------------------------------				

# -------------------------------------------------------------------------------------------------				
func open_debug_menu() -> void:
	pass
	## setup cloes behavior
	#ActiveMenu.onClose = func() -> void:	
		#GBL.find_node(REFS.ROOM_NODES).is_active = false	
		#set_btn_disabled_state(false)
	#
	## make room nodes active
	#GBL.find_node(REFS.ROOM_NODES).is_active = true
	#
	## enable/disable buttons
	#ActiveMenu.freeze_inputs = false
	#set_btn_disabled_state(true)
	#
	## pull data, create the options list
	#var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	#var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	#var room_is_empty:bool = room_extract.is_room_empty
	#var researchers_count:int = room_extract.researchers_count
	#var is_room_active:bool = room_extract.is_activated
	#var room_is_active
	#
	#var options_list := []
	#options_list.push_back({
		#"title": "BACK",
		#"onSelect": func() -> void:	
			#GBL.find_node(REFS.ROOM_NODES).is_active = false
			#ActiveMenu.close()
			#await U.tick()
			#set_btn_disabled_state(false)
	#})
	#
	#options_list.push_back({
		#"title": "TRIGGER MORALE EVENT...",
		#"onSelect": func() -> void:
			#ActiveMenu.freeze_inputs = true
			#set_btn_disabled_state(true)
			#var props:Dictionary = {"onSelection": func(selected):print(selected), "current_location": current_location}
			#await GameplayNode.triggger_event(EVT.TYPE.MORALE, props)
			#ActiveMenu.freeze_inputs = false
			#restore_btn_disable_state()
	#})		
	#
	#options_list.push_back({
		#"title": "TRIGGER MORALE EVENT...",
		#"onSelect": func() -> void:
			#ActiveMenu.freeze_inputs = true
			#set_btn_disabled_state(true)
			#var props:Dictionary = {"onSelection": func(selected):print(selected), "current_location": current_location}
			#await GameplayNode.triggger_event(EVT.TYPE.MORALE, props)
			#ActiveMenu.freeze_inputs = false
			#restore_btn_disable_state()
	#})		
#
	#ActiveMenu.header = "DEBUG"
	#ActiveMenu.use_color = Color.WHITE
	#ActiveMenu.options_list = options_list		
	#await U.tick()
	#ActiveMenu.size = Vector2(1, 1)
	#ActiveMenu.custom_minimum_size = Vector2(1, 1)
	#ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	#ActiveMenu.open()
# --------------------------------------------------------------------------------------------------				

## --------------------------------------------------------------------------------------------------
#func open_alarm_setting() -> void:
	## setup cloes behavior
	#ActiveMenu.onClose = func() -> void:			
		#set_btn_disabled_state(false)
#
	## enable/disable buttons
	#ActiveMenu.freeze_inputs = false
	#set_btn_disabled_state(true)
	#
	## pull data, create the options list
	#var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)	
	#var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	#var options_list := []
	#var is_scp_empty:bool = room_extract.scp.is_empty()
	#
	#options_list.push_back({
		#"title": "BACK",
		#"onSelect": func() -> void:
			#ActiveMenu.close()
			#set_btn_disabled_state(false)
	#})	
	#
	#options_list.push_back({
		#"title": "NORMAL",
		#"onSelect": func() -> void:
			#ActiveMenu.freeze_inputs = true
			#var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), ROOM.EMERGENCY_MODES.NORMAL)
			#ActiveMenu.freeze_inputs = false
			#if response.has_changes:
				#open_alarm_setting()
	#})		
						#
	#options_list.push_back({
		#"title": "CAUTION",
		#"onSelect": func() -> void:
			#ActiveMenu.freeze_inputs = true
			#var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), ROOM.EMERGENCY_MODES.CAUTION)
			#ActiveMenu.freeze_inputs = false
			#if response.has_changes:
				#open_alarm_setting()			
	#})
	#
	#options_list.push_back({
		#"title": "WARNING",
		#"onSelect": func() -> void:
			#ActiveMenu.freeze_inputs = true
			#var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), ROOM.EMERGENCY_MODES.WARNING)
			#ActiveMenu.freeze_inputs = false
			#if response.has_changes:
				#open_alarm_setting()			
	#})	
#
	#options_list.push_back({
		#"title": "DANGER",
		#"onSelect": func() -> void:
			#ActiveMenu.freeze_inputs = true
			#var response:Dictionary = await GameplayNode.set_wing_emergency_mode(current_location.duplicate(), ROOM.EMERGENCY_MODES.DANGER)
			#ActiveMenu.freeze_inputs = false
			#if response.has_changes:
				#open_alarm_setting()	
	#})	
#
	#ActiveMenu.options_list = options_list		
	#await U.tick()
	#ActiveMenu.size = Vector2(1, 1)
	#ActiveMenu.global_position = Vector2(ref_btn.global_position.x, ref_btn.global_position.y - ActiveMenu.size.y - 10)	
	#ActiveMenu.open()				
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func use_ability(ability:Dictionary) -> void:
	var designation:String = str(current_location.floor, current_location.ring)
	var apply_cooldown:bool = await ability.effect.call(GameplayNode)
	
	if ability.name not in base_states.ring[designation].ability_on_cooldown:
		base_states.ring[designation].ability_on_cooldown[ability.name] = 0
			
	if apply_cooldown:
		base_states.ring[designation].ability_on_cooldown[ability.name] = ability.cooldown_duration
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func show_actions(skip_animation:bool = false) -> void:
	open_menu()
		
	action_list_options = []
	disable_inputs_while_menu_is_open = true
	# setup cloes behavior
	#set_btn_disabled_state(false, true)
	# pull data, create the options list
	var extract_wing_data:Dictionary = ROOM_UTIL.extract_wing_details()
	var designation:String = str(current_location.floor, current_location.ring)
	
	for room_ref in extract_wing_data.abilities:
		var abilities:Array = extract_wing_data.abilities[room_ref]

		for ability in abilities:
			if ability_level_index == ability.level:
				var cooldown_duration:int = 0
				if ability.details.name in base_states.ring[designation].ability_on_cooldown:
					cooldown_duration = base_states.ring[designation].ability_on_cooldown[ability.details.name]
				
				action_list_options.push_back({
					"bookmark_data": {"ref": room_ref, "ability_index": ability.index},
					"title": ability.details.name,
					"cooldown_duration": cooldown_duration, 
					"is_disabled": cooldown_duration != 0,
					"action": func() -> void:
						await use_ability(ability.details)
						show_actions(),
					"onSelect": onSelect
				})				

	ActiveMenu.ap_val = ability_level_index
	ActiveMenu.show_ap = true
	
	ActiveMenu.onClose = func() -> void:	
		disable_inputs_while_menu_is_open = false
		restore_menu()
		
	ActiveMenu.onBookmark = func(index:int, target:int) -> void:
		if target not in bookmarked[designation].actions:
			bookmarked[designation].actions[target] = {}
		if bookmarked[designation].actions[target].is_empty():
			bookmarked[designation].actions[target] = action_list_options[index].bookmark_data
		else:
			if bookmarked[designation].actions[target] == action_list_options[index].bookmark_data:
				bookmarked[designation].actions[target] = {}
			else:
				bookmarked[designation].actions[target] = action_list_options[index].bookmark_data
		build_action_shortcut(true)
			

	update_active_menu("ACTIONS", Color.WHITE, action_list_options, ActionBtn.global_position, skip_animation)	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func update_active_menu(header:String, color:Color, options_list:Array, btn_position:Vector2, skip_animation:bool) -> void:
	ActiveMenu.header = header
	ActiveMenu.use_color = color
	ActiveMenu.options_list = options_list		

	ActiveMenu.size.y = 1
	ActiveMenu.custom_minimum_size.y = 1	
	ActiveMenu.global_position = Vector2(btn_position.x, get_menu_y_pos())
	if !skip_animation:
		await U.tick()	
		ActiveMenu.open()	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func show_toggles() -> void:
	pass
	## setup cloes behavior
	#ActiveMenu.onClose = func() -> void:	
		#GBL.find_node(REFS.ROOM_NODES).is_active = false	
		#set_btn_disabled_state(false)
	#
	## make room nodes active
	#GBL.find_node(REFS.ROOM_NODES).is_active = true
	#
	## enable/disable buttons
	#ActiveMenu.freeze_inputs = false
	#set_btn_disabled_state(true)
	#
	## pull data, create the options list
	#var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	#var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	#var room_is_empty:bool = room_extract.is_room_empty
	#var researchers_count:int = room_extract.researchers_count
	#var is_room_active:bool = room_extract.is_activated
	#var room_is_active
	#
	#var options_list := []
	#options_list.push_back({
		#"title": "BACK",
		#"onSelect": func() -> void:	
			#GBL.find_node(REFS.ROOM_NODES).is_active = false
			#ActiveMenu.close()
			#set_btn_disabled_state(false)
	#})
	#
	#
	#ActiveMenu.header = "TOGGLE"
	#ActiveMenu.use_color = Color.WHITE
	#ActiveMenu.options_list = options_list		
	#await U.tick()
	#ActiveMenu.size = Vector2(1, 1)
	#ActiveMenu.custom_minimum_size = Vector2(1, 1)
	#ActiveMenu.global_position = Vector2(ToggleBtn.global_position.x, get_menu_y_pos())
	#ActiveMenu.open()	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	verify_available_actions()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	await U.set_timeout(0.3)
	U.debounce("build_btns", buildout_btns)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
var previous_designation:String
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if current_location.is_empty():return
	
	if enable_update_details:
		update_details()
	
	if in_clear_mode:
		check_if_remove_is_valid()
	
	if previous_designation != str(current_location.floor, current_location.ring):
		previous_designation = str(current_location.floor, current_location.ring)
		
		var designation:String = str(current_location.floor, current_location.ring)
		if designation not in bookmarked:
			bookmarked[designation] = {
				"actions": {},
				"togglebles": {}
			}		
			
		U.debounce("build_btns", buildout_btns)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func buildout_btns() -> void:
	if !is_node_ready() or camera_settings.is_empty() or room_config.is_empty() or current_location.is_empty():return

	var end_of_turn_metrics_event_count:int = GameplayNode.end_of_turn_metrics_event_count()
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var floor_is_powered:bool = room_extract.floor_config_data.is_powered

	var room_is_empty:bool = room_extract.room.is_empty()	
	var is_activated:bool = room_extract.is_activated
	var room_can_contain
	var is_room_under_construction:bool = room_extract.is_room_under_construction
	var can_contain:bool =  room_extract.can_contain
	var room_step_complete:bool = !room_is_empty and !is_room_under_construction
	var room_category:int = room_extract.room_category
	var scp_is_empty:bool = room_extract.is_scp_empty

	var new_right_btn_list:Array = [] 
	var new_left_btn_list:Array = []
	var new_center_btn_list:Array = []
	var reload:bool = false
	
	if camera_settings.type != previous_camera_type:
		previous_camera_type = camera_settings.type	
		reload = true

	new_center_btn_list.push_back({
		"title": "DESIGN" if camera_settings.type == CAMERA.TYPE.FLOOR_SELECT else "ADMIN",
		"assigned_key": "SPACEBAR",
		"icon": SVGS.TYPE.SETTINGS,
		"onClick": func() -> void:
			if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
				toggle_camera_view(),
	})	

	match camera_settings.type:
		# ------------------------------------
		CAMERA.TYPE.FLOOR_SELECT:			
			for node in [LeftSideContainer, RightSideContainer]:
				node.hide()
				
			new_center_btn_list.push_back({
				"title": "QUICKSAVE",
				"assigned_key": "F5",
				"icon": SVGS.TYPE.SAVE,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						GameplayNode.quicksave()
			})		

			new_center_btn_list.push_back({
				"title": "QUICKLOAD",
				"assigned_key": "F8",
				"icon": SVGS.TYPE.LOADING,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						GameplayNode.quickload()
			})	
	
		# ------------------------------------
		CAMERA.TYPE.ROOM_SELECT:	
			for node in [LeftSideContainer, RightSideContainer]:
				node.show()
							
			new_center_btn_list.push_back({
				"title": "CONSTRUCT",
				"assigned_key": "C",
				"icon": SVGS.TYPE.BUILD,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						GameplayNode.construct_room(),
			})	
			#
			new_center_btn_list.push_back({
				"title": "CLEAR",
				"assigned_key": "X",
				"icon": SVGS.TYPE.CLEAR,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						current_mode = MODE.CONFIRM_AND_BACK
						in_clear_mode = true
						
						await GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer, GameplayNode.RoomInfo])
						
						BackBtn.onClick = func() -> void:
							in_clear_mode = false
							current_mode = MODE.SELECT_BASE
							GameplayNode.restore_showing_state()
			})	

			new_center_btn_list.push_back({
				"assigned_key": "R",
				"title": "INVESTIGATE",
				"icon": SVGS.TYPE.QUESTION_MARK,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						enable_update_details = true
						current_mode = MODE.BACK_ONLY
						await GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer, GameplayNode.RoomInfo])
						U.tween_node_property(DetailsPanel, "position:y", control_pos[DetailsPanel].show)	
						
						BackBtn.onClick = func() -> void:
							enable_update_details = false
							current_mode = MODE.SELECT_BASE
							await U.tween_node_property(DetailsPanel, "position:y", control_pos[DetailsPanel].hide)	
							GameplayNode.restore_showing_state()
							
			})		
				
			new_center_btn_list.push_back({
				"title": "DEBUG",
				"assigned_key": "TAB",
				"icon": SVGS.TYPE.WARNING,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						open_debug_menu(),
			})	
	

	new_center_btn_list.push_back({
		"title": "NEXT",
		"assigned_key": "ENTER",
		"icon": SVGS.TYPE.NEXT,
		"onClick": func() -> void:
			if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
				GameplayNode.next_day(),
	})
			
	btn_list_update(CenterBtnList, new_center_btn_list, reload, func(): center_btn_list = new_center_btn_list)
	build_action_shortcut(false)
	
	is_setup = true
	await U.set_timeout(0.1)
	refresh_buttons.emit()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func verify_available_actions() -> void:
	if current_location.is_empty():return
	var designation:String = str(current_location.floor, current_location.ring)
	var extract_wing_data:Dictionary = ROOM_UTIL.extract_wing_details()  #TODO: replace this with current level
	
	var available_list:Array = []
	for room_ref in extract_wing_data.abilities:
		var abilities:Array = extract_wing_data.abilities[room_ref]
		for ability in abilities:
			available_list.push_back({"ref": room_ref, "ability_index": ability.index})
			
	U.debounce("build_btns", buildout_btns)
# --------------------------------------------------------------------------------------------------	
	
# --------------------------------------------------------------------------------------------------
func build_action_shortcut(is_disabled:bool) -> void:
	var designation:String = str(current_location.floor, current_location.ring)

	for index in LeftSideBtnList.get_child_count():		
		var btn:Control = LeftSideBtnList.get_child(index)
		# ------
		if index in bookmarked[designation].actions: 
			var bookmarked_data:Dictionary = bookmarked[designation].actions[index]
			# ------
			if bookmarked_data.is_empty():
				btn.title = "EMPTY"
				btn.icon = SVGS.TYPE.NONE
				btn.is_disabled = is_disabled
				btn.onClick = func() -> void:pass
			# ------
			else:
				var ability:Dictionary = ROOM_UTIL.return_ability(bookmarked_data.ref, bookmarked_data.ability_index)
				var cooldown_duration:int = 0
				if ability.name in base_states.ring[designation].ability_on_cooldown:
					cooldown_duration = base_states.ring[designation].ability_on_cooldown[ability.name]				
				btn.title = ability.name
				btn.icon = SVGS.TYPE.TARGET
				btn.is_disabled = is_disabled
				
				btn.check_disabled = func() -> bool:
					if ability.name in base_states.ring[designation].ability_on_cooldown:
						cooldown_duration = base_states.ring[designation].ability_on_cooldown[ability.name]
					return cooldown_duration > 0
					
				btn.onClick = func() -> void:
					await lock_menu()
					await use_ability(ability)
					unlock_menu()
		# ------
		else:
			btn.title = "EMPTY"
			btn.icon = SVGS.TYPE.NONE
			btn.is_disabled = is_disabled
			btn.onClick = func() -> void:pass
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func set_backdrop_state(state:bool) -> void:
	await U.tween_node_property(Backdrop, 'color', Color(0, 0.1, 0, 0.4 if state else 0.0))	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func lock_menu() -> void:
	disable_inputs_while_menu_is_open = true
	for node in [LeftSideBtnList, RightSideBtnList, CenterBtnList]:
		for child in node.get_children():
			child.is_disabled = true 
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide)
	
func unlock_menu() -> void:
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show)	
	disable_inputs_while_menu_is_open = false
	for node in [LeftSideBtnList, RightSideBtnList, CenterBtnList]:
		for child in node.get_children():
			child.is_disabled = child.check_disabled.call()
	
	
func open_menu() -> void:	
	active_menu_is_open = true
	await U.tick() # DO NOT REMOVE
	
	for btn in [ActionBtn, ToggleBtn]:
		btn.is_disabled = true
		
	for node in [LeftSideBtnList, RightSideBtnList, CenterBtnList]:
		for child in node.get_children():
			child.is_disabled = true 
	
	ActiveMenu.freeze_inputs = false
	set_backdrop_state(true)	
	

func restore_menu() -> void:
	await U.tick()	
	
	for btn in [ActionBtn, ToggleBtn]:
		btn.is_disabled = false
		
	for node in [LeftSideBtnList, RightSideBtnList, CenterBtnList]:
		for child in node.get_children():
			child.is_disabled = child.check_disabled.call() 
		

	ActiveMenu.freeze_inputs = true
	set_backdrop_state(false)	
	active_menu_is_open = false

		
func btn_list_update(container:Control, new_list:Array, reload:bool, callback:Callable) -> void:
	if !is_node_ready():return

	if reload or container.get_child_count() != new_list.size():
		await U.tick()
		for node in container.get_children():
			node.queue_free()
			
		for item in new_list:
			var new_btn:BtnBase = KeyBtnPreload.instantiate()
			new_btn.title = item.title
			new_btn.assigned_key = item.assigned_key
			new_btn.icon = item.icon
			new_btn.is_disabled = item.is_disabled if "is_disabled" in item else false
			new_btn.size_flags_vertical = Control.SIZE_SHRINK_END
			new_btn.hide() if ("is_hidden" in item and item.is_hidden) else new_btn.show()
			
			new_btn.onFocus = func(_node:Control) -> void:
				ref_btn = new_btn
			
			new_btn.onClick = func() -> void:
				ref_btn = new_btn
				item.onClick.call()
				
			container.add_child(new_btn)
			
		callback.call()
	else:
		for index in new_list.size():
			var item:Dictionary = new_list[index]
			var btn_node:BtnBase = container.get_child(index)
			var is_disabled_state:bool = new_list[index].is_disabled if "is_disabled" in new_list[index] else false
			btn_node.title = item.title
			btn_node.icon = item.icon
			#btn_node.is_disabled = (item.is_disabled if "is_disabled" in item else false) if !disable_inputs_while_menu_is_open else btn_node.is_disabled
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_mode_update() -> void:
	if !is_node_ready():return	
	
	if !control_pos.is_empty():
		await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide)
		
	match current_mode:
		# --------------
		MODE.SELECT_BASE:
			for btn in [ConfirmBtn, BackBtn]:
				btn.hide()
			for btn in [ActionBtn, ToggleBtn, CenterBtnList, RightSideContainer, LeftSideContainer]:
				btn.show()
		# --------------
		MODE.BACK_ONLY:
			for btn in [ActionBtn, ToggleBtn, CenterBtnList, RightSideContainer, LeftSideContainer]:
				btn.hide()				
			ConfirmBtn.hide()
			BackBtn.show()
		# --------------
		MODE.CONFIRM_AND_BACK:
			for btn in [ActionBtn, ToggleBtn, CenterBtnList, RightSideContainer, LeftSideContainer]:
				btn.hide()
			for btn in [ConfirmBtn, BackBtn]:
				btn.show()
	
	if !control_pos.is_empty():
		U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show )
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_showing or GameplayNode.is_occupied() or current_location.is_empty() or room_config.is_empty() or freeze_inputs or disable_inputs_while_menu_is_open:return
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		# ----------------------------
		"W":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					U.inc_floor()
				CAMERA.TYPE.ROOM_SELECT:
					match current_mode:
						MODE.SELECT_BASE:
							U.inc_floor()
						MODE.BACK_ONLY:
							U.room_up()
						MODE.CONFIRM_AND_BACK:
							U.room_up()
		# ----------------------------
		"S":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					U.dec_floor()
				CAMERA.TYPE.ROOM_SELECT:
					match current_mode:
						MODE.SELECT_BASE:
							U.dec_floor()
						MODE.BACK_ONLY:
							U.room_down()
						MODE.CONFIRM_AND_BACK:
							U.room_down()
		# ----------------------------
		"D":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					U.inc_ring()
				CAMERA.TYPE.ROOM_SELECT:
					match current_mode:
						MODE.SELECT_BASE:
							U.inc_ring()
						MODE.BACK_ONLY:
							U.room_right()
						MODE.CONFIRM_AND_BACK:
							U.room_right()
		# ----------------------------
		"A":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					U.dec_ring()
				CAMERA.TYPE.ROOM_SELECT:
					match current_mode:
						MODE.SELECT_BASE:
							U.dec_ring()
						MODE.BACK_ONLY:
							U.room_left()
						MODE.CONFIRM_AND_BACK:
							U.room_left()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func check_if_remove_is_valid() -> void:
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)	
	var is_room_empty:bool = room_extract.is_room_empty
	var is_room_under_construction:bool = room_extract.is_room_under_construction
	
	ConfirmBtn.title = "REFUND" if is_room_under_construction else "DESTROY"
	ConfirmBtn.is_disabled = is_room_empty && !is_room_under_construction

	ConfirmBtn.onClick = func() -> void:
		for btn in [ConfirmBtn, BackBtn]:
			btn.is_disabled = true		
		if is_room_under_construction:
			await GameplayNode.cancel_construction(current_location.duplicate())
		else:
			await GameplayNode.reset_room(current_location.duplicate())
		for btn in [ConfirmBtn, BackBtn]:
			btn.is_disabled = false	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func update_details() -> void:
	# update room_extract
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)	
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var is_room_empty:bool = room_extract.is_room_empty
	var is_activated:bool = room_extract.is_activated
	var abilities:Array = [] if is_room_empty else room_extract.room.abilities

	RoomMiniCard.is_activated = is_activated
	RoomMiniCard.is_room_under_construction = room_extract.is_room_under_construction	
	RoomMiniCard.ref = room_extract.room.details.ref if !is_room_empty else -1	
	
	if !room_extract.scp.is_empty():
		ScpMiniCard.ref = room_extract.scp.details.ref
	ScpMiniCard.show() if !room_extract.scp.is_empty() else ScpMiniCard.hide()
	
	if room_extract.researchers.is_empty():
		Researchers.hide()
		TraitContainer.hide()
		SynergyContainer.hide()
	else:
		Researchers.show()
		var total_traits_list := []
		
		for researcher in room_extract.researchers:
			var mini_card:Control = ResearcherMiniCard.instantiate()
			mini_card.researcher = researcher
			mini_card.room_extract = room_extract
			ResearcherList.add_child(mini_card)
			# add selected to selected list	
			total_traits_list.push_back(researcher.traits)
		ResearcherCount.text = "%s/2" % [room_extract.researchers.size()]	
		
	## RESEARCHER DETAILS
	if room_extract.researchers.is_empty():
		Researchers.hide()
		TraitContainer.hide()
		SynergyContainer.hide()
	else:
		Researchers.show()
		var total_traits_list := []
		
		for researcher in room_extract.researchers:
			var mini_card:Control = ResearcherMiniCard.instantiate()
			mini_card.researcher = researcher
			mini_card.room_extract = room_extract
			ResearcherList.add_child(mini_card)
			# add selected to selected list	
			total_traits_list.push_back(researcher.traits)
		ResearcherCount.text = "%s/2" % [room_extract.researchers.size()]
	
	TraitContainer.show() if !room_extract.trait_list.is_empty() else TraitContainer.hide()
	for item in room_extract.trait_list:
		var card:Control = TraitCardPreload.instantiate()
		card.ref = item.details.ref
		card.effect = item.effect
		card.show_output = true
		TraitList.add_child(card)
	
	SynergyContainer.hide() if room_extract.synergy_trait_list.is_empty() else SynergyContainer.show()
	for item in room_extract.synergy_trait_list:
		var card:Control = TraitCardPreload.instantiate()
		card.ref = item.details.ref
		card.effect = item.effect
		card.show_output = true
		card.is_synergy = true
		SynergyTraitList.add_child(card)		
# --------------------------------------------------------------------------------------------------

## --------------------------------------------------------------------------------------------------			
#func show_details() -> void:
	## update room_extract
	#var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)	
	#var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	#var options_list := []
	#var is_room_empty:bool = room_extract.is_room_empty
	#var is_activated:bool = room_extract.is_activated
	#var abilities:Array = [] if is_room_empty else room_extract.room.abilities
	#var passive_abilities:Array = [] if is_room_empty else room_extract.room.passive_abilities
	#var abilities_unlocked:Array = [] if is_room_empty else room_extract.room.abilities_unlocked
	#var passives_unlocked:Array = [] if is_room_empty else room_extract.room.passives_unlocked
	#var ap_val:int = 0 if is_room_empty else room_extract.room.ap
	#var ap_charge_val:int = 0 if is_room_empty else room_extract.room.ap_diff
	##var upgrade_level:int = 0 if is_room_empty else room_extract.room.upgrade_level
	##var available_upgrade_levels:int = gameplay_conditionals[CONDITIONALS.TYPE.UPGRADE_LEVEL]
#
	## enable/disable buttons
	#await U.tick()	# DO NOT REMOVE, PREVENTS DOUBLE KEY PRESS
	#ActiveMenu.freeze_inputs = false
	#set_btn_disabled_state(true)
		#
	## clear list
	#for child in [TraitList, SynergyTraitList, ResearcherList]:
		#for item in child.get_children():
			#item.free()
				#
	## animate in/out
	#Details.modulate = Color(1, 1, 1, 1)
	#U.tween_node_property(DetailsPanel, "position:y", control_pos[DetailsPanel].show)	
#
	## setup cloes behavior
	#ActiveMenu.onClose = func() -> void:
		#await U.tween_node_property(DetailsPanel, "position:y", control_pos[DetailsPanel].hide)
		#GameplayNode.restore_player_hud()
		#set_btn_disabled_state(false)
		#for child in ResearcherList.get_children():
			#child.free()
#
	#options_list.push_back({
		#"title": "BACK",
		#"onSelect": func() -> void:
			#GBL.find_node(REFS.ROOM_NODES).is_active = false
			#ActiveMenu.close()
	#})
	#
	#if !is_room_empty and is_activated:
		## ----------------------- PASSIVE ABILITIES
		#for n in passive_abilities.size():
			#var ability:Dictionary = passive_abilities[n]
			#var can_use:bool = n in passives_unlocked
			#var enough_ap_to_use:bool = ap_charge_val < ability.ap_cost				
			#
			#if can_use:
				#options_list.push_back({
					#"title": ability.name,
					#"is_disabled": (ap_charge_val < ability.ap_cost and n not in base_states.room[U.location_to_designation(current_location)].passives_enabled) or !can_use,
					#"cost": ability.ap_cost if can_use else -1,
					#"is_togglable": true,
					#"is_checked": n in base_states.room[U.location_to_designation(current_location)].passives_enabled,
					#"onSelect": func() -> void:
						#if n not in base_states.room[U.location_to_designation(current_location)].passives_enabled:
							#base_states.room[U.location_to_designation(current_location)].passives_enabled.push_back(n)
						#else:
							#base_states.room[U.location_to_designation(current_location)].passives_enabled.erase(n)
						## updates toggle state in the base states
						#SUBSCRIBE.base_states = base_states
						#show_details()
				#})
			#else:
				#options_list.push_back({
					#"title": "%s [UNLOCK]" % [ability.name],
					#"icon": SVGS.TYPE.LOCK,
					#"is_disabled": false,
					#"onSelect": func() -> void:
						#ActiveMenu.freeze_inputs = true
						#await GameplayNode.unlock_passive_ability(current_location.duplicate(), n)
						#ActiveMenu.freeze_inputs = false
						#show_details()
						#
				#})
		## ----------------------- ACTIVE ABILITIES
		#for n in abilities.size():
			#var ability:Dictionary = abilities[n]
			#var can_use:bool = n in abilities_unlocked
			#var enough_ap_to_use:bool = ap_val < ability.ap_cost
			#
			#if can_use:
				#options_list.push_back({
					#"title": ability.name,
					#"is_disabled": ap_val < ability.ap_cost or !can_use,
					#"cost": ability.ap_cost if can_use else -1,
					#"onSelect": func() -> void:				
						#U.tween_node_property(DetailsPanel, "position:y", control_pos[DetailsPanel].hide)
						#ActiveMenu.freeze_inputs = true
						#if "effect" in ability:
							#var response:bool = await ability.effect.call(GameplayNode)
							#if response:
								#base_states.room[U.location_to_designation(current_location)].ap -= ability.ap_cost
								#SUBSCRIBE.base_states = base_states						
						#U.tween_node_property(DetailsPanel, "position:y", control_pos[DetailsPanel].show)						
						#ActiveMenu.freeze_inputs = false
						#show_details(),
				#})
			#else:
				#options_list.push_back({
					#"title": "%s [UNLOCK]" % [ability.name],
					#"icon": SVGS.TYPE.LOCK,
					#"is_disabled": false,
					#"onSelect": func() -> void:
						#ActiveMenu.freeze_inputs = true
						#await GameplayNode.unlock_ability(current_location.duplicate(), n)
						#ActiveMenu.freeze_inputs = false
						#show_details()
				#})
#
	## ROOM DETAILS	
	#RoomMiniCard.is_activated = is_activated
	#RoomMiniCard.is_room_under_construction = room_extract.is_room_under_construction	
	#RoomMiniCard.ref = room_extract.room.details.ref if !is_room_empty else -1
#
	##
	## SCP DETAILS
	#if !room_extract.scp.is_empty():
		#ScpMiniCard.ref = room_extract.scp.details.ref
	#ScpMiniCard.show() if !room_extract.scp.is_empty() else ScpMiniCard.hide()
	#
	### RESEARCHER DETAILS
	#if room_extract.researchers.is_empty():
		#Researchers.hide()
		#TraitContainer.hide()
		#SynergyContainer.hide()
	#else:
		#Researchers.show()
		#var total_traits_list := []
		#
		#for researcher in room_extract.researchers:
			#var mini_card:Control = ResearcherMiniCard.instantiate()
			#mini_card.researcher = researcher
			#mini_card.room_extract = room_extract
			#ResearcherList.add_child(mini_card)
			## add selected to selected list	
			#total_traits_list.push_back(researcher.traits)
		#ResearcherCount.text = "%s/2" % [room_extract.researchers.size()]
	#
	#TraitContainer.show() if !room_extract.trait_list.is_empty() else TraitContainer.hide()
	#for item in room_extract.trait_list:
		#var card:Control = TraitCardPreload.instantiate()
		#card.ref = item.details.ref
		#card.effect = item.effect
		#card.show_output = true
		#TraitList.add_child(card)
	#
	#SynergyContainer.hide() if room_extract.synergy_trait_list.is_empty() else SynergyContainer.show()
	#for item in room_extract.synergy_trait_list:
		#var card:Control = TraitCardPreload.instantiate()
		#card.ref = item.details.ref
		#card.effect = item.effect
		#card.show_output = true
		#card.is_synergy = true
		#SynergyTraitList.add_child(card)
	#
	#
	#GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer, GameplayNode.RoomInfo])
	#
	#ActiveMenu.ap_charge_val = ap_charge_val
	##ActiveMenu.level = upgrade_level
	#ActiveMenu.ap_val = ap_val
	#ActiveMenu.show_ap = abilities.size() > 0 and is_activated
	#ActiveMenu.show_ap_charge = passive_abilities.size() > 0 and is_activated
	#ActiveMenu.header = "EMPTY" if is_room_empty else "%s" % [room_extract.room.details.name]
	#ActiveMenu.use_color = Color(1, 0.745, 0.381)
	#ActiveMenu.options_list = options_list
	#await U.tick()
	#ActiveMenu.size = Vector2(1, 1)
	#ActiveMenu.custom_minimum_size = Vector2(1, 1)
	#ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	#ActiveMenu.open()
## --------------------------------------------------------------------------------------------------				


## --------------------------------------------------------------------------------------------------		
#func open_scp_details() -> void:
	## setup cloes behavior
	#ActiveMenu.onClose = func() -> void:	
		#GBL.find_node(REFS.ROOM_NODES).is_active = false	
		#set_btn_disabled_state(false)
	#
	## make room nodes active
	#GBL.find_node(REFS.ROOM_NODES).is_active = true
	#
	## enable/disable buttons
	#ActiveMenu.freeze_inputs = false
	#set_btn_disabled_state(true)
	#
	#
	## pull data, create the options list
	#var options_list := []
#
	#options_list.push_back({
		#"title": "BACK",
		#"onSelect": func() -> void:
			#GBL.find_node(REFS.ROOM_NODES).is_active = false
			#ActiveMenu.close()
	#})
#
	#options_list.push_back({
		#"title": "VIEW DETAILS",
		#"onSelect": func() -> void:
			#ActiveMenu.freeze_inputs = true				
			#await GameplayNode.view_scp_details()
			#ActiveMenu.freeze_inputs = false
	#})
	#
#
	#ActiveMenu.options_list = options_list			
	#await U.tick()
	#ActiveMenu.size = Vector2(1, 1)
	#ActiveMenu.custom_minimum_size = Vector2(1, 1)
	#ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	#ActiveMenu.open()
## --------------------------------------------------------------------------------------------------			
#
## --------------------------------------------------------------------------------------------------		
#func open_room_menu() -> void:
	## pull data, create the options list
	#var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	#var room_is_empty:bool = room_extract.is_room_empty
	#var is_room_under_construction:bool = room_extract.is_room_under_construction
	#var is_room_active:bool = room_extract.is_activated
	#var can_destroy:bool = room_extract.can_destroy
	#var room_category:int = room_extract.room_category
	#var researchers_count:int = room_extract.researchers_count
	#var is_scp_empty:bool = room_extract.is_scp_empty
	#var options_list:Array = []
	#
	#options_list.push_back({
		#"title": "BACK",
		#"onSelect": func() -> void:
			#GBL.find_node(REFS.ROOM_NODES).is_active = false
			#ActiveMenu.close()
			#set_btn_disabled_state(false)
	#})
	#
	#if room_is_empty:
		#options_list.push_back({
			#"title": "CONSTRUCT ROOM...",
			#"onSelect": func() -> void:
				#ActiveMenu.freeze_inputs = true				
				#await GameplayNode.construct_room()
				#ActiveMenu.freeze_inputs = false				
				#open_room_menu()
		#})	
	#
	#if is_room_under_construction:
		#options_list.push_back({
			#"title": "CANCEL CONSTRUCTION",
			#"onSelect": func() -> void:
				#ActiveMenu.freeze_inputs = true			
				#await GameplayNode.cancel_construction(current_location.duplicate())
				#ActiveMenu.freeze_inputs = false
				#open_room_menu()
		#})		
#
	#if !room_is_empty:
		#if !is_room_active:
			#options_list.push_back({
				#"title": "ACTIVATE ROOM",
				#"onSelect": func() -> void:
					#ActiveMenu.freeze_inputs = true	
					#await GameplayNode.activate_room(current_location.duplicate())
					#ActiveMenu.freeze_inputs = false
					#open_room_menu()
			#})		
		#else:
			#options_list.push_back({
				#"title": "DEACTIVATE ROOM",
				#"onSelect": func() -> void:
					#ActiveMenu.freeze_inputs = true	
					#await GameplayNode.deactivate_room(current_location.duplicate())
					#ActiveMenu.freeze_inputs = false
					#open_room_menu()
			#})				
	##
	#
	#if !room_is_empty:
		#options_list.push_back({
			#"title": "CANNOT DESTROY ROOM" if !is_scp_empty or !can_destroy else "DESTROY ROOM",
			#"is_disabled": !is_scp_empty or !can_destroy,
			#"onSelect": func() -> void:
				#ActiveMenu.freeze_inputs = true	
				#await GameplayNode.reset_room(current_location.duplicate())
				#ActiveMenu.freeze_inputs = false	
				#open_room_menu()
		#})
#
#
#
	## setup cloes behavior
	#ActiveMenu.onClose = func() -> void:	
		#GBL.find_node(REFS.ROOM_NODES).is_active = false	
		#set_btn_disabled_state(false)
		#GameplayNode.restore_player_hud()
		#
	## make room nodes active
	#GBL.find_node(REFS.ROOM_NODES).is_active = true
	#
	## enable/disable buttons
	#ActiveMenu.freeze_inputs = false
	#set_btn_disabled_state(true)
	#
	#GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer])
	#
	#
	#ActiveMenu.show_ap = false
	#ActiveMenu.header = "FACILITY"
	#ActiveMenu.use_color = Color(0, 0.529, 1)
	#ActiveMenu.options_list = options_list
	#await U.tick()
	#ActiveMenu.size = Vector2(1, 1)
	#ActiveMenu.custom_minimum_size = Vector2(1, 1)
	#ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	#ActiveMenu.open()
## --------------------------------------------------------------------------------------------------			
#
## --------------------------------------------------------------------------------------------------			
#func open_scp_menu() -> void:
	## setup cloes behavior
	#ActiveMenu.onClose = func() -> void:	
		#GBL.find_node(REFS.ROOM_NODES).is_active = false	
		#set_btn_disabled_state(false)
	#
	## make room nodes active
	#GBL.find_node(REFS.ROOM_NODES).is_active = true
	#
	## enable/disable buttons
	#ActiveMenu.freeze_inputs = false
	#set_btn_disabled_state(true)
	#
	## pull data, create the options list
	#var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	#var room_is_empty:bool = room_extract.is_room_empty
	#var is_room_under_construction:bool = room_extract.is_room_under_construction
	#var is_room_active:bool = room_extract.is_activated
	#var room_category:int = room_extract.room_category
	#var is_scp_empty:bool = room_extract.is_scp_empty
	##var	is_scp_transfering:bool = room_extract.is_scp_transfering
	##var is_scp_contained:bool = room_extract.is_scp_contained
	#var researchers_count:int = room_extract.researchers_count	
	#var options_list:Array = []
			#
	#options_list.push_back({
		#"title": "BACK",
		#"onSelect": func() -> void:
			#GBL.find_node(REFS.ROOM_NODES).is_active = false
			#ActiveMenu.close()
			#set_btn_disabled_state(false)
	#})
	#
	#if is_scp_empty:
		#options_list.push_back({
			#"title": "CONTAIN SCP",
			#"is_disabled": scp_data.available_list.size() == 0,
			#"onSelect": func() -> void:
				#ActiveMenu.freeze_inputs = true
				#await GameplayNode.contain_scp(current_location.duplicate(), scp_data.available_list[0].ref)
				#ActiveMenu.freeze_inputs = false
				#open_scp_menu()
		#})
	#else:
		#options_list.push_back({
			#"title": "CONDUCT TESTING",
			#"onSelect": func() -> void:
				#ActiveMenu.freeze_inputs = true
				#await GameplayNode.upgrade_scp_level(current_location.duplicate(), room_extract.scp.details.ref)
				#print("upgrade complete...")
				#ActiveMenu.freeze_inputs = false
				#open_scp_menu()
		#})		
				#
		#options_list.push_back({
			#"title": "DETAILS",
			#"onSelect": func() -> void:
				#ActiveMenu.freeze_inputs = true
				#await GameplayNode.view_scp_details(room_extract.scp.details.ref)
				#ActiveMenu.freeze_inputs = false
				#open_scp_menu()
		#})					
		#
#
	#ActiveMenu.show_ap = false
	#ActiveMenu.header = "CONTAINMENT"
	#ActiveMenu.use_color = Color(0.511, 0.002, 0.717)
	#ActiveMenu.options_list = options_list		
	#await U.tick()
	#ActiveMenu.size = Vector2(1, 1)
	#ActiveMenu.custom_minimum_size = Vector2(1, 1)
	#ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	#ActiveMenu.open()
## --------------------------------------------------------------------------------------------------				
#
## --------------------------------------------------------------------------------------------------				
#func open_researcher_menu() -> void:
	## setup cloes behavior
	#ActiveMenu.onClose = func() -> void:	
		#GBL.find_node(REFS.ROOM_NODES).is_active = false	
		#set_btn_disabled_state(false)
	#
	## make room nodes active
	#GBL.find_node(REFS.ROOM_NODES).is_active = true
	#
	## enable/disable buttons
	#ActiveMenu.freeze_inputs = false
	#set_btn_disabled_state(true)
	#
	## pull data, create the options list
	#var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	#var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	#var room_is_empty:bool = room_extract.is_room_empty
	#var researchers_count:int = room_extract.researchers_count
	#var is_room_active:bool = room_extract.is_activated
	#var room_is_active
	#
	#var options_list := []
	#options_list.push_back({
		#"title": "BACK",
		#"onSelect": func() -> void:	
			#GBL.find_node(REFS.ROOM_NODES).is_active = false
			#ActiveMenu.close()
			#set_btn_disabled_state(false)
	#})
	#
	#options_list.push_back({
		#"title": "ASSIGN RESEARCHER...",
		#"onSelect": func() -> void:
			#ActiveMenu.freeze_inputs = true
			#set_btn_disabled_state(true)
			#await GameplayNode.assign_researcher(current_location.duplicate())
			#ActiveMenu.freeze_inputs = false
			#restore_btn_disable_state()
	#})		
	#
	#options_list.push_back({
		#"title": "PROMOTE RESEARCHER",
		#"onSelect": func() -> void:
			#ActiveMenu.freeze_inputs = true
			#await GameplayNode.promote_researchers()
			#ActiveMenu.freeze_inputs = false
			#open_researcher_menu(),
	#})			
	#
	#for researcher in room_extract.researchers:
		#options_list.push_back({
			#"title": "REMOVE %s" % [researcher.name],
			#"onSelect": func() -> void:
				#ActiveMenu.freeze_inputs = true
				#var response:Dictionary = await GameplayNode.unassign_researcher(researcher, room_extract.room.details)
				#ActiveMenu.freeze_inputs = false
				#open_researcher_menu(),
		#})
#
	#ActiveMenu.header = "RESEARCHER"
	#ActiveMenu.use_color = Color(0, 0.965, 0.278)
	#ActiveMenu.options_list = options_list		
	#await U.tick()
	#ActiveMenu.size = Vector2(1, 1)
	#ActiveMenu.custom_minimum_size = Vector2(1, 1)
	#ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	#ActiveMenu.open()
## --------------------------------------------------------------------------------------------------				

		
## ---- CENTER
#CenterBtnList
#
## ---- LEFT SIDE
#new_left_btn_list.push_back({
	#"title": "UNLOCK",
	#"assigned_key": "E",
	#"is_disabled": floor_is_powered,
	#"icon": SVGS.TYPE.TARGET,
	#"onClick": func() -> void:
		#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
			#set_btn_disabled_state(true)
			#await GameplayNode.activate_floor(current_location.duplicate())
			#restore_btn_disable_state(true)
			#
#})						
			#
## ---- RIGHT SIDE
#new_right_btn_list.push_back({
	#"title": "QUICKSAVE",
	#"assigned_key": "F5",
	#"icon": SVGS.TYPE.SAVE,
	#"onClick": func() -> void:
		#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
			#GameplayNode.quicksave()
#})		
#
#new_right_btn_list.push_back({
	#"title": "QUICKLOAD",
	#"assigned_key": "F8",
	#"icon": SVGS.TYPE.LOADING,
	#"onClick": func() -> void:
		#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
			#GameplayNode.quickload()
#})	
#
#if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_ROOM_DETAILS_BTN]:
	#new_right_btn_list.push_back({
		#"title": "DETAILS",
		#"assigned_key": "SPACEBAR",
		#"icon": SVGS.TYPE.CHECKBOX if GBL.find_node(REFS.FLOOR_INFO).expand else SVGS.TYPE.EMPTY_CHECKBOX,
		#"onClick": func() -> void:
			#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied():  
				#GBL.find_node(REFS.FLOOR_INFO).toggle_expand()
				#buildout_btns()
	#})				
			#
#new_right_btn_list.push_back({
	#"title": "GOTO WING",
	#"assigned_key": "TAB",
	#"icon": SVGS.TYPE.TARGET,
	#"onClick": func() -> void:
		#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
			#toggle_camera_view()
#})		

## ---- LEFT SIDE
#new_left_btn_list.push_back({
	#"title": "ABILITIES",
	#"assigned_key": "E",
	#"is_disabled": !gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_ACTION_DETAILS] or !is_activated,
	#"icon": SVGS.TYPE.TARGET,
	#"onClick": func() -> void:
		#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
			#show_details()
#})						
#
#new_left_btn_list.push_back({
	#"title": "FACILITY",
	#"assigned_key": "1",
	#"icon": SVGS.TYPE.MONEY,
	#"onClick": func() -> void:
		#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
			#open_room_menu()
#})
#
#
#new_left_btn_list.push_back({
	#"title": "RESEARCHER",
	#"is_disabled": !gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_ACTIONS_RESEARCHER],
	#"assigned_key": "2",
	#"icon": SVGS.TYPE.CONTAIN,
	#"onClick": func() -> void:
		#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
			#open_researcher_menu()
#})
	#
#
#new_left_btn_list.push_back({
	#"title": "CONTAINMENT",
	#"is_disabled": !gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_ACTIONS_SCP] or !can_contain,
	#"assigned_key": "3",
	#"icon": SVGS.TYPE.CONTAIN if room_category == ROOM.CATEGORY.CONTAINMENT_CELL else SVGS.TYPE.CLEAR,
	#"onClick": func() -> void:
		#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
			#open_scp_menu()
#})
#
#
#
## ---- RIGHT SIDE
#new_right_btn_list.push_back({
	#"title": "DEBUG",
	#"assigned_key": "-",
	#"icon": SVGS.TYPE.DOWNLOAD,
	#"onClick": func() -> void:
		#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied():  
			#open_debug_menu()
#})							
#
#if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_DATABASE_BTN]:
	#new_right_btn_list.push_back({
		#"title": "DATABASE",
		#"assigned_key": "-",
		#"icon": SVGS.TYPE.CONVERSATION,
		#"onClick": func() -> void:
			#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied():  
				#set_btn_disabled_state(true)
				#await GameplayNode.open_scp_database()
				#restore_btn_disable_state(true)
	#})				
#
#if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_OBJECTIVES_BTN]:
	#new_right_btn_list.push_back({
		#"title": "OBJECTIVES",
		#"assigned_key": "O",
		#"icon": SVGS.TYPE.TXT_FILE,
		#"onClick": func() -> void:
			#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied():  
				#set_btn_disabled_state(true)
				#await GameplayNode.open_objectives()							
				#restore_btn_disable_state(true)
	#})				
#
#if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_ROOM_DETAILS_BTN]:
	#new_right_btn_list.push_back({
		#"title": "DETAILS",
		#"assigned_key": "SPACEBAR",
		#"icon": SVGS.TYPE.CHECKBOX if GBL.find_node(REFS.ROOM_INFO).expand else SVGS.TYPE.EMPTY_CHECKBOX,
		#"onClick": func() -> void:
			#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied():  
				#GBL.find_node(REFS.ROOM_INFO).toggle_expand()
				#buildout_btns()
	#})	
			#
#new_right_btn_list.push_back({
	#"title": "GOTO",
	#"assigned_key": "TAB",
	#"icon": SVGS.TYPE.CAMERA_B,
	#"onClick": func() -> void:
		#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
			#toggle_camera_view()
#})
