extends GameContainer

#  ---------------------------------------
# SPECIAL NODES
@onready var RootPanel:PanelContainer = $"."
@onready var Backdrop:ColorRect = $Backdrop
@onready var BtnControls:Control = $BtnControls
@onready var NameControl:Control = $NameControl
@onready var RoomDetailsControl:Control = $RoomDetails
#@onready var ControllerOverlay:Control = $ControllerOverlay
#  ---------------------------------------

# NOTIFICATION
#  ---------------------------------------
@onready var NotificationPanel:PanelContainer = $NotificationControls/PanelContainer
@onready var NotificationMargin:MarginContainer = $NotificationControls/PanelContainer/MarginContainer
@onready var NewMessageBtn:BtnBase = $NotificationControls/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NewMessageBtn
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
@onready var SummaryCard:PanelContainer = $MiniCardControl/PanelContainer/MarginContainer/SummaryCard
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
# FaciiltyProgramBtn.on

@onready var WingActionPanel:PanelContainer = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions
@onready var WingActionBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions/MarginContainer/VBoxContainer/HBoxContainer/WingActionBtn
@onready var ProgramBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer2/CenterBtnList/RoomBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/ProgramBtn
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
@onready var TutorialBtn:BtnBase = $ActionControls/PanelContainer/MarginContainer/HBoxContainer2/Right/PlayerActions/MarginContainer/VBoxContainer/HBoxContainer/TutorialBtn


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

@onready var HotkeyContainer:Control = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/RightSide/VBoxContainer2/HotkeyContainer
@onready var InvestigateBackBtn:BtnBase = $InvestigateControls/PanelContainer/MarginContainer/HBoxContainer/LeftSide/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/InvestigateBackBtn
#  ---------------------------------------

enum MODE { 
	NONE,
	ACTIONS,
	INVESTIGATE, 
	ABILITY,
	BUILD,
	RESET_ROOM, 
	DISMISS_RESEARCHER 
}

const KeyBtnPreload:PackedScene = preload("res://UI/Buttons/KeyBtn/KeyBtn.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")
const NametagPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionContainer/parts/Nametag.tscn")
const ActiveMenuPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionContainer/parts/ActiveMenu.tscn")

var current_mode:MODE = MODE.NONE : 
	set(val):
		current_mode = val
		on_current_mode_update()

var prev_draw_state:Dictionary	= {}
var is_in_transition:bool = false 
var is_busy:bool = false
var is_started:bool = false
var show_new_message_btn:bool = false : 
	set(val):
		show_new_message_btn = val
		reveal_new_message(val)

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
		
	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	await U.tick()
	
	control_pos_default[ActionPanel] = ActionPanel.position
	control_pos_default[InvestigatePanel] = InvestigatePanel.position
	control_pos_default[MiniCardPanel] = MiniCardPanel.position
	control_pos_default[FloorPreviewPanel] = FloorPreviewPanel.position
	control_pos_default[NotificationPanel] = NotificationPanel.position
	
	lock_panel_btn_state(true, [InvestigatePanel, ActionPanel])

	update_control_pos(false)
	check_action_btn_state()
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
	
	control_pos[NotificationPanel] = {
		"show": 0,
		"hide": NotificationMargin.size.x
	}
	
	for node in [ActionPanel, InvestigatePanel]: 
		node.position.y = control_pos[node].hide

	for node in [NotificationPanel, FloorPreviewPanel]: 
		node.position.x = control_pos[node].hide
	
	# hide by default
	NewMessageBtn.is_disabled = true
	
	on_current_mode_update(skip_animation)
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------	
func start() -> void:	
	is_started = true
	
	# -------------------------------------
	for btn in [GenEndTurnBtn, WingEndTurnBtn, FacilityEndTurnBtn]:
		btn.onClick = func() -> void:
			#ControllerOverlay.hide()
			reveal_notification(false)
			await lock_actions(true)
			await GameplayNode.next_day()
			reveal_notification(true)			
			lock_actions(false)
			#ControllerOverlay.show()
	
	# -------------------------------------
	if !GameplayNode.is_tutorial:
		TutorialBtn.hide()

	# -------------------------------------
	NewMessageBtn.onClick = func() -> void:
		lock_panel_btn_state(true, [ActionPanel])
		await reveal_notification(false)
		show_new_message_btn = false
		await GBL.find_node(REFS.DOOR_SCENE).play_next_sequence()
		lock_panel_btn_state(false, [ActionPanel])
		
	# -------------------------------------

	# -------------------------------------
	GotoFloorBtn.onClick = func() -> void:
		if camera_settings.type == CAMERA.TYPE.FLOOR_SELECT:return
		camera_settings.type = CAMERA.TYPE.FLOOR_SELECT
		SUBSCRIBE.camera_settings = camera_settings
	
	GotoWingBtn.onClick = func() -> void:
		if camera_settings.type == CAMERA.TYPE.WING_SELECT:return
		camera_settings.type = CAMERA.TYPE.WING_SELECT
		SUBSCRIBE.camera_settings = camera_settings
		
	GotoGeneratorBtn.onClick = func() -> void:
		if camera_settings.type == CAMERA.TYPE.GENERATOR:return
		camera_settings.type = CAMERA.TYPE.GENERATOR
		SUBSCRIBE.camera_settings = camera_settings	
		
	WingActionBtn.onClick = func() -> void:
		GameplayNode.show_marked_objectives = false
		GameplayNode.show_timeline = false
		on_current_location_update()
		current_mode = MODE.INVESTIGATE	
		camera_settings.type = CAMERA.TYPE.ROOM_SELECT
		SUBSCRIBE.camera_settings = camera_settings
	
	ProgramBtn.onClick = func() -> void:
		show_ability_list()
	# -------------------------------------
	
	# -------------------------------------
	GenActionBtns.onClick = func() -> void:
		await lock_actions(true)
		show_generator_updates()
		
	FacilityActionBtn.onClick = func() -> void:
		#ControllerOverlay.show_directional = false
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
			await GAME_UTIL.reset_room(current_location)
		)
	# -------------------------------------
	
	# -------------------------------------
	ObjectivesBtn.onClick = func() -> void:
		reveal_notification(false)
		lock_actions(true)
		await GAME_UTIL.open_objectives()
		reveal_notification(true)		
		lock_actions(false)
		on_current_mode_update()
	
	SettingsBtn.onClick = func() -> void:
		#ControllerOverlay.hide()
		NameControl.hide()
		reveal_notification(false)		
		await lock_actions(true)
		show_settings()
		
	HintInfoBtn.onClick = func() -> void:
		# ControllerOverlay.hide()
		NameControl.hide()
		GameplayNode.TimelineContainer.show_details(true)
		reveal_notification(false)
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
			GameplayNode.TimelineContainer.show_details(false)
			reveal_notification(true)
			lock_actions(false)
			set_backdrop_state(false)
			# ControllerOverlay.show()
			NameControl.show()
	
	TutorialBtn.onClick = func() -> void:
		freeze_inputs = true
		await lock_actions(true)
		print('load previous message')
		await U.tick()
		#await GAME_UTIL.start_tutorial()
		lock_actions(false)
		freeze_inputs = false
	# -------------------------------------
	
	# -------------------------------------
	current_mode = MODE.ACTIONS
	# -------------------------------------	
		
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3, 0.5)

# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func tutorial_is_running(is_running:bool) -> void:
	freeze_inputs = is_running
	
	var ActiveNode = GBL.find_node(REFS.ACTIVE_MENU)
	if ActiveNode != null:
		ActiveNode.tutorial_is_open = is_running
	
	match current_mode:
		MODE.NONE:
			await BtnControls.reveal(is_running)
		# --------------
		MODE.ACTIONS:
			await lock_actions(is_running)
		# --------------
		MODE.INVESTIGATE:	
			await lock_investigate(is_running)
		# --------------	
		MODE.BUILD:
			await RoomDetailsControl.reveal(is_running)			
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func reveal_new_message(state:bool) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	NewMessageBtn.show()	if state else NewMessageBtn.hide()
	await reveal_notification(state)	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos(true)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------				
func clear_lines() -> void:
	GBL.find_node(REFS.LINE_DRAW).clear()
	prev_draw_state = {}			
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------
signal query_complete
func query_items(ActiveMenuNode:Control, query_size:int, category:ROOM.CATEGORY, page:int, return_list:Array, is_disabled_func:Callable, hint_func:Callable) -> void:
	var query:Dictionary
	var start_at:int = page * query_size
	query = ROOM_UTIL.get_unlocked_category(category, start_at, query_size)	

	return_list.push_back(
		query.list.map(func(x):return {
			"title": x.details.name,
			"img_src": x.details.img_src,
			"is_disabled": is_disabled_func.call(x),
			"hint": hint_func.call(x), 
			"ref": x.ref,
			"details": x.details,
			"action": func() -> void:
				await ActiveMenuNode.lock()
				# purchase and show tally
				var room_details:Dictionary = ROOM_UTIL.return_data(x.details.ref)
				
				var costs:Array = [{
					"amount": -(room_details.costs.purchase), 
					"resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)
				}] if room_details.costs.purchase > 0 else []
				
				var confirm:bool = await GAME_UTIL.create_modal("Construct %s here?" % room_details.name, "This room CANNOT be destroyed once placed.  Are you sure you want to continue?" if !room_details.can_destroy else "Continue?" , room_details.img_src, costs)
				
				# update
				if confirm:
					ROOM_UTIL.add_room(x.details.ref)
					if !x.details.event_trigger.is_empty():
						var event_data:Dictionary = EVENT_UTIL.return_data(x.details.event_trigger.ref)
						
						GAME_UTIL.add_timeline_item({
							"title": event_data.timeline.title,
							"icon": event_data.timeline.icon,
							"description": event_data.timeline.description,
							"day": progress_data.day + x.details.event_trigger.day,
							"location": current_location.duplicate(),
							"event": {
								"ref": x.details.event_trigger.ref
							},
							
						})
					ActiveMenuNode.close()
					return
				
				ActiveMenuNode.unlock(),
		})
	)	
	
	if query.has_more:
		query_items(ActiveMenuNode, query_size, category, page + 1, return_list, is_disabled_func, hint_func)
	else:
		await U.tick()
		query_complete.emit(return_list)
		
