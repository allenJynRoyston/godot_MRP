extends GameContainer

#  ---------------------------------------
# SPECIAL NODES
@onready var Backdrop:ColorRect = $Backdrop
@onready var SummaryControls:Control = $SummaryControls
@onready var NameControl:Control = $NameControl
@onready var TransistionScreen:Control = $TransitionScreen
#  ---------------------------------------

#  ---------------------------------------
# CONTROLS
@onready var DesignControls:Control = $DesignControls
@onready var CommandControls:Control = $CommandControls
@onready var InfoControls:Control = $InfoControls
@onready var ProgramControls:Control = $ProgramControls
@onready var BaseManagementControls:Control = $BaseMangementControls
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

# MODULES
@onready var ModulesPanel:PanelContainer = $ModulesAndPrograms/PanelContainer
@onready var ModulesMargin:MarginContainer = $ModulesAndPrograms/PanelContainer/MarginContainer
@onready var ModulesCard:PanelContainer = $ModulesAndPrograms/PanelContainer/MarginContainer/ModulesCard

# BASE MANAGEMENT
@onready var BaseManagementPanel:PanelContainer = $BaseManagement/PanelContainer
@onready var BaseManagementMargin:MarginContainer = $BaseManagement/PanelContainer/MarginContainer
@onready var BaseSummaryPanel:PanelContainer = $BaseSummary/PanelContainer
@onready var BaseSummaryMargin:MarginContainer = $BaseSummary/PanelContainer/MarginContainer
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
@onready var ToggleLevelBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/ToggleLevelBtn
#@onready var GotoWingBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/GotoWingBtn
#@onready var GotoGeneratorBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/GotoGeneratorBtn
@onready var DebugBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/GotoBtnPanel/MarginContainer/VBoxContainer/HBoxContainer/DebugBtn

# WING ACTION PANELS
@onready var WingActions:PanelContainer = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions
@onready var WingActionBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions/MarginContainer/VBoxContainer/HBoxContainer/WingActionBtn
@onready var WingDesignBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions/MarginContainer/VBoxContainer/HBoxContainer/WingDesignBtn
@onready var WingProgramBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/WingActions/MarginContainer/VBoxContainer/HBoxContainer/WingProgramBtn
@onready var WingInfoBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Right/PlayerActions/MarginContainer/VBoxContainer/HBoxContainer/WingInfoBtn
@onready var EndTurnBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Right/PlayerActions/MarginContainer/VBoxContainer/HBoxContainer/EndTurnBtn

# FACILITY ACTION PANELS
@onready var BaseActions:PanelContainer = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/BaseActions
@onready var BaseManagementBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/BaseActions/MarginContainer/VBoxContainer/HBoxContainer/BaseManagementBtn

# GENERATION ACTION PANEL
@onready var GeneratorActions:PanelContainer = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/GeneratorActions
@onready var GenActionBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer/Center/GeneratorActions/MarginContainer/VBoxContainer/HBoxContainer/GenActionBtn
#  ---------------------------------------

enum MODE { 
	NONE,
	COMMANDS,
	SUMMARY_CARD,
	BASE_MANAGEMENT,
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

var selected_room:int = -1
var list_of_available_rooms:Array = []

var prev_draw_state:Dictionary	= {}
var is_in_transition:bool = false 
var active_menu_is_open:bool = false

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
	BaseManagementControls.reveal(false)
	
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
	
