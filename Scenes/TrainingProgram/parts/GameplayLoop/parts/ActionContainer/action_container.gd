extends GameContainer

#  ---------------------------------------
# SPECIAL NODES
@onready var RootPanel:PanelContainer = $"."
@onready var Backdrop:ColorRect = $Backdrop
@onready var ActiveMenu:PanelContainer = $Control/ActiveMenu
@onready var PreviewTextureRect:TextureRect = $FloorPreviewControl/PanelContainer/MarginContainer/VBoxContainer/PreviewTextureRect
@onready var BtnControls:Control = $BtnControls
@onready var NameControl:Control = $NameControl
@onready var RoomDetailsControl:Control = $RoomDetails
#  ---------------------------------------

#  ---------------------------------------
# MINICARDS
@onready var MiniCardPanel:PanelContainer = $MiniCardControl/PanelContainer
@onready var MiniCardMargin:MarginContainer = $MiniCardControl/PanelContainer/MarginContainer

@onready var ScpMiniCard:Control = $MiniCardControl/PanelContainer/MarginContainer/VBoxContainer/ScpMiniCard
@onready var RoomMiniCard:Control = $MiniCardControl/PanelContainer/MarginContainer/VBoxContainer/RoomMiniCard
@onready var ResearcherMiniCard:Control = $MiniCardControl/PanelContainer/MarginContainer/VBoxContainer/ResearcherMiniCard
#  ---------------------------------------

#  ---------------------------------------
# STATIC CONTROLS 
# GOTO PANEL
@onready var ActionControls:Control = $ActionControls
@onready var ActionPanel:PanelContainer = $ActionControls/PanelContainer
@onready var ActionMarginPanel:MarginContainer = $ActionControls/PanelContainer/MarginContainer

# GOTO PANEL
@onready var GotoBtnPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/GotoBtnPanel
@onready var GotoFloorBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/GotoFloorBtn
@onready var GotoWingBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/GotoWingBtn
@onready var GotoGeneratorBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/GotoGeneratorBtn

# FACILITY ACTION PANELS
@onready var FacilityActionPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/RightSide/FacilityActions
@onready var FacilityActionBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/RightSide/FacilityActions/MarginContainer/VBoxContainer/HBoxContainer/FacilityActionBtn
@onready var FacilityEndTurnBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/RightSide/WingActions/MarginContainer/VBoxContainer/HBoxContainer/FacilityEndTurnBtn

# WING ACTION PANELS
@onready var WingActionPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/RightSide/WingActions
@onready var WingActionBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/RightSide/WingActions/MarginContainer/VBoxContainer/HBoxContainer/WingActionBtn
@onready var WingEndTurnBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/RightSide/WingActions/MarginContainer/VBoxContainer/HBoxContainer/WingEndTurnBtn

# GENERATION ACTION PANEL
@onready var GenActionPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/RightSide/GeneratorActions
@onready var GenActionBtns:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/RightSide/GeneratorActions/MarginContainer/VBoxContainer/HBoxContainer/GenActionBtn
@onready var GenEndTurnBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/RightSide/GeneratorActions/MarginContainer/VBoxContainer/HBoxContainer/GenEndTurnBtn

# PLAYER BTNS
@onready var PlayerActionPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/LeftSide/PlayerActions
@onready var SettingsBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/LeftSide/PlayerActions/MarginContainer/VBoxContainer/HBoxContainer/SettingsBtn
@onready var ObjectivesBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/LeftSide/PlayerActions/MarginContainer/VBoxContainer/HBoxContainer/ObjectivesBtn
@onready var HintInfoBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/LeftSide/PlayerActions/MarginContainer/VBoxContainer/HBoxContainer/HintInfoBtn

# ACTION CONTROLS ?
@onready var BaseBtnPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/BaseBtnPanel
@onready var RoomBtnPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/RoomBtnPanel
@onready var RoomBtnPanelLabel:Label = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/RoomBtnPanel/MarginContainer/VBoxContainer/RoomBtnPanelLabel
#@onready var UseAbilityBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/RoomBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/UseAbilityBtn

#  ---------------------------------------

#  ---------------------------------------
# INVESTIGATE CONTROLS 
# GOTO PANEL
@onready var InvestigateControls:Control = $InvestigateControls
@onready var InvestigatePanel:PanelContainer = $InvestigateControls/PanelContainer
@onready var InvestigateMargin:MarginContainer = $InvestigateControls/PanelContainer/MarginContainer

@onready var ResearcherBtnPanel:Control = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/ResearcherBtnPanel
@onready var ScpBtnPanel:Control = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/ScpBtnPanel

@onready var AbilityBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/RoomBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/UseAbilityBtn
@onready var BuildBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/RoomBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/BuildBtn
@onready var DeconstructBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/RoomBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/DeconstructBtn

@onready var AssignBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/ResearcherBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/AssignBtn
@onready var UnassignBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/ResearcherBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/UnassignBtn
@onready var ContainBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/ScpBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/ContainBtn

@onready var HotkeyContainer:Control = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/RightSide/VBoxContainer2/HotkeyContainer

@onready var InvestigateBackBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/LeftSide/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/InvestigateBackBtn
#  ---------------------------------------

enum BOOKMARK_TYPE { GLOBAL, RING }
enum MODE { 
	NONE,
	SELECT_FLOOR, 
	SELECT_ROOM, 
	SCP_DETAILS, 
	INVESTIGATE, 
	ABILITY,
	BUILD,
	RESET_ROOM, 
	DISMISS_RESEARCHER 
}
enum MENU_TYPE { ACTIONS = 0, ABILITIES = 1, PASSIVES = 2 }

