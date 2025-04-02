extends GameContainer

@onready var RootPanel:PanelContainer = $"."
@onready var Backdrop:ColorRect = $Backdrop
@onready var BtnControlPanel:MarginContainer = $BtnControl/MarginContainer
@onready var ActiveMenu:PanelContainer = $Control/ActiveMenu
@onready var Details:Control = $Details
@onready var DetailsPanel:PanelContainer = $Details/PanelContainer
@onready var HotkeyContainer:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSide/HotkeyContainer
@onready var PreviewTextureRect:TextureRect = $PanelContainer/PreviewTextureRect

@onready var NameControl:Control = $NameControl
@onready var RoomDetailsControl:Control = $RoomDetails
@onready var RoomDetailsPanel:Control = $RoomDetails/DetailPanel

@onready var NavBtnPanel:PanelContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/NavBtnPanel
@onready var GotoBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/NavBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/GotoBtn
@onready var FloorPlanBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/NavBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/FloorPlanBtn

@onready var AdminBtnPanel:PanelContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/AdminBtnPanel
@onready var InfoBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/AdminBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/InfoBtn

@onready var ResearcherBtnPanel:PanelContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ResearcherBtnPanel
@onready var AssignBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ResearcherBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/AssignBtn
@onready var UnassignBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ResearcherBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/UnassignBtn
@onready var ResearcherDetailBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ResearcherBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/ResearcherDetailBtn
@onready var ResearcherNextBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ResearcherBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/ResearcherNextBtn

@onready var ScpBtnPanel:PanelContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ScpBtnPanel
@onready var ScpDetailsBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ScpBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/ScpDetailsBtn
#@onready var ContainBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSide/ScpBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/ContainBtn

@onready var BaseBtnPanel:PanelContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/BaseBtnPanel
@onready var BuildBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/BaseBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/ConstructBtn
@onready var DecontructBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/BaseBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/DeconstructBtn
@onready var NextBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/BaseBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/NextBtn

@onready var AbilityBtnPanel:PanelContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/AbilityBtnPanel
@onready var AbilityBtnPanelLabel:Label = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/AbilityBtnPanel/MarginContainer/VBoxContainer/AbilityBtnPanelLabel
@onready var AbilityBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/AbilityBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/AbilityBtn
@onready var PassiveBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/AbilityBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/PassiveBtn
@onready var RoomDetailsToggleBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/AbilityBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/RoomDetailsToggleBtn
@onready var EmptyBuildBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/AbilityBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/EmptyBuildBtn

@onready var FacilityBtnPanel:PanelContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/FacilityBtnPanel

@onready var ConfirmBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSide/ConfirmBtn
@onready var BackBtn:BtnBase = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSide/BackBtn
@onready var RoomVBox:VBoxContainer = $Details/PanelContainer/MarginContainer/VBoxContainer/Room

@onready var Researchers:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/Researchers
@onready var ResearcherCount:Label = $Details/PanelContainer/MarginContainer/VBoxContainer/Researchers/HBoxContainer/ResearcherCount
@onready var ResearcherList:VBoxContainer = $Details/PanelContainer/MarginContainer/VBoxContainer/Researchers/ResearcherList

@onready var SynergyContainer:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/SynergyContainer
@onready var SynergyTraitList:VBoxContainer = $Details/PanelContainer/MarginContainer/VBoxContainer/SynergyContainer/SynergyTraitList
@onready var ScpMiniCard:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/Room/ScpMiniCard
@onready var RoomMiniCard:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/Room/RoomMiniCard

@onready var ScpDetails:Control = $ScpDetails
@onready var ScpDetailsPanel:PanelContainer = $ScpDetails/PanelContainer
@onready var ScpCard:Control = $ScpDetails/PanelContainer/SCPCard

@onready var ResearcherDetails:Control = $ResearcherDetails
@onready var ResearcherDetailsPanel:PanelContainer = $ResearcherDetails/PanelContainer
@onready var ResearcherCard:Control = $ResearcherDetails/PanelContainer/ResearcherCard

enum BOOKMARK_TYPE { GLOBAL, RING }
enum MODE { SELECT_FLOOR, SELECT_ROOM, SCP_DETAILS, RESEARCHER_DETAILS, INVESTIGATE, RESET_ROOM, DISMISS_RESEARCHER }
enum MENU_TYPE { ACTIONS = 0, ABILITIES = 1, PASSIVES = 2 }

const KeyBtnPreload:PackedScene = preload("res://UI/Buttons/KeyBtn/KeyBtn.tscn")
const ResearcherMiniCard:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ResearcherMiniCard/ResearcherMiniCard.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")

var previous_camera_type:int
var current_menu_type:MENU_TYPE = MENU_TYPE.ABILITIES
var current_bookmark_type:BOOKMARK_TYPE = BOOKMARK_TYPE.GLOBAL : 
	set(val):
		current_bookmark_type = val
		on_current_bookmark_type_update()

var current_mode:MODE = MODE.SELECT_FLOOR : 
	set(val):
		current_mode = val
		on_current_mode_update()

var selected_researcher:int = 0 : 
	set(val):
		selected_researcher = val
		on_selected_researcher_update()

var ref_btn:Control
var active_menu_index:int = 0
var active_menu_is_open:bool = false
var prev_draw_state:Dictionary	= {}
var is_setup:bool = false
var in_contain_mode:bool = false : 
	set(val):
		in_contain_mode = val
		if in_contain_mode:
			check_if_contain_is_valid()

var show_floating_nametags:bool = false : 
	set(val):
		show_floating_nametags = val
		on_show_floating_nametags_update()
		