	control_pos[BaseManagementPanel] = {
		"show": 0, 
		"hide": -BaseManagementMargin.size.x
	}
	
	
	control_pos[BaseSummaryPanel] = {
		"show": 0, 
		"hide": -BaseSummaryMargin.size.x
	}
		
	
	# for eelements in the top right
	control_pos[ModulesPanel] = {
		"show": 0, 
		"hide": ModulesMargin.size.x
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

	for node in [NotificationPanel, ActionPanel, SummaryPanel, ModulesPanel, BaseManagementPanel, BaseSummaryPanel]: 
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
	ToggleLevelBtn.onClick = func() -> void:
		camera_settings.type = CAMERA.TYPE.FLOOR_SELECT if camera_settings.type == CAMERA.TYPE.WING_SELECT else CAMERA.TYPE.WING_SELECT
		ToggleLevelBtn.title = "ZOOM OUT" if camera_settings.type else "ZOOM IN"
			
		SUBSCRIBE.camera_settings = camera_settings
		TransistionScreen.start(0.3, true)
		reveal_base_summary(camera_settings.type != CAMERA.TYPE.WING_SELECT)		
	
		
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

	BaseManagementBtn.onClick = func() -> void:			
		GBL.find_node( REFS.BASE_RENDER ).set_base_zoom(1)
		current_mode = MODE.BASE_MANAGEMENT
		reveal_base_summary(false)
		await lock_actions(true)
		reveal_base_management(true)
		BaseManagementControls.reveal(true)
	
	BaseManagementControls.onAction = func() -> void:
		reveal_base_management(true)

	BaseManagementControls.onBack = func() -> void:			
		GBL.find_node( REFS.BASE_RENDER ).set_base_zoom(0)
		reveal_base_management(false)
		await BaseManagementControls.reveal(false)
		lock_actions(false)
		reveal_base_summary(true)
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
		query.list.map(func(x):
			
		return {
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
				
				# skip or use build confirm
				var has_build_confirm:bool = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].gameplay_settings.enable_build_confirm
				
				# set default as true
				var confirm:bool = true
				
				# calculate costs
				var costs:Array = [{
					"amount": -(room_details.costs.purchase), 
					"resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)
				}] if room_details.costs.purchase > 0 else []
				
				# use build confirm
				if has_build_confirm:
					confirm = await GAME_UTIL.create_modal("Construct %s here?" % room_details.name, "This room CANNOT be destroyed once placed.  Are you sure you want to continue?" if !room_details.can_destroy else "Continue?" , room_details.img_src, costs)					
				
				# or skip
				else:
					for item in costs:
						var amount:int = item.amount
						RESOURCE_UTIL.make_update_to_currency_amount(item.resource.ref, amount)
					
					
				# update
				if confirm:
					await ROOM_UTIL.add_room(x.details.ref)
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
	var ring_level_config:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]
	var energy_availble:int = ring_level_config.energy.available - ring_level_config.energy.used

	for listitem in [
			{
				"title": 'RESOURCES', 
				"type": ROOM.CATEGORY.RESOURCES,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or energy_availble < x.details.required_energy or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x: Dictionary) -> Dictionary:
					var description: String = x.details.description
					var disabled_reason: String = ""

					if x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount:
						disabled_reason = "Insufficient funds."
					elif energy_availble < x.details.required_energy:
						disabled_reason = "Not enough energy."
					elif ROOM_UTIL.at_own_limit(x.ref):
						disabled_reason = "At building capacity."

					return {
						"icon": SVGS.TYPE.GLOBAL,
						"title": x.details.name,
						"description": description if disabled_reason == "" else disabled_reason
					},
			},
			{
				"title": 'RECRUITMENT', 
				"type": ROOM.CATEGORY.RECRUITMENT,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or energy_availble < x.details.required_energy or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x: Dictionary) -> Dictionary:
					var description: String = x.details.description
					var disabled_reason: String = ""

					if x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount:
						disabled_reason = "Insufficient funds."
					elif energy_availble < x.details.required_energy:
						disabled_reason = "Not enough energy."
					elif ROOM_UTIL.at_own_limit(x.ref):
						disabled_reason = "At building capacity."

					return {
						"icon": SVGS.TYPE.GLOBAL,
						"title": x.details.name,
						"description": description if disabled_reason == "" else disabled_reason
					},
			},			
			{
				"title": 'ENERGY', 
				"type": ROOM.CATEGORY.ENERGY,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or energy_availble < x.details.required_energy or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x: Dictionary) -> Dictionary:
					var description: String = x.details.description
					var disabled_reason: String = ""