const KeyBtnPreload:PackedScene = preload("res://UI/Buttons/KeyBtn/KeyBtn.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")

var previous_camera_type:int
var current_menu_type:MENU_TYPE = MENU_TYPE.ABILITIES
#var current_bookmark_type:BOOKMARK_TYPE = BOOKMARK_TYPE.GLOBAL : 
	#set(val):
		#current_bookmark_type = val
		#on_current_bookmark_type_update()

var current_mode:MODE = MODE.NONE : 
	set(val):
		current_mode = val
		on_current_mode_update()
		
var show_room_details:bool = false : 
	set(val):
		show_room_details = val
		on_show_room_details_update()
		
var ref_btn:Control
var active_menu_index:int = 0
var active_menu_is_open:bool = false
var prev_draw_state:Dictionary	= {}
var is_setup:bool = false
var is_in_transition:bool = false 

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.ACTION_CONTAINER, self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.ACTION_CONTAINER)
	
func _ready() -> void:
	super._ready()
	
	BtnControls.reveal(false)
	NameControl.hide()
	
	var subviewport:SubViewport = GBL.find_node(REFS.ROOM_NODES).get_preview_viewport()
	PreviewTextureRect.texture = subviewport.get_texture()	
	
	# -------------------------------------
	BuildBtn.onClick = func() -> void:
		investigate_wrapper(func():			
			await GameplayNode.open_build()
		)
	
	ContainBtn.onClick = func() -> void:
		investigate_wrapper(func(): 
			await GAME_UTIL.contain_scp()
		)
		
	DeconstructBtn.onClick = func() -> void:
		investigate_wrapper(func():
			await GAME_UTIL.reset_room()
		)
	
	AssignBtn.onClick = func() -> void:
		investigate_wrapper(func():
			await GAME_UTIL.assign_researcher()
		)
	
	UnassignBtn.onClick = func() -> void:
		investigate_wrapper(func(): 
			var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)	
			var researcher_data:Dictionary = room_extract.researchers[0]
			await GAME_UTIL.unassign_researcher(researcher_data)	
		)
		
	#ActivateFloorBtn.onClick = func() -> void:
		#call_and_redraw(func(): 
			#await GAME_UTIL.activate_floor()
		#)
	# -------------------------------------


	
	# -------------------------------------
	ObjectivesBtn.onClick = func() -> void:
		await lock_actions(true)
		await GAME_UTIL.open_objectives()
		lock_actions(false)
		on_current_mode_update()
	
	SettingsBtn.onClick = func() -> void:
		await lock_actions(true)
		current_menu_type = MENU_TYPE.ACTIONS
		active_menu_index = 0
		show_actions()
		on_current_mode_update()
		
	HintInfoBtn.onClick = func() -> void:
		await lock_actions(true)
		
		BtnControls.itemlist = GBL.find_node(REFS.GAMEPLAY_HEADER).get_hint_buttons()
		BtnControls.directional_pref = "LR"
		BtnControls.offset = Vector2(0, 0)
		BtnControls.hide_a_btn = true
		BtnControls.reveal(true)
		
		await U.tick()
		BtnControls.item_index = 0
		BtnControls.onBack = func() -> void:
			await BtnControls.reveal(false)
			lock_actions(false)
			on_current_mode_update()		
	# -------------------------------------
	
	# -------------------------------------
	GotoFloorBtn.onClick = func() -> void:
		camera_settings.type = CAMERA.TYPE.FLOOR_SELECT
		SUBSCRIBE.camera_settings = camera_settings
	
	GotoWingBtn.onClick = func() -> void:
		camera_settings.type = CAMERA.TYPE.WING_SELECT
		SUBSCRIBE.camera_settings = camera_settings
	
	WingActionBtn.onClick = func() -> void:
		camera_settings.type = CAMERA.TYPE.ROOM_SELECT
		SUBSCRIBE.camera_settings = camera_settings
		current_mode = MODE.INVESTIGATE	
	
	GotoGeneratorBtn.onClick = func() -> void:
		camera_settings.type = CAMERA.TYPE.GENERATOR
		SUBSCRIBE.camera_settings = camera_settings
		
	# -------------------------------------
	
	
	ActiveMenu.onNext = func() -> void:		
		match current_menu_type:
			MENU_TYPE.ACTIONS:
				active_menu_index = U.min_max(active_menu_index + 1, 0, 2)
				show_actions(true)
			_:
				active_menu_index = U.min_max(active_menu_index + 1, 0, 1)
				#show_abilities(true)
		
	ActiveMenu.onPrev = func() -> void:
		match current_menu_type:
			MENU_TYPE.ACTIONS:
				active_menu_index = U.min_max(active_menu_index - 1, 0, 2)
				show_actions(true)
			_:
				active_menu_index = U.min_max(active_menu_index - 1, 0, 1)
				#show_abilities(true)

	#ActiveMenu.onDrawUpdate = func(index:int, selected_data:Dictionary) -> void:		
		#SUBSCRIBE.current_location = selected_data.shortcut_data.use_location
		#update_details(selected_data.shortcut_data.use_location)
		##draw_active_menu_items(selected_data, index)
		#
	##ScpDetailsBtn.onClick = func() -> void:
		##current_mode = MODE.SCP_DETAILS
	#
	##ResearcherDetailBtn.onClick = func() -> void:
		##current_mode = MODE.RESEARCHER_DETAILS
			
	#HotkeyContainer.onBookmarkToggle = func() -> void:
		#if current_bookmark_type == BOOKMARK_TYPE.GLOBAL:
			#current_bookmark_type = BOOKMARK_TYPE.RING			
		#elif current_bookmark_type == BOOKMARK_TYPE.RING:
			#current_bookmark_type = BOOKMARK_TYPE.GLOBAL
	
	#HotkeyContainer.onClearStart = func() -> void:
		#freeze_inputs = true
		##lock_btns(true, true)
	#
	#HotkeyContainer.onClearEnd = func() -> void:
		#freeze_inputs = false
		##lock_btns(false, true)

	#ActiveMenu.onBookmark = func(shotcut_data:Dictionary, menu_btn:Control) -> void:		
		#HotkeyContainer.enable_assign_mode(true)
		#await U.tick()		
		#drawline_bookmark()	
		#ActiveMenu.freeze_inputs = true
		#ActiveMenu.show_hotkey = true
		#HotkeyContainer.start_bookmark(shotcut_data)
