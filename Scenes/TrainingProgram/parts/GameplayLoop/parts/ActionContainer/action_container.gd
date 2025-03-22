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

@onready var RightSideShortcutContainer:PanelContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSide/ShortcutContainer
@onready var LeftSideShortcutContainer:PanelContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ShortcutContainer

@onready var LeftSideTitleLabel:Label = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ShortcutContainer/VBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/LeftSideTitleLabel
@onready var RightSideBtnLabel:Label = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSide/ShortcutContainer/VBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/RightSideBtnLabel
@onready var LeftSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ShortcutContainer/VBoxContainer/MarginContainer/VBoxContainer2/LeftSideBtnList
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSide/ShortcutContainer/VBoxContainer/MarginContainer/VBoxContainer2/RightSideBtnList
@onready var CenterBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList
@onready var Backdrop:ColorRect = $Backdrop

enum MODE { SELECT_FLOOR, SELECT_ROOM, BACK_ONLY, CONFIRM_AND_BACK }
enum MENU_TYPE { ACTIVES, PASSIVES }

const KeyBtnPreload:PackedScene = preload("res://UI/Buttons/KeyBtn/KeyBtn.tscn")
const ResearcherMiniCard:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ResearcherMiniCard/ResearcherMiniCard.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")

var disable_inputs_while_menu_is_open:bool = false
var previous_camera_type:int

var current_menu_type:MENU_TYPE = MENU_TYPE.ACTIVES

var current_mode:MODE = MODE.SELECT_FLOOR : 
	set(val):
		current_mode = val
		on_current_mode_update()

var ref_btn:Control
var center_btn_list:Array = []
var left_btn_list:Array = [] 
var right_btn_list:Array = []
var action_list_options:Array = []
var passive_list_options:Array = []

var restore_state:Dictionary 
var shortcuts:Dictionary = {}
#var inactive_shortcuts:Dictionary = {}

var active_menu_is_open:bool = false
var is_setup:bool = false
var enable_update_details:bool = false
var in_clear_mode:bool = false : 
	set(val):
		in_clear_mode = val
		if in_clear_mode:
			check_if_remove_is_valid()

