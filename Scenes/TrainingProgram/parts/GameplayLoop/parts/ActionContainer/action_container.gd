extends GameContainer

#  ---------------------------------------
# SPECIAL NODES
@onready var RootPanel:PanelContainer = $"."
@onready var Backdrop:ColorRect = $Backdrop
@onready var BtnControls:Control = $BtnControls
@onready var NameControl:Control = $NameControl
@onready var RoomDetailsControl:Control = $RoomDetails
@onready var ControllerOverlay:Control = $ControllerOverlay
#  ---------------------------------------

#  ---------------------------------------
# FLOOR PREVIEW
@onready var FloorPreviewControl:Control = $FloorPreviewControl
@onready var FloorPreviewPanel:PanelContainer = $FloorPreviewControl/PanelContainer
@onready var FloorPreviewMargin:MarginContainer = $FloorPreviewControl/PanelContainer/MarginContainer
@onready var PreviewTextureRect:TextureRect = $FloorPreviewControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PreviewTextureRect
#  ---------------------------------------

#  ---------------------------------------
# MINICARDS
@onready var MiniCardPanel:PanelContainer = $MiniCardControl/PanelContainer
@onready var MiniCardMargin:MarginContainer = $MiniCardControl/PanelContainer/MarginContainer
@onready var SummaryCard:PanelContainer = $MiniCardControl/PanelContainer/MarginContainer/VBoxContainer/SummaryCard
#  ---------------------------------------

#  ---------------------------------------
# STATIC CONTROLS 
# GOTO PANEL
@onready var ActionControls:Control = $ActionControls
@onready var ActionPanel:PanelContainer = $ActionControls/PanelContainer
@onready var ActionMarginPanel:MarginContainer = $ActionControls/PanelContainer/MarginContainer

# GOTO PANEL
@onready var GotoBtnPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel
@onready var GotoFloorBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/GotoFloorBtn
@onready var GotoWingBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/GotoWingBtn
@onready var GotoGeneratorBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/GotoGeneratorBtn

# FACILITY ACTION PANELS
@onready var FacilityActionPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/Center/FacilityActions
@onready var FacilityActionBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/Center/FacilityActions/MarginContainer/VBoxContainer/HBoxContainer/FacilityActionBtn
@onready var FacilityEndTurnBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/Center/FacilityActions/MarginContainer/VBoxContainer/HBoxContainer/FacilityEndTurnBtn

# WING ACTION PANELS
@onready var WingActionPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions
@onready var WingActionBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions/MarginContainer/VBoxContainer/HBoxContainer/WingActionBtn
@onready var WingEndTurnBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions/MarginContainer/VBoxContainer/HBoxContainer/WingEndTurnBtn

# GENERATION ACTION PANEL
@onready var GenActionPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/Center/GeneratorActions
@onready var GenActionBtns:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/Center/GeneratorActions/MarginContainer/VBoxContainer/HBoxContainer/GenActionBtn
@onready var GenEndTurnBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/Center/GeneratorActions/MarginContainer/VBoxContainer/HBoxContainer/GenEndTurnBtn

# PLAYER BTNS
@onready var PlayerActionPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer2/Right/PlayerActions
@onready var SettingsBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer2/Right/PlayerActions/MarginContainer/VBoxContainer/HBoxContainer/SettingsBtn
@onready var ObjectivesBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer2/Right/PlayerActions/MarginContainer/VBoxContainer/HBoxContainer/ObjectivesBtn
@onready var HintInfoBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer2/Right/PlayerActions/MarginContainer/VBoxContainer/HBoxContainer/HintInfoBtn

# ACTION CONTROLS 
@onready var RoomBtnPanel:PanelContainer = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/CenterBtnList/RoomBtnPanel
@onready var RoomBtnPanelLabel:Label = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer2/CenterBtnList/RoomBtnPanel/MarginContainer/VBoxContainer/RoomBtnPanelLabel
#  ---------------------------------------

#  ---------------------------------------
# INVESTIGATE CONTROLS 
# GOTO PANEL
@onready var InvestigateControls:Control = $InvestigateControls
@onready var InvestigatePanel:PanelContainer = $InvestigateControls/PanelContainer
@onready var InvestigateMargin:MarginContainer = $InvestigateControls/PanelContainer/MarginContainer
@onready var AbilityBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer2/CenterBtnList/RoomBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/UseAbilityBtn
@onready var BuildBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer2/CenterBtnList/RoomBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/BuildBtn
@onready var DeconstructBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer2/CenterBtnList/RoomBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/DeconstructBtn