func show_build_options() -> void:
	const query_size:int = 100
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()
	var options:Array = []

	for listitem in [
			{
				"title": 'RESOURCES', 
				"type": ROOM.CATEGORY.RESOURCES,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x:Dictionary) -> Dictionary:
					var description:String = x.details.description
					return {
						"icon": SVGS.TYPE.MONEY,
						"title": x.details.name,
						"description": description if !ROOM_UTIL.at_own_limit(x.ref) else "At max capacity."
					},
			},
			{
				"title": 'RECRUITMENT', 
				"type": ROOM.CATEGORY.RECRUITMENT,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x:Dictionary) -> Dictionary:
					var description:String = x.details.description
					return {
						"icon": SVGS.TYPE.MONEY,
						"title": x.details.name,
						"description": description if !ROOM_UTIL.at_own_limit(x.ref) else "At max capacity."
					},
			},			
			{
				"title": 'ENERGY', 
				"type": ROOM.CATEGORY.ENERGY,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x:Dictionary) -> Dictionary:
					var description:String = x.details.description
					return {
						"icon": SVGS.TYPE.MONEY,
						"title": x.details.name,
						"description": description if !ROOM_UTIL.at_own_limit(x.ref) else "At max capacity."
					},
			},
			{
				"title": 'UTILITY', 
				"type": ROOM.CATEGORY.UTILITY,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x:Dictionary) -> Dictionary:
					var description:String = x.details.description
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
					var description:String = x.details.description
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
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x:Dictionary) -> Dictionary:
					var description:String = x.details.description
					return {
						"icon": SVGS.TYPE.GLOBAL,
						"title": x.details.name,
						"description": description if !ROOM_UTIL.at_own_limit(x.ref) else "At building capacity."
					},
			},
		]:
	
			
		query_items(ActiveMenuNode, query_size, listitem.type, 0, [], listitem.is_disabled_func, listitem.hint_func)
		var query_results:Array = await query_complete
		for index in query_results.size():
			var items:Array = query_results[index]
			if items.size() > 0:
				options.push_back({
					"title": listitem.title,
					"items": items,
					"footer": "%s / %s" % [index + 1, items.size() ],
				})		

	
	ActiveMenuNode.onUpdate = func(item:Dictionary) -> void:
		# update card
		RoomDetailsControl.room_ref = item.ref
		RoomDetailsControl.reveal(true)		
		
		# disable/enable btn
		var can_afford:bool = resources_data[RESOURCE.CURRENCY.MONEY].amount >= item.details.costs.purchase 
		ActiveMenuNode.disable_active_btn = !can_afford

		# draw lines
		var get_node_pos:Callable = func() -> Vector2: 
			return GBL.find_node(REFS.WING_RENDER).get_room_position(current_location.room) * self.size
		
		GBL.find_node(REFS.LINE_DRAW).add( get_node_pos, {
			"draw_to_active_menu": true,
			#"draw_to_money": item.details.costs.purchase > 0
		}, 0 )
	
	ActiveMenuNode.onBeforeClose = func() -> void:
		clear_lines()
		RoomDetailsControl.room_ref = -1		
		RoomDetailsControl.reveal(false)				

	ActiveMenuNode.onClose = func() -> void:
		current_mode = MODE.INVESTIGATE
		previous_designation = ""
		on_current_location_update()	
		
		
	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	
	# ACTIVATE NODE
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate(4)
	ActiveMenuNode.open(true)	

# --------------------------------------------------------------------------------------------------
					#"index": index, 
					#"location": location,
					#"ability": ability, 
					#"room_details": room_details, 
# --------------------------------------------------------------------------------------------------
func show_ability_list() -> void:
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()
	
	var update_list:Callable = func() -> void:
		await U.tick()
		ActiveMenuNode.remap_data(GAME_UTIL.get_list_of_abilities().map(func(x): return {
			"title":  x.ability.name if !x.on_cooldown else str(x.ability.name, " (COOLDOWN)" ),
			"is_disabled": x.on_cooldown,
			"hint": {
				"icon": SVGS.TYPE.ENERGY,
				"title": "HINT",
				"description": str(x.ability.description, " " if !x.on_cooldown else " (ON COOLDOWN FOR %s DAYS)" % [x.cooldown_val] )
			},			
		}) )
		

	var items:Array = GAME_UTIL.get_list_of_abilities().map(func(x): 
		return {
			"title":  x.ability.name if !x.on_cooldown else str(x.ability.name, " (COOLDOWN)" ),
			"is_disabled": x.on_cooldown,
			"hint": {
				"icon": SVGS.TYPE.ENERGY,
				"title": "HINT",
				"description": str(x.ability.description, " " if !x.on_cooldown else " (ON COOLDOWN FOR %s DAYS)" % [x.cooldown_val] )
			},
			"is_togglable": false,
			"action": func() -> void:
				await ActiveMenuNode.lock()
				await GAME_UTIL.use_active_ability(x.ability, x.room_details.ref, x.index, x.location)
				await update_list.call()
				ActiveMenuNode.unlock(),
		}
	)
		
	var options:Array = [
		{
			"title": "ABILITIES",
			"items": items,
		}
	]

	ActiveMenuNode.onClose = func() -> void:	
		set_backdrop_state(false)
		await reveal_cardminipanel(false)
		on_camera_settings_update()
		reveal_cardminipanel(true)
		lock_investigate(false)
		
	
	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	
	reveal_cardminipanel(false)	
	lock_investigate(true)
	set_backdrop_state(true)
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate()
	ActiveMenuNode.open()	

# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func show_generator_updates() -> void:			
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()
	var gen_level:int = base_states.floor[str(current_location.floor)].generator_level

	var options:Array = [
		{
			"title": "GENERATOR ABILITIES",
			"items": [
				{
					"title": "ENERGY CAPACITY (lvl %s)" % (gen_level + 1),
					"hint": {
						"icon": SVGS.TYPE.ENERGY,
						"title": "HINT",
						"description": "Increases the available energy for each wing."
					},
					"is_togglable": true,
					"action": func() -> void:
						await ActiveMenuNode.lock()
				
						var activation_cost:int = (base_states.floor[str(current_location.floor)].generator_level + 1) * 50

						var costs:Array = [{
							"amount": -(activation_cost), 
							"resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MATERIAL)
						}]
						
						var confirm:bool = await GAME_UTIL.create_modal( "Increase generator capacity for floor %s?" % current_location.floor, "Effects all wings equally." , "", costs)
						
						if confirm:
							await ActiveMenuNode.lock()
							await GAME_UTIL.upgrade_generator_level()							
							ActiveMenuNode.close()
							return
							
						ActiveMenuNode.unlock(),						
						

				},
				{
					"title": "???",
					"hint": {
						"icon": SVGS.TYPE.QUESTION_MARK,
						"title": "HINT",
						"description": "???"
					},
					"is_disabled": true,
					"action": func() -> void:
						pass,
				},
				{
					"title": "???",
					"hint": {
						"icon": SVGS.TYPE.QUESTION_MARK,
						"title": "HINT",
						"description": "???"
					},
					"is_disabled": true,
					"action": func() -> void:
						pass,
				},
				{
					"title": "???",
					"hint": {
						"icon": SVGS.TYPE.QUESTION_MARK,
						"title": "HINT",
						"description": "???"
					},
					"is_disabled": true,
					"action": func() -> void:
						pass,
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
func show_events_debug() -> void:
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()
	
	var scp_ref:int
	for ref in scp_data:
		if scp_data[ref].location == current_location:
			scp_ref = ref
			
	var options:Array = [
		{
			"title": "EVENTS",
			"items": [
				{
					"title": "INITIAL CONTAINMENT",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for INITIAL CONTAINMENT event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.trigger_initial_containment_event(scp_ref)
						ActiveMenuNode.unlock(),
				},
				{
					"title": "CONTAINMENT BREACH EVENT",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for CONTAINMENT BREACH event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.trigger_breach_event(scp_ref)
						ActiveMenuNode.unlock(),
				},
				{
					"title": "CONTAINED EVENT",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for CONTAINED event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.trigger_containment_event(scp_ref)
						ActiveMenuNode.unlock(),
				}				
			]
		}
	]


	BtnControls.reveal(false)

	reveal_cardminipanel(false)
	RoomDetailsControl.reveal(false)

	ActiveMenuNode.onClose = func() -> void:	
		set_backdrop_state(false)
		reveal_cardminipanel(true)	
		RoomDetailsControl.reveal(true)		
		await BtnControls.reveal(true)
		
	
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
	var is_powered:bool = base_states.floor[str(current_location.floor)].is_powered
	
	var options:Array = [
		{
			"title": "ENERGY",
			"items": [
				{
					"title": "SUPPLY POWER",
					"hint": {
						"icon": SVGS.TYPE.ENERGY,
						"title": "HINT",
						"description": "Supply power to FLOOR %s." % [current_location.floor]
					},
					#"is_disabled": is_powered,
					"is_checked": is_powered,
					"is_togglable": true,
					"action": func() -> void:
						await ActiveMenuNode.lock()
						var activation_cost:int = GAME_UTIL.get_activated_floor_count() * 25 if !is_powered else 0

						var costs:Array = [{
							"amount": -(activation_cost), 
							"resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.CORE)
						}]
						
						var confirm:bool 
						
						if is_powered:
							confirm = await GAME_UTIL.create_warning("Remove power from floor %s" % current_location.floor, "Rooms on this floor will be deactivated and any SCP's contained here a be at risk of breaking containment.", "res://Media/images/Defaults/stop_sign.png")						
						else:
							confirm = await GAME_UTIL.create_modal( "Supply power to floor %s?" % current_location.floor, "All rings will become usable." , "res://Media/images/Defaults/lightbulb_on.jpg", costs)
						
						if confirm:
							ActiveMenuNode.close()
							if !is_powered:
								GAME_UTIL.activate_floor(current_location.floor)
							else:
								GAME_UTIL.deactivate_floor(current_location.floor)
							await U.set_timeout(0.7)
							camera_settings.type = CAMERA.TYPE.WING_SELECT
							SUBSCRIBE.camera_settings = camera_settings	
							return			
							
						ActiveMenuNode.unlock(),
				},
				{
					"title": "???",
					"hint": {
						"icon": SVGS.TYPE.ENERGY,
						"title": "HINT",
						"description": "???"
					},
					"is_disabled": true,
					"action": func() -> void:
						pass,
				}
			]
		},
		{
			"title": "PERSONNEL MANAGEMENT",
			"items": [
				{
					"title": "VIEW PROFILES" if ROOM_UTIL.owns_and_is_active(ROOM.REF.HQ) else "???",
					"is_disabled": !ROOM_UTIL.owns_and_is_active(ROOM.REF.HQ),
					"hint": {
						"icon": SVGS.TYPE.INVESTIGATE,
						"title": "HINT",
						"description": "View personnel records"
					} if ROOM_UTIL.owns_and_is_active(ROOM.REF.HQ) else {
						"icon": SVGS.TYPE.QUESTION_MARK,
						"title": "HINT",
						"description": "???"
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						
						await GAME_UTIL.view_personnel()
							
						ActiveMenuNode.unlock(),
				},
				{
					"title": "PROMOTE" if ROOM_UTIL.owns_and_is_active(ROOM.REF.HQ) else "???",
					"is_disabled": !ROOM_UTIL.owns_and_is_active(ROOM.REF.HQ),
					"hint": {
						"icon": SVGS.TYPE.INVESTIGATE,
						"title": "HINT",
						"description": "Promote a researcher, security officer or administrator."
					} if ROOM_UTIL.owns_and_is_active(ROOM.REF.HQ) else {
						"icon": SVGS.TYPE.QUESTION_MARK,
						"title": "HINT",
						"description": "???"
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						
						await GAME_UTIL.promote_researcher()
							
						ActiveMenuNode.unlock(),
				}
			]
		}		
	]
	
	GameplayNode.show_marked_objectives = false
	GameplayNode.show_timeline = false	

	ActiveMenuNode.onClose = func() -> void:	
		GameplayNode.show_marked_objectives = true #gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_OBJECTIVES].val
		GameplayNode.show_timeline = true
		
		set_backdrop_state(false)
		await lock_actions(false)
		on_camera_settings_update()
	
	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	
	set_backdrop_state(true)
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate(2)
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
					"title": "FULLSCREEN",
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
						GBL.find_node(REFS.MAIN).toggle_fullscreen(),
				},
			]
		},
		{
			"title": "SAVE AND LOAD",
			"items": [
				{
					"title": "QUICKSAVE",
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"description": "Save your current progress."
					},
					"action": func() -> void:
						GameplayNode.quicksave(),
												
				},
				#{
					#"title": "Load Previous Checkpoint",
					#"hint": {
						#"icon": SVGS.TYPE.CONVERSATION,
						#"description": "Load from the last checkpoint."
					#},
					#"action": func() -> void:
						#GameplayNode.load_from(),
												#
				#},
				#{
					#"title": "Restart from beginning",
					#"hint": {
						#"icon": SVGS.TYPE.CONVERSATION,
						#"description": "Restart on day 1."
					#},
					#"action": func() -> void:
						#GameplayNode.restart_game(),
												#
				#},
				#{
					#"title": "Restart from beginning",
					#"hint": {
						#"icon": SVGS.TYPE.CONVERSATION,
						#"description": "Restart on day 1."
					#},
					#"action": func() -> void:
						#GameplayNode.restart_game(),
												#
				#}										
			]
		},
		{
			"title": "QUIT",
			"items": [
				{
					"title": "EXIT GAME",
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"description": "Exit your current game."
					},
					"action": func() -> void:
						get_tree().quit(),
				},				
				{
					"title": "RETURN TO DESKTOP",
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"description": "Exit your current game."
					},
					"action": func() -> void:
						await GameplayNode.quicksave()
						GameplayNode.exit_game(),
				},
				{
					"title": "RETURN TO TITLESCREEN",
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
	
	
	ActiveMenuNode.onClose = func() -> void:	
		set_backdrop_state(false)
		await lock_actions(false)
		reveal_notification(true)
		on_current_mode_update()
		GameplayNode.restore_player_hud()

	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	
	add_child(ActiveMenuNode)
	
	GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer])
	
	await ActiveMenuNode.activate(3)
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
var previous_room_ref:int 
func before_use() -> void:
	previous_room_ref = RoomDetailsControl.room_ref
	await BtnControls.reveal(false)
	
func after_use() -> void:
	BtnControls.itemlist = SummaryCard.get_ability_btns()
	await U.tick()
	BtnControls.reveal(true)
	RoomDetailsControl.room_ref = previous_room_ref
	
		
func after_use_passive_ability() -> void:
	pass
	#update_details()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty() or control_pos.is_empty() or current_mode == MODE.NONE:return
	
	var actionpanels:Array = [WingActionPanel, FacilityActionPanel, GenActionPanel]
	
	match camera_settings.type:
		# ----------------------
		CAMERA.TYPE.FLOOR_SELECT:
			NameControl.hide()
			#ControllerOverlay.hide()
			#ControllerOverlay.show_directional = false
			
			if camera_settings.is_locked:
				reveal_floorpreview(false)
			else:
				reveal_floorpreview(true)
			
					
			for panel in actionpanels:
				if panel == FacilityActionPanel:
					panel.show()
				else:
					panel.hide()
			
		# ----------------------
		CAMERA.TYPE.WING_SELECT:
			reveal_floorpreview(false)
			NameControl.show()
			#ControllerOverlay.show()
			#ControllerOverlay.show_directional = true
			
			for panel in actionpanels:
				if panel == WingActionPanel:
					panel.show()
				else:
					panel.hide()
			
			#if GameplayNode.is_tutorial:
				#await GAME_UTIL.check_tutorial(TUTORIAL.TYPE.FLOORPLAN, 0.3)
			
		# ----------------------
		CAMERA.TYPE.GENERATOR:
			reveal_floorpreview(false)
			NameControl.hide()
			#ControllerOverlay.hide()			
			#ControllerOverlay.show_directional = false

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
	
	var filtered:Array = purchased_facility_arr.filter(func(x): 
		return x.location.floor == current_location.floor and x.location.ring == current_location.ring 
	)
	
	# update room details control
	RoomDetailsControl.use_location = current_location
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
	var nuke_activated:bool = room_config.base.onsite_nuke.triggered
	var is_powered:bool = room_config.floor[current_location.floor].is_powered
	var in_lockdown:bool = room_config.floor[current_location.floor].in_lockdown
	var is_room_empty:bool = room_extract.room.is_empty()
	var is_scp_empty:bool = room_extract.scp.is_empty()
	var abilities:Array = [] if is_room_empty else room_extract.room.details.abilities.call()
	var passive_abilities:Array = [] if is_room_empty else room_extract.room.details.passive_abilities.call()
	var is_activated:bool = false if is_room_empty else room_extract.room.is_activated
	var can_contain:bool = false if is_room_empty else room_extract.room.details.can_contain
	var can_assign_researchers:bool = false if is_room_empty else room_extract.room.details.can_assign_researchers
	var can_take_action:bool = (is_powered and !in_lockdown)
	var can_deconstruct:bool = false if is_room_empty else room_extract.room.can_destroy 
	var has_options:bool = !abilities.is_empty() or !passive_abilities.is_empty()
	
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
			# ControllerOverlay.show_directional = true
			WingActionBtn.is_disabled = !is_powered or in_lockdown
			ProgramBtn.is_disabled = GAME_UTIL.get_list_of_abilities().is_empty()
			WingActionBtn.icon = SVGS.TYPE.DELETE if !is_powered or in_lockdown else SVGS.TYPE.CONTAIN
			
			camera_settings.type = CAMERA.TYPE.WING_SELECT
			SUBSCRIBE.camera_settings = camera_settings
		# -----------
		MODE.INVESTIGATE:
			NameControl.hide()
			# ControllerOverlay.show_directional = false
			
			# update mouse
			var warp_to_pos:Vector2 = GBL.find_node(REFS.WING_RENDER).get_room_position(current_location.room) * self.size			
			Input.warp_mouse(warp_to_pos)
			
			# set this flat first
			RoomDetailsControl.disable_location = false

			# update roomDetailsControl
			RoomDetailsControl.show_cost = false
			RoomDetailsControl.preview_mode = false
			RoomDetailsControl.show_room_card = !is_room_empty
			RoomDetailsControl.show_scp_card = false
			RoomDetailsControl.show_researcher_card = false	
			
			RoomDetailsControl.room_ref = -1 if is_room_empty else room_extract.room.details.ref
			RoomDetailsControl.researcher_uid = -1 
			RoomDetailsControl.reveal(!is_room_empty)
			
			RoomBtnPanelLabel.text = "EMPTY" if is_room_empty else room_extract.room.details.name if is_activated else "%s - INACTIVE" % [room_extract.room.details.name]
			
			# set button states
			BuildBtn.is_disabled = (!is_room_empty) or nuke_activated or !is_powered
			DeconstructBtn.is_disabled = !can_deconstruct or nuke_activated
			AbilityBtn.is_disabled = !can_take_action 
	
			# update line draw
			var get_node_pos:Callable = func() -> Vector2: 
				return GBL.find_node(REFS.WING_RENDER).get_room_position(current_location.room) * self.size			
						
			GBL.find_node(REFS.LINE_DRAW).add( get_node_pos, {
				"draw_to_summary_card": true,
			}, 0 )
		# -----------	
		MODE.BUILD:
			RoomDetailsControl.show_cost = true
			RoomDetailsControl.preview_mode = true
			RoomDetailsControl.show_room_card = true
			RoomDetailsControl.show_scp_card = false
			RoomDetailsControl.show_researcher_card = false	

# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func set_backdrop_state(state:bool) -> void:	
	await U.tween_node_property(Backdrop, 'color', Color(0, 0, 0, 0.2 if state else 0.0))	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func reveal_notification(state:bool, duration:float = 0.3) -> void:
	if control_pos.is_empty() or !show_new_message_btn:return	
	NewMessageBtn.is_disabled = true
	
	await U.tween_node_property(NotificationPanel, "position:x", control_pos[NotificationPanel].show if state else control_pos[NotificationPanel].hide , duration)

	NewMessageBtn.is_disabled = !show_new_message_btn
# --------------------------------------------------------------------------------------------------	
	

# --------------------------------------------------------------------------------------------------	
func reveal_floorpreview(state:bool, duration:float = 0.3) -> void:
	if control_pos.is_empty():return
	pass
	#if state:
		#FloorPreviewControl.show()
		#var subviewport:SubViewport = GBL.find_node(REFS.WING_RENDER).get_preview_viewport()
		#PreviewTextureRect.texture = subviewport.get_texture()		
	#
	#await U.tween_node_property(FloorPreviewPanel, "position:x", control_pos[FloorPreviewPanel].show if state else control_pos[FloorPreviewPanel].hide , duration)
	#
	#if !state:
		#PreviewTextureRect.texture = null
		#FloorPreviewControl.hide()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func reveal_investigate_controls(state:bool, duration:float = 0.2) -> void:
	if control_pos.is_empty():return
	
	is_in_transition = true
	await U.tween_node_property(InvestigatePanel, "position:y", control_pos[InvestigatePanel].show if state else control_pos[InvestigatePanel].hide, duration)
	is_in_transition = false
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_action_controls(state:bool, duration:float = 0.2) -> void:
	if control_pos.is_empty():return
	
	is_in_transition = true
	await U.tween_node_property(ActionPanel, "position:y", control_pos[ActionPanel].show if state else control_pos[ActionPanel].hide, duration)
	is_in_transition = false
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_cardminipanel(state:bool, duration:float = 0.2) -> void:
	await U.tween_node_property(MiniCardPanel, "position:x", control_pos[MiniCardPanel].show if state else control_pos[MiniCardPanel].hide, duration)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func enable_room_focus(state:bool) -> void:
	GBL.find_node(REFS.WING_RENDER).enable_room_focus = state
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func lock_panel_btn_state(state:bool, panels:Array) -> void:
	for panel in panels:		
		var margin_panel = panel.get_node('./MarginContainer') 
		for root_panel in margin_panel.get_children():
			if root_panel != null:
				for child in root_panel.get_children():
					for node in child.get_children():
						if node is BtnBase and "is_disabled" in node:
							node.is_disabled = state
						
						var btn_list:HBoxContainer = node.get_node('./MarginContainer/VBoxContainer/HBoxContainer/')
						if btn_list != null:
							for btn in btn_list.get_children():
								btn.is_disabled = state
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func check_action_btn_state() -> void:
	var has_one_floor_activated:bool = GAME_UTIL.get_activated_floor_count()	> 0
	var has_generator_prerequisite:bool = ROOM_UTIL.owns_and_is_active(ROOM.REF.GENERATOR_SUBSTATION)	
	GotoWingBtn.show() if has_one_floor_activated else GotoWingBtn.hide()
	GotoGeneratorBtn.show() if has_generator_prerequisite else GotoGeneratorBtn.hide()
	FacilityEndTurnBtn.is_disabled = !has_one_floor_activated

func lock_actions(state:bool) -> void:
	if state:
		freeze_inputs = true		
		lock_panel_btn_state(true, [InvestigatePanel, ActionPanel])
	
	await reveal_action_controls(!state)
	
	if !state:
		freeze_inputs = false
		lock_panel_btn_state(false, [ActionPanel])
		check_action_btn_state()
		
				
		
func lock_investigate(state:bool, ignore_panel:bool = false) -> void:
	if state:
		freeze_inputs = true
		lock_panel_btn_state(true, [InvestigatePanel, ActionPanel])
	
	await reveal_investigate_controls(!state)
	
	if !state:
		freeze_inputs = false
		lock_panel_btn_state(false, [InvestigatePanel])		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return	
	var duration:float = 0.0 if skip_animation else 0.3
	var RenderNode:Node3D = GBL.find_node(REFS.WING_RENDER)
	
	
	match current_mode:
		MODE.NONE:
			BtnControls.reveal(false)
			RoomDetailsControl.reveal(false) 
			#ControllerOverlay.hide()
			
			reveal_new_message(false)
			reveal_cardminipanel(false, duration)
		# --------------
		MODE.ACTIONS:
			RenderNode.update_camera_size(125)
			
			enable_room_focus(false)
			set_backdrop_state(false)	

			BtnControls.reveal(false)
			RoomDetailsControl.reveal(false) 
			# ControllerOverlay.show()
			
			reveal_cardminipanel(false, duration)
			await lock_actions(false)
			
		# --------------
		MODE.INVESTIGATE:
			RenderNode.update_camera_size(175)
			
			NewMessageBtn.is_disabled = true
		
			InvestigateBackBtn.onClick = func() -> void:
				clear_lines()
				reveal_cardminipanel(false)
				reveal_investigate_controls(false)
				lock_investigate(true)
				reveal_action_controls(true)
				U.tween_node_property(NotificationPanel, 'position:x', control_pos[NotificationPanel].show)
				NewMessageBtn.is_disabled = !show_new_message_btn
				current_mode = MODE.ACTIONS
				GameplayNode.show_marked_objectives = true #gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_OBJECTIVES].val
				GameplayNode.show_timeline = true

			enable_room_focus(true)
			set_backdrop_state(true)	
			
			BtnControls.reveal(false)
			# ControllerOverlay.hide()
			
			reveal_action_controls(false)
			reveal_cardminipanel(true)
		
			lock_investigate(false)
			await lock_actions(true)			
			
		
			U.tween_node_property(NotificationPanel, 'position:x', control_pos[NotificationPanel].hide)
			
			#if GameplayNode.is_tutorial:
				#await GAME_UTIL.check_tutorial(TUTORIAL.TYPE.INVESTIGATE, 0.5)
		# --------------
		MODE.ABILITY:
			var extract_room_data:Dictionary = GAME_UTIL.extract_room_details()
			var is_powered:bool = room_config.floor[current_location.floor].is_powered
			var is_room_empty:bool = extract_room_data.room.is_empty()
			var room_name:String = extract_room_data.room.details.name if !is_room_empty else "EMPTY"
			var abl_lvl:int = extract_room_data.room.abl_lvl if !is_room_empty else -1
			var max_upgrade_lvl:int = extract_room_data.room.max_upgrade_lvl if !is_room_empty else -1

			BtnControls.itemlist = SummaryCard.get_ability_btns()
			BtnControls.item_index = 0
			BtnControls.directional_pref = "UD"
			BtnControls.offset = SummaryCard.global_position
		
			BtnControls.onUpdate = func(node:Control) -> void:
				for _node in BtnControls.itemlist:
					_node.is_selected = _node == node
					
				BtnControls.onAction = func() -> void:pass
				BtnControls.hide_c_btn = true
				BtnControls.hide_a_btn = false
				BtnControls.disable_active_btn = false
				
				# ----------------------
				match node.ref_data.type:
					"active_ability":
						BtnControls.a_btn_title = "USE"
						BtnControls.hide_c_btn = true
						
						RoomDetailsControl.cycle_to_room(true)
						RoomDetailsControl.show()				
						RoomDetailsControl.show_room_card = true
						RoomDetailsControl.show_scp_card = false
						RoomDetailsControl.show_researcher_card = false
						return
					# ----------------------
					"passive_ability":
						BtnControls.a_btn_title = "ENABLE"
						BtnControls.hide_c_btn = true
						
						RoomDetailsControl.cycle_to_room(true)
						RoomDetailsControl.show()				
						RoomDetailsControl.show_room_card = true
						RoomDetailsControl.show_scp_card = false
						RoomDetailsControl.show_researcher_card = false
						return					
					# ----------------------
					"researcher":
						# check if there are any available researchers
						var filter_for_spec:Array = [extract_room_data.room.details.required_staffing[node.index]]
						var available_researchers:Array = RESEARCHER_UTIL.get_list_of_available(filter_for_spec)
						var node_researcher_data = node.ref_data.data
						
						BtnControls.a_btn_title = "ASSIGN" if node_researcher_data.is_empty() else "UNASSIGN"
						BtnControls.hide_c_btn = !node_researcher_data.is_empty() and available_researchers.size() > 0
						BtnControls.disable_c_btn = available_researchers.is_empty()
						BtnControls.c_btn_title = "AUTO ASSIGN"
						BtnControls.onCBtn = func() -> void:
							var researcher_details:Dictionary = RESEARCHER_UTIL.get_user_object(available_researchers[0])
							var new_uid:String = GAME_UTIL.auto_assign_staff(researcher_details.specialization.ref, node.index)
							RoomDetailsControl.show()
							RoomDetailsControl.researcher_uid = new_uid
						
						RoomDetailsControl.hide() if node_researcher_data.is_empty() else RoomDetailsControl.show()
						RoomDetailsControl.researcher_uid = node_researcher_data.uid if !node_researcher_data.is_empty() else -1
						RoomDetailsControl.cycle_to_reseacher(true)
						RoomDetailsControl.show_room_card = false
						RoomDetailsControl.show_scp_card = false
						RoomDetailsControl.show_researcher_card = true
						return
					# ----------------------
					"scp":
						BtnControls.a_btn_title = "CONTAIN"
						
						BtnControls.hide_c_btn = !DEBUG.get_val(DEBUG.GAMEPLAY_ENABLE_SCP_DEBUG)
						BtnControls.disable_c_btn = node.ref_data.data.is_empty()
						BtnControls.c_btn_title = "DEBUG EVENT"
						BtnControls.onCBtn = func() -> void:
							show_events_debug()
						
						RoomDetailsControl.hide() if node.ref_data.data.is_empty() else RoomDetailsControl.show()
						RoomDetailsControl.scp_ref = -1 if node.ref_data.data.is_empty() else node.ref_data.data.ref
						RoomDetailsControl.cycle_to_scp(true)
						RoomDetailsControl.show_room_card = false
						RoomDetailsControl.show_scp_card = true
						RoomDetailsControl.show_researcher_card = false
						return

				# on nametag
				BtnControls.hide_a_btn = is_room_empty or abl_lvl >= max_upgrade_lvl
				BtnControls.disable_active_btn = is_room_empty or abl_lvl >= max_upgrade_lvl
				BtnControls.a_btn_title = "UPGRADE" if abl_lvl < max_upgrade_lvl else "AT MAX LEVEL"
				
				RoomDetailsControl.cycle_to_room(true)
				RoomDetailsControl.show()
				RoomDetailsControl.show_room_card = true
				RoomDetailsControl.show_scp_card = false
				RoomDetailsControl.show_researcher_card = false

			BtnControls.onBack = func() -> void:
				RoomDetailsControl.cycle_to_room(true)
				RoomDetailsControl.show()				

				RoomDetailsControl.show_room_card = true
				RoomDetailsControl.show_scp_card = false
				RoomDetailsControl.show_researcher_card = false
								
				current_mode = MODE.INVESTIGATE	
				SummaryCard.deselect_btns()				
			
			clear_lines()
			await lock_investigate(true)			
			await BtnControls.reveal(true)
			
			#if GameplayNode.is_tutorial:
				#await GAME_UTIL.check_tutorial(TUTORIAL.TYPE.ACTIONS)			
		# --------------
		MODE.BUILD:
			clear_lines()
			reveal_cardminipanel(false)
			RoomDetailsControl.reveal(false)
			await lock_investigate(true)						
			show_build_options()

			
			#if GameplayNode.is_tutorial:
				#await GAME_UTIL.check_tutorial(TUTORIAL.TYPE.BUILD, 0.5)
	
	on_current_location_update()	
	on_camera_settings_update()
	
# --------------------------------------------------------------------------------------------------			

## --------------------------------------------------------------------------------------------------	
#func check_if_remove_is_valid() -> void:
	#var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)	
	#var is_room_empty:bool = room_extract.room.is_empty()
	#
	##ConfirmBtn.title = "DESTROY"
	##ConfirmBtn.is_disabled = is_room_empty
## --------------------------------------------------------------------------------------------------		
#
## --------------------------------------------------------------------------------------------------
#func check_if_contain_is_valid() -> void:
	#var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)	
	#var is_room_empty:bool = room_extract.room.is_empty()
	#var can_contain:bool = false if is_room_empty else room_extract.room.can_contain
	##
	##ConfirmBtn.title = "CONTAIN"
	##ConfirmBtn.is_disabled = is_room_empty or !can_contain
## --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_visible_in_tree() or GBL.has_animation_in_queue() or current_location.is_empty() or camera_settings.is_empty() or room_config.is_empty() or !is_started or !is_showing or is_in_transition or freeze_inputs or is_busy:return	
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
				#"D":
					#U.inc_ring()
				# ----------------------------
				#"A":
					#camera_settings.is_locked = !camera_settings.is_locked
					#SUBSCRIBE.camera_settings = camera_settings
		# ----------------------------
		CAMERA.TYPE.WING_SELECT:
			match key:
				# ----------------------------
				"W":
					U.inc_floor(false)
				# ----------------------------
				"S":
					U.dec_floor(false)
				# ----------------------------
				"D":
					U.inc_ring(false)
				# ----------------------------
				"A":
					U.dec_ring(false)
		# ----------------------------
		CAMERA.TYPE.ROOM_SELECT:
			match key:
				# ----------------------------
				"W":
					U.room_up(true)
				# ----------------------------
				"S":
					U.room_down(true)
				# ----------------------------
				"D":
					U.room_right(true)
				# ----------------------------
				"A":
					U.room_left(true)
	

		
	is_busy = false
# --------------------------------------------------------------------------------------------------	