var show_room_details:bool = false : 
	set(val):
		show_room_details = val
		on_show_room_details_update()

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
	
	for child in [SynergyTraitList]:
		for node in child.get_children():
			node.queue_free()	

	AssignBtn.onClick = func() -> void:
		call_and_redraw(func():await GAME_UTIL.assign_researcher(), true)
	
	UnassignBtn.onClick = func() -> void:
		current_mode = MODE.DISMISS_RESEARCHER
	
	for btn in [BuildBtn, EmptyBuildBtn]:
		btn.onClick = func() -> void:
			call_and_redraw(func():
				enable_room_focus(true)
				await GAME_UTIL.construct_room()
				enable_room_focus(false)
			)

		
	RoomDetailsToggleBtn.onClick = func() -> void:
		show_room_details = !show_room_details
	
	DecontructBtn.onClick = func() -> void:
		call_and_redraw(func():
			enable_room_focus(true)
			await GAME_UTIL.reset_room()
			enable_room_focus(false)
		)

	InfoBtn.onClick = func() -> void:
		current_menu_type = MENU_TYPE.ACTIONS
		match current_mode:
			MODE.SELECT_ROOM:
				active_menu_index = 0
				show_actions()

	AbilityBtn.onClick = func() -> void:
		current_menu_type = MENU_TYPE.ABILITIES
		active_menu_index = 0
		show_abilities(false)

	PassiveBtn.onClick = func() -> void:
		current_menu_type = MENU_TYPE.PASSIVES
		active_menu_index = 0
		show_passives(false)
		
	ActiveMenu.onNext = func() -> void:		
		match current_menu_type:
			MENU_TYPE.ACTIONS:
				active_menu_index = U.min_max(active_menu_index + 1, 0, 2)
				show_actions(true)
			MENU_TYPE.ABILITIES:
				active_menu_index = U.min_max(active_menu_index + 1, 0, GAME_UTIL.get_ability_level())
				show_abilities(true)
			MENU_TYPE.PASSIVES:
				active_menu_index = U.min_max(active_menu_index + 1, 0, GAME_UTIL.get_ability_level())
				show_passives(true)
		
	ActiveMenu.onPrev = func() -> void:
		match current_menu_type:
			MENU_TYPE.ACTIONS:
				active_menu_index = U.min_max(active_menu_index - 1, 0, 2)
				show_actions(true)
			MENU_TYPE.ABILITIES:
				active_menu_index = U.min_max(active_menu_index - 1, 0, GAME_UTIL.get_ability_level())
				show_abilities(true)
			MENU_TYPE.PASSIVES:
				active_menu_index = U.min_max(active_menu_index - 1, 0, GAME_UTIL.get_ability_level())
				show_passives(true)

	ActiveMenu.onDrawUpdate = func(index:int, selected_data:Dictionary) -> void:
		SUBSCRIBE.current_location = selected_data.shortcut_data.use_location
		update_details(selected_data.shortcut_data.use_location)
		draw_active_menu_items(selected_data, index)
		
	ScpDetailsBtn.onClick = func() -> void:
		current_mode = MODE.SCP_DETAILS
	
	ResearcherDetailBtn.onClick = func() -> void:
		current_mode = MODE.RESEARCHER_DETAILS
			
	HotkeyContainer.onBookmarkToggle = func() -> void:
		if current_bookmark_type == BOOKMARK_TYPE.GLOBAL:
			current_bookmark_type = BOOKMARK_TYPE.RING			
		elif current_bookmark_type == BOOKMARK_TYPE.RING:
			current_bookmark_type = BOOKMARK_TYPE.GLOBAL
	
	HotkeyContainer.onClearStart = func() -> void:
		freeze_inputs = true
		lock_btns(true, true)
	
	HotkeyContainer.onClearEnd = func() -> void:
		freeze_inputs = false
		lock_btns(false, true)

	ActiveMenu.onBookmark = func(shotcut_data:Dictionary, menu_btn:Control) -> void:		
		await U.tick()		
		drawline_bookmark()	
		ActiveMenu.freeze_inputs = true
		HotkeyContainer.start_bookmark(shotcut_data)

	HotkeyContainer.onBookmarkEnd = func() -> void:
		GBL.find_node(REFS.LINE_DRAW).clear()
		prev_draw_state = {}
		await U.tick()
		ActiveMenu.freeze_inputs = false
		draw_active_menu_items()

	HotkeyContainer.action_func_lookup = action_func_lookup
	HotkeyContainer.ability_funcs = ability_funcs
	HotkeyContainer.passive_funcs = passive_funcs			

	GBL.direct_ref["AbilityBtn"] = AbilityBtn
	GBL.direct_ref["PassiveBtn"] = PassiveBtn	
	GBL.direct_ref["ResearcherList"] = ResearcherList	
	GBL.direct_ref["RoomMiniCard"] = RoomMiniCard	
	GBL.direct_ref["ScpMiniCard"] = ScpMiniCard	
	GBL.direct_ref["HotkeyContainer"] = HotkeyContainer
	GBL.direct_ref["ActiveMenu"] = ActiveMenu
	
	on_show_room_details_update()
	on_show_floating_nametags_update()
	on_current_bookmark_type_update()
	on_current_mode_update()

	hide()		
	ScpDetailsPanel.hide()
	ResearcherDetails.hide()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()
	
	control_pos_default[BtnControlPanel] = BtnControlPanel.position
	control_pos_default[DetailsPanel] = DetailsPanel.position
	control_pos_default[ScpDetailsPanel] = ScpDetailsPanel.position
	control_pos_default[ResearcherDetailsPanel] = ResearcherDetailsPanel.position

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

	# for elements in the bottom left corner
	control_pos[BtnControlPanel] = {
		"global": BtnControlPanel.global_position,
		"show": control_pos_default[BtnControlPanel].y, 
		"hide": control_pos_default[BtnControlPanel].y + BtnControlPanel.size.y
	}
	
	# for eelements in the top right
	control_pos[DetailsPanel] = {
		"show": control_pos_default[DetailsPanel].x, 
		"hide": control_pos_default[DetailsPanel].x - DetailsPanel.size.x
	}	
	
	control_pos[ScpDetailsPanel] = {
		"show": control_pos_default[ScpDetailsPanel].y, 
		"hide": control_pos_default[ScpDetailsPanel].y - ScpDetailsPanel.size.y
	}		

	control_pos[ResearcherDetailsPanel] = {
		"show": control_pos_default[ResearcherDetailsPanel].y, 
		"hide": control_pos_default[ResearcherDetailsPanel].y - ResearcherDetailsPanel.size.y
	}		

	if ref_btn != null:
		ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	
	BtnControlPanel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	on_is_showing_update(true)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func toggle_camera_view() -> void:	
	lock_btns(true)
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
	lock_btns(false)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_is_showing_update(skip_animation:bool = false) -> void:	
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return
	
	U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show if is_showing else control_pos[BtnControlPanel].hide, 0 if skip_animation else 0.3)
	U.tween_node_property(DetailsPanel, "position:x", control_pos[DetailsPanel].hide, 0.3 if !skip_animation else 0)
	
	U.tween_node_property(ScpDetailsPanel, "position:y", control_pos[ScpDetailsPanel].hide, 0 if skip_animation else 0.3)	
	U.tween_node_property(ResearcherDetailsPanel, "position:y", control_pos[ResearcherDetailsPanel].hide, 0 if skip_animation else 0.3)		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func get_menu_y_pos() -> int:
	return self.size.y - 40 - ActiveMenu.size.y
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------				
func drawline_bookmark() -> void:	
	GBL.find_node(REFS.LINE_DRAW).add( func() -> Vector2:
		return Vector2(ActiveMenu.global_position.x + ActiveMenu.size.x + 10, ActiveMenu.global_position.y + ActiveMenu.size.y), { 
			"draw_hotkey": true, 
			"draw_active_menu": true, 
			"label": "PRESS [%s] TO ASSIGN TO HOTKEY" % ['E'],
		})	
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------
func draw_active_menu() -> void:
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
	var abilities:Array = room_extract.room.abilities if !room_extract.is_room_empty else []
	var passive_abilities:Array = room_extract.room.passive_abilities if !room_extract.is_room_empty else []
	var resources:Array = passive_abilities.filter(func(x): return "provides" in x and x.is_enabled).map(func(x): return x.provides)
	var get_node_pos:Callable = func() -> Vector2: 
		return GBL.find_node(REFS.ROOM_NODES).get_room_position(current_location.room) * self.size
	
	var draw_dict:Dictionary = {
		"use_nametag": true,
		"draw_ability": !abilities.is_empty(), 
		"draw_passive": !passive_abilities.is_empty(),
		#"draw_resource": !resources.is_empty(),
		#"draw_research": RESOURCE.TYPE.SCIENCE in room_extract.resource_details.total,
		#"draw_energy": RESOURCE.TYPE.ENERGY in room_extract.resource_details.total,
		#"draw_funding": RESOURCE.TYPE.MONEY in room_extract.resource_details.total,
		"draw_to_room": true,
		"draw_researcher": !room_extract.researchers.is_empty(),
		"draw_to_scp": !room_extract.is_scp_empty
	}
	
	if prev_draw_state != draw_dict:
		prev_draw_state = draw_dict
		GBL.find_node(REFS.LINE_DRAW).add( get_node_pos, draw_dict )
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
var selected_data_state:Dictionary
var selected_index_state:int 
func draw_active_menu_items(selected_data:Dictionary = selected_data_state, selected_index:int = selected_index_state) -> void:	
	selected_data_state = selected_data
	selected_index_state = selected_index
	
	var get_node_pos:Callable = func() -> Vector2: 
		return ActiveMenu.get_node_btn(selected_index).global_position - Vector2(200, 100)

	# do a check for passives to see if they provide a resource
	var draw_resource:bool = false
	if selected_data.shortcut_data.type == 2:
		var room_extract:Dictionary = GAME_UTIL.extract_room_details(selected_data.shortcut_data.use_location)	
		var item:Dictionary = room_extract.room.passive_abilities.filter(func(x): return x.name == selected_data.title)[0]
		draw_resource = "provides" in item

	var draw_dict:Dictionary = {
		"label": "PRESS [%s] TO USE" % ['E'],
		"draw_to_room": true,
		"draw_energy": selected_data.shortcut_data.type == 2,
		"draw_resource": draw_resource,
		"draw_ability": selected_data.shortcut_data.type == 1,
		"draw_passive": selected_data.shortcut_data.type == 2,
		"draw_active_menu": true
	}
	
	if prev_draw_state != draw_dict:
		prev_draw_state = draw_dict
		GBL.find_node(REFS.LINE_DRAW).add( get_node_pos, draw_dict)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------	