#@onready var ResearcherBtnPanel:Control = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer2/CenterBtnList/ResearcherBtnPanel
#@onready var ResearcherPanelLabel:Label = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer2/CenterBtnList/ResearcherBtnPanel/MarginContainer/VBoxContainer/CenterLabel
#@onready var AssignBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer2/CenterBtnList/ResearcherBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/AssignBtn
#@onready var UnassignBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer2/CenterBtnList/ResearcherBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/UnassignBtn

#@onready var ScpBtnPanel:Control = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer2/CenterBtnList/ScpBtnPanel
#@onready var ContainBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer2/CenterBtnList/ScpBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/ContainBtn

@onready var HotkeyContainer:Control = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/RightSide/VBoxContainer2/HotkeyContainer
@onready var InvestigateBackBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/LeftSide/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/InvestigateBackBtn
#  ---------------------------------------

enum BOOKMARK_TYPE { GLOBAL, RING }
enum MODE { 
	NONE,
	ACTIONS,
	INVESTIGATE, 
	ABILITY,
	BUILD,
	RESET_ROOM, 
	DISMISS_RESEARCHER 
}
enum MENU_TYPE { ACTIONS = 0, ABILITIES = 1, PASSIVES = 2 }

const KeyBtnPreload:PackedScene = preload("res://UI/Buttons/KeyBtn/KeyBtn.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")
const NametagPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionContainer/parts/nametag.tscn")
const ActiveMenuPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionContainer/parts/ActiveMenu.tscn")

var current_mode:MODE = MODE.NONE : 
	set(val):
		current_mode = val
		on_current_mode_update()

var prev_draw_state:Dictionary	= {}
var is_in_transition:bool = false 
var is_busy:bool = false

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.ACTION_CONTAINER, self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.ACTION_CONTAINER)
		# set reference 
	GBL.direct_ref.erase("SummaryCard")

	