#
	#HotkeyContainer.onBookmarkEnd = func() -> void:
		#ActiveMenu.show_hotkey = false
		#clear_lines()
		#await U.tick()
		#ActiveMenu.freeze_inputs = false
		#draw_active_menu_items()
		#
	#EndTurnBtn.onClick = func() -> void:
		#await lock_btns(true)
		#await GameplayNode.next_day()
		#lock_btns(false)


		
	#GotoBuildingBtn.onClick = func() -> void:
		#toggle_camera_view()
	#
	#GotoBaseBtn.onClick = func() -> void:
		#toggle_camera_view()
			#
	#FloorPlanBtn.onClick = func() -> void:
		#await lock_btns(true)
		#camera_settings.type = CAMERA.TYPE.ROOM_SELECT
		#SUBSCRIBE.camera_settings = camera_settings						
		#current_mode = MODE.INVESTIGATE		
		#lock_btns(false)
	

			

	#HotkeyContainer.action_func_lookup = action_func_lookup
	#HotkeyContainer.ability_funcs = ability_funcs
	#HotkeyContainer.passive_funcs = passive_funcs			
	
	#GBL.direct_ref["CenterBtnList"] = CenterBtnList
	#GBL.direct_ref["HotkeyContainer"] = HotkeyContainer
	GBL.direct_ref["ResearcherMiniCard"] = ResearcherMiniCard	
	GBL.direct_ref["RoomMiniCard"] = RoomMiniCard	
	GBL.direct_ref["ScpMiniCard"] = ScpMiniCard	
	#GBL.direct_ref["ActiveMenu"] = ActiveMenu
	
	on_show_room_details_update()
	#on_current_bookmark_type_update()
	
	hide()		
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()
	var duration:float = 0
	
	control_pos_default[ActionPanel] = ActionPanel.position
	control_pos_default[InvestigatePanel] = InvestigatePanel.position
	control_pos_default[MiniCardPanel] = MiniCardPanel.position
	
	lock_panel_btn_state(true, [InvestigatePanel, ActionPanel])

	update_control_pos(true)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos(true)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos(skip_animation:bool = false) -> void:	
	await U.tick()
	
	# for elements in the bottom left corner
	control_pos[ActionPanel] = {
		"show": control_pos_default[ActionPanel].y, 
		"hide": control_pos_default[ActionPanel].y + ActionMarginPanel.size.y
	}
	
	control_pos[InvestigatePanel] = {
		"show": control_pos_default[InvestigatePanel].y, 
		"hide": control_pos_default[InvestigatePanel].y + InvestigateMargin.size.y
	}	
	
	# for eelements in the top right
	control_pos[MiniCardPanel] = {
		"show": control_pos_default[MiniCardPanel].x, 
		"hide": control_pos_default[MiniCardPanel].x - MiniCardMargin.size.x
	}
	
	on_current_mode_update(skip_animation)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func on_is_showing_update(skip_animation:bool = false) -> void:	
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return
# --------------------------------------------------------------------------------------------------		

## --------------------------------------------------------------------------------------------------		
#func get_menu_y_pos() -> int:
	#return self.size.y - 40 - ActiveMenu.size.y
## --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------				
func clear_lines() -> void:
	GBL.find_node(REFS.LINE_DRAW).clear()
	prev_draw_state = {}			
# --------------------------------------------------------------------------------------------------				

## --------------------------------------------------------------------------------------------------				
#func drawline_bookmark() -> void:	
	#GBL.find_node(REFS.LINE_DRAW).add( func() -> Vector2:
		#return Vector2(ActiveMenu.global_position.x + ActiveMenu.size.x + 10, ActiveMenu.global_position.y - 70), { 
			#"draw_to_hotkeys": true, 
			#"draw_to_active_menu": true,
			#"label": "PRESS [%s] TO ASSIGN, [%s] TO CANCEL" % ['E', 'B'],
		#})	