func show_generator_upgrades(skip_animation:bool = false) -> void:
	var options:Array = []
	
	options.push_back({
		"title": "UPGRADE GENERATOR LVL %s" % [base_states.floor[str(current_location.floor)].generator_level + 1],				
		"is_disabled": false,
		"action": func() -> void:
			await GAME_UTIL.upgrade_generator_level.call(),
		"onSelect": func(index:int) -> void:
			await options[index].action.call(),
	})					
	
	update_active_menu("GENERATOR", Color.WHITE, options, GAME_UTIL.get_ability_level(), Vector2(300, 300), skip_animation)	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func show_base_upgrades(skip_animation:bool = false) -> void:
	var options:Array = []
		
	var is_powered:Callable = func() -> bool:
		return room_config.floor[current_location.floor].is_powered
		
	var is_in_lockdown:Callable = func() -> bool:
		return room_config.floor[current_location.floor].in_lockdown		
	
	if !is_powered.call():
		options.push_back({
			"title": "UNLOCK FLOOR" if !is_powered.call() else "ALREADY UNLOCKED",					
			"is_disabled": is_powered.call(),
			"get_disabled_state": is_powered,		
			"action": func() -> void:
				await GAME_UTIL.activate_floor(),
			"onSelect": func(index:int) -> void:
				await options[index].action.call(),
		})
	
	options.push_back({
		"title": "LOCKDOWN FLOOR" if !is_in_lockdown.call() else "RELEASE LOCKDOWN",		
		"is_disabled": false,
		"action": func() -> void:
			await GAME_UTIL.set_floor_lockdown(!is_in_lockdown.call()),
		"onSelect": func(index:int) -> void:
			await options[index].action.call(),
	})						
	
	update_active_menu("UPGRADES", Color.WHITE, options, 0, Vector2(300, 300), skip_animation)		
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func action_func_lookup(title:String) -> Dictionary:
	var action_dict:Dictionary 
	match title:
		# ------------------
		"ASSIGN": 
			action_dict = {
				"onSelect": func(_index:int) -> void:
					enable_room_focus(true)
					await GAME_UTIL.assign_researcher()
			}					
		# ------------------
		"OBJECTIVES":
			action_dict = {
				"onSelect": func(_index:int) -> void:
					await GAME_UTIL.open_objectives(),
			}

		# ------------------
		"QUICKSAVE": 
			action_dict = {
				"onSelect": func(_index:int) -> void:
					GameplayNode.quicksave()
			}
		# ------------------		
		"QUICKLOAD": 
			action_dict = {
				"onSelect": func(_index:int) -> void:
					GameplayNode.quickload()
			}
		# ------------------				
	
	action_dict.title = title	
	action_dict.shortcut_data = {
		"type": MENU_TYPE.ACTIONS,
		"lookup_ref": title
	}

	return action_dict
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
func show_actions(skip_animation:bool = false) -> void:
	var options:Array = []
	var designation:String = str(current_location.floor, current_location.ring)	
	var extract_wing_data:Dictionary = GAME_UTIL.extract_wing_details()	
	var is_powered:bool = room_config.floor[current_location.floor].is_powered
	var menu_title:String = "TITLE"
	
	ActiveMenu.onClose = func() -> void:	
		GBL.find_node(REFS.LINE_DRAW).clear()
		prev_draw_state = {}		
		open_menu(false)
		on_current_location_update()
		
	var is_floating_checked:Callable = func() -> bool:
		return show_floating_nametags
	
	if active_menu_index == 0:
		menu_title = "LAYOUT"
		options.push_back({
			"title": "FLOATING",
			"icon": SVGS.TYPE.RESEARCH,
			"is_togglable": true,
			"is_checked": await is_floating_checked.call(),
			"get_checked_state": is_floating_checked,
			"action": func() -> void:
				show_floating_nametags = !show_floating_nametags,
			"onSelect": func(index:int) -> void:
				await options[index].action.call(),
		})				
		
	if active_menu_index == 1:
		menu_title = "INFORMATION"
		options.push_back(action_func_lookup('OBJECTIVES'))
		#options.push_back(action_func_lookup('ASSIGN'))
		
	if active_menu_index == 2:
		menu_title = "SYSTEM"
		options.push_back(action_func_lookup('QUICKSAVE'))
		options.push_back(action_func_lookup('QUICKLOAD'))

	ActiveMenu.level = active_menu_index
	ActiveMenu.show_ap = true

	update_active_menu(menu_title, Color.WHITE, options, 2, Vector2(10, AdminBtnPanel.global_position.y - 150), skip_animation)	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func ability_funcs(ability:Dictionary, use_location:Dictionary) -> Dictionary:
	var get_cooldown_duration:Callable = func() -> int:
		return GAME_UTIL.get_ability_cooldown(ability, use_location)
							
	var get_not_ready_func:Callable = func() -> bool:
		var enough_science:bool = resources_data[RESOURCE.TYPE.SCIENCE].amount  >= ability.science_cost
		var cooldown_duration:int = GAME_UTIL.get_ability_cooldown(ability, use_location)
		return cooldown_duration != 0 or !enough_science
		
	var get_icon_func:Callable = func() -> SVGS.TYPE:
		return SVGS.TYPE.MEDIA_PLAY if GAME_UTIL.get_ability_cooldown(ability, use_location) == 0 else SVGS.TYPE.CLEAR
	
	var get_invalid_func:Callable = func() -> bool:
		return !GAME_UTIL.does_ability_exists_in_ring(ability, use_location)
	
	return 	{
		"get_invalid_func": get_invalid_func,
		"get_cooldown_duration": get_cooldown_duration, 
		"get_not_ready_func": get_not_ready_func,
		"get_icon_func": get_icon_func
	}