func _ready() -> void:
	super._ready()
	modulate = Color(1, 1, 1, 0)
	BtnControls.freeze_and_disable(true)			
	# set defaults
	BtnControls.reveal(false)
	
	# set reference 
	GBL.direct_ref["SummaryCard"] = SummaryCard	

	# CREATE NAMETAGS AND ADD THEM TO SCENE
	for index in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
		var new_node:Control = NametagPreload.instantiate()
		new_node.index = index
		NameControl.add_child(new_node)
	
	hide()		
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	await U.tick()
	
	control_pos_default[ActionPanel] = ActionPanel.position
	control_pos_default[InvestigatePanel] = InvestigatePanel.position
	control_pos_default[MiniCardPanel] = MiniCardPanel.position
	control_pos_default[FloorPreviewPanel] = FloorPreviewPanel.position
	
	lock_panel_btn_state(true, [InvestigatePanel, ActionPanel])

	update_control_pos(false)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func start(start_at_ring_level:bool = false) -> void:
	# -------------------------------------
	GotoFloorBtn.onClick = func() -> void:
		camera_settings.type = CAMERA.TYPE.FLOOR_SELECT
		SUBSCRIBE.camera_settings = camera_settings
	
	GotoWingBtn.onClick = func() -> void:
		camera_settings.type = CAMERA.TYPE.WING_SELECT
		SUBSCRIBE.camera_settings = camera_settings
	
	WingActionBtn.onClick = func() -> void:
		on_current_location_update()
		current_mode = MODE.INVESTIGATE	
		camera_settings.type = CAMERA.TYPE.ROOM_SELECT
		SUBSCRIBE.camera_settings = camera_settings
		
	GotoGeneratorBtn.onClick = func() -> void:
		camera_settings.type = CAMERA.TYPE.GENERATOR
		SUBSCRIBE.camera_settings = camera_settings	
	# -------------------------------------
	
	# -------------------------------------
	GenActionBtns.onClick = func() -> void:
		await lock_actions(true)
		show_generator_updates()
		
	FacilityActionBtn.onClick = func() -> void:
		ControllerOverlay.show_directional = false
		reveal_floorpreview(false)
		await lock_actions(true)
		show_facility_updates()
	# -------------------------------------	
	
	# -------------------------------------
	BuildBtn.onClick = func() -> void:
		current_mode = MODE.BUILD			

	AbilityBtn.onClick = func() -> void:
		current_mode = MODE.ABILITY			
		
	DeconstructBtn.onClick = func() -> void:
		investigate_wrapper(func():
			await GAME_UTIL.reset_room()
		)
	# -------------------------------------
	
	# -------------------------------------
	ObjectivesBtn.onClick = func() -> void:
		await lock_actions(true)
		await GAME_UTIL.open_objectives()
		lock_actions(false)
		on_current_mode_update()
	
	SettingsBtn.onClick = func() -> void:
		ControllerOverlay.hide()
		NameControl.hide()		
		await lock_actions(true)
		show_settings()
		
	HintInfoBtn.onClick = func() -> void:
		ControllerOverlay.hide()
		NameControl.hide()
		set_backdrop_state(true)
		await lock_actions(true)
		
		BtnControls.itemlist = GBL.find_node(REFS.GAMEPLAY_HEADER).get_hint_buttons()
		BtnControls.item_index = 0
		
		BtnControls.directional_pref = "LR"
		BtnControls.offset = Vector2(0, 0)
		BtnControls.hide_a_btn = true
		await BtnControls.reveal(true)
		
		BtnControls.onBack = func() -> void:
			await BtnControls.reveal(false)
			lock_actions(false)
			set_backdrop_state(false)
			ControllerOverlay.show()
			NameControl.show()
	# -------------------------------------
	
	current_mode = MODE.ACTIONS
	modulate = Color(1, 1, 1, 1)
	if start_at_ring_level:
		camera_settings.type = CAMERA.TYPE.WING_SELECT
		SUBSCRIBE.camera_settings = camera_settings		
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
		"show": 0, 
		"hide": ActionMarginPanel.size.y 
	}
	
	control_pos[InvestigatePanel] = {
		"show": 0, 
		"hide": InvestigateMargin.size.y
	}	
	
	# for eelements in the top right
	control_pos[MiniCardPanel] = {
		"show": 0, 
		"hide": -MiniCardMargin.size.x
	}
	
	control_pos[FloorPreviewPanel] = {
		"show": 0, 
		"hide":  -FloorPreviewMargin.size.x
	}	
	
	ActionPanel.position.y = control_pos[ActionPanel].hide
	InvestigatePanel.position.y = control_pos[InvestigatePanel].hide
	FloorPreviewPanel.position.x = control_pos[FloorPreviewPanel].hide
	
	on_current_mode_update(skip_animation)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func on_is_showing_update(skip_animation:bool = false) -> void:	
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------				
func clear_lines() -> void:
	GBL.find_node(REFS.LINE_DRAW).clear()
	prev_draw_state = {}			
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------
signal query_complete
func query_items(cards_on_screen:int, category:ROOM.CATEGORY, page:int, return_list:Array, is_disabled_func:Callable, hint_func:Callable) -> void:
	var query:Dictionary
	var start_at:int = page * cards_on_screen
	query = ROOM_UTIL.get_unlocked_category(category, start_at, cards_on_screen)	

	return_list.push_back(
		query.list.map(func(x):return {
			"title": x.details.name,
			"img_src": x.details.img_src,
			"is_disabled": is_disabled_func.call(x),
			"hint": hint_func.call(x), 
			"ref": x.ref,
			"details": x.details,
			"action": func() -> void:
				# update
				purchased_facility_arr.push_back({
					"ref": x.details.ref,
					"type_ref": x.details.type_ref,
					"location": current_location.duplicate()
				})
				
				SUBSCRIBE.purchased_facility_arr = purchased_facility_arr	
				SUBSCRIBE.resources_data = ROOM_UTIL.calculate_purchase_cost(x.details.ref),
		})
	)	
	
	if query.has_more:
		query_items(cards_on_screen, category, page + 1, return_list, is_disabled_func, hint_func)
	else:
		await U.tick()
		query_complete.emit(return_list)
		