var in_contain_mode:bool = false : 
	set(val):
		in_contain_mode = val
		if in_contain_mode:
			check_if_contain_is_valid()

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
			
	for child in [LeftSideBtnList]:
		for node in child.get_children():
			node.onFocus = func(node:Control) -> void:
				LeftSideTitleLabel.text = node.ability.name if !node.ability.is_empty() else "HOTKEYS"
			node.onBlur = func(node:Control) -> void:
				LeftSideTitleLabel.text = "HOTKEYS"

	for child in [RightSideBtnList]:
		for node in child.get_children():
			node.onFocus = func(node:Control) -> void:
				RightSideBtnLabel.text = node.ability.name if !node.ability.is_empty() else "HOTKEYS"
			node.onBlur = func(node:Control) -> void:
				RightSideBtnLabel.text = "HOTKEYS"			
			
	ActionBtn.onClick = func() -> void:
		current_menu_type = MENU_TYPE.ACTIVES
		match current_mode:
			MODE.SELECT_FLOOR:
				show_base_upgrades()
			MODE.SELECT_ROOM:
				ability_level_index = 0
				show_actives()
	
	ToggleBtn.onClick = func() -> void:
		current_menu_type = MENU_TYPE.PASSIVES
		match current_mode:
			MODE.SELECT_FLOOR:
				show_generator_upgrades()
			MODE.SELECT_ROOM:
				ability_level_index = 0
				show_passives()
		
	ActiveMenu.onNext = func() -> void:
		ability_level_index = U.min_max(ability_level_index + 1, 0, GAME_UTIL.get_ring_ability_level())
		match current_menu_type:
			MENU_TYPE.ACTIVES:
				show_actives(true)
			MENU_TYPE.PASSIVES:
				show_passives(true)
		
	ActiveMenu.onPrev = func() -> void:
		ability_level_index = U.min_max(ability_level_index - 1, 0, GAME_UTIL.get_ring_ability_level())
		match current_menu_type:
			MENU_TYPE.ACTIVES:
				show_actives(true)
			MENU_TYPE.PASSIVES:
				show_passives(true)
	
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
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide)
	
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			camera_settings.type = CAMERA.TYPE.ROOM_SELECT
			current_mode = MODE.SELECT_ROOM

		CAMERA.TYPE.ROOM_SELECT:
			camera_settings.type = CAMERA.TYPE.FLOOR_SELECT
			current_mode = MODE.SELECT_FLOOR
	
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
func show_generator_upgrades(skip_animation:bool = false) -> void:
	open_menu()
		
	var list = []
	disable_inputs_while_menu_is_open = true
	
	list.push_back({
		"title": "UPGRADE GENERATOR LVL %s" % [base_states.floor[str(current_location.floor)].generator_level + 1],		
		"cooldown_duration": 0, 
		"is_disabled": false,
		"action": func() -> void:
			await GameplayNode.upgrade_generator_level.call(),
		"onSelect": func(index:int) -> void:
			await list[index].action.call(),
	})					
	
	ActiveMenu.onClose = func() -> void:	
		disable_inputs_while_menu_is_open = false
		restore_menu()	
	
	update_active_menu("GENERATOR", Color.WHITE, list, ToggleBtn.global_position.x - ActiveMenu.size.x + ToggleBtn.size.x + 5, skip_animation)	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func show_base_upgrades(skip_animation:bool = false) -> void:
	open_menu()
		
	var list = []
	disable_inputs_while_menu_is_open = true
		
	var is_powered:Callable = func() -> bool:
		return room_config.floor[current_location.floor].is_powered
		
	var is_in_lockdown:Callable = func() -> bool:
		return room_config.floor[current_location.floor].in_lockdown		
	
	if !is_powered.call():
		list.push_back({
			"title": "UNLOCK FLOOR" if !is_powered.call() else "ALREADY UNLOCKED",		
			"cooldown_duration": 0, 
			"is_disabled": is_powered.call(),
			"get_disabled_state": is_powered,		
			"action": func() -> void:
				await GameplayNode.activate_floor(current_location.duplicate(true)),
			"onSelect": func(index:int) -> void:
				await list[index].action.call(),
		})
	
	list.push_back({
		"title": "LOCKDOWN FLOOR" if !is_in_lockdown.call() else "RELEASE LOCKDOWN",
		"cooldown_duration": 0, 
		"is_disabled": false,
		"action": func() -> void:
			await GameplayNode.set_floor_lockdown(current_location.duplicate(true), !is_in_lockdown.call()),
		"onSelect": func(index:int) -> void:
			await list[index].action.call(),
	})						
	
	ActiveMenu.onClose = func() -> void:	
		disable_inputs_while_menu_is_open = false
		restore_menu()	
	
	update_active_menu("UPGRADES", Color.WHITE, list, ActionBtn.global_position.x - 5, skip_animation)		
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func show_actives(skip_animation:bool = false) -> void:
	open_menu()
		
	action_list_options = []
	disable_inputs_while_menu_is_open = true
	# setup cloes behavior
	#set_btn_disabled_state(false, true)
	# pull data, create the options list
	var designation:String = str(current_location.floor, current_location.ring)	
	var extract_wing_data:Dictionary = GAME_UTIL.extract_wing_details()	
	var wing_max_level:int = GAME_UTIL.get_ring_ability_level()
	var is_powered:bool = room_config.floor[current_location.floor].is_powered
	
	if is_powered:
		for room_ref in extract_wing_data.abilities:
			var abilities:Array = extract_wing_data.abilities[room_ref]

			for ability in abilities:
				if ability_level_index == ability.level:
					
					var get_cooldown_duration:Callable = func() -> int:
						await U.tick()
						var cooldown_duration:int = 0
						if ability.details.name in base_states.ring[designation].ability_on_cooldown:
							cooldown_duration = base_states.ring[designation].ability_on_cooldown[ability.details.name]
						return cooldown_duration
						
					var is_disabled:Callable = func() -> bool:
						await U.tick()
						var cooldown_duration:int = await get_cooldown_duration.call() 
						return cooldown_duration != 0
					
					action_list_options.push_back({
						"bookmark_data": {"ref": room_ref, "ability_level": ability.index},
						"title": ability.details.name,
						"cooldown_duration": await get_cooldown_duration.call(), 
						"is_disabled": await is_disabled.call(),
						"get_disabled_state": is_disabled,
						"get_cooldown_duration": get_cooldown_duration,
						"action": func() -> void:
							await GAME_UTIL.use_active_ability(ability.details),
						"onSelect": func(index:int) -> void:
							await action_list_options[index].action.call(),
					})				

	ActiveMenu.level = ability_level_index
	ActiveMenu.show_ap = true
	
	ActiveMenu.onClose = func() -> void:	
		disable_inputs_while_menu_is_open = false
		restore_menu()
		
	ActiveMenu.onBookmark = func(index:int, target:int) -> void:
		if action_list_options.is_empty() or action_list_options[index].is_empty():return
		
		if target not in shortcuts[designation].actives:
			shortcuts[designation].actives[target] = {}
			
		if shortcuts[designation].actives[target].is_empty():
			shortcuts[designation].actives[target] = action_list_options[index].bookmark_data
		else:
			if shortcuts[designation].actives[target] == action_list_options[index].bookmark_data:
				shortcuts[designation].actives[target] = {}
			else:
				shortcuts[designation].actives[target] = action_list_options[index].bookmark_data
				
		build_action_shortcut()
			

	update_active_menu("ACTIVE", Color.WHITE, action_list_options, ActionBtn.global_position.x - 5, skip_animation)	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func show_passives(skip_animation:bool = false) -> void:
	open_menu()
		
	passive_list_options = []
	disable_inputs_while_menu_is_open = true
	# setup cloes behavior

	# pull data, create the options list
	var extract_wing_data:Dictionary = GAME_UTIL.extract_wing_details()
	var designation:String = str(current_location.floor, current_location.ring)
	var passives_enabled:Dictionary = base_states.ring[designation].passives_enabled

	for room_ref in extract_wing_data.passive_abilities:
		var abilities:Array = extract_wing_data.passive_abilities[room_ref]

		for ability_level in abilities.size():
			var ability:Dictionary = abilities[ability_level]
			if ability_level_index == ability.level:
				var ability_uid:String = str(room_ref, ability_level)
				var energy_cost:int = ability.details.energy_cost if "energy_cost" in ability.details else 1
				
				var is_checked:Callable = func() -> bool: 
					await U.tick()
					return passives_enabled[ability_uid] if (ability_uid in passives_enabled) else false
					
				var is_disabled:Callable = func() -> bool: 
					var _is_checked:bool = await is_checked.call()
					var energy:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].energy
					var energy_remaining:int = energy.available - energy.used
					var has_enough:bool = energy_remaining - energy_cost >= 0
					
					return !has_enough and !_is_checked
				
				
				passive_list_options.push_back({
					"bookmark_data": {"ref": room_ref, "ability_level": ability.index},
					"title": ability.details.name,
					"icon": SVGS.TYPE.RESEARCH,
					"energy_cost": energy_cost, 
					"is_togglable": true,
					"is_checked": await is_checked.call(),
					"is_disabled": await is_disabled.call(),
					"get_disabled_state": is_disabled,
					"get_checked_state": is_checked,
					"action": func() -> void:
						GAME_UTIL.toggle_passive_ability(room_ref, ability_level),
					"onSelect": func(index:int) -> void:
						await passive_list_options[index].action.call(),
				})				

	ActiveMenu.level = ability_level_index
	ActiveMenu.show_ap = true
	
	ActiveMenu.onClose = func() -> void:	
		disable_inputs_while_menu_is_open = false
		restore_menu()
		
	ActiveMenu.onBookmark = func(index:int, target:int) -> void:
		if passive_list_options.is_empty() or passive_list_options[index].is_empty():return
		
		if target not in shortcuts[designation].passives:
			shortcuts[designation].passives[target] = {}
			
		if shortcuts[designation].passives[target].is_empty():
			shortcuts[designation].passives[target] = passive_list_options[index].bookmark_data
		else:
			if shortcuts[designation].passives[target] == passive_list_options[index].bookmark_data:
				shortcuts[designation].passives[target] = {}
			else:
				shortcuts[designation].passives[target] = passive_list_options[index].bookmark_data
				
		build_passive_shortcut()
			
	update_active_menu("PASSIVE", Color.WHITE, passive_list_options, ToggleBtn.global_position.x - ActiveMenu.size.x + ToggleBtn.size.x + 5, skip_animation)	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func update_active_menu(header:String, color:Color, options_list:Array, xpos:int, skip_animation:bool) -> void:
	ActiveMenu.header = header
	ActiveMenu.use_color = color
	ActiveMenu.options_list = options_list		
	ActiveMenu.max_level = GAME_UTIL.get_ring_ability_level()

	ActiveMenu.size.y = 1
	ActiveMenu.custom_minimum_size.y = 1	
	ActiveMenu.global_position = Vector2(xpos, get_menu_y_pos())
	if !skip_animation:
		await U.tick()	
		ActiveMenu.open()	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_setup:
		U.debounce("build_btns", buildout_btns)		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	await U.set_timeout(0.3)
	U.debounce("build_btns", buildout_btns)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func set_backdrop_state(state:bool) -> void:	
	await U.tween_node_property(Backdrop, 'color', Color(0, 0.1, 0, 0.4 if state else 0.0))	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