					if x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount:
						disabled_reason = "Insufficient funds."
					elif energy_availble < x.details.required_energy:
						disabled_reason = "Not enough energy."
					elif ROOM_UTIL.at_own_limit(x.ref):
						disabled_reason = "At building capacity."

					return {
						"icon": SVGS.TYPE.GLOBAL,
						"title": x.details.name,
						"description": description if disabled_reason == "" else disabled_reason
					},
			},
			{
				"title": 'UTILITY', 
				"type": ROOM.CATEGORY.UTILITY,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or energy_availble < x.details.required_energy or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x: Dictionary) -> Dictionary:
					var description: String = x.details.description
					var disabled_reason: String = ""

					if x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount:
						disabled_reason = "Insufficient funds."
					elif energy_availble < x.details.required_energy:
						disabled_reason = "Not enough energy."
					elif ROOM_UTIL.at_own_limit(x.ref):
						disabled_reason = "At building capacity."

					return {
						"icon": SVGS.TYPE.GLOBAL,
						"title": x.details.name,
						"description": description if disabled_reason == "" else disabled_reason
					},
			},			
			{
				"title": 'CONTAINMENT', 
				"type": ROOM.CATEGORY.CONTAINMENT,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or energy_availble < x.details.required_energy or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x: Dictionary) -> Dictionary:
					var description: String = x.details.description
					var disabled_reason: String = ""

					if x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount:
						disabled_reason = "Insufficient funds."
					elif energy_availble < x.details.required_energy:
						disabled_reason = "Not enough energy."
					elif ROOM_UTIL.at_own_limit(x.ref):
						disabled_reason = "At building capacity."

					return {
						"icon": SVGS.TYPE.GLOBAL,
						"title": x.details.name,
						"description": description if disabled_reason == "" else disabled_reason
					},
			},
			{
				"title": 'SPECIAL', 
				"type": ROOM.CATEGORY.SPECIAL,
				"is_disabled_func": func(x:Dictionary) -> bool:
					return x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or energy_availble < x.details.required_energy or ROOM_UTIL.at_own_limit(x.ref),
				"hint_func": func(x: Dictionary) -> Dictionary:
					var description: String = x.details.description
					var disabled_reason: String = ""

					if x.details.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount:
						disabled_reason = "Insufficient funds."
					elif ring_level_config.energy.available < x.details.required_energy:
						disabled_reason = "Not enough energy."
					elif ROOM_UTIL.at_own_limit(x.ref):
						disabled_reason = "At building capacity."

					return {
						"icon": SVGS.TYPE.GLOBAL,
						"title": x.details.name,
						"description": description if disabled_reason == "" else disabled_reason
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
		SummaryCard.preview_mode_ref = item.ref

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
	
	active_menu_is_open = true
	ActiveMenuNode.onClose = func() -> void:
		SummaryCard.preview_mode_ref = -1
		SummaryCard.preview_mode = false		
		await reveal_summarycard(false)
		active_menu_is_open = false
		show_build_complete.emit()
		
		
	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	ActiveMenuNode.render_on_right = true
	
	# summary card
	SummaryCard.preview_mode = true	
	reveal_summarycard(true, false)	

	
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
		ActiveMenuNode.remap_data(GAME_UTIL.get_list_of_programs(current_location, true).map(func(x): 
			return {
				"title":  x.ability.name if !x.on_cooldown else str(x.ability.name, " (COOLDOWN)" ),
				"show": x.at_level_threshold,
				"is_disabled": x.on_cooldown,
				"data": x.data,
				"hint": {
					"icon": SVGS.TYPE.ENERGY,
					"title": "HINT",
					"description": str(x.ability.description, " " if !x.on_cooldown else " (ON COOLDOWN FOR %s DAYS)" % [x.cooldown_val] )
			},			
		}) )
		

	var items:Array = GAME_UTIL.get_list_of_programs(current_location, true).map(func(x): 
		return {
			"title":  x.ability.name if !x.on_cooldown else str(x.ability.name, " (COOLDOWN)" ),
			"show": x.at_level_threshold,
			"is_disabled": x.on_cooldown,
			"data": x.data,
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
	
	ActiveMenuNode.onUpdate = func(item:Dictionary) -> void:
		SUBSCRIBE.current_location = item.data.location
	
	active_menu_is_open = true
	ActiveMenuNode.onClose = func() -> void:	
		await U.tick()
		active_menu_is_open = false
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
	
	active_menu_is_open = true
	ActiveMenuNode.onClose = func() -> void:	
		active_menu_is_open = false
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
	
	var options:Array = [
		{
			"title": "BASE STATES",
			"items": [
				{
					"title": "TOGGLE IS_POWERED",
					"icon": SVGS.TYPE.DANGER,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "DEBUG: toggle the IS_POWERED flag.."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.toggle_is_powered(current_location.floor)
						ActiveMenuNode.unlock(),
				},
				{
					"title": "TOGGLE IS_OVERHEATED",
					"icon": SVGS.TYPE.DANGER,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "DEBUG: toggle the IS_OVERHEATED flag.."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.toggle_is_overheated(current_location)
						ActiveMenuNode.unlock(),
				},							
				{
					"title": "TOGGLE VENTILATION",
					"icon": SVGS.TYPE.DANGER,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "DEBUG: toggle the IS_VENTILATED flag.."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.toggle_is_ventilated(current_location)
						ActiveMenuNode.unlock(),
				},			
				{
					"title": "TOGGLE NUKE",
					"icon": SVGS.TYPE.DANGER,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "DEBUG: toggle the NUKE flag.."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.toggle_onsite_nuke()
						ActiveMenuNode.unlock(),
				},		
								
			],
		},		
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
						await GAME_UTIL.set_emergency_mode_to_normal(true)
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
						await GAME_UTIL.set_emergency_mode_to_caution(true)
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
						await GAME_UTIL.set_emergency_mode_to_warning(true)
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
						await GAME_UTIL.set_emergency_mode_to_danger(true)
						ActiveMenuNode.unlock(),
				},				
			],
		},
		{
			"title": "EVENTS",
			"items": [
				{
					"title": "HAPPY HOUR",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for HAPPY HOUR event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.trigger_event([EVENT_UTIL.run_event(
							EVT.TYPE.HAPPY_HOUR, 
								{
									"onSelection": func(selection:Dictionary) -> void:
										# add buff, debuff
										print("todo: ADD BUFF OR DEBUFF depending on option")
										print(selection),
								}
							)
						])
						ActiveMenuNode.unlock(),
				},
			]
		},		
		{
			"title": "SCP EVENTS",
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
						var scp_ref:int = await GAME_UTIL.select_scp()
						if scp_ref != -1:
							await GAME_UTIL.trigger_initial_containment_event(0)
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
						var scp_ref:int = await GAME_UTIL.select_scp()
						if scp_ref != -1:						
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
						var scp_ref:int = await GAME_UTIL.select_scp()
						if scp_ref != -1:						
							await GAME_UTIL.trigger_containment_event(scp_ref)
						ActiveMenuNode.unlock(),
				}				
			]
		}
	]

	active_menu_is_open = true
	ActiveMenuNode.onClose = func() -> void:	
		active_menu_is_open = false
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
	
	active_menu_is_open = true
	ActiveMenuNode.onClose = func() -> void:	
		active_menu_is_open = false
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
	
	active_menu_is_open = true
	ActiveMenuNode.onClose = func() -> void:	
		active_menu_is_open = false
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
			BaseManagementBtn.show()
			GeneratorActions.hide()
			
		# ----------------------
		CAMERA.TYPE.WING_SELECT:
			NameControl.hide()
			WingActions.show()
			BaseManagementBtn.hide()
			GeneratorActions.hide()

		## ----------------------
		#CAMERA.TYPE.GENERATOR:
			#NameControl.hide()
			#WingActions.hide()
			#BaseManagementBtn.hide()
			#GeneratorActions.show()	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	U.debounce(str(self, "_check_btn_states"), check_btn_states)