func show_abilities(skip_animation:bool = false) -> void:
	var options:Array = []
	var designation:String = str(current_location.floor, current_location.ring)	
	var extract_wing_data:Dictionary = GAME_UTIL.extract_wing_details()	
	var extract_room_data:Dictionary = GAME_UTIL.extract_room_details()
	var is_powered:bool = room_config.floor[current_location.floor].is_powered
	var room_only:bool = current_mode == MODE.INVESTIGATE
	var room_name:String = extract_room_data.room.details.name if !extract_room_data.is_room_empty else "EMPTY"
	
	HotkeyContainer.enable_assign_mode(true)
	BackBtn.hide()
	ActiveMenu.onClose = func() -> void:	
		HotkeyContainer.enable_assign_mode(false)
		GBL.find_node(REFS.LINE_DRAW).clear()
		prev_draw_state = {}		
		open_menu(false)		
		BackBtn.show()		
		on_current_location_update()		

	if is_powered:
		for room_ref in extract_wing_data.abilities:
			var abilities:Array = extract_wing_data.abilities[room_ref]
			
			for index in abilities.size():
				var ability:Dictionary = abilities[index]
				var include:bool = true if !room_only else current_location.room == ability.room_index
				if active_menu_index == ability.lvl_required and include:
					var use_location:Dictionary = {"floor": current_location.floor, "ring": current_location.ring, "room": ability.room_index}
					var funcs:Dictionary = ability_funcs(ability.details, use_location)
					var get_cooldown_duration:Callable = funcs.get_cooldown_duration
					var get_not_ready_func:Callable = funcs.get_not_ready_func
					var get_icon_func:Callable = funcs.get_icon_func
					var science_cost:int = ability.details.science_cost
					
					options.push_back({
						"shortcut_data": {
							"room_ref": room_ref, 
							"index": index,
							"type": MENU_TYPE.ABILITIES,
							"use_location": use_location.duplicate(true), 
						},
						"title": ability.details.name,
						"science_cost": science_cost, 
						"cooldown_duration": await get_cooldown_duration.call(), 
						"is_disabled": await get_not_ready_func.call(),
						"get_disabled_state": get_not_ready_func,
						"get_cooldown_duration": get_cooldown_duration,
						"action": func() -> void:
							await call_and_redraw(func():
								await GAME_UTIL.use_active_ability(ability.details)
							),
						"onSelect": func(index:int) -> void:
							await options[index].action.call(),
					})				

	ActiveMenu.level = active_menu_index
	ActiveMenu.show_ap = true

	U.tween_node_property(DetailsPanel, "position:x", control_pos[DetailsPanel].show)	
	enable_room_focus(true)
	
	var use_global_position:Vector2 = Vector2(RoomMiniCard.global_position.x + RoomMiniCard.size.x + 250, RoomMiniCard.global_position.y + 0)
	update_active_menu("ABILITY [ALL]" if !room_only else "ABILITIES [%s]" % [room_name], Color.WHITE, options, GAME_UTIL.get_ability_level(), use_global_position, skip_animation)	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func call_and_redraw(action:Callable, show_details:bool = false) -> void:
	prev_draw_state = {}
	GBL.find_node(REFS.LINE_DRAW).clear()
	await action.call()
	await U.tick() # leave this in just in case any of the functions update data
	
	if active_menu_is_open:
		# redraws lines
		ActiveMenu.add_draw_lines()
		draw_active_menu_items()
		# shows the details panel
		U.tween_node_property(DetailsPanel, "position:x", control_pos[DetailsPanel].show)			
	else:
		on_current_location_update()
		GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer, GameplayNode.RoomInfo, GameplayNode.ResourceContainer, GameplayNode.MetricsContainer])
		if show_details:
			U.tween_node_property(DetailsPanel, "position:x", control_pos[DetailsPanel].show)	
	
	#on_current_mode_update(true)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func passive_funcs(room_ref:int, ability_index:int, use_location:Dictionary) -> Dictionary:
	var ability:Dictionary = ROOM_UTIL.return_passive_ability(room_ref, ability_index)
	
	var get_checked:Callable = func() -> bool: 
		await U.tick()
		return GAME_UTIL.get_passive_ability_state(room_ref, ability_index)
						
	var get_not_ready_func:Callable = func() -> bool: 
		return false 
		
	var get_icon_func:Callable = func() -> SVGS.TYPE:
		var is_checked:bool = GAME_UTIL.get_passive_ability_state(room_ref, ability_index)
		return SVGS.TYPE.CHECKBOX if await is_checked else SVGS.TYPE.EMPTY_CHECKBOX
		
	var get_invalid_func:Callable = func() -> bool:
		return !GAME_UTIL.does_passive_ability_exists_in_ring(ability, use_location)		
	
	return 	{
		"get_checked": get_checked,
		"get_not_ready_func": get_not_ready_func,
		"get_icon_func": get_icon_func,
		"get_invalid_func": get_invalid_func
	}
	
