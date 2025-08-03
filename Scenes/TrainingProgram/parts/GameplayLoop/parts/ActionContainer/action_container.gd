extends GameContainer

#  ---------------------------------------
# SPECIAL NODES
@onready var Backdrop:ColorRect = $Backdrop
@onready var SummaryControls:Control = $SummaryControls
@onready var NameControl:Control = $NameControl
@onready var RoomDetailsControl:Control = $RoomDetails
@onready var TransistionScreen:Control = $TransitionScreen
#  ---------------------------------------

#  ---------------------------------------
# CONTROLS
@onready var DesignControls:Control = $DesignControls
@onready var CommandControls:Control = $CommandControls
@onready var InfoControls:Control = $InfoControls
@onready var ProgramControls:Control = $ProgramControls
#  ---------------------------------------

#  ---------------------------------------
# NOTIFICATION
@onready var NotificationPanel:PanelContainer = $NotificationControls/PanelContainer
@onready var NotificationMargin:MarginContainer = $NotificationControls/PanelContainer/MarginContainer
@onready var NewMessageBtn:BtnBase = $NotificationControls/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NewMessageBtn
#  ---------------------------------------

#  ---------------------------------------
# SUMMARY
@onready var SummaryPanel:PanelContainer = $SummaryControl/PanelContainer
@onready var SummaryPanelMargin:MarginContainer = $SummaryControl/PanelContainer/MarginContainer
@onready var SummaryCard:PanelContainer = $SummaryControl/PanelContainer/MarginContainer/SummaryCard
#  ---------------------------------------

#  ---------------------------------------
# STATIC CONTROLS 
# GOTO PANEL
@onready var RootControls:Control = $RootControls
@onready var WingRootPanel:PanelContainer = $RootControls/PanelContainer
@onready var WingRootMargin:MarginContainer = $RootControls/PanelContainer/MarginContainer

# CURRENT ACTION
@onready var ActionPanel:PanelContainer = $ActionLabelPanel/PanelContainer
@onready var ActionMargin:MarginContainer = $ActionLabelPanel/PanelContainer/MarginContainer
@onready var CurrentActionLabel:Label  =$ActionLabelPanel/PanelContainer/MarginContainer/CurrentActionLabel

# SETTINGS
@onready var SettingsBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Right/PlayerActions/MarginContainer/VBoxContainer/HBoxContainer/SettingsBtn

# GOTO PANEL
@onready var GotoBtnPanel:PanelContainer = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel
@onready var GotoFloorBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/GotoFloorBtn
@onready var GotoWingBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/GotoWingBtn
@onready var GotoGeneratorBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/GotoGeneratorBtn
@onready var DebugBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/DebugBtn

# WING ACTION PANELS
@onready var WingActions:PanelContainer = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions
@onready var WingActionBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions/MarginContainer/VBoxContainer/HBoxContainer/WingActionBtn
@onready var WingDesignBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions/MarginContainer/VBoxContainer/HBoxContainer/WingDesignBtn
@onready var WingProgramBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions/MarginContainer/VBoxContainer/HBoxContainer/WingProgramBtn
@onready var WingInfoBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Right/PlayerActions/MarginContainer/VBoxContainer/HBoxContainer/WingInfoBtn
@onready var EndTurnBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Right/PlayerActions/MarginContainer/VBoxContainer/HBoxContainer/EndTurnBtn

# FACILITY ACTION PANELS
@onready var FacilityActions:PanelContainer = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/FacilityActions
@onready var FacilityActionBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/FacilityActions/MarginContainer/VBoxContainer/HBoxContainer/FacilityActionBtn

# GENERATION ACTION PANEL
@onready var GeneratorActions:PanelContainer = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/GeneratorActions
@onready var GenActionBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/GeneratorActions/MarginContainer/VBoxContainer/HBoxContainer/GenActionBtn
#  ---------------------------------------


enum MODE { 
	NONE,
	COMMANDS,
	SUMMARY_CARD,
	INFO,
	ABILITY,
	PROGRAMS,
	BUILD,
	ACTIVE_MENU_OPEN,
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
	