func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	U.debounce(str(self, "_check_btn_states"), check_btn_states)
# --------------------------------------------------------------------------------------------------
	
# --------------------------------------------------------------------------------------------------
func before_active_selection() -> void:
	await SummaryControls.reveal(false)

func after_active_selection() -> void:
	SummaryControls.reveal(true)

func before_scp_selection() -> void:
	await SummaryControls.reveal(false)

func after_scp_selection() -> void:
	SummaryControls.reveal(true)

func check_btn_states() -> void:
	if current_location.is_empty() or room_config.is_empty():return
	# update room details control
	var WingRenderNode:Node3D = GBL.find_node(REFS.WING_RENDER)
	var has_one_floor_activated:bool = GAME_UTIL.get_activated_floor_count()	> 0
	var has_generator_prerequisite:bool = ROOM_UTIL.owns_and_is_active(ROOM.REF.GENERATOR_SUBSTATION)		
	var room_extract:Dictionary = GAME_UTIL.extract_room_details(current_location)
	var nuke_activated:bool = room_config.base.onsite_nuke.triggered
	var is_powered:bool = room_config.floor[current_location.floor].is_powered
	var is_ventilated:bool = room_config.floor[current_location.floor].ring[current_location.ring].is_ventilated	
	var is_overheated:bool = room_config.floor[current_location.floor].ring[current_location.ring].is_overheated	
	var in_lockdown:bool = room_config.floor[current_location.floor].in_lockdown
	var is_room_empty:bool = room_extract.room.is_empty()
	var is_scp_empty:bool = room_extract.scp.is_empty()
	var abilities:Array = [] if is_room_empty else room_extract.room.details.abilities.call()
	var passive_abilities:Array = [] if is_room_empty else room_extract.room.details.passive_abilities.call()
	var is_activated:bool = false if is_room_empty else room_extract.room.is_activated
	var can_contain:bool = false if is_room_empty else room_extract.room.details.can_contain
	var can_assign_researchers:bool = false if is_room_empty else room_extract.room.details.can_assign_researchers
	var can_take_action:bool = (is_powered and !in_lockdown)
	var can_deconstruct:bool = false if is_room_empty else room_extract.room.details.can_destroy 
	var is_under_construction:bool = false if is_room_empty else ROOM_UTIL.is_under_construction(current_location)
	var has_options:bool = !abilities.is_empty() or !passive_abilities.is_empty()
	var lvl:int = -1 if is_room_empty else room_extract.room.abl_lvl 
	var max_upgrade_lvl:int = -1 if is_room_empty else room_extract.room.max_upgrade_lvl 
	var at_max_level:bool = lvl >= max_upgrade_lvl
	var rooms_in_wing_count:int = purchased_facility_arr.filter(func(x): 
		return x.location.floor == current_location.floor and x.location.ring == current_location.ring 
	).size()	

	SummaryCard.use_location = current_location
	ModulesCard.use_location = current_location

	match current_mode:
		MODE.NONE:
			WingDesignBtn.is_disabled = !is_powered or !is_ventilated or is_overheated
			WingDesignBtn.title = "DESIGN" if (is_powered and is_ventilated and !is_overheated) else "UNAVAILABLE"
			WingProgramBtn.hide() if GAME_UTIL.get_list_of_programs(current_location, true).is_empty() else WingProgramBtn.show()
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
				current_mode = MODE.NONE
		# -----------	
		MODE.SUMMARY_CARD:
			SummaryControls.directional_pref = "UD"
			SummaryControls.offset = ModulesCard.global_position
			
			SummaryControls.onBack = func() -> void:
				ModulesCard.deselect_btns()
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
					"scp":						
						SummaryControls.a_btn_title = "SELECT SCP" if node.ref_data.data.is_empty() else "FULL"
						SummaryControls.disable_active_btn = !node.ref_data.data.is_empty()
						
					"active_ability":
						SummaryControls.a_btn_title = "USE PROGRAM"
						SummaryControls.disable_active_btn = node.ref_data.is_disabled
					# ----------------------
					"passive_ability":
						SummaryControls.a_btn_title = "UNAVAILABLE" if node.ref_data.is_disabled else "TOGGLE MODULE" 
						SummaryControls.disable_active_btn = node.ref_data.is_disabled
					# ----------------------
		# -----------	
		MODE.COMMANDS:
			var can_activate:bool = ROOM_UTIL.can_activate_check(room_extract.room.details.ref)	if !room_extract.room.is_empty() else false
			
			CommandControls.a_btn_title = "MISSING STAFF" if !is_room_empty and !can_activate else "UTILIZE" if is_activated else "ACTIVATE"
			CommandControls.hide_a_btn = is_room_empty or is_under_construction
			CommandControls.disable_active_btn = !is_room_empty and !can_activate

			CommandControls.hide_c_btn = is_room_empty or !is_activated	or at_max_level
			CommandControls.disable_c_btn = !is_activated
			
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
				WingRenderNode.highlight_rooms = []
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
			DesignControls.c_btn_title = "RUSH CONSTRUCTION"
			
			DesignControls.hide_c_btn = !is_under_construction
			
			DesignControls.onCBtn = func() -> void:
				await DesignControls.reveal(false)
				var confirm:bool = await GAME_UTIL.rush_construction_room()
				if confirm:
					await U.tick()
					on_current_location_update()
				DesignControls.reveal(true)
				return
			
			DesignControls.onAction = func() -> void:				
				await DesignControls.reveal(false)
				
				# if cancel construction
				if is_under_construction:
					var made_changes:bool = await GAME_UTIL.cancel_construction(current_location)
					if made_changes:
						await U.tick()
						on_current_location_update()
					DesignControls.reveal(true)
					return
				
				# if build new room
				if is_room_empty:
					await show_build_options()
					DesignControls.reveal(true)
					reveal_summarycard(true, false)
					return
						
				#...else destroy room
				var confirm:bool = await GAME_UTIL.reset_room(current_location)
				if confirm:
					await U.tick()
					on_current_location_update()
				DesignControls.reveal(true)
						
			DesignControls.onBack = func() -> void:
				await DesignControls.reveal(false)
				current_mode = MODE.NONE