func show_build_options() -> void:
	const list_size:int = 8
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()
	var options:Array = []
	
	for listitem in [
			{
				"title": 'FACILITY', 
				"type": ROOM.CATEGORY.STANDARD,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x:Dictionary) -> Dictionary:
					var description:String = "Construction cost: %s (You have %s available.)" % [x.details.costs.purchase, resources_data[RESOURCE.CURRENCY.MONEY].amount]
					return {
						"icon": SVGS.TYPE.MONEY,
						"title": x.details.name,
						"description": description if !ROOM_UTIL.at_own_limit(x.ref) else "At building capacity."
					},
			},
			{
				"title": 'CONTAINMENT', 
				"type": ROOM.CATEGORY.CONTAINMENT,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x:Dictionary) -> Dictionary:
					var description:String = "Construction cost: %s (You have %s available.)" % [x.details.costs.purchase, resources_data[RESOURCE.CURRENCY.MONEY].amount]
					return {
						"icon": SVGS.TYPE.MONEY,
						"title": x.details.name,
						"description": description if !ROOM_UTIL.at_own_limit(x.ref) else "At building capacity."
					},
			},
			{
				"title": 'SPECIAL', 
				"type": ROOM.CATEGORY.SPECIAL,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.CORE].amount or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x:Dictionary) -> Dictionary:
					var description:String = "Construction cost: %s (You have %s available.)" % [x.details.costs.purchase, resources_data[RESOURCE.CURRENCY.CORE].amount]
					return {
						"icon": SVGS.TYPE.GLOBAL,
						"title": x.details.name,
						"description": description if !ROOM_UTIL.at_own_limit(x.ref) else "At building capacity."
					},
			},
		]:
		query_items(list_size, listitem.type, 0, [], listitem.is_disabled_func, listitem.hint_func)
		var query_results:Array = await query_complete
		for index in query_results.size():
			var items:Array = query_results[index]
			if items.size() > 0:
				options.push_back({
					"title": listitem.title,
					"items": items,
					"footer": "%s / %s" % [index + 1, items.size() ],
				})		
		
	var onClose:Callable = func(skip_reveal:bool) -> void:
		previous_designation = ""
		on_current_location_update()	
		if !skip_reveal:
			await RoomDetailsControl.reveal(false)
		current_mode = MODE.INVESTIGATE
		
	
	ActiveMenuNode.onUpdate = func(item:Dictionary) -> void:
		# update card
		RoomDetailsControl.room_ref = item.ref
		
		# disable/enable btn
		var can_afford:bool = resources_data[RESOURCE.CURRENCY.MONEY].amount >= item.details.costs.purchase 
		ActiveMenuNode.disable_active_btn = !can_afford
		ActiveMenuNode.hint_border_color = Color.RED if !can_afford else Color(0.337, 0.275, 1.0)

		# draw lines
		var get_node_pos:Callable = func() -> Vector2: 
			return GBL.find_node(REFS.ROOM_NODES).get_room_position(current_location.room) * self.size
		GBL.find_node(REFS.LINE_DRAW).add( get_node_pos, {
			"draw_to_active_menu": true,
			"draw_to_money": item.details.costs.purchase > 0
		}, 0 )
	
	ActiveMenuNode.onBeforeClose = func() -> void:
		clear_lines()
	
	ActiveMenuNode.onClose = func() -> void:
		onClose.call(false)
		
	ActiveMenuNode.onAction = func() -> void:
		await ActiveMenuNode.close()
			
	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	
	# ACTIVATE NODE
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate()
	ActiveMenuNode.open()	
	

# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func show_generator_updates() -> void:			
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()
	
	var options:Array = [
		{
			"title": "GENERATOR ENHANCE",
			"items": [
				{
					"title": "Powerup X",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "FULLSCREEN",
						"description": "Supply power to FLOOR 0."
					},
					"is_togglable": true,
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.upgrade_generator_level()
						ActiveMenuNode.unlock(),
				},
				{
					"title": "Powerup Y",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "FULLSCREEN",
						"description": "Supply power to FLOOR 1."
					},
					"is_togglable": true,
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.upgrade_generator_level()
						ActiveMenuNode.unlock(),
				},
				{
					"title": "Powerup Z",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "FULLSCREEN",
						"description": "Supply power to FLOOR 2."
					},
					"is_togglable": true,
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.upgrade_generator_level()
						ActiveMenuNode.unlock(),
				},
			]
		}
	]
	
	ActiveMenuNode.onClose = func() -> void:	
		set_backdrop_state(false)
		await lock_actions(false)
		on_camera_settings_update()
	
	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	
	set_backdrop_state(true)
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate()
	ActiveMenuNode.open()	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func show_facility_updates() -> void:			
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()

	var options:Array = [
		{
			"title": "ENERGY SUPPLY",
			"items": [
				{
					"title": "Supply Power",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "FULLSCREEN",
						"description": "Supply power to FLOOR %s." % [current_location.floor]
					},
					"is_togglable": true,
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.activate_floor(current_location.floor)
						ActiveMenuNode.unlock(),
				}
			]
		}
	]

	ActiveMenuNode.onClose = func() -> void:	
		set_backdrop_state(false)
		await lock_actions(false)
		on_camera_settings_update()
	
	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	
	set_backdrop_state(true)
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate()
	ActiveMenuNode.open()	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func show_settings() -> void:			
	var is_fullscreen_checked:Callable = func() -> bool:
		return GBL.is_fullscreen
		
	var is_enable_nametags_checked:Callable = func() -> bool:
		return true
		
	var is_ability_hints_checked:Callable = func() -> bool:
		return true
	
	var options:Array = [
		{
			"title": "GRAPHICS",
			"items": [
				{
					"title": "Fullscreen",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "FULLSCREEN",
						"description": "Change to and from fullscreen mode."
					},
					"is_togglable": true,
					"is_checked": await is_fullscreen_checked.call(),
					"get_checked_state": is_fullscreen_checked,
					"action": func() -> void:
						GBL.find_node(REFS.OS_ROOT).toggle_fullscreen(),
				},
			]
		},
		{
			"title": "SAVE AND LOAD",
			"items": [
				{
					"title": "Quicksave",
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"description": "Save your current progress"
					},
					"action": func() -> void:
						GameplayNode.quicksave(),
				}
			]
		},
		{
			"title": "QUIT",
			"items": [
				{
					"title": "Exit Game",
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"description": "Exit your current game."
					},
					"action": func() -> void:
						get_tree().quit(),
				},				
				{
					"title": "Return to Desktop",
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"description": "Exit your current game."
					},
					"action": func() -> void:
						await GameplayNode.quicksave()
						GameplayNode.exit_game(),
				},
				{
					"title": "Return to Titlescreen",
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"description": "Exit to title screen."
					},
					"action": func() -> void:
						await GameplayNode.quicksave()
						GameplayNode.exit_to_titlescreen(),
				},	
			]
		},		
	]
	
	set_backdrop_state(true)

	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()
	
	ActiveMenuNode.onBeforeAction = func(_item:Dictionary) -> void:
		pass
	
	ActiveMenuNode.onAfterAction = func(_item:Dictionary) -> void:
		pass
	
	ActiveMenuNode.onClose = func() -> void:	
		set_backdrop_state(false)
		await lock_actions(false)
		on_current_mode_update()

	
	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate()
	ActiveMenuNode.open()	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func investigate_wrapper(action:Callable) -> void:
	clear_lines()
	await lock_investigate(true)
	await action.call()
	await U.tick() 
	await lock_investigate(false)
	
	previous_designation = ""
	on_current_location_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func before_use() -> void:
	await BtnControls.reveal(false)
	
func after_use() -> void:
	BtnControls.reveal(true)
	