	# set defaults
	SummaryControls.reveal(false)
	DesignControls.reveal(false)
	CommandControls.reveal(false)
	InfoControls.reveal(false)
	ProgramControls.reveal(false)
	
	DebugBtn.show() if DEBUG.get_val(DEBUG.GAMEPLAY_SHOW_DEBUG_MENU) else DebugBtn.hide()
	
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
	
	lock_panel_btn_state(true)
	update_control_pos(false)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos(skip_animation:bool = false) -> void:	
	await U.tick()
	
	# for elements in the bottom left corner
	control_pos[WingRootPanel] = {
		"show": 0, 
		"hide": WingRootMargin.size.y 
	}
	
	# for eelements in the top right
	control_pos[SummaryPanel] = {
		"show": 0, 
		"hide": -SummaryPanelMargin.size.x
	}
	
	control_pos[NotificationPanel] = {
		"show": 0,
		"hide": NotificationMargin.size.x
	}
	
	# for elements in the bottom left corner
	control_pos[ActionPanel] = {
		"show": 0, 
		"hide": ActionMargin.size.x
	}	
	
	for node in [WingRootPanel]: 
		node.position.y = control_pos[node].hide

	for node in [NotificationPanel, ActionPanel, SummaryPanel]: 
		node.position.x = control_pos[node].hide
	
	# hide by default
	NewMessageBtn.is_disabled = true
	
	on_current_mode_update(skip_animation)
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------	
func start() -> void:	
	is_started = true
	
	# -------------------------------------
	for btn in [EndTurnBtn]:
		btn.onClick = func() -> void:
			await lock_actions(true)
			await GameplayNode.next_day()
			lock_actions(false)
	
	# -------------------------------------
	#if !GameplayNode.is_tutorial:
		#TutorialBtn.hide()

	# -------------------------------------
	NewMessageBtn.onClick = func() -> void:
		lock_panel_btn_state(true)
		#await reveal_notification(false)
		show_new_message_btn = false
		await GBL.find_node(REFS.DOOR_SCENE).play_next_sequence()
		lock_panel_btn_state(false)
		
	# -------------------------------------

	# -------------------------------------
	GotoFloorBtn.onClick = func() -> void:
		if camera_settings.type == CAMERA.TYPE.FLOOR_SELECT:return
		camera_settings.type = CAMERA.TYPE.FLOOR_SELECT
		SUBSCRIBE.camera_settings = camera_settings
		TransistionScreen.start(0.3, true)		
	
	GotoWingBtn.onClick = func() -> void:
		if camera_settings.type == CAMERA.TYPE.WING_SELECT:return
		camera_settings.type = CAMERA.TYPE.WING_SELECT
		SUBSCRIBE.camera_settings = camera_settings
		TransistionScreen.start(0.3, true)

	GotoGeneratorBtn.onClick = func() -> void:
		if camera_settings.type == CAMERA.TYPE.GENERATOR:return
		camera_settings.type = CAMERA.TYPE.GENERATOR
		SUBSCRIBE.camera_settings = camera_settings	
		TransistionScreen.start(0.3, true)
		
	WingDesignBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.BUILD
		
	WingActionBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.COMMANDS	
	
	WingProgramBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.PROGRAMS

	WingInfoBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.INFO	

	FacilityActionBtn.onClick = func() -> void:		
		set_backdrop_state(true)
		await lock_actions(true)
		current_mode = MODE.ACTIVE_MENU_OPEN	
		await show_facility_updates()
		current_mode = MODE.NONE
		
	SettingsBtn.onClick = func() -> void:
		set_backdrop_state(true)
		await lock_actions(true)
		GameplayNode.show_marked_objectives = false
		GameplayNode.show_timeline = false			
		current_mode = MODE.ACTIVE_MENU_OPEN	
		await show_settings()
		current_mode = MODE.NONE
		
	DebugBtn.onClick = func() -> void:
		set_backdrop_state(true)
		await lock_actions(true)
		GameplayNode.show_marked_objectives = false
		GameplayNode.show_timeline = false			
		current_mode = MODE.ACTIVE_MENU_OPEN	
		await show_debug()
		current_mode = MODE.NONE
	# -------------------------------------	
	