func show_passives(skip_animation:bool = false) -> void:
	var options:Array = []
	var extract_wing_data:Dictionary = GAME_UTIL.extract_wing_details()
	var extract_room_data:Dictionary = GAME_UTIL.extract_room_details()
	var designation:String = str(current_location.floor, current_location.ring)
	var room_only:bool = current_mode == MODE.INVESTIGATE
	var room_name:String = extract_room_data.room.details.name if !extract_room_data.is_room_empty else "EMPTY"

	HotkeyContainer.enable_assign_mode(true)
	BackBtn.hide()
	ActiveMenu.onClose = func() -> void:
		HotkeyContainer.enable_assign_mode(false)
		GBL.find_node(REFS.LINE_DRAW).clear()
		prev_draw_state = {}		
		open_menu(false)
		#enable_room_focus(false)
		BackBtn.show()		
		on_current_location_update()		

	for room_ref in extract_wing_data.passive_abilities:
		var abilities:Array = extract_wing_data.passive_abilities[room_ref]
		for index in abilities.size():
			var ability:Dictionary = abilities[index]
			var include:bool = true if !room_only else current_location.room == ability.room_index
			if active_menu_index == ability.lvl_required and include:
				var use_location:Dictionary = {"floor": current_location.floor, "ring": current_location.ring, "room": ability.room_index}
				var funcs:Dictionary = passive_funcs(room_ref, ability.index, use_location)
				var get_not_ready_func:Callable = funcs.get_not_ready_func
				var get_icon_func:Callable = funcs.get_icon_func
				var energy_cost:int = ability.details.energy_cost if "energy_cost" in ability.details else 1
				options.push_back({
					"shortcut_data": {
						"room_ref": room_ref, 
						"index": index, 
						"type": MENU_TYPE.PASSIVES,
						"use_location": use_location, 
					},
					"title": ability.details.name,
					"icon": SVGS.TYPE.RESEARCH,
					"energy_cost": energy_cost, 
					"is_togglable": true,
					"is_checked": await funcs.get_checked.call(),
					"is_disabled": await get_not_ready_func.call(),
					"get_disabled_state": get_not_ready_func,
					"get_checked_state": funcs.get_checked,
					"action": func() -> void:
						var is_checked:bool = GAME_UTIL.get_passive_ability_state(room_ref, ability.index)
						var energy:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].energy
						var energy_remaining:int = energy.available - energy.used
						var has_enough:bool = energy_remaining - energy_cost >= 0
						if !has_enough and !is_checked:return
						GAME_UTIL.toggle_passive_ability(room_ref, ability.index),
					"onSelect": func(index:int) -> void:
						await options[index].action.call(),
				})				

	ActiveMenu.level = active_menu_index
	ActiveMenu.show_ap = true

				
	U.tween_node_property(DetailsPanel, "position:x", control_pos[DetailsPanel].show)	
	enable_room_focus(true)
	
	var use_global_position:Vector2 = Vector2(RoomMiniCard.global_position.x + RoomMiniCard.size.x + 260, RoomMiniCard.global_position.y + 0)
	update_active_menu("PASSIVE [ALL]" if !room_only else "PASSIVES [%s]" % [room_name], Color.WHITE, options, GAME_UTIL.get_ability_level(), use_global_position, skip_animation)	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func update_active_menu(header:String, color:Color, options_list:Array, max_level:int, use_position:Vector2, skip_animation:bool) -> void:
	open_menu(true)
	
	ActiveMenu.header = header
	ActiveMenu.use_color = color
	ActiveMenu.options_list = options_list
	ActiveMenu.max_level = max_level
	ActiveMenu.size.y = 1
	ActiveMenu.custom_minimum_size.y = 1	
	
	update_details()
	
	if !skip_animation:
		ActiveMenu.global_position = use_position
		ActiveMenu.open()	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func on_base_states_update(new_val:Dictionary = base_states) -> void:
	base_states = new_val
	if !is_setup:
		U.debounce("build_btns", buildout_btns)		
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
var previous_designation:String
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if current_location.is_empty():return
	var designation:String = str(current_location.floor, current_location.ring)
	
	if current_mode == MODE.INVESTIGATE:
		var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
		var abilities:Array = room_extract.room.abilities if !room_extract.is_room_empty else []
		var passive_abilities:Array = room_extract.room.passive_abilities if !room_extract.is_room_empty else []
		var researchers_per_room:int = base_states.ring[str(current_location.floor, current_location.ring)].researchers_per_room

		ResearcherBtnPanel.show() if !room_extract.is_room_empty else ResearcherBtnPanel.hide()		
		for btn in [PassiveBtn, AbilityBtn, RoomDetailsToggleBtn]:
			if room_extract.is_room_empty:
				btn.hide()
			else: 
				btn.show()

		EmptyBuildBtn.show() if room_extract.is_room_empty else EmptyBuildBtn.hide()
		ResearcherNextBtn.hide() if researchers_per_room == 1 else ResearcherNextBtn.show()
		ScpBtnPanel.hide() if !room_extract.can_contain else ScpBtnPanel.show()
				
		AssignBtn.is_disabled = room_extract.researchers.size() >= researchers_per_room or active_menu_is_open
		UnassignBtn.is_disabled = room_extract.researchers.size() == 0  or active_menu_is_open
		ResearcherDetailBtn.is_disabled = room_extract.is_room_empty or room_extract.researchers.size() == 0  or active_menu_is_open		
		ScpDetailsBtn.is_disabled = room_extract.scp.is_empty() or active_menu_is_open
		PassiveBtn.is_disabled = passive_abilities.is_empty() or active_menu_is_open
		AbilityBtn.is_disabled = abilities.is_empty() or active_menu_is_open

		draw_active_menu()
		update_details()
		selected_researcher = 0
		return

	
	if current_mode == MODE.RESET_ROOM:
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
func set_backdrop_state(state:bool) -> void:	
	await U.tween_node_property(Backdrop, 'color', Color(0, 0, 0, 0.4 if state else 0.0))	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_current_bookmark_type_update() -> void:
	if !is_node_ready():return
	HotkeyContainer.current_bookmark_type = current_bookmark_type
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_selected_researcher_update() -> void:
	if current_mode != MODE.DISMISS_RESEARCHER:return
	for index in ResearcherList.get_child_count():
		var card:Control = ResearcherList.get_child(index)
		card.is_selected = index == selected_researcher

# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func enable_room_focus(state:bool) -> void:
	GBL.find_node(REFS.ROOM_NODES).enable_room_focus = state
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func render_shorcut_container() -> void:
	if !is_node_ready() or gameplay_conditionals.is_empty():return	
	#ShortcutBtnList.show()
	#LeftSideShortcutContainer.show() if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_ACTIVE_ABILITY_SHORTCUTS] else LeftSideShortcutContainer.hide()
	#RightSideShortcutContainer.show() if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_PASSIVE_ABILITY_SHORTCUTS] else RightSideShortcutContainer.hide()	
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
	
	GotoBtn.title = "DESIGN" if camera_settings.type == CAMERA.TYPE.FLOOR_SELECT else "ADMIN"
	
	NextBtn.onClick = func() -> void:
		if !active_menu_is_open and !GameplayNode.is_occupied(): 
			GameplayNode.next_day()
	
	GotoBtn.onClick = func() -> void:
		if !active_menu_is_open and !GameplayNode.is_occupied(): 
			toggle_camera_view()
			
	FloorPlanBtn.onClick = func() -> void:
		current_mode = MODE.INVESTIGATE		
		on_current_location_update()

	is_setup = true
	await U.set_timeout(0.1)
	refresh_buttons.emit()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------	
func on_show_floating_nametags_update() -> void:
	if !is_node_ready():return
	NameControl.show() if show_floating_nametags else NameControl.hide()
	hide_nametags(!show_floating_nametags)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_show_room_details_update() -> void:
	if !is_node_ready():return
	RoomDetailsControl.show() if show_room_details else RoomDetailsControl.hide()
	RoomDetailsToggleBtn.icon = SVGS.TYPE.CHECKBOX if show_room_details else SVGS.TYPE.EMPTY_CHECKBOX
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func hide_nametags(state:bool, fast:bool = false) -> void:
	for nametag in NameControl.get_children():
		nametag.fade = state
		if !fast:
			await U.set_timeout(0.02)
# --------------------------------------------------------------------------------------------------		
		

# --------------------------------------------------------------------------------------------------		
func lock_btns(state:bool, ignore_panel:bool = false) -> void:
	for panel in [NavBtnPanel, AdminBtnPanel, ResearcherBtnPanel, ScpBtnPanel, BaseBtnPanel, AbilityBtnPanel]:				
		for btn in panel.get_node('./MarginContainer/VBoxContainer/HBoxContainer').get_children():
			btn.is_disabled = state
	
	if !ignore_panel:
		await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide if state else control_pos[BtnControlPanel].show)

func open_menu(state:bool) -> void:	
	if state:
		active_menu_is_open = true
	
	for panel in [NavBtnPanel, AdminBtnPanel, ResearcherBtnPanel, ScpBtnPanel, BaseBtnPanel, AbilityBtnPanel]:
		for btn in panel.get_node('./MarginContainer/VBoxContainer/HBoxContainer').get_children():
			btn.is_disabled = state	
	
	ActiveMenu.freeze_inputs = !state
	
	if !state and current_mode != MODE.INVESTIGATE:
		U.tween_node_property(DetailsPanel, "position:x", control_pos[DetailsPanel].hide )	
	
	if !state:
		active_menu_is_open = false
	