var previous_designation:String
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if current_location.is_empty():return
	var designation:String = str(current_location.floor, current_location.ring)
	
	if designation not in shortcuts:
		shortcuts[designation] = {
			"actives": {},
			"passives": {}
		}			
	
	if enable_update_details:
		update_details()
		return
	
	if in_clear_mode:
		check_if_remove_is_valid()
		return
		
	if in_contain_mode:
		check_if_contain_is_valid()
		return
		
	if previous_designation != designation:
		previous_designation = designation
		U.debounce("build_btns", buildout_btns)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func enable_room_focus(state:bool) -> void:
	GBL.find_node(REFS.ROOM_NODES).enable_room_focus = state
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func render_shorcut_container() -> void:
	if !is_node_ready() or gameplay_conditionals.is_empty():return
	LeftSideShortcutContainer.show() if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_ACTIVE_ABILITY_SHORTCUTS] else LeftSideShortcutContainer.hide()
	RightSideShortcutContainer.show() if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_PASSIVE_ABILITY_SHORTCUTS] else RightSideShortcutContainer.hide()	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func buildout_btns() -> void:
	if !is_node_ready() or camera_settings.is_empty() or room_config.is_empty() or current_location.is_empty():return
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
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
			for node in [LeftSideShortcutContainer, RightSideShortcutContainer]:
				node.hide()
			
			if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_SAVE_AND_LOAD]:
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
			
			if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_OBJECTIVES_BTN]:
				new_center_btn_list.push_back({
					"title": "OBJECTIVES",
					"assigned_key": "O",
					"icon": SVGS.TYPE.TXT_FILE,
					"onClick": func() -> void:
						if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied():  
							await lock_menu()
							await GameplayNode.open_objectives()
							unlock_menu(),
				})							
	
		# ------------------------------------
		CAMERA.TYPE.ROOM_SELECT:	
			render_shorcut_container()
							
			new_center_btn_list.push_back({
				"title": "BUILD",
				"assigned_key": "B",
				"icon": SVGS.TYPE.BUILD,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						enable_room_focus(true)
						await lock_menu(true)
						await GameplayNode.construct_room()
						unlock_menu(true)
						enable_room_focus(false),
			})	
			
			if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_DESTROY_ROOM]:
				new_center_btn_list.push_back({
					"title": "CLEAR",
					"assigned_key": "X",
					"icon": SVGS.TYPE.CLEAR,
					"onClick": func() -> void:
						if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
							enable_room_focus(true)
							await lock_menu(true)
							in_clear_mode = true
							current_mode = MODE.CONFIRM_AND_BACK
							GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer, GameplayNode.RoomInfo])
							
							ConfirmBtn.onClick = func() -> void:
								await GameplayNode.reset_room(current_location.duplicate())
								await U.tick()
								check_if_remove_is_valid()
							
							BackBtn.onClick = func() -> void:
								current_mode = MODE.SELECT_FLOOR
								in_clear_mode = false
								await GameplayNode.restore_showing_state()
								
								enable_room_focus(false)
								unlock_menu(true)
				})	
			
			if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_INVESTIGATE]:
				new_center_btn_list.push_back({
					"assigned_key": "R",
					"title": "INVESTIGATE",
					"icon": SVGS.TYPE.QUESTION_MARK,
					"onClick": func() -> void:
						if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
							enable_room_focus(true)
							await lock_menu(true)
							enable_update_details = true
							update_details()
							current_mode = MODE.BACK_ONLY
							await GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer, GameplayNode.RoomInfo])
							U.tween_node_property(DetailsPanel, "position:y", control_pos[DetailsPanel].show)	
							
							BackBtn.onClick = func() -> void:
								current_mode = MODE.SELECT_FLOOR
								U.tween_node_property(DetailsPanel, "position:y", control_pos[DetailsPanel].hide)	
								await GameplayNode.restore_showing_state()
								
								enable_room_focus(false)
								unlock_menu(true)
								enable_update_details = false
				})
			
			#new_center_btn_list.push_back({
				#"title": "CONTAIN",
				#"assigned_key": "C",
				#"icon": SVGS.TYPE.CONTAIN,
				#"is_disabled": scp_data.available_list.size() == 0,
				#"get_disable": func() -> bool:
					#return scp_data.available_list.size() == 0,
				#"onClick": func() -> void:
					#if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						#enable_room_focus(true)
						#await lock_menu(true)
						#in_contain_mode = true
						#current_mode = MODE.CONFIRM_AND_BACK
						#GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer, GameplayNode.RoomInfo])
						#
						#var onFinish = func() -> void:
							#current_mode = MODE.SELECT_FLOOR
							#in_contain_mode = false
							#await GameplayNode.restore_player_hud()
							#enable_room_focus(false)
							#unlock_menu(true)
													#
						#
						#ConfirmBtn.onClick = func() -> void:
							#await GameplayNode.contain_scp(scp_data.available_list[0].ref)
							#onFinish.call()
						#
						#BackBtn.onClick = func() -> void:
							#onFinish.call()
			#})						
			
			if false:	
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
	build_action_shortcut()
	build_passive_shortcut()
	
	is_setup = true
	await U.set_timeout(0.1)
	refresh_buttons.emit()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func build_action_shortcut() -> void:
	var designation:String = str(current_location.floor, current_location.ring)
	for index in LeftSideBtnList.get_child_count():		
		if index in shortcuts[designation].actives:			
			var shortcut_data:Dictionary = shortcuts[designation].actives[index]
			var btn:Control = LeftSideBtnList.get_child(index)
			
			if !shortcut_data.is_empty():
				var ability:Dictionary = ROOM_UTIL.return_ability(shortcut_data.ref, shortcut_data.ability_level)			
				btn.set_refs('active', shortcut_data.ref, shortcut_data.ability_level)
				btn.onReset = func() -> void:
					shortcuts[designation].actives.erase(index)
					btn.onClick = func() -> void:pass
				btn.onClick = func() -> void:
					await lock_menu()
					await GAME_UTIL.use_active_ability(ability)
					unlock_menu()
			else:
				btn.onClick = func() -> void:pass
				btn.onReset = func() -> void:pass
				btn.reset()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func build_passive_shortcut() -> void:
	var designation:String = str(current_location.floor, current_location.ring)
	for index in RightSideBtnList.get_child_count():
		if index in shortcuts[designation].passives:
			var shortcut_data:Dictionary = shortcuts[designation].passives[index]
			var btn:Control = RightSideBtnList.get_child(index)
			
			if !shortcut_data.is_empty():
				btn.set_refs('passive', shortcut_data.ref, shortcut_data.ability_level)
				btn.onReset = func() -> void:
					shortcuts[designation].passives.erase(index)
					btn.onClick = func() -> void:pass
				btn.onClick = func() -> void:
					GAME_UTIL.toggle_passive_ability(shortcut_data.ref, shortcut_data.ability_level)
			else:
				btn.onClick = func() -> void:pass
				btn.onReset = func() -> void:pass
				btn.reset()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func lock_menu(skip_disable:bool = false) -> void:
	if !skip_disable:
		disable_inputs_while_menu_is_open = true
	for node in [LeftSideBtnList, RightSideBtnList, CenterBtnList]:
		for child in node.get_children():
			child.is_disabled = true 
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide)
	