func after_use_passive_ability() -> void:
	pass
	#update_details()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty() or control_pos.is_empty() or current_mode == MODE.NONE:return
	
	var btnlist:Array = [GotoFloorBtn, GotoWingBtn, GotoGeneratorBtn]
	var actionpanels:Array = [WingActionPanel, FacilityActionPanel, GenActionPanel]
	
	match camera_settings.type:
		# ----------------------
		CAMERA.TYPE.FLOOR_SELECT:
			NameControl.hide()
			ControllerOverlay.hide()
			ControllerOverlay.show_directional = false
			
			if camera_settings.is_locked:
				reveal_floorpreview(false)
			else:
				reveal_floorpreview(true)
			
			if !is_in_transition:
				for btn in btnlist:
					btn.is_disabled = btn == GotoFloorBtn
					
			for panel in actionpanels:
				if panel == FacilityActionPanel:
					panel.show()
				else:
					panel.hide()
			
		# ----------------------
		CAMERA.TYPE.WING_SELECT:
			reveal_floorpreview(false)
			NameControl.show()
			ControllerOverlay.show()
			ControllerOverlay.show_directional = true
			
			for panel in actionpanels:
				if panel == WingActionPanel:
					panel.show()
				else:
					panel.hide()
			
			if !is_in_transition:
				for btn in btnlist:
					btn.is_disabled = btn == GotoWingBtn
					
		# ----------------------
		CAMERA.TYPE.GENERATOR:
			reveal_floorpreview(false)
			NameControl.hide()
			ControllerOverlay.hide()			
			ControllerOverlay.show_directional = false
			
			if !is_in_transition:
				for btn in btnlist:
					btn.is_disabled = btn == GotoGeneratorBtn
					
			for panel in actionpanels:
				if panel == GenActionPanel:
					panel.show()
				else:
					panel.hide()
					
			
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
var previous_designation:String
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if current_location.is_empty() or room_config.is_empty() or camera_settings.type == CAMERA.TYPE.FLOOR_SELECT or is_in_transition:return
	
	# update room details control
	RoomDetailsControl.use_location = current_location
		
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
	var is_powered:bool = room_config.floor[current_location.floor].is_powered
	var in_lockdown:bool = room_config.floor[current_location.floor].in_lockdown
	var is_room_empty:bool = room_extract.room.is_empty()
	var is_scp_empty:bool = room_extract.scp.is_empty()
	var is_activated:bool = false if is_room_empty else room_extract.room.is_activated
	var can_contain:bool = false if is_room_empty else room_extract.room.details.can_contain
	var can_assign_researchers:bool = false if is_room_empty else room_extract.room.details.can_assign_researchers
	var can_take_action:bool = (is_powered and !in_lockdown)
	var has_options:bool = SummaryCard.get_ability_btns().size() > 0
	
	if !room_extract.is_empty():
		AbilityBtn.show() if !is_room_empty else AbilityBtn.hide()
		BuildBtn.show() if is_room_empty else BuildBtn.hide()

		if previous_designation != U.location_to_designation(current_location):
			previous_designation = U.location_to_designation(current_location)	
			SummaryCard.use_location = current_location
			SummaryCard.room_ref = room_extract.room.details.ref if !is_room_empty else -1

	match current_mode:
		# -----------
		MODE.ACTIONS:
			NameControl.show()
			ControllerOverlay.show_directional = true
			WingActionBtn.is_disabled = !is_powered or in_lockdown
			WingActionBtn.icon = SVGS.TYPE.DELETE if !is_powered or in_lockdown else SVGS.TYPE.CONTAIN
			
			camera_settings.type = CAMERA.TYPE.WING_SELECT
			SUBSCRIBE.camera_settings = camera_settings
		# -----------
		MODE.INVESTIGATE:
			NameControl.hide()
			ControllerOverlay.show_directional = false
			var abilities:Array = room_extract.room.abilities if !is_room_empty else []
			var passive_abilities:Array = room_extract.room.passive_abilities if !is_room_empty else []
			var researchers_per_room:int = base_states.ring[str(current_location.floor, current_location.ring)].researchers_per_room
			var warp_to_pos:Vector2 = GBL.find_node(REFS.ROOM_NODES).get_room_position(current_location.room) * self.size
			
			# update mouse
			Input.warp_mouse(warp_to_pos)
			
			# update roomDetailsControl
			RoomDetailsControl.show_room_card = !is_room_empty
			RoomDetailsControl.show_scp_card = false
			RoomDetailsControl.show_researcher_card = false	
			
			RoomDetailsControl.room_ref = -1 if is_room_empty else room_extract.room.details.ref
			RoomDetailsControl.researcher_uid = -1 
			

			RoomDetailsControl.disable_location = false
			RoomDetailsControl.reveal(!is_room_empty)
			
			RoomBtnPanelLabel.text = "EMPTY" if is_room_empty else room_extract.room.details.name if is_activated else "%s - INACTIVE" % [room_extract.room.details.name]
			
			# set button states
			BuildBtn.is_disabled = !is_room_empty
			DeconstructBtn.is_disabled = is_room_empty

			if can_take_action:
				AbilityBtn.is_disabled = !is_activated and has_options
				DeconstructBtn.is_disabled = true if is_room_empty else !room_extract.room.can_destroy
			else:
				AbilityBtn.is_disabled = true
				DeconstructBtn.is_disabled = true
						
			# update line draw
			var get_node_pos:Callable = func() -> Vector2: 
				return GBL.find_node(REFS.ROOM_NODES).get_room_position(current_location.room) * self.size			
						
			GBL.find_node(REFS.LINE_DRAW).add( get_node_pos, {
				"draw_to_summary_card": true,
			}, 0 )
		# -----------	
		MODE.BUILD:
			RoomDetailsControl.show_room_card = true
			RoomDetailsControl.show_scp_card = false
			RoomDetailsControl.show_researcher_card = false	
			RoomDetailsControl.disable_location = true
			RoomDetailsControl.reveal(true)

# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func set_backdrop_state(state:bool) -> void:	
	await U.tween_node_property(Backdrop, 'color', Color(0, 0, 0, 0.4 if state else 0.0))	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func reveal_floorpreview(state:bool, duration:float = 0.3) -> void:
	if control_pos.is_empty():return
	
	if state:
		FloorPreviewControl.show()
		var subviewport:SubViewport = GBL.find_node(REFS.ROOM_NODES).get_preview_viewport()
		PreviewTextureRect.texture = subviewport.get_texture()		
	
	await U.tween_node_property(FloorPreviewPanel, "position:x", control_pos[FloorPreviewPanel].show if state else control_pos[FloorPreviewPanel].hide , duration)
	
	if !state:
		PreviewTextureRect.texture = null
		FloorPreviewControl.hide()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func reveal_investigate_controls(state:bool, duration:float = 0.3) -> void:
	if control_pos.is_empty():return
	
	is_in_transition = true
	await U.tween_node_property(InvestigatePanel, "position:y", control_pos[InvestigatePanel].show if state else control_pos[InvestigatePanel].hide, duration)
	is_in_transition = false
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_action_controls(state:bool, duration:float = 0.3) -> void:
	if control_pos.is_empty():return
	
	is_in_transition = true
	await U.tween_node_property(ActionPanel, "position:y", control_pos[ActionPanel].show if state else control_pos[ActionPanel].hide, duration)
	is_in_transition = false
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_cardminipanel(state:bool, duration:float = 0.3) -> void:
	await U.tween_node_property(MiniCardPanel, "position:x", control_pos[MiniCardPanel].show if state else control_pos[MiniCardPanel].hide, duration)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func enable_room_focus(state:bool) -> void:
	GBL.find_node(REFS.ROOM_NODES).enable_room_focus = state
# --------------------------------------------------------------------------------------------------	
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
		var margin_panel = panel.get_node('./MarginContainer') 
		for root_panel in margin_panel.get_children():
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
		lock_panel_btn_state(state, [InvestigatePanel, ActionPanel])
	
	await reveal_action_controls(!state)
	
	if !state:
		freeze_inputs = false
		lock_panel_btn_state(state, [ActionPanel])
		