# --------------------------------------------------------------------------------------------------		
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready():return	
	
	var duration:float = 0.0 if skip_animation else 0.3
	
	if !control_pos.is_empty():
		HotkeyContainer.lock_btns = true
				
		for btn in [ConfirmBtn, BackBtn]:
			btn.is_disabled = true
			
		U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide, duration)
		
		
	match current_mode:
		# --------------
		MODE.SELECT_FLOOR:
			hide_nametags(true)
			
			for panel in [ScpBtnPanel, ResearcherBtnPanel, AbilityBtnPanel, BaseBtnPanel, AdminBtnPanel]:
				panel.hide()
				
			for panel in [FacilityBtnPanel, NavBtnPanel]:
				panel.show()
			
			for btn in [ConfirmBtn, BackBtn, FloorPlanBtn]:
				btn.hide()
				
			HotkeyContainer.hide()
			HotkeyContainer.lock_btns = true
		# --------------
		MODE.SELECT_ROOM:
			AbilityBtn.title = "ABILITY"
			PassiveBtn.title = "PASSIVE"
			
			#render_nametags()
			NameControl.show()
			

			U.tween_node_property(DetailsPanel, "position:x", control_pos[DetailsPanel].hide, duration)

			for panel in [FacilityBtnPanel, ScpBtnPanel, ResearcherBtnPanel, AbilityBtnPanel]:
				panel.hide()
				
			for panel in [AdminBtnPanel, NavBtnPanel, BaseBtnPanel, HotkeyContainer]:
				panel.show()
				
			for btn in [ConfirmBtn, BackBtn]:
				btn.hide()
				
			for btn in [FloorPlanBtn]:
				btn.show()				
						
			HotkeyContainer.show()
			HotkeyContainer.lock_btns = false
			show_room_details = false
		# --------------
		MODE.INVESTIGATE:
			enable_room_focus(true)
			set_backdrop_state(true)	
			
			GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer, GameplayNode.RoomInfo, GameplayNode.ResourceContainer, GameplayNode.MetricsContainer])

			update_details()
			U.tween_node_property(DetailsPanel, "position:x", control_pos[DetailsPanel].show, duration)
			
			NameControl.hide()
			#CenterLabel.text = "ROOM OPTIONS"

			for panel in [AdminBtnPanel, NavBtnPanel, FacilityBtnPanel, ScpBtnPanel, BaseBtnPanel, ResearcherBtnPanel]:
				panel.hide()
				
			for panel in [ResearcherBtnPanel, ScpBtnPanel, AbilityBtnPanel]:
				panel.show()

			for btn in [ConfirmBtn, BackBtn]:
				btn.is_disabled = false

			BackBtn.show()
			ConfirmBtn.hide()
			
			HotkeyContainer.hide()
			HotkeyContainer.lock_btns = true
			
			BackBtn.onClick = func() -> void:				
				enable_room_focus(false)
				set_backdrop_state(false)	
				GameplayNode.restore_player_hud()
				
				prev_draw_state = {}
				GBL.find_node(REFS.LINE_DRAW).clear()
				current_mode = MODE.SELECT_ROOM
		# --------------
		MODE.SCP_DETAILS:
			var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
			var wing_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]
			ScpCard.current_metrics = wing_data.metrics
			ScpCard.ref = room_extract.scp.details.ref
			freeze_inputs = true
			
			ScpDetailsPanel.show()
			GBL.find_node(REFS.LINE_DRAW).clear()
			prev_draw_state = {}
			
			U.tween_node_property(DetailsPanel, "position:x", control_pos[DetailsPanel].hide)	
			U.tween_node_property(ScpDetailsPanel, "position:y", control_pos[ScpDetailsPanel].show)	
			
			GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer])
			BackBtn.is_disabled = false
			
			for panel in [ScpBtnPanel, AbilityBtnPanel, ResearcherBtnPanel]:
				panel.hide()			
			
			BackBtn.onClick = func() -> void:				
				freeze_inputs = false
				current_mode = MODE.INVESTIGATE
				on_current_location_update()
				await U.tween_node_property(ScpDetailsPanel, "position:y", control_pos[ScpDetailsPanel].hide)	
				ScpDetailsPanel.hide()				
		# --------------
		MODE.RESEARCHER_DETAILS:
			var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
			var uid:String = room_extract.researchers[selected_researcher].uid
			print(room_extract.researchers)
			ResearcherCard.uid = uid
			freeze_inputs = true
			
			ResearcherDetails.show()
			GBL.find_node(REFS.LINE_DRAW).clear()
			prev_draw_state = {}			
			
			U.tween_node_property(DetailsPanel, "position:x", control_pos[DetailsPanel].hide)	
			U.tween_node_property(ResearcherDetailsPanel, "position:y", control_pos[ResearcherDetailsPanel].show)
			
			GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer])
			BackBtn.is_disabled = false
			
			for panel in [ScpBtnPanel, AbilityBtnPanel, ResearcherBtnPanel]:
				panel.hide()						
			
			BackBtn.onClick = func() -> void:				
				freeze_inputs = false
				current_mode = MODE.INVESTIGATE
				on_current_location_update()
				await U.tween_node_property(ResearcherDetailsPanel, "position:y", control_pos[ResearcherDetailsPanel].hide)	
				ResearcherDetails.hide()							
		# --------------
		MODE.RESET_ROOM:
			check_if_remove_is_valid()
			
			HotkeyContainer.lock_btns = true
			
			for btn in [ConfirmBtn, BackBtn]:
				btn.show()
				btn.is_disabled = false
		# --------------
		MODE.DISMISS_RESEARCHER:
			for panel in [BaseBtnPanel, AbilityBtnPanel, ScpBtnPanel, BaseBtnPanel, ResearcherBtnPanel]:
				panel.hide()			
			
			selected_researcher = 0
			U.tween_node_property(DetailsPanel, "position:x", control_pos[DetailsPanel].show + 50, duration)
			
			GBL.find_node(REFS.LINE_DRAW).clear()
			RoomVBox.modulate = Color(1, 1, 1, 0)
			#TraitContainer.modulate = Color(1, 1, 1, 0)
				
			for btn in [ConfirmBtn, BackBtn]:
				btn.show()
				btn.is_disabled = false
				
			BackBtn.onClick = func() -> void:
				current_mode = MODE.INVESTIGATE
				RoomVBox.modulate = Color(1, 1, 1, 1)
				#TraitContainer.modulate = Color(1, 1, 1, 1)
				on_current_location_update()
			
			ConfirmBtn.onClick = func() -> void:
				var researcher:Dictionary = ResearcherList.get_child(selected_researcher).researcher
				await GAME_UTIL.unassign_researcher(researcher)
				current_mode = MODE.INVESTIGATE
				RoomVBox.modulate = Color(1, 1, 1, 1)
				#TraitContainer.modulate = Color(1, 1, 1, 1)
				on_current_location_update()
		
	if !control_pos.is_empty():
		U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show, duration )
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
func show_debug(skip_animation:bool = false) -> void:
	open_menu(true)
		
	var list:Array = []

	list.push_back({
		"title": "OPEN SHOP",
		"icon": SVGS.TYPE.RESEARCH,
		"action": func() -> void:
			await GAME_UTIL.open_store(),
		"onSelect": func(index:int) -> void:
			await list[index].action.call()
			GameplayNode.restore_player_hud(),
	})
	
	list.push_back({
		"title": "get_new_scp",
		"icon": SVGS.TYPE.RESEARCH,
		"action": func() -> void:
			await GAME_UTIL.get_new_scp(),
		"onSelect": func(index:int) -> void:
			await list[index].action.call()
			GameplayNode.restore_player_hud(),
	})	
	

	ActiveMenu.level = active_menu_index
	ActiveMenu.show_ap = true
	
	update_active_menu("DEBUG", Color.WHITE, list, 3, Vector2(10, 300), skip_animation)	
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------
func update_details(use_location:Dictionary = current_location) -> void:
	# update room_extract
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(use_location)	
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var is_room_empty:bool = room_extract.is_room_empty
	var is_activated:bool = room_extract.is_activated
	var abilities:Array = [] if is_room_empty else room_extract.room.abilities

	RoomMiniCard.is_activated = is_activated
	RoomMiniCard.is_room_under_construction = room_extract.is_room_under_construction	
	RoomMiniCard.ref = room_extract.room.details.ref if !is_room_empty else -1	
	
	AbilityBtnPanelLabel.text = "EMPTY" if is_room_empty else room_extract.room.details.name
	
	for node in [ResearcherList, SynergyTraitList]:
		for child in node.get_children():
			child.queue_free()
	
	RoomDetailsPanel.ref = -1 if is_room_empty else room_extract.room.details.ref
	
	
	if !room_extract.scp.is_empty():
		ScpMiniCard.ref = room_extract.scp.details.ref
	ScpMiniCard.show() if !room_extract.scp.is_empty() else ScpMiniCard.hide()
	
	## RESEARCHER DETAILS
	if room_extract.researchers.is_empty():
		Researchers.hide()
		#
		SynergyContainer.hide()
	else:
		Researchers.show()
		var total_traits_list := []
		
		for researcher in room_extract.researchers:
			var mini_card:Control = ResearcherMiniCard.instantiate()
			mini_card.researcher = researcher
			ResearcherList.add_child(mini_card)
			# add selected to selected list	
			total_traits_list.push_back(researcher.traits)
		ResearcherCount.text = "%s/%s" % [room_extract.researchers.size(), base_states.ring[str(current_location.floor, current_location.ring)].researchers_per_room]
	
	#TraitContainer.show() if !room_extract.trait_list.is_empty() else TraitContainer.hide()
	#for item in room_extract.trait_list:
		#var card:Control = TraitCardPreload.instantiate()
		#card.ref = item.details.ref
		#card.effect = item.effect
		#card.show_output = true
		#TraitList.add_child(card)
	
	SynergyContainer.hide() if room_extract.synergy_list.is_empty() else SynergyContainer.show()
	for item in room_extract.synergy_list:
		var card:Control = TraitCardPreload.instantiate()
		card.ref = item.details.ref
		card.effect = item.effect
		card.show_output = true
		card.is_synergy = true
		SynergyTraitList.add_child(card)		
	
	await U.tick()
	DetailsPanel.position.y = 0	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_showing or GameplayNode.is_occupied() or current_location.is_empty() or room_config.is_empty() or freeze_inputs or active_menu_is_open:return
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
						MODE.DISMISS_RESEARCHER:
							selected_researcher = U.min_max(selected_researcher - 1, 0, ResearcherList.get_child_count() - 1, true)
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
						MODE.DISMISS_RESEARCHER:
							selected_researcher = U.min_max(selected_researcher + 1, 0, ResearcherList.get_child_count() - 1, true)
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


## --------------------------------------------------------------------------------------------------
#func open_alarm_setting() -> void:
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
		
# --------------------------------------------------------------------------------------------------
	

## --------------------------------------------------------------------------------------------------		
#func open_scp_details() -> void:
	#options_list.push_back({
		#"title": "VIEW DETAILS",
		#"onSelect": func() -> void:
			#ActiveMenu.freeze_inputs = true				
			#await GameplayNode.view_scp_details()
			#ActiveMenu.freeze_inputs = false
	#})

## --------------------------------------------------------------------------------------------------			
#
## --------------------------------------------------------------------------------------------------		
#func open_room_menu() -> void:


## --------------------------------------------------------------------------------------------------			
#func open_scp_menu() -> void:
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

## --------------------------------------------------------------------------------------------------				
#
## --------------------------------------------------------------------------------------------------				
#func open_researcher_menu() -> void:

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
## --------------------------------------------------------------------------------------------------				

		
## ---- CENTER
#CenterBtnList

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