func unlock_menu(skip_disable:bool = false) -> void:
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show)	
	if !skip_disable:
		disable_inputs_while_menu_is_open = false
	for node in [LeftSideBtnList, RightSideBtnList, CenterBtnList]:
		for child in node.get_children():
			if "get_disable" in child:
				child.is_disabled = child.get_disable.call()
			if "get_icon" in child:
				child.icon = child.get_icon.call()

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
			child.is_disabled = await child.get_disable.call()
			child.icon = await child.get_icon.call()

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
		for node in [LeftSideBtnList, RightSideBtnList, CenterBtnList]:
			for child in node.get_children():
				child.is_disabled = true
				
		for btn in [ConfirmBtn, BackBtn]:
			btn.is_disabled = true		
		await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide)
		
	match current_mode:
		# --------------
		MODE.SELECT_FLOOR:			
			ActionBtn.title = "FACILITY UPGRADES"
			ToggleBtn.title = "GENERATOR UPGRADES"
			
			for node in [LeftSideBtnList, RightSideBtnList, CenterBtnList]:
				for child in node.get_children():
					child.is_disabled = false
					
			for btn in [ConfirmBtn, BackBtn]:
				btn.is_disabled = true
				btn.hide()
				
			LeftSideShortcutContainer.hide()
			RightSideShortcutContainer.hide()
		# --------------
		MODE.SELECT_ROOM:
			ActionBtn.title = "ACTIVE"
			ToggleBtn.title = "PASSIVE"

						
			for node in [LeftSideBtnList, RightSideBtnList, CenterBtnList]:
				for child in node.get_children():
					child.is_disabled = false
					
			for btn in [ConfirmBtn, BackBtn]:
				btn.is_disabled = true
				btn.hide()
				
			render_shorcut_container()
		# --------------
		MODE.BACK_ONLY:
			for node in [LeftSideBtnList, RightSideBtnList, CenterBtnList]:
				for child in node.get_children():
					child.is_disabled = true 
								
			for btn in [ActionBtn, ToggleBtn, CenterBtnList]:
				btn.hide()

			for btn in [ConfirmBtn, BackBtn]:
				btn.is_disabled = false
				
			ConfirmBtn.hide()
			BackBtn.show()
		# --------------
		MODE.CONFIRM_AND_BACK:
			for node in [LeftSideBtnList, RightSideBtnList, CenterBtnList]:
				for child in node.get_children():
					child.is_disabled = true 
						
			for btn in [ActionBtn, ToggleBtn, CenterBtnList]:
				btn.hide()

			for btn in [ConfirmBtn, BackBtn]:
				btn.show()
				btn.is_disabled = false
		# --------------
		
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
						MODE.SELECT_FLOOR:
							U.inc_floor()
						MODE.SELECT_ROOM:
							U.inc_floor()
						_:
							U.room_up()
		# ----------------------------
		"S":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					U.dec_floor()
				CAMERA.TYPE.ROOM_SELECT:
					match current_mode:
						MODE.SELECT_FLOOR:
							U.dec_floor()
						MODE.SELECT_ROOM:
							U.dec_floor()
						_:
							U.room_down()
		# ----------------------------
		"D":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					U.inc_ring()
				CAMERA.TYPE.ROOM_SELECT:
					match current_mode:
						MODE.SELECT_FLOOR:
							U.inc_ring()
						MODE.SELECT_ROOM:
							U.inc_ring()
						_:
							U.room_right()
		# ----------------------------
		"A":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					U.dec_ring()
				CAMERA.TYPE.ROOM_SELECT:
					match current_mode:
						MODE.SELECT_FLOOR:
							U.dec_ring()
						MODE.SELECT_ROOM:
							U.dec_ring()
						_:
							U.room_left()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func check_if_remove_is_valid() -> void:
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)	
	var is_room_empty:bool = room_extract.is_room_empty
	var is_room_under_construction:bool = room_extract.is_room_under_construction
	
	ConfirmBtn.title = "REFUND" if is_room_under_construction else "DESTROY"
	ConfirmBtn.is_disabled = is_room_empty and !is_room_under_construction
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func check_if_contain_is_valid() -> void:
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)	
	var is_room_empty:bool = room_extract.is_room_empty
	var is_room_under_construction:bool = room_extract.is_room_under_construction
	var can_contain:bool = room_extract.can_contain
	
	ConfirmBtn.title = "CONTAIN"
	ConfirmBtn.is_disabled = is_room_empty or is_room_under_construction or !can_contain
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
	#var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
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
	#var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)	
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
func update_details() -> void:
	# update room_extract
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)	
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
#func open_scp_details() -> void:
	## setup cloes behavior
	#ActiveMenu.onClose = func() -> void:	
		#GBL.find_node(REFS.ROOM_NODES).is_active = false	
		
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
	#var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
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
	#var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
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
	#var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
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