## --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------
func draw_active_menu(draw_delay:float = 0) -> void:
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
	var abilities:Array = room_extract.room.abilities if !room_extract.is_room_empty else []
	var passive_abilities:Array = room_extract.room.passive_abilities if !room_extract.is_room_empty else []
	var resources:Array = passive_abilities.filter(func(x): return "personnel" in x and x.is_enabled).map(func(x): return x.personnel)
	var get_node_pos:Callable = func() -> Vector2: 
		return GBL.find_node(REFS.ROOM_NODES).get_room_position(current_location.room) * self.size
	
	var draw_dict:Dictionary = {
		"use_nametag": true,
		"draw_to_center_list": true,
		"draw_to_room_mini_card": true,
		"draw_to_researcher_list": !room_extract.researchers.is_empty(),
		"draw_to_scp_mini_card": !room_extract.is_scp_empty
	}
	
	if prev_draw_state != draw_dict:
		prev_draw_state = draw_dict
		GBL.find_node(REFS.LINE_DRAW).add( get_node_pos, draw_dict, draw_delay )
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
#var selected_data_state:Dictionary
#var selected_index_state:int 
#func draw_active_menu_items(selected_data:Dictionary = selected_data_state, selected_index:int = selected_index_state) -> void:	
	#selected_data_state = selected_data
	#selected_index_state = selected_index
	#var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
	#var get_node_pos:Callable = func() -> Vector2: 
		#return GBL.find_node(REFS.ROOM_NODES).get_room_position(current_location.room) * self.size
#
	## do a check for passives to see if they provide a resource
	#var draw_to_personnel:bool = false
	#var draw_to_research:bool = false
	#var draw_to_morale:bool = false
	#var draw_to_readiness:bool = false
	#var draw_to_safety:bool = false
	#var ability:Dictionary
	#
	## get ability data
	#match selected_data.shortcut_data.type:
		## IF ACTIVE
		#1:
			#ability = room_extract.room.abilities.filter(func(x): return x.name == selected_data.title)[0]
			#draw_to_research = true
		## IF PASSIVE
		#2:
			#ability = room_extract.room.passive_abilities.filter(func(x): return x.name == selected_data.title)[0]
			#draw_to_personnel = "personnel" in ability
	#
	## if any "metrics" draw to applies
	#if "metrics" in ability:
		#for ref in ability.metrics:
			#match ref:
				#RESOURCE.METRICS.MORALE:
					#draw_to_morale = true
				#RESOURCE.METRICS.SAFETY:
					#draw_to_safety = true
				#RESOURCE.METRICS.READINESS:
					#draw_to_readiness = true
#
	#
	#var draw_dict:Dictionary = {
		#"use_nametag": false,
		##"label": "PRESS [%s] TO USE" % ['E'],
		#"draw_to_research": selected_data.shortcut_data.type == 1,
		#"draw_to_personnel": draw_to_personnel,
		#
		#"draw_to_energy": selected_data.shortcut_data.type == 2,
		#"draw_to_morale": draw_to_morale,
		#"draw_to_readiness": draw_to_readiness,
		#"draw_to_safety": draw_to_safety,
		##
		#"draw_to_center_btn_list": true
	#}
	#
	#if prev_draw_state != draw_dict:
		#prev_draw_state = draw_dict
		#GBL.find_node(REFS.LINE_DRAW).add( get_node_pos, draw_dict, 0)
# --------------------------------------------------------------------------------------------------

## --------------------------------------------------------------------------------------------------	
#func show_generator_upgrades(skip_animation:bool = false) -> void:
	#var options:Array = []
	#
	#options.push_back({
		#"title": "UPGRADE GENERATOR LVL %s" % [base_states.floor[str(current_location.floor)].generator_level + 1],				
		#"is_disabled": false,
		#"action": func() -> void:
			#await GAME_UTIL.upgrade_generator_level.call(),
		#"onSelect": func(index:int) -> void:
			#await options[index].action.call(),
	#})					
	#
	#update_active_menu("GENERATOR", Color.WHITE, options, GAME_UTIL.get_ability_level(), Vector2(300, 300), skip_animation)	