# --------------------------------------------------------------------------------------------------
func set_backdrop_state(state:bool) -> void:	
	await U.tween_node_property(Backdrop, 'color', Color(0, 0, 0, 0.7 if state else 0.0))	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func reveal_action_label(state:bool, duration:float = 0.3, title:String = "") -> void:
	CurrentActionLabel.text = str(title)
	if state:
		ActionPanel.show()
		
	await U.tween_node_property(ActionPanel, "position:x", control_pos[ActionPanel].show if state else control_pos[ActionPanel].hide, duration)
	
	if !state:
		ActionPanel.hide()
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
	if !is_node_ready() or control_pos.is_empty():return
	
	is_in_transition = true
	await U.tween_node_property(WingRootPanel, "position:y", control_pos[WingRootPanel].show if state else control_pos[WingRootPanel].hide, duration)
	is_in_transition = false
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_summarycard(state:bool, show_modules:bool = true, duration:float = 0.2) -> void:
	if show_modules:
		U.tween_node_property(ModulesPanel, "position:x", control_pos[ModulesPanel].show if state else control_pos[ModulesPanel].hide, duration)
	else:
		ModulesPanel.position.x = control_pos[ModulesPanel].hide
		
	await U.tween_node_property(SummaryPanel, "position:x", control_pos[SummaryPanel].show if state else control_pos[SummaryPanel].hide, duration)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_base_management(state:bool, duration:float = 0.3) -> void:
	if !is_node_ready():return
	if state:
		BaseManagementPanel.show()
		
	print(state, BaseManagementPanel)
	
	await U.tween_node_property(BaseManagementPanel, "position:x", control_pos[BaseManagementPanel].show if state else control_pos[BaseManagementPanel].hide, duration)
	
	if !state:
		BaseManagementPanel.hide()

# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_base_summary(state:bool, duration:float = 0.3) -> void:
	if !is_node_ready():return
	if state:
		BaseSummaryPanel.show()
	
	await U.tween_node_property(BaseSummaryPanel, "position:x", control_pos[BaseSummaryPanel].show if state else control_pos[BaseSummaryPanel].hide, duration)
	
	if !state:
		BaseSummaryPanel.hide()
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
		lock_panel_btn_state(true)
	
	await reveal_action_controls(!state)
	
	if !state:		
		lock_panel_btn_state(false)		
		check_btn_states()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
var previous_mode:int = -1
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return	
	var WingRenderNode:Node3D = GBL.find_node(REFS.WING_RENDER)
	var RenderingNode:Control = GBL.find_node(REFS.RENDERING)
	
	if previous_mode != current_mode:
		previous_mode = current_mode 
		
		match current_mode:
			# --------------
			MODE.NONE:
				WingRenderNode.change_camera_view(CAMERA.VIEWPOINT.ANGLE_NEAR)
				RenderingNode.set_shader_strength(0)
				reveal_action_label(false)			
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = true
				lock_actions(false)
				set_backdrop_state(false)
				reveal_summarycard(false, false)
				
				# recenter...
				SUBSCRIBE.current_location =  {"floor": current_location.floor, "ring": current_location.ring, "room": 4}
			# --------------
			MODE.INFO:			
				WingRenderNode.change_camera_view(CAMERA.VIEWPOINT.ANGLE_NEAR)
				RenderingNode.set_shader_strength(0)
				GameplayNode.show_marked_objectives = true
				GameplayNode.show_timeline = true
				InfoControls.reveal(true)
			# --------------
			MODE.SUMMARY_CARD:
				WingRenderNode.change_camera_view(CAMERA.VIEWPOINT.DISTANCE)
				RenderingNode.set_shader_strength(0)
				SummaryControls.reveal(true)

				SummaryControls.itemlist = ModulesCard.get_ability_btns()
				SummaryControls.item_index = 0
			# --------------
			MODE.BUILD:
				WingRenderNode.change_camera_view(CAMERA.VIEWPOINT.OVERHEAD)
				RenderingNode.set_shader_strength(1)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false	
				reveal_summarycard(true, false)
				reveal_action_label(true, 0.4, "BUILD MODE")				
				DesignControls.reveal(true)			
			# --------------
			MODE.COMMANDS:
				WingRenderNode.change_camera_view(CAMERA.VIEWPOINT.ANGLE_FAR)
				RenderingNode.set_shader_strength(1)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false	
				reveal_action_label(true, 0.4, "ACTIONS")
				reveal_summarycard(true, true)
				CommandControls.reveal(true)
				
				list_of_available_rooms = ROOM_UTIL.list_of_rooms_in_wing()
				list_of_available_rooms.sort()
				selected_room = -1 if list_of_available_rooms.is_empty() else list_of_available_rooms[0]
				if selected_room != -1:
					SUBSCRIBE.current_location = {"floor": current_location.floor, "ring": current_location.ring, "room": selected_room}
				WingRenderNode.highlight_rooms = [selected_room]								
			# -----------	
			MODE.PROGRAMS:
				WingRenderNode.change_camera_view(CAMERA.VIEWPOINT.DISTANCE)
				RenderingNode.set_shader_strength(1)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false	
				reveal_action_label(true, 0.4, "PROGRAMS")

		on_current_location_update()
		on_camera_settings_update()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:	
	if !is_node_ready() or !is_visible_in_tree() or GBL.has_animation_in_queue() or current_location.is_empty() or camera_settings.is_empty() or room_config.is_empty() or !is_started or is_in_transition or active_menu_is_open:return	
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
				"W":
					U.room_up(true, true)
				# ----------------------------
				"S":
					U.room_down(true, true)
				# ----------------------------
				"D":
					U.room_right(true, true)
				# ----------------------------
				"A":
					U.room_left(true, true)
					
			var WingRenderNode:Node3D = GBL.find_node(REFS.WING_RENDER)
			WingRenderNode.highlight_rooms = [current_location.room]
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
		MODE.BASE_MANAGEMENT:
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