	on_current_mode_update()
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3, 0.5)	
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

signal show_build_complete
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
		# update preview
		RoomDetailsControl.room_ref = item.details.ref
		
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

	ActiveMenuNode.onClose = func() -> void:
		await U.tick()
		show_build_complete.emit()
		RoomDetailsControl.reveal(false)
		
		
	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	
	# SETUP ROOM DETAILS
	RoomDetailsControl.reveal(true)
	RoomDetailsControl.show_room_card = true
	RoomDetailsControl.show_researcher_card = false
	RoomDetailsControl.show_scp_card = false
	RoomDetailsControl.preview_mode = true
	
	# ACTIVATE NODE	
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate(4)
	ActiveMenuNode.open(true)	
	
	# allows for wait response
	await show_build_complete
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
signal show_show_program_list_complete
func show_program_list() -> void:
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()

	var update_list:Callable = func() -> void:
		await U.tick()
		ActiveMenuNode.remap_data(GAME_UTIL.get_list_of_programs().map(func(x): 
			return {
				"title":  x.ability.name if !x.on_cooldown else str(x.ability.name, " (COOLDOWN)" ),
				"show": x.at_level_threshold,
				"is_disabled": x.on_cooldown,
				"hint": {
					"icon": SVGS.TYPE.ENERGY,
					"title": "HINT",
					"description": str(x.ability.description, " " if !x.on_cooldown else " (ON COOLDOWN FOR %s DAYS)" % [x.cooldown_val] )
			},			
		}) )
		

	var items:Array = GAME_UTIL.get_list_of_programs().map(func(x): 
		return {
			"title":  x.ability.name if !x.on_cooldown else str(x.ability.name, " (COOLDOWN)" ),
			"show": x.at_level_threshold,
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
			"title": "GLOBAL",
			"items": items,
		},
		{
			"title": "FLOOR SPECIFIC",
			"items": [],
		}		
	]

	ActiveMenuNode.onClose = func() -> void:	
		await U.tick()
		show_show_program_list_complete.emit()
		
	
	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate()
	ActiveMenuNode.open()	
	
	await show_show_program_list_complete
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
signal show_generator_complete
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
		show_generator_complete.emit()
	
	ActiveMenuNode.options_list = options
	
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate()
	ActiveMenuNode.open()	
	
	await show_generator_complete
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
signal show_debug_complete
func show_debug() -> void:
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()
	
	var scp_ref:int
	for ref in scp_data:
		if scp_data[ref].location == current_location:
			scp_ref = ref
			
	var options:Array = [
		{
			"title": "EMERGENCY MODE",
			"items": [
				{
					"title": "NORMAL",
					"icon": SVGS.TYPE.DANGER,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "DEBUG: set to NORMAL mode."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.set_emergency_mode_to_normal()
						ActiveMenuNode.unlock(),
				},												
				{
					"title": "CAUTION",
					"icon": SVGS.TYPE.DANGER,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "DEBUG: set to CAUTION mode."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.set_emergency_mode_to_caution()
						ActiveMenuNode.unlock(),
				},								
				{
					"title": "WARNING",
					"icon": SVGS.TYPE.DANGER,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "DEBUG: set to WARNING mode."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.set_emergency_mode_to_warning()
						ActiveMenuNode.unlock(),
				},								
				{
					"title": "DANGER",
					"icon": SVGS.TYPE.DANGER,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "DEBUG: set to DANGER mode."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.set_emergency_mode_to_danger()
						ActiveMenuNode.unlock(),
				},				
			],
		},
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

	ActiveMenuNode.onClose = func() -> void:	
		show_debug_complete.emit()

	ActiveMenuNode.options_list = options
	
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate()
	ActiveMenuNode.open()	
	
	await show_debug_complete
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
signal show_facility_complete
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
	
	ActiveMenuNode.onClose = func() -> void:	
		show_facility_complete.emit()		
	
	ActiveMenuNode.options_list = options
	
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate(2)
	ActiveMenuNode.open()	
	
	await show_facility_complete
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
signal show_settings_complete
func show_settings() -> void:
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()
	
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

	ActiveMenuNode.onClose = func() -> void:	
		show_settings_complete.emit()
		GameplayNode.restore_player_hud()

	ActiveMenuNode.options_list = options	
	
	GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer])	
	
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate(3)
	ActiveMenuNode.open()	
	
	await show_settings_complete
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty() or control_pos.is_empty():return
	
	match camera_settings.type:
		# ----------------------
		CAMERA.TYPE.FLOOR_SELECT:
			NameControl.hide()
			WingActions.hide()
			FacilityActions.show()
			GeneratorActions.hide()

		# ----------------------
		CAMERA.TYPE.WING_SELECT:
			NameControl.hide()
			WingActions.show()
			FacilityActions.hide()
			GeneratorActions.hide()
			
		# ----------------------
		CAMERA.TYPE.GENERATOR:
			NameControl.hide()
			WingActions.hide()
			FacilityActions.hide()
			GeneratorActions.show()			
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
var previous_designation:String
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if current_location.is_empty() or room_config.is_empty():return
	
	# update room details control
	var has_one_floor_activated:bool = GAME_UTIL.get_activated_floor_count()	> 0
	var has_generator_prerequisite:bool = ROOM_UTIL.owns_and_is_active(ROOM.REF.GENERATOR_SUBSTATION)		
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
	var is_under_construction:bool = false if is_room_empty else ROOM_UTIL.is_under_construction(current_location)
	var has_options:bool = !abilities.is_empty() or !passive_abilities.is_empty()
	var lvl:int = -1 if is_room_empty else room_extract.room.abl_lvl 
	var max_upgrade_lvl:int = -1 if is_room_empty else room_extract.room.max_upgrade_lvl 
	var at_max_level:bool = lvl >= max_upgrade_lvl
	var rooms_in_wing_count:int = purchased_facility_arr.filter(func(x): 
		return x.location.floor == current_location.floor and x.location.ring == current_location.ring 
	).size()	
		
	if !room_extract.is_empty():
		if previous_designation != U.location_to_designation(current_location):
			previous_designation = U.location_to_designation(current_location)	
			SummaryCard.use_location = current_location			
			
	match current_mode:
		MODE.NONE:
			GotoWingBtn.is_disabled = !has_one_floor_activated
			GotoGeneratorBtn.is_disabled = !has_generator_prerequisite
			WingProgramBtn.is_disabled = GAME_UTIL.get_list_of_programs().is_empty()
			WingActionBtn.is_disabled = rooms_in_wing_count == 0
			GenActionBtn.is_disabled = !has_one_floor_activated			
		# -----------	
		MODE.INFO:
			var story_progress:Dictionary = GBL.active_user_profile.story_progress
			var chapter:Dictionary = STORY.get_chapter( story_progress.on_chapter )			
						
			# show timeline details
			GameplayNode.TimelineContainer.show_details(true)
			
			# set backdrop
			set_backdrop_state(true)
			
			# hide tutorial btn if not a tutorial
			InfoControls.hide_c_btn = !GameplayNode.is_tutorial or !chapter.has("tutorial")
			
			# show objectives
			InfoControls.onAction = func() -> void:
				InfoControls.reveal(false)
				await GAME_UTIL.open_objectives()
				InfoControls.reveal(true)
			
			# show current tutorial
			InfoControls.onCBtn = func() -> void:
				InfoControls.reveal(false)
				await GAME_UTIL.play_tutorial(chapter)
				InfoControls.reveal(true)
			
			# on back
			InfoControls.onBack = func() -> void:
				GameplayNode.TimelineContainer.show_details(false)
				await InfoControls.reveal(false)
				GBL.find_node(REFS.WING_RENDER).change_camera_view(1)
				current_mode = MODE.NONE
		# -----------	
		MODE.SUMMARY_CARD:
			SummaryControls.itemlist = SummaryCard.get_ability_btns()
			SummaryControls.item_index = 0
			SummaryControls.directional_pref = "UD"
			SummaryControls.offset = SummaryCard.global_position
			
			SummaryControls.onBack = func() -> void:
				await SummaryControls.reveal(false)
				current_mode = MODE.COMMANDS
		
			SummaryControls.onUpdate = func(node:Control) -> void:
				for _node in SummaryControls.itemlist:
					_node.is_selected = _node == node
					
				SummaryControls.onAction = func() -> void:pass
				SummaryControls.hide_c_btn = true
				SummaryControls.disable_active_btn = false
				
				SummaryControls.disable_active_btn = node.ref_data.is_disabled
				
				# ----------------------
				match node.ref_data.type:
					"active_ability":
						SummaryControls.a_btn_title = "USE PROGRAM"
					# ----------------------
					"passive_ability":
						SummaryControls.a_btn_title = "TOGGLE MODULE"
					# ----------------------
		# -----------	
		MODE.COMMANDS:
			CommandControls.a_btn_title = "UTILIZE" if is_activated else "ACTIVATE" if !is_under_construction else "UNDER CONSTRUCTION"
			CommandControls.disable_active_btn = is_under_construction
			CommandControls.hide_a_btn = is_room_empty
			
			CommandControls.hide_c_btn = is_room_empty or !is_activated	
			CommandControls.disable_c_btn = at_max_level or !is_activated
			
			CommandControls.onAction = func() -> void:
				await CommandControls.reveal(false)
				if is_activated:
					current_mode = MODE.SUMMARY_CARD						
				else:
					var confirm:bool = await GAME_UTIL.activate_room()
					if confirm:
						await U.tick()
						on_current_location_update()
					CommandControls.reveal(true)
					
			CommandControls.onCBtn = func() -> void:
				await CommandControls.reveal(false)
				var confirm:bool = await GAME_UTIL.upgrade_facility()
				if confirm:
					await U.tick()
					on_current_location_update()
				CommandControls.reveal(true)
				
			CommandControls.onBack = func() -> void:
				await CommandControls.reveal(false)
				lock_actions(false)
				current_mode = MODE.NONE
		# -----------	
		MODE.PROGRAMS:
			current_mode = MODE.ACTIVE_MENU_OPEN
			await show_program_list()
			current_mode = MODE.NONE
		# -----------	
		MODE.BUILD:	
			DesignControls.a_btn_title = ("BUILD" if is_room_empty else "DESTROY") if !is_under_construction else "CANCEL CONSTRUCTION"
			
			DesignControls.onAction = func() -> void:				
				await DesignControls.reveal(false)
				# if cancel construction
				if is_under_construction:
					var made_changes:bool = await GAME_UTIL.cancel_construction(current_location)
					if made_changes:
						GBL.find_node(REFS.WING_RENDER).construction_is_canceled(current_location)
						await U.tick()
						on_current_location_update()
					DesignControls.reveal(true)
					return
				
				# if build new room
				if is_room_empty:
					current_mode = MODE.ACTIVE_MENU_OPEN
					await show_build_options()
					current_mode = MODE.BUILD
					await DesignControls.reveal(true)
					return
					
				
				# ...else destroy room
				var confirm:bool = await GAME_UTIL.reset_room(current_location)
				if confirm:
					GBL.find_node(REFS.WING_RENDER).room_is_destroyed(current_location)
					await U.tick()
					on_current_location_update()
				DesignControls.reveal(true)
						
			DesignControls.onBack = func() -> void:
				await DesignControls.reveal(false)
				lock_actions(false)
				GBL.find_node(REFS.WING_RENDER).change_camera_view(1)
				current_mode = MODE.NONE
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func set_backdrop_state(state:bool) -> void:	
	await U.tween_node_property(Backdrop, 'color', Color(0, 0, 0, 0.7 if state else 0.0))	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func reveal_action_label(state:bool, duration:float = 0.3, title:String = "") -> void:
	CurrentActionLabel.text = str(title)
	await U.tween_node_property(ActionPanel, "position:x", control_pos[ActionPanel].show if state else control_pos[ActionPanel].hide, duration)
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------	
func reveal_notification(state:bool, duration:float = 0.3) -> void:
	if control_pos.is_empty() or !show_new_message_btn:return	
	NewMessageBtn.is_disabled = true
	
	await U.tween_node_property(NotificationPanel, "position:x", control_pos[NotificationPanel].show if state else control_pos[NotificationPanel].hide , duration)

	NewMessageBtn.is_disabled = !show_new_message_btn
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func reveal_action_controls(state:bool, duration:float = 0.2) -> void:
	if control_pos.is_empty():return
	
	is_in_transition = true
	await U.tween_node_property(WingRootPanel, "position:y", control_pos[WingRootPanel].show if state else control_pos[WingRootPanel].hide, duration)
	is_in_transition = false
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_summarycard(state:bool, duration:float = 0.2) -> void:
	await U.tween_node_property(SummaryPanel, "position:x", control_pos[SummaryPanel].show if state else control_pos[SummaryPanel].hide, duration)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func enable_room_focus(state:bool) -> void:
	GBL.find_node(REFS.WING_RENDER).enable_room_focus = state
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
var previous_lock_states:Dictionary = {}
func lock_panel_btn_state(state: bool) -> void:
	for panel in [WingRootPanel]:
		var margin_panel = panel.get_node('./MarginContainer') 
		for root_panel in margin_panel.get_children():
			for child in root_panel.get_children():
				for node in child.get_children():
					if node is BtnBase and "is_disabled" in node:
						if state:
							previous_lock_states[node] = node.is_disabled
						node.is_disabled = true if state else previous_lock_states.get(node, false)

					var btn_list: HBoxContainer = node.get_node('./MarginContainer/VBoxContainer/HBoxContainer/')
					if btn_list != null:
						for btn in btn_list.get_children():
							if state:
								previous_lock_states[btn] = btn.is_disabled
							btn.is_disabled = true if state else previous_lock_states.get(btn, false)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func lock_actions(state:bool) -> void:
	if state:
		freeze_inputs = true		
		lock_panel_btn_state(true)
	
	await reveal_action_controls(!state)
	
	if !state:
		freeze_inputs = false
		lock_panel_btn_state(false)		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return	
	var duration:float = 0.0 if skip_animation else 0.3
	var RenderNode:Node3D = GBL.find_node(REFS.WING_RENDER)
	
	match current_mode:
		# --------------
		MODE.NONE:
			reveal_action_label(false)
			await RenderNode.update_camera_size(125)
			GameplayNode.show_marked_objectives = false
			GameplayNode.show_timeline = true
			lock_actions(false)
			set_backdrop_state(false)
			reveal_summarycard(false, duration)
		# --------------
		MODE.INFO:			
			await RenderNode.update_camera_size(180)
			GameplayNode.show_marked_objectives = true
			GameplayNode.show_timeline = true
			GBL.find_node(REFS.WING_RENDER).change_camera_view(0)
			InfoControls.reveal(true)
		# --------------
		MODE.SUMMARY_CARD:
			SummaryControls.reveal(true)
		# --------------
		MODE.BUILD:
			await RenderNode.update_camera_size(180)
			GameplayNode.show_marked_objectives = false
			GameplayNode.show_timeline = false	
			reveal_summarycard(true)
			reveal_action_label(true, 0.4, "BUILD MODE")
			GBL.find_node(REFS.WING_RENDER).change_camera_view(0)
			DesignControls.reveal(true)			
		# --------------
		MODE.COMMANDS:
			await RenderNode.update_camera_size(180)
			GameplayNode.show_marked_objectives = false
			GameplayNode.show_timeline = false	
			reveal_action_label(true, 0.4, "SELECT A ROOM")
			reveal_summarycard(true)
			CommandControls.reveal(true)
		# -----------	
		MODE.PROGRAMS:
			await RenderNode.update_camera_size(180)
			GameplayNode.show_marked_objectives = false
			GameplayNode.show_timeline = false	
			reveal_action_label(true, 0.4, "PROGRAMS")

	on_current_location_update()
	on_camera_settings_update()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:	
	if !is_node_ready() or !is_visible_in_tree() or GBL.has_animation_in_queue() or current_location.is_empty() or camera_settings.is_empty() or room_config.is_empty() or !is_started or is_in_transition:return	
	var key:String = input_data.key
		
	match current_mode:
		MODE.NONE:
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
		MODE.COMMANDS:
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
		MODE.BUILD:
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

# --------------------------------------------------------------------------------------------------	