## --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
#func show_base_upgrades(skip_animation:bool = false) -> void:
	#var options:Array = []
		#
	#var is_powered:Callable = func() -> bool:
		#return room_config.floor[current_location.floor].is_powered
		#
	#var is_in_lockdown:Callable = func() -> bool:
		#return room_config.floor[current_location.floor].in_lockdown		
	#
	#if !is_powered.call():
		#options.push_back({
			#"title": "UNLOCK FLOOR" if !is_powered.call() else "ALREADY UNLOCKED",					
			#"is_disabled": is_powered.call(),
			#"get_disabled_state": is_powered,		
			#"action": func() -> void:
				#await GAME_UTIL.activate_floor(),
			#"onSelect": func(index:int) -> void:
				#await options[index].action.call(),
		#})
	#
	#options.push_back({
		#"title": "LOCKDOWN FLOOR" if !is_in_lockdown.call() else "RELEASE LOCKDOWN",		
		#"is_disabled": false,
		#"action": func() -> void:
			#await GAME_UTIL.set_floor_lockdown(!is_in_lockdown.call()),
		#"onSelect": func(index:int) -> void:
			#await options[index].action.call(),
	#})						
	#
	#update_active_menu("UPGRADES", Color.WHITE, options, 0, Vector2(300, 300), skip_animation)		
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func action_func_lookup(title:String) -> Dictionary:
	var action_dict:Dictionary 
	match title:
		# ------------------	
		"EXIT GAME":
			action_dict = {
				"onSelect": func(_index:int) -> void:
					await GameplayNode.quicksave()
					GameplayNode.exit_game()
			}	
		# ------------------		
		"RETURN TO TITLESCREEN":
			action_dict = {
				"onSelect": func(_index:int) -> void:
					await GameplayNode.quicksave()
					GameplayNode.exit_to_titlescreen()
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
	var menu_title:String 
	NameControl.hide()
	set_backdrop_state(true)
	
	ActiveMenu.onClose = func() -> void:	
		clear_lines()
		NameControl.show()
		set_backdrop_state(false)
		open_menu(false)
		on_current_location_update()
		lock_actions(false)
		
	var is_fullscreen_checked:Callable = func() -> bool:
		return GBL.is_fullscreen
		
	var is_enable_nametags_checked:Callable = func() -> bool:
		return gameplay_conditionals[CONDITIONALS.TYPE.UI_ENABLE_NAMETAGS]
		
	var is_ability_hints_checked:Callable = func() -> bool:
		return gameplay_conditionals[CONDITIONALS.TYPE.UI_ENABLE_ABILITY_HINTS]
	
	if active_menu_index == 0:
		menu_title = "UI"
		options.push_back({
			"title": "FULLSCREEN",
			"icon": SVGS.TYPE.CONVERSATION,
			"is_togglable": true,
			"is_checked": await is_fullscreen_checked.call(),
			"get_checked_state": is_fullscreen_checked,
			"action": func() -> void:
				GBL.find_node(REFS.OS_ROOT).toggle_fullscreen(),	
			"onSelect": func(index:int) -> void:
				await options[index].action.call(),
		})
		
		options.push_back({
			"title": "NAMETAG OVERLAY",
			"icon": SVGS.TYPE.RESEARCH,
			"is_togglable": true,
			"is_checked": await is_enable_nametags_checked.call(),
			"get_checked_state": is_enable_nametags_checked,
			"action": func() -> void:
				gameplay_conditionals[CONDITIONALS.TYPE.UI_ENABLE_NAMETAGS] = !gameplay_conditionals[CONDITIONALS.TYPE.UI_ENABLE_NAMETAGS]
				SUBSCRIBE.gameplay_conditionals = gameplay_conditionals,
			"onSelect": func(index:int) -> void:
				await options[index].action.call(),
		})
		options.push_back({
			"title": "ABILITY HINTS",
			"icon": SVGS.TYPE.QUESTION_MARK,
			"is_togglable": true,
			"is_checked": await is_ability_hints_checked.call(),
			"get_checked_state": is_ability_hints_checked,
			"action": func() -> void:
				gameplay_conditionals[CONDITIONALS.TYPE.UI_ENABLE_ABILITY_HINTS] = !gameplay_conditionals[CONDITIONALS.TYPE.UI_ENABLE_ABILITY_HINTS]
				SUBSCRIBE.gameplay_conditionals = gameplay_conditionals,
			"onSelect": func(index:int) -> void:
				await options[index].action.call(),
		})		
	
		
	if active_menu_index == 1:
		menu_title = "SYSTEM"
		options.push_back(action_func_lookup('QUICKSAVE'))
	
	if active_menu_index == 2:
		menu_title = "QUIT"		
		options.push_back(action_func_lookup('RETURN TO TITLESCREEN'))		
		options.push_back(action_func_lookup('EXIT GAME'))


	ActiveMenu.level = active_menu_index
	ActiveMenu.show_ap = true

	#if active_menu_index == 1:
		#menu_title = "INFORMATION"
		#options.push_back(action_func_lookup('OBJECTIVES'))
		##options.push_back(action_func_lookup('ASSIGN'))

	var active_menu_pos:Vector2 = Vector2(GBL.game_resolution.x/2 - ActiveMenu.size.x/2, GBL.game_resolution.y/2 - ActiveMenu.size.y/2 - 100)
	update_active_menu(menu_title, Color.WHITE, options, 2, active_menu_pos, skip_animation)	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func ability_funcs(ability:Dictionary, use_location:Dictionary) -> Dictionary:
	var get_cooldown_duration:Callable = func() -> int:
		return GAME_UTIL.get_ability_cooldown(ability, use_location)
							
	var get_not_ready_func:Callable = func() -> bool:
		var enough_science:bool = resources_data[RESOURCE.CURRENCY.SCIENCE].amount  >= ability.science_cost
		var cooldown_duration:int = GAME_UTIL.get_ability_cooldown(ability, use_location)
		return false #cooldown_duration != 0 or !enough_science
		
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
# --------------------------------------------------------------------------------------------------
	
# --------------------------------------------------------------------------------------------------
func passive_funcs(room_ref:int, ability_index:int, use_location:Dictionary) -> Dictionary:
	var ability:Dictionary = ROOM_UTIL.return_passive_ability(room_ref, ability_index)
	
	var get_checked:Callable = func() -> bool: 
		await U.tick()
		return GAME_UTIL.get_passive_ability_state(room_ref, ability_index)
						
	var get_not_ready_func:Callable = func() -> bool: 
		var get_ability_level:int = GAME_UTIL.get_ability_level()	
		var is_checked:bool = GAME_UTIL.get_passive_ability_state(room_ref, ability_index)
		var energy:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].energy
		var energy_remaining:int = energy.available - energy.used
		if !is_checked and energy_remaining < ability.energy_cost:
			return true
		return get_ability_level < ability.lvl_required
		
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
# --------------------------------------------------------------------------------------------------
	