func lock_investigate(state:bool, ignore_panel:bool = false) -> void:
	if state:
		freeze_inputs = true
		lock_panel_btn_state(state, [InvestigatePanel, ActionPanel])
		
	await reveal_investigate_controls(!state)
	
	if !state:
		freeze_inputs = false
		lock_panel_btn_state(state, [InvestigatePanel])		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return	
	var duration:float = 0.0 if skip_animation else 0.3
	
	match current_mode:
		MODE.NONE:
			BtnControls.reveal(false)
			RoomDetailsControl.reveal(false) 
			ControllerOverlay.hide()
			
			reveal_cardminipanel(false, duration)
		# --------------
		MODE.ACTIONS:					
			enable_room_focus(false)
			set_backdrop_state(false)	

			BtnControls.reveal(false)
			RoomDetailsControl.reveal(false) 
			ControllerOverlay.show()
			
			reveal_cardminipanel(false, duration)
			await lock_actions(false)
			
		# --------------
		MODE.INVESTIGATE:
			InvestigateBackBtn.onClick = func() -> void:
				await lock_investigate(true)
				clear_lines()
				reveal_cardminipanel(false)
				await reveal_investigate_controls(false)
				reveal_action_controls(true)
				current_mode = MODE.ACTIONS

			enable_room_focus(true)
			set_backdrop_state(true)	
			
			BtnControls.reveal(false)
			ControllerOverlay.hide()
			
			reveal_action_controls(false)
			reveal_cardminipanel(true)
			
			await lock_actions(true)			
			await lock_investigate(false)
		
		# --------------
		MODE.ABILITY:
			var extract_room_data:Dictionary = GAME_UTIL.extract_room_details()
			var is_powered:bool = room_config.floor[current_location.floor].is_powered
			var is_room_empty:bool = extract_room_data.room.is_empty()
			var room_name:String = extract_room_data.room.details.name if !is_room_empty else "EMPTY"

			BtnControls.itemlist = SummaryCard.get_ability_btns()
			BtnControls.item_index = 0
			
			BtnControls.directional_pref = "UD"
			BtnControls.offset = SummaryCard.global_position

			BtnControls.onUpdate = func(node:Control) -> void:
				# toggle is selected
				for _node in BtnControls.itemlist:
					if "is_selected" in _node:
						_node.is_selected = _node == node
										
				# ----------------------
				if "ability_data" in node:
					RoomDetailsControl.cycle_to_room(true)
					await U.tick()
					RoomDetailsControl.show_room_card = true
					RoomDetailsControl.show_scp_card = false
					RoomDetailsControl.show_researcher_card = false
				# ----------------------
				if "researcher" in node:
					RoomDetailsControl.researcher_uid = node.researcher.uid if !node.researcher.is_empty() else -1
					RoomDetailsControl.cycle_to_reseacher(true)
					await U.tick()
					RoomDetailsControl.show_room_card = false
					RoomDetailsControl.show_scp_card = false
					RoomDetailsControl.show_researcher_card = true	
				# ----------------------
				if "scp_ref" in node:
					RoomDetailsControl.scp_ref = node.scp_ref 
					RoomDetailsControl.cycle_to_scp(true)
					await U.tick()
					RoomDetailsControl.show_room_card = false
					RoomDetailsControl.show_scp_card = true
					RoomDetailsControl.show_researcher_card = false						

			BtnControls.onBack = func() -> void:
				current_mode = MODE.INVESTIGATE	
				SummaryCard.deselect_btns()				
			
			clear_lines()
			await lock_investigate(true)			
			await BtnControls.reveal(true)
		# --------------
		MODE.BUILD:
			clear_lines()
			reveal_cardminipanel(false)
			RoomDetailsControl.reveal(false)
			await lock_investigate(true)
			await show_build_options()
			RoomDetailsControl.reveal(true)
	
	on_current_location_update()	
	on_camera_settings_update()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------	
func check_if_remove_is_valid() -> void:
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)	
	var is_room_empty:bool = room_extract.room.is_empty()
	
	#ConfirmBtn.title = "DESTROY"
	#ConfirmBtn.is_disabled = is_room_empty
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func check_if_contain_is_valid() -> void:
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)	
	var is_room_empty:bool = room_extract.room.is_empty()
	var can_contain:bool = false if is_room_empty else room_extract.room.can_contain
	#
	#ConfirmBtn.title = "CONTAIN"
	#ConfirmBtn.is_disabled = is_room_empty or !can_contain
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_visible_in_tree() or current_location.is_empty() or camera_settings.is_empty() or room_config.is_empty() or !is_showing or is_in_transition or freeze_inputs or is_busy:return	
	if current_mode == MODE.ABILITY:return
	var key:String = input_data.key
	is_busy = true
	
	match camera_settings.type:
		# ----------------------------
		CAMERA.TYPE.FLOOR_SELECT:
			match key:
				# ----------------------------
				"W":
					U.inc_floor()
				# ----------------------------
				"S":
					U.dec_floor()
				# ----------------------------
				"D":
					U.inc_ring()
				# ----------------------------
				"A":
					camera_settings.is_locked = !camera_settings.is_locked
					SUBSCRIBE.camera_settings = camera_settings
		# ----------------------------
		CAMERA.TYPE.WING_SELECT:
			match key:
				# ----------------------------
				"W":
					U.inc_floor()
				# ----------------------------
				"S":
					U.dec_floor()
				# ----------------------------
				"D":
					U.inc_ring()
				# ----------------------------
				"A":
					U.dec_ring()
		# ----------------------------
		CAMERA.TYPE.ROOM_SELECT:
			match key:
				# ----------------------------
				"W":
					U.room_up()
				# ----------------------------
				"S":
					U.room_down()
				# ----------------------------
				"D":
					U.room_right()
				# ----------------------------
				"A":
					U.room_left()
		
	await U.set_timeout(0.1)
	is_busy = false
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
	