# --------------------------------------------------------------------------------------------------
func show_abilities() -> void:
	var extract_room_data:Dictionary = GAME_UTIL.extract_room_details()
	var is_powered:bool = room_config.floor[current_location.floor].is_powered
	var room_name:String = extract_room_data.room.details.name if !extract_room_data.is_room_empty else "EMPTY"
	BtnControls.itemlist = await RoomMiniCard.get_ability_btns()
	BtnControls.directional_pref = "UD"
	BtnControls.offset = RoomMiniCard.global_position
	
	await U.tick()
	
	BtnControls.item_index = 0
	BtnControls.reveal(true)
	BtnControls.onBack = func() -> void:
		await BtnControls.reveal(false)
		current_mode = MODE.INVESTIGATE
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func investigate_wrapper(action:Callable) -> void:
	clear_lines()
	await lock_investigate(true)
	await action.call()
	await U.tick() 
	lock_investigate(false)
	on_current_location_update()
	on_current_mode_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func before_use_ability(_ability:Dictionary) -> void:
	await BtnControls.reveal(false)
	
func after_use_ability(_ability:Dictionary) -> void:
	BtnControls.reveal(true)
	
func after_use_passive_ability(_ability:Dictionary) -> void:
	pass
	#update_details()
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
	
	
	if !skip_animation:
		await U.tick()
		ActiveMenu.global_position = use_position + Vector2(40, 100) #-ActiveMenu.size.y/2)
		ActiveMenu.open()	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
	
	var btnlist:Array = [GotoFloorBtn, GotoWingBtn, GotoGeneratorBtn]
	var actionpanels:Array = [WingActionPanel, FacilityActionPanel, GenActionPanel]
	
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			for btn in btnlist:
				btn.is_disabled = btn == GotoFloorBtn
			for panel in actionpanels:
				if panel == FacilityActionPanel:
					panel.show()
				else:
					panel.hide()
			NameControl.hide()
			
		CAMERA.TYPE.WING_SELECT:
			for btn in btnlist:
				btn.is_disabled = btn == GotoWingBtn
				
			for panel in actionpanels:
				if panel == WingActionPanel:
					panel.show()
				else:
					panel.hide()
					
			if current_mode == MODE.NONE:		
				await U.set_timeout(0.3)
				NameControl.show()
				
		CAMERA.TYPE.GENERATOR:
			for btn in btnlist:
				btn.is_disabled = btn == GotoGeneratorBtn
				
			for panel in actionpanels:
				if panel == GenActionPanel:
					panel.show()
				else:
					panel.hide()
					
			NameControl.hide()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
var previous_designation:String
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if current_location.is_empty():return
	
	# update room details control
	RoomDetailsControl.use_location = current_location
		
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
	
	if !room_extract.is_empty():
		AbilityBtn.show() if !room_extract.is_room_empty else AbilityBtn.hide()
		BuildBtn.show() if room_extract.is_room_empty else BuildBtn.hide()
		#ResearcherBtnPanel.hide() if room_extract.is_room_empty else ResearcherBtnPanel.show()
		ScpBtnPanel.hide() if room_extract.is_room_empty or !room_extract.can_contain else ScpBtnPanel.show()		
	
	if current_mode == MODE.INVESTIGATE:
		var abilities:Array = room_extract.room.abilities if !room_extract.is_room_empty else []
		var passive_abilities:Array = room_extract.room.passive_abilities if !room_extract.is_room_empty else []
		var researchers_per_room:int = base_states.ring[str(current_location.floor, current_location.ring)].researchers_per_room
		var warp_to_pos:Vector2 = GBL.find_node(REFS.ROOM_NODES).get_room_position(current_location.room) * self.size
		
		DeconstructBtn.is_disabled = room_extract.is_room_empty
		ContainBtn.is_disabled = !room_extract.scp.is_empty()
		AssignBtn.is_disabled = room_extract.researchers.size() >= researchers_per_room or active_menu_is_open
		UnassignBtn.is_disabled = room_extract.researchers.size() == 0  or active_menu_is_open

		RoomDetailsControl.show_room_card = !room_extract.is_room_empty
		RoomDetailsControl.show_scp_card = !room_extract.scp.is_empty() and room_extract.can_contain 
		RoomDetailsControl.show_researcher_card = !room_extract.is_room_empty and room_extract.researchers.size() > 0
		RoomMiniCard.use_location = current_location
				
		Input.warp_mouse(warp_to_pos)
		draw_active_menu()
		update_details(current_location)


# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func set_backdrop_state(state:bool) -> void:	
	await U.tween_node_property(Backdrop, 'color', Color(0, 0, 0, 0.4 if state else 0.0))	
# --------------------------------------------------------------------------------------------------	

## --------------------------------------------------------------------------------------------------	
#func on_current_bookmark_type_update() -> void:
	#if !is_node_ready():return
	#HotkeyContainer.current_bookmark_type = current_bookmark_type
## --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_investigate_controls(state:bool, duration:float = 0.3) -> void:
	await U.tween_node_property(InvestigatePanel, "position:y", control_pos[InvestigatePanel].show if state else control_pos[InvestigatePanel].hide , duration)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_action_controls(state:bool, duration:float = 0.3) -> void:
	await U.tween_node_property(ActionPanel, "position:y", control_pos[ActionPanel].show if state else control_pos[ActionPanel].hide, duration)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_cardminipanel(state:bool, duration:float = 0.3) -> void:
	await U.tween_node_property(MiniCardPanel, "position:x", control_pos[MiniCardPanel].show if state else control_pos[MiniCardPanel].hide, duration)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
#func on_selected_researcher_update() -> void:
	#if current_mode != MODE.DISMISS_RESEARCHER:return
	#for index in ResearcherList.get_child_count():
		#var card:Control = ResearcherList.get_child(index)
		#card.is_selected = index == selected_researcher

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

## --------------------------------------------------------------------------------------------------
#func buildout_btns() -> void:
	#if !is_node_ready() or camera_settings.is_empty() or room_config.is_empty() or current_location.is_empty():return	
	#var floor_config:Dictionary = room_config.floor[current_location.floor]
#
	#var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
	#var floor_is_powered:bool = room_extract.floor_config.is_powered
	#
	#var room_is_empty:bool = room_extract.room.is_empty()	
	#var is_activated:bool = room_extract.is_activated
	#var can_contain:bool =  room_extract.can_contain
	#var room_step_complete:bool = !room_is_empty
	#var scp_is_empty:bool = room_extract.is_scp_empty
#
	#var new_right_btn_list:Array = [] 
	#var new_left_btn_list:Array = []
	#var new_center_btn_list:Array = []
	#var reload:bool = false
	#
	#if camera_settings.type != previous_camera_type:
		#previous_camera_type = camera_settings.type	
		#reload = true
	#
	#
	##FloorPlanBtn.show() if floor_config.is_powered else FloorPlanBtn.hide()
	##ActivateFloorBtn.hide() if floor_config.is_powered else ActivateFloorBtn.show()
	#
	#is_setup = true
## --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
var previous_nametag_state:bool 
func on_gameplay_conditionals_update(new_val:Dictionary = gameplay_conditionals, force_change:bool = false) -> void:
	super.on_gameplay_conditionals_update(new_val)
	if !is_node_ready() or (current_mode == MODE.SELECT_FLOOR and !force_change):return
	var state:bool = gameplay_conditionals[CONDITIONALS.TYPE.UI_ENABLE_NAMETAGS]
	if previous_nametag_state != state or force_change:
		previous_nametag_state = state
		if state:
			NameControl.show()
			hide_nametags(!state)
		else:
			await hide_nametags(!state)
			NameControl.hide()
# --------------------------------------------------------------------------------------------------	

## --------------------------------------------------------------------------------------------------	
func on_show_room_details_update() -> void:
	if !is_node_ready():return
	RoomDetailsControl.reveal(show_room_details) 
## --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func hide_nametags(state:bool, fast:bool = false) -> void:
	for nametag in NameControl.get_children():
		nametag.fade = state
		if !fast:
			await U.set_timeout(0.02)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func lock_panel_btn_state(state:bool, panels:Array) -> void:
	for panel in panels:		
		var root_panel = panel.get_node('./MarginContainer/HBoxContainer') 
		if root_panel != null:
			for child in root_panel.get_children():
				for node in child.get_children():
					var btn_list:HBoxContainer = node.get_node('./MarginContainer/VBoxContainer/HBoxContainer/')
					if btn_list != null:
						for btn in btn_list.get_children():
							btn.is_disabled = state
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func lock_actions(state:bool, ignore_panel:bool = false) -> void:
	if state:
		freeze_inputs = true
		lock_panel_btn_state(state, [ActionPanel])
	await reveal_action_controls(!state)
	if !state:
		freeze_inputs = false
		lock_panel_btn_state(state, [ActionPanel])
		
func lock_investigate(state:bool, ignore_panel:bool = false) -> void:
	if state:
		freeze_inputs = true
		lock_panel_btn_state(state, [InvestigatePanel])
	await reveal_investigate_controls(!state)
	if !state:
		freeze_inputs = false
		lock_panel_btn_state(state, [InvestigatePanel])		

func open_menu(state:bool) -> void:	
	if state:
		RoomDetailsControl.reveal(false) 
		active_menu_is_open = true
		lock_panel_btn_state(true, [])
	
	ActiveMenu.freeze_inputs = !state
	
	if !state:
		if current_mode != MODE.INVESTIGATE:
			U.tween_node_property(MiniCardPanel, "position:x", control_pos[MiniCardPanel].hide )		
		
		RoomDetailsControl.reveal(show_room_details) 
		active_menu_is_open = false
		lock_panel_btn_state(false, [])
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return	
	var duration:float = 0.0 if skip_animation else 0.3
	
	match current_mode:
		# --------------
		MODE.NONE:
			camera_settings.type = CAMERA.TYPE.WING_SELECT
			SUBSCRIBE.camera_settings = camera_settings
						
			for btn in [InvestigateBackBtn, AbilityBtn]:
				btn.onClick = func() -> void:pass
					
			GBL.find_node(REFS.ROOM_NODES).update_camera_size(31)
			enable_room_focus(false)
			set_backdrop_state(false)	

			BtnControls.reveal(false)
			RoomDetailsControl.reveal(false) 
			NameControl.show()
			
			reveal_cardminipanel(false, duration)
			reveal_investigate_controls(false, duration)
			await reveal_action_controls(true, duration)
			
			lock_panel_btn_state(false, [ActionPanel])
		# --------------
		MODE.INVESTIGATE:
			lock_panel_btn_state(true, [ActionPanel])
			NameControl.hide()

			GBL.find_node(REFS.ROOM_NODES).update_camera_size(40)
			enable_room_focus(true)
			set_backdrop_state(true)	
			
			RoomDetailsControl.reveal(true)
			BtnControls.reveal(false)
			
			await reveal_action_controls(false)
			await reveal_investigate_controls(true)
			reveal_cardminipanel(true)
			
			lock_panel_btn_state(false, [InvestigatePanel])
			
			InvestigateBackBtn.onClick = func() -> void:						
				lock_panel_btn_state(true, [InvestigatePanel])
				clear_lines()
				reveal_cardminipanel(false)
				await reveal_investigate_controls(false)
				reveal_action_controls(true)
				
				current_mode = MODE.NONE

			AbilityBtn.onClick = func() -> void:
				current_mode = MODE.ABILITY

		# --------------
		MODE.ABILITY:
			clear_lines()
			RoomDetailsControl.reveal(false)
			lock_panel_btn_state(true, [InvestigatePanel])
			reveal_investigate_controls(false)
			show_abilities()
		# --------------

	on_current_location_update()	
	on_camera_settings_update()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------	
func check_if_remove_is_valid() -> void:
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)	
	var is_room_empty:bool = room_extract.is_room_empty
	
	#ConfirmBtn.title = "DESTROY"
	#ConfirmBtn.is_disabled = is_room_empty
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func check_if_contain_is_valid() -> void:
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)	
	var is_room_empty:bool = room_extract.is_room_empty
	var can_contain:bool = room_extract.can_contain
	#
	#ConfirmBtn.title = "CONTAIN"
	#ConfirmBtn.is_disabled = is_room_empty or !can_contain
# --------------------------------------------------------------------------------------------------	

# -------------------------------------------------------------------------------------------------				
#func show_debug(skip_animation:bool = false) -> void:
	#open_menu(true)
		#
	#var list:Array = []
#
	#list.push_back({
		#"title": "OPEN SHOP",
		#"icon": SVGS.TYPE.RESEARCH,
		#"action": func() -> void:
			#await GameplayNode.open_store(),
		#"onSelect": func(index:int) -> void:
			#await list[index].action.call()
			#GameplayNode.restore_player_hud(),
	#})
	#
	#list.push_back({
		#"title": "get_new_scp",
		#"icon": SVGS.TYPE.RESEARCH,
		#"action": func() -> void:
			#await GAME_UTIL.get_new_scp(),
		#"onSelect": func(index:int) -> void:
			#await list[index].action.call()
			#GameplayNode.restore_player_hud(),
	#})	
	#
#
	#ActiveMenu.level = active_menu_index
	#ActiveMenu.show_ap = true
	#
	#update_active_menu("DEBUG", Color.WHITE, list, 3, Vector2(10, 300), skip_animation)	
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------
func update_details(use_location:Dictionary) -> void:
	# update room_extract
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(use_location)	
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var is_room_empty:bool = room_extract.is_room_empty
	var is_activated:bool = room_extract.is_activated
	var abilities:Array = room_extract.room.abilities if !room_extract.is_room_empty else []
	var passive_abilities:Array = room_extract.room.passive_abilities if !room_extract.is_room_empty else []

	RoomMiniCard.ref = room_extract.room.details.ref if !is_room_empty else -1	
	RoomBtnPanelLabel.text = "EMPTY" if is_room_empty else room_extract.room.details.name if is_activated else "%s - INACTIVE" % [room_extract.room.details.name]
	
	# update RoomDetails
	RoomDetailsControl.room_ref = -1 if is_room_empty else room_extract.room.details.ref
	RoomDetailsControl.scp_ref = -1 if room_extract.scp.is_empty() else room_extract.scp.details.ref
	RoomDetailsControl.researcher_uid = -1 if room_extract.researchers.is_empty() else room_extract.researchers[0].uid
	
	# and jump to the right card
	if room_extract.scp.is_empty():
		RoomDetailsControl.cycle_to_room(true)
	else:
		RoomDetailsControl.cycle_to_scp(true)
	
	# Ability/Deconstruct button
	AbilityBtn.is_disabled = !is_activated or (abilities.is_empty() and passive_abilities.is_empty())
	DeconstructBtn.is_disabled = !room_extract.can_destroy

	if !room_extract.scp.is_empty():
		ScpMiniCard.ref = room_extract.scp.details.ref
	ScpMiniCard.show() if !room_extract.scp.is_empty() else ScpMiniCard.hide()
	
	## RESEARCHER DETAILS
	if room_extract.researchers.is_empty():
		ResearcherMiniCard.hide()
	else:
		ResearcherMiniCard.show()
		if room_extract.researchers.size() > 0:
			ResearcherMiniCard.researcher = room_extract.researchers[0]
			
	await U.tick()
	MiniCardPanel.position.y = 0	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_visible_in_tree() or GameplayNode.is_occupied() or current_location.is_empty() or room_config.is_empty() or !is_showing or freeze_inputs or is_in_transition:return
	var key:String = input_data.key

	match key:
		# ----------------------------
		"W":
			match current_mode:
				MODE.NONE:
					U.inc_floor()
				MODE.INVESTIGATE:
					U.room_up()
		# ----------------------------
		"S":
			match current_mode:
				MODE.NONE:
					U.dec_floor()
				MODE.INVESTIGATE:
					U.room_down()
		# ----------------------------
		"D":
			match current_mode:
				MODE.NONE:
					U.inc_ring()
				MODE.INVESTIGATE:
					U.room_right()
		# ----------------------------
		"A":
			match current_mode:
				MODE.NONE:
					U.dec_ring()
				MODE.INVESTIGATE:
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
