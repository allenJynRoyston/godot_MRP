extends GameContainer

#region setup
#  ---------------------------------------
# SPECIAL NODES
@onready var Backdrop:ColorRect = $Backdrop
@onready var NametagControl:Control = $NametagControl
@onready var TransistionScreen:Control = $TransitionScreen
@onready var LocationAndDirectivesContainer:Control = $LocationAndDirectivesContainer
#  ---------------------------------------

#  ---------------------------------------
# CONTROLS
@onready var AdminControls:Control = $AdminControls
@onready var AdminModulesControls:Control = $AdminModulesControls
@onready var FabricationControls:Control = $FabricationControls
@onready var IntelControls:Control = $IntelControls
@onready var IntelOverviewControls:Control = $IntelOverviewControls
@onready var MedicalControls:Control = $MedicalControls
@onready var MedicalOverviewControls:Control = $MedicalOverviewControls
@onready var EngineeringControls:Control = $EngineeringControls
@onready var EngineeringConfigControls:Control = $EngineeringConfigControls
@onready var LogisticsControls:Control = $LogisticsControls
@onready var SecurityControls:Control = $SecurityControls
@onready var ScienceControls:Control = $ScienceControls
@onready var EthicsControls:Control = $EthicsControls
@onready var InfoControls:Control = $InfoControls
@onready var ContainControls:Control = $ContainControls
#  ---------------------------------------

#  ---------------------------------------
# NOTIFICATION
@onready var NotificationPanel:PanelContainer = $NotificationControls/PanelContainer
@onready var NotificationMargin:MarginContainer = $NotificationControls/PanelContainer/MarginContainer
@onready var NewMessageBtn:BtnBase = $NotificationControls/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NewMessageBtn
#  ---------------------------------------

#  ---------------------------------------
# SUMMARY
@onready var SummaryPanel:PanelContainer = $Summary/PanelContainer
@onready var SummaryPanelMargin:MarginContainer = $Summary/PanelContainer/MarginContainer
@onready var SummaryCard:PanelContainer = $Summary/PanelContainer/MarginContainer/SummaryCard

# MODULES
@onready var ModulesPanel:PanelContainer = $ModulesAndPrograms/PanelContainer
@onready var ModulesMargin:MarginContainer = $ModulesAndPrograms/PanelContainer/MarginContainer
@onready var ModulesCard:PanelContainer = $ModulesAndPrograms/PanelContainer/MarginContainer/ModulesCard

# BASE MANAGEMENT
@onready var EngineeringPanel:PanelContainer = $Engineering/PanelContainer
@onready var EngineeringMargin:MarginContainer = $Engineering/PanelContainer/MarginContainer
@onready var EngineeringComponent:Control = $Engineering/PanelContainer/MarginContainer/EngineeringComponent

@onready var TopographyPanel:PanelContainer = $Topography/PanelContainer
@onready var TopographyMargin:MarginContainer = $Topography/PanelContainer/MarginContainer
@onready var TopographyComponent:PanelContainer = $Topography/PanelContainer/MarginContainer/TopographyComponent

@onready var TelemetryPanel:PanelContainer = $Telemetry/PanelContainer
@onready var TelemetryMargin:MarginContainer = $Telemetry/PanelContainer/MarginContainer 
@onready var TelemetryComponent:Control = $Telemetry/PanelContainer/MarginContainer/TelemetryComponent

@onready var BlueprintPanel:PanelContainer = $Blueprint/PanelContainer
@onready var BlueprintMargin:MarginContainer = $Blueprint/PanelContainer/MarginContainer
@onready var BlueprintComponent:Control = $Blueprint/PanelContainer/MarginContainer/BlueprintComponent
#  ---------------------------------------

#  ---------------------------------------
# STATIC CONTROLS 
# GOTO PANEL
@onready var WingRootPanel:PanelContainer = $RootControls/PanelContainer
@onready var WingRootMargin:MarginContainer = $RootControls/PanelContainer/MarginContainer

# CURRENT ACTION
@onready var ActionPanel:PanelContainer = $ActionLabelPanel/PanelContainer
@onready var ActionMargin:MarginContainer = $ActionLabelPanel/PanelContainer/MarginContainer
@onready var CurrentActionLabel:Label  = $ActionLabelPanel/PanelContainer/MarginContainer/VBoxContainer/CurrentActionLabel
@onready var ActionTextureRect:TextureRect = $ActionLabelPanel/PanelContainer/MarginContainer/VBoxContainer/ActionTextureRect

# LEFT SIDE
@onready var HasEventBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/HasEventBtn
@onready var IntelBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/IntelBtn
@onready var FabricationBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/FabricationBtn
@onready var EngineeringBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/EngineeringBtn
@onready var LogisticsBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/LogisticsBtn
@onready var AdminBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/AdminBtn
@onready var SecurityBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/SecurityBtn
@onready var ScienceBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/ScienceBtn
@onready var MedicalBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/MedicalBtn
@onready var EthicsBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/EthicsBtn
@onready var ContainBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/ContainBtn

#@onready var OperationsBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/OperationsBtn
@onready var DebugBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Left/DebugBtn

# RIGHT SIDE
@onready var SettingsBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Right/SettingsBtn
@onready var InfoBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Right/InfoBtn
@onready var EndTurnBtn:BtnBase = $RootControls/PanelContainer/MarginContainer/HBoxContainer2/Right/EndTurnBtn
#  ---------------------------------------
#endregion

#region vars
enum MODE { 
	NO_INPUT,
	ROOT,	
	EVENT_BTN_TRIGGER,
	
	FABRICATION,
	FABRICATION_LINKABLE,
	INTEL, INTEL_OVERSIGHT, 
	
	ENGINEERING, ENGINEERING_CONFIG,
	ADMINISTRATION, ADMINISTRATION_MODULES,
	SECURITY,
	SCIENCE, 
	MEDICAL, MEDICAL_OVERVIEW,
	LOGISTICS, 
	ETHICS,
	CONTAIN, SCP_SELECT,
	
	INFO,
	ACTIVE_MENU_OPEN,
}

const KeyBtnPreload:PackedScene = preload("res://UI/Buttons/KeyBtn/KeyBtn.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")
const ActiveMenuPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionContainer/parts/ActiveMenu.tscn")

const portrait_img_src:Dictionary = {
	PORTRAIT.ENGINEER: "res://Media/images/SectionArt/engineer.png",
	PORTRAIT.SECURITY: "res://Media/images/SectionArt/security.png",	
	PORTRAIT.ADMIN: "res://Media/images/SectionArt/admin.png",	
}

enum PORTRAIT {ENGINEER, SECURITY, ADMIN}

var current_mode:MODE = MODE.ROOT : 
	set(val):
		current_mode = val
		on_current_mode_update()

var selected_room:int = -1
#var telemetry_count:int = 0
var list_of_available_rooms:Array = []
var list_of_adjacent_rooms:Array = []

var prev_draw_state:Dictionary	= {}
var is_in_transition:bool = false 
var active_menu_is_open:bool = false
var add_on_base_location:Dictionary

var is_started:bool = false
var show_new_message_btn:bool = false : 
	set(val):
		show_new_message_btn = val
		reveal_new_message(val)
#endregion

#region setup
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
	for node in [
			IntelControls, IntelOverviewControls,
			FabricationControls, 
			AdminControls, AdminModulesControls, 
			MedicalControls, MedicalOverviewControls,
			EngineeringControls, EngineeringConfigControls, 
		]:
		node.reveal(false)


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
	
	control_pos[EngineeringPanel] = {
		"show": 0, 
		"hide": EngineeringMargin.size.x
	}

	control_pos[TopographyPanel] = {
		"show": 0, 
		"hide": TopographyMargin.size.x
	}
	
	control_pos[TelemetryPanel] = {
		"show": 0,
		"hide": TelemetryMargin.size.x
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
	
	control_pos[BlueprintPanel] = {
		"show": 0,
		"hide": -BlueprintMargin.size.y
	}
		
	
	# for elements in the bottom left corner
	control_pos[ActionPanel] = {
		"show": 0, 
		"hide": ActionMargin.size.x
	}	
	
	for node in [WingRootPanel, BlueprintPanel]: 
		node.position.y = control_pos[node].hide

	for node in [NotificationPanel, ActionPanel, SummaryPanel, ModulesPanel, EngineeringPanel, TopographyPanel, TelemetryPanel]: 
		node.position.x = control_pos[node].hide
		node.hide()
	
	# hide by default
	NewMessageBtn.is_disabled = true
	
	on_current_mode_update(skip_animation)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func start() -> void:	
	var BaseRenderNode:Node3D = GBL.find_node( REFS.BASE_RENDER )
	is_started = true

	# -------------------------------------
	EndTurnBtn.onClick = func() -> void:
		EndTurnBtn.is_flashing = false
		await lock_actions(true)
		await GameplayNode.next_day()
		lock_actions(false)
	
	# -------------------------------------
	HasEventBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.EVENT_BTN_TRIGGER

	# -------------------------------------
	NewMessageBtn.onClick = func() -> void:
		lock_panel_btn_state(true)
		#await reveal_notification(false)
		show_new_message_btn = false
		await GBL.find_node(REFS.DOOR_SCENE).play_next_sequence()
		lock_panel_btn_state(false)

	# -------------------------------------
	IntelBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.INTEL
	
	EngineeringBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.ENGINEERING
		
	EthicsBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.ETHICS		
		
	LogisticsBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.LOGISTICS		
		
	AdminBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.ADMINISTRATION	
		
	SecurityBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.SECURITY	
	
	ScienceBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.SCIENCE

	MedicalBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.MEDICAL
		
	ContainBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.CONTAIN		

	DebugBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.ACTIVE_MENU_OPEN	
		await show_debug()
		current_mode = MODE.ROOT

	# -------------------------------------
	SettingsBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.ACTIVE_MENU_OPEN	
		await show_settings()
		current_mode = MODE.ROOT
		
	InfoBtn.onClick = func() -> void:
		await lock_actions(true)
		current_mode = MODE.INFO	
	# -------------------------------------	
	
	on_current_mode_update()
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3, 0.5)	
# --------------------------------------------------------------------------------------------------	
#endregion

#region active_menus
# --------------------------------------------------------------------------------------------------
signal query_complete
func query_items(ActiveMenuNode:Control, query_size:int, category:ROOM.CATEGORY, page:int, return_list:Array, is_disabled_func:Callable, hint_func:Callable, action:Callable) -> void:
	var query:Dictionary
	var start_at:int = page * query_size
	query = ROOM_UTIL.get_unlocked_category(category, start_at, query_size)	

	return_list.push_back(
		query.list.map(func(x):
		return {
			"title": x.details.name,
			"img_src": x.details.img_src,
			"is_disabled": is_disabled_func.call(x.details),
			"hint": hint_func.call(x.details), 
			"ref": x.ref,
			"details": x.details,
			"action": action.bind(x)
		})
	)	
	
	if query.has_more:
		query_items(ActiveMenuNode, query_size, category, page + 1, return_list, is_disabled_func, hint_func, action)
	else:
		await U.tick()
		query_complete.emit(return_list)

signal show_build_complete
signal linkable_action
func show_fabrication_options() -> void:
	const query_size:int = 25
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()	
	var WingRenderNode:Node3D = GBL.find_node(REFS.WING_RENDER)	
	var is_room_empty:bool = ROOM_UTIL.is_room_empty()	
	var ring_level_config:Dictionary = GAME_UTIL.get_ring_level_config()
	var energy_available:int = GAME_UTIL.get_energy_available()
	var department_count:int = purchased_facility_arr.filter(func(x): 
		var room_details:Dictionary = ROOM_UTIL.return_data(x.ref)
		return x.location.floor == current_location.floor and x.location.ring == current_location.ring and ROOM.CATEGORY.DEPARTMENT in room_details.categories
	).size()	
	
	# assists functions
	var is_disabled_func:Callable = func(x:Dictionary) -> bool:
		return x.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount or energy_available < x.required_energy or ROOM_UTIL.at_own_limit(x.ref)
	var hint_func:Callable = func(x: Dictionary) -> Dictionary:
		var description: String = x.description
		var disabled_reason: String = ""		

		if x.costs.purchase > resources_data[RESOURCE.CURRENCY.MONEY].amount:
			disabled_reason = "Insufficient funds."
		elif energy_available < x.required_energy:
			disabled_reason = "Not enough energy."
		elif ROOM_UTIL.at_own_limit(x.ref):
			disabled_reason = "At building capacity."
		return {
			"icon": SVGS.TYPE.GLOBAL,
			"title": x.name,
			"description": description if disabled_reason == "" else disabled_reason
		}
		
	var on_selected:Callable = func(x:Dictionary) -> void:
		await ActiveMenuNode.lock()
		# purchase and show tally
		var room_details:Dictionary = ROOM_UTIL.return_data(x.ref)
		# calculate costs
		var costs:Array = [{
			"amount": -(room_details.costs.purchase), 
			"resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY)
		}] if room_details.costs.purchase > 0 else []

		# build new foundation
		# pay and close
		for item in costs:
			var amount:int = item.amount
			RESOURCE_UTIL.make_update_to_currency_amount(item.resource.ref, amount)
			
		# add room
		await ROOM_UTIL.add_room(x.ref)
		
		ActiveMenuNode.close()
	var all_link_categories:Array = ROOM_UTIL.get_all_link_catagories() 

	var options:Array = []
	var list:Array = []
	
	# first, get adjacent cateogries
	for type in all_link_categories:
		list.push_back({
			"title": ROOM.return_category_title(type),
			"type": type,
			"is_disabled_func": is_disabled_func,
			"hint_func": hint_func
		})

	# ... then general other categories
	for type in [ROOM.CATEGORY.ENERGY, ROOM.CATEGORY.UTILITY, ROOM.CATEGORY.CONTAINMENT, ROOM.CATEGORY.DEPARTMENT]:
		list.push_back({
			"title": ROOM.return_category_title(type),
			"type": type,
			"is_disabled_func": is_disabled_func,
			"hint_func": hint_func
		})
	
	for listitem in list:
		query_items(ActiveMenuNode, query_size, listitem.type, 0, [], listitem.is_disabled_func, listitem.hint_func, on_selected)
		var query_results:Array = await query_complete
		for index in query_results.size():
			var items:Array = query_results[index]
			if items.size() > 0:
				options.push_back({
					"title": listitem.title,
					"items": items,
					"footer": "%s / %s" % [index + 1, items.size() ],
				})
				
	var subdivision_list:Array = []
	if GAME_UTIL.is_conditional_active(CONDITIONALS.TYPE.ENABLE_ADMIN_SUBDIVISON):
		var room_details:Dictionary = ROOM_UTIL.return_data(ROOM.REF.ADMIN_OFFICE)
		subdivision_list.push_back({
			"title": room_details.name,
			"img_src": room_details.img_src,
			"is_disabled": is_disabled_func.call(room_details),
			"hint": hint_func.call(room_details), 
			"ref": ROOM.REF.ADMIN_OFFICE,
			"details": room_details,
			"action": on_selected.bind(room_details)
		})

	
	if !subdivision_list.is_empty():
		options.push_back({
			"title": "BRANCH",
			"items": subdivision_list,
			"footer": "%s / %s" % [0, 99],
		})				
				
	
	ActiveMenuNode.onUpdate = func(item:Dictionary) -> void:
		# update preview
		SummaryCard.preview_mode_ref = item.ref
		# mark preview
		WingRenderNode.mark_preview(item.ref)

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
		WingRenderNode.end_preview()
		clear_lines()
	
	active_menu_is_open = true
	ActiveMenuNode.onClose = func() -> void:
		current_mode = MODE.FABRICATION
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
signal show_programs_complete
func show_programs(filter_for:Array, title:String) -> void:
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()

	var update_list:Callable = func() -> void:
		await U.tick()
		ActiveMenuNode.remap_data(GAME_UTIL.get_list_of_programs(current_location, filter_for).map(func(x): 
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
		

	var items:Array = GAME_UTIL.get_list_of_programs(current_location, filter_for).map(func(x): 
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
			"title": title,
			"items": items,
		},
	]
	
	ActiveMenuNode.onUpdate = func(item:Dictionary) -> void:
		SUBSCRIBE.current_location = item.data.location
	
	active_menu_is_open = true
	ActiveMenuNode.onClose = func() -> void:	
		await U.tick()
		active_menu_is_open = false
		show_programs_complete.emit()
		
	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	ActiveMenuNode.render_on_right = true
	
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate()
	ActiveMenuNode.open()	
	
	await show_programs_complete
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
signal show_debug_complete
func show_debug() -> void:
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()
	
	var options:Array = [
		{
			"title": "EVENTS",
			"items": [
				{
					"title": "FORCE TELEMTRY EVENT IN ROOM",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "For a rooms event to trigger and show up for Telemetry."
					},
					"action": func() -> void:
						print("add check to get room events and conditions")
						GAME_UTIL.add_room_event(EVT.TYPE.HAPPY_HOUR, current_location)
						print("event added: ", EVT.TYPE.HAPPY_HOUR),
#						pass
				},	
				{
					"title": "TEST EVENT A",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for TEST_EVENT_A event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.run_event(EVT.TYPE.TEST_EVENT_A)
						ActiveMenuNode.unlock(),
				},
				{
					"title": "TEST EVENT B",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for TEST_EVENT_B event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.run_event(EVT.TYPE.TEST_EVENT_B)
						ActiveMenuNode.unlock(),
				},
				{
					"title": "TEST EVENT C",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for TEST_EVENT_C event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.run_event(EVT.TYPE.TEST_EVENT_C)
						ActiveMenuNode.unlock(),
				},				
				{
					"title": "HAPPY HOUR",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for HAPPY_HOUR event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.run_event(EVT.TYPE.HAPPY_HOUR)
						ActiveMenuNode.unlock(),
				},
				{
					"title": "MYSTERY MEAT 1",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for MYSTERY_MEAT event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.run_event(EVT.TYPE.MYSTERY_MEAT_1)
						ActiveMenuNode.unlock(),
				},
				{
					"title": "MYSTERY MEAT 2",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for MYSTERY_MEAT event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.run_event(EVT.TYPE.MYSTERY_MEAT_2)
						ActiveMenuNode.unlock(),
				},
				{
					"title": "MYSTERY MEAT 3",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for MYSTERY_MEAT event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.run_event(EVT.TYPE.MYSTERY_MEAT_3)
						ActiveMenuNode.unlock(),
				},
				{
					"title": "FACILITY RAID 1",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for MYSTERY_MEAT event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.run_event(EVT.TYPE.FACILITY_RAID_1)
						ActiveMenuNode.unlock(),
				},
				{
					"title": "FACILITY RAID 2",
					"icon": SVGS.TYPE.CONVERSATION,
					"hint": {
						"icon": SVGS.TYPE.CONVERSATION,
						"title": "HINT",
						"description": "Test for MYSTERY_MEAT event."
					},
					"action": func() -> void:
						await ActiveMenuNode.lock()
						await GAME_UTIL.run_event(EVT.TYPE.FACILITY_RAID_2)
						ActiveMenuNode.unlock(),
				},				
			]
		},				
		{
			"title": "BASE STATES",
			"items": [
				#{
					#"title": "TOGGLE IS_POWERED",
					#"icon": SVGS.TYPE.DANGER,
					#"hint": {
						#"icon": SVGS.TYPE.CONVERSATION,
						#"title": "HINT",
						#"description": "DEBUG: toggle the IS_POWERED flag.."
					#},
					#"action": func() -> void:
						#await ActiveMenuNode.lock()
						#await GAME_UTIL.toggle_is_powered(current_location.floor)
						#ActiveMenuNode.unlock(),
				#},
				#{
					#"title": "TOGGLE IS_OVERHEATED",
					#"icon": SVGS.TYPE.DANGER,
					#"hint": {
						#"icon": SVGS.TYPE.CONVERSATION,
						#"title": "HINT",
						#"description": "DEBUG: toggle the IS_OVERHEATED flag.."
					#},
					#"action": func() -> void:
						#await ActiveMenuNode.lock()
						#await GAME_UTIL.toggle_is_overheated(current_location)
						#ActiveMenuNode.unlock(),
				#},							
				#{
					#"title": "TOGGLE VENTILATION",
					#"icon": SVGS.TYPE.DANGER,
					#"hint": {
						#"icon": SVGS.TYPE.CONVERSATION,
						#"title": "HINT",
						#"description": "DEBUG: toggle the IS_VENTILATED flag.."
					#},
					#"action": func() -> void:
						#await ActiveMenuNode.lock()
						#await GAME_UTIL.toggle_is_ventilated(current_location)
						#ActiveMenuNode.unlock(),
				#},			
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
# --------------------------------------------------------------------------------------------------s

# --------------------------------------------------------------------------------------------------
signal show_settings_complete
func show_settings() -> void:
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()
	
	var is_fullscreen_checked:Callable = func() -> bool:
		return GBL.is_fullscreen

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
#endregion

#region checkbtnstates
# --------------------------------------------------------------------------------------------------
func before_active_selection() -> void:
	await AdminModulesControls.reveal(false)

func after_active_selection() -> void:
	AdminModulesControls.reveal(true)

func before_scp_selection() -> void:
	await AdminModulesControls.reveal(false)

func after_scp_selection() -> void:
	AdminModulesControls.reveal(true)

func change_camera_viewpoint(new_viewpoint:CAMERA.VIEWPOINT) -> void:
	var WingRenderNode:Node3D = GBL.find_node(REFS.WING_RENDER)
	NametagControl.change_camera_view(new_viewpoint)
	await WingRenderNode.change_camera_view(new_viewpoint)	

func change_camera_to(type:CAMERA.TYPE) -> void:
	camera_settings.type = type
	SUBSCRIBE.camera_settings = camera_settings
	await TransistionScreen.start(0.3, true)									

func check_btn_states() -> void:
	if current_location.is_empty() or room_config.is_empty():return
	# update room details control
	var WingRenderNode:Node3D = GBL.find_node(REFS.WING_RENDER)
	var is_activated:bool = ROOM_UTIL.is_room_activated()	
	var is_scp_empty:bool = ROOM_UTIL.is_scp_empty()
	var is_room_empty:bool = ROOM_UTIL.is_room_empty()	
	var is_nuke_active:bool = ROOM_UTIL.is_nuke_active()	
	var is_ring_powered:bool = ROOM_UTIL.is_ring_powered()
	var in_lockdown:bool = ROOM_UTIL.is_floor_in_lockdown()
	var abilities:Array = ROOM_UTIL.return_room_abilities()
	var passive_abilities:Array = ROOM_UTIL.return_room_passive_abilities()
	var can_contain:bool = ROOM_UTIL.room_can_contain()
	var can_deconstruct:bool = ROOM_UTIL.room_can_deconstruct()
	var is_under_construction:bool = ROOM_UTIL.is_under_construction()
	var can_take_action:bool = (is_ring_powered and !in_lockdown)
	var lvl:int = ROOM_UTIL.get_room_lvl()
	var max_upgrade_lvl:int = ROOM_UTIL.get_room_max_level()
	var has_options:bool = !abilities.is_empty() or !passive_abilities.is_empty()
	var at_max_level:bool = lvl >= max_upgrade_lvl
	var rooms_in_wing_count:int = purchased_facility_arr.filter(func(x): 
		return x.location.floor == current_location.floor and x.location.ring == current_location.ring 
	).size()	
	var story_progress:Dictionary = GBL.active_user_profile.story_progress
	var chapter:Dictionary = STORY.get_chapter( story_progress.on_chapter )

	SummaryCard.use_location = current_location
	ModulesCard.use_location = current_location

	match current_mode:
		MODE.ROOT:
			# check for priority events and enable/disable the button
			var has_priority_events:bool = !priority_events.is_empty()
			if has_priority_events:
				var event_data:Dictionary = EVENT_UTIL.return_data(priority_events[0])				
				if event_data.has("btn"):
					var event_btn_data:Dictionary = event_data.btn
					HasEventBtn.title = event_btn_data.title
					HasEventBtn.is_disabled = event_btn_data.is_disabled_check.call() if event_btn_data.has("is_disabled_check") else !is_ring_powered

			# show only starting/info if new game
			HasEventBtn.show() if has_priority_events else HasEventBtn.hide()
			EndTurnBtn.is_disabled = has_priority_events
			
			# info button
			IntelBtn.show() if !has_priority_events else IntelBtn.hide()
			

			# TODO: this is going to become a function of a room, so it doesn't need its own button.  
			FabricationBtn.show() if !has_priority_events else FabricationBtn.hide()
			FabricationBtn.is_disabled = !is_ring_powered
			#FabricationBtn.title = "BLUEPRINT" #if rooms_in_wing_count == 0 else "FABRICATION"
			
			FabricationBtn.onClick = func() -> void:
				await lock_actions(true)
				current_mode = MODE.FABRICATION
			
			# need engineering department before you can use this 
			AdminBtn.show() if (ROOM_UTIL.owns(ROOM.REF.ADMIN_DEPARTMENT) or ROOM_UTIL.owns(ROOM.REF.ADMIN_OFFICE)) and !has_priority_events else AdminBtn.hide()
			AdminBtn.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.ADMIN_DEPARTMENT)
						
			EngineeringBtn.show() if ROOM_UTIL.owns(ROOM.REF.ENGINEERING_DEPARTMENT) and !has_priority_events else EngineeringBtn.hide()
			EngineeringBtn.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.ENGINEERING_DEPARTMENT)
			
			LogisticsBtn.show() if ROOM_UTIL.owns(ROOM.REF.LOGISTICS_DEPARTMENT) and !has_priority_events else LogisticsBtn.hide()
			LogisticsBtn.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.LOGISTICS_DEPARTMENT)

			ScienceBtn.show() if ROOM_UTIL.owns(ROOM.REF.SCIENCE_DEPARTMENT) and !has_priority_events else ScienceBtn.hide()
			ScienceBtn.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.SCIENCE_DEPARTMENT)
			
			MedicalBtn.show() if ROOM_UTIL.owns(ROOM.REF.MEDICAL_DEPARTMENT) and !has_priority_events else MedicalBtn.hide()
			MedicalBtn.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.MEDICAL_DEPARTMENT)			
			
			SecurityBtn.show() if ROOM_UTIL.owns(ROOM.REF.SECURITY_DEPARTMENT) and !has_priority_events else SecurityBtn.hide()
			SecurityBtn.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.SECURITY_DEPARTMENT)
			
			EthicsBtn.show() if ROOM_UTIL.owns(ROOM.REF.ETHICS_DEPARTMENT) and !has_priority_events else EthicsBtn.hide()
			EthicsBtn.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.ETHICS_DEPARTMENT)
						
			#OperationsBtn.hide()
			DebugBtn.show() if DEBUG.get_val(DEBUG.GAMEPLAY_SHOW_DEBUG_MENU) else DebugBtn.hide()
			
			# end button 
			var end_btn_is_flashing:bool = false
			for btn in [AdminBtn, EngineeringBtn, LogisticsBtn, ScienceBtn, MedicalBtn, SecurityBtn, EthicsBtn]:
				if btn.is_visible_in_tree() and btn.is_disabled:
					end_btn_is_flashing = true 
					break
			EndTurnBtn.is_flashing = end_btn_is_flashing
		# -----------	
		MODE.ADMINISTRATION_MODULES:
			AdminModulesControls.reveal(true)

			AdminModulesControls.itemlist = ModulesCard.get_ability_btns()
			AdminModulesControls.item_index = 0							
			AdminModulesControls.directional_pref = "UD"
			AdminModulesControls.offset = ModulesCard.global_position
			
			AdminModulesControls.onBack = func() -> void:
				ModulesCard.deselect_btns()
				await AdminModulesControls.reveal(false)
				current_mode = MODE.ADMINISTRATION
		
			AdminModulesControls.onUpdate = func(node:Control) -> void:
				for _node in AdminModulesControls.itemlist:
					_node.is_selected = _node == node
					
				AdminModulesControls.onAction = func() -> void:pass
				AdminModulesControls.hide_c_btn = true
				AdminModulesControls.disable_active_btn = false
				
				AdminModulesControls.disable_active_btn = node.ref_data.is_disabled
				# ----------------------
				match node.ref_data.type:
					"scp":						
						AdminModulesControls.a_btn_title = "SELECT SCP" if node.ref_data.data.is_empty() else "FULL"
						AdminModulesControls.disable_active_btn = !node.ref_data.data.is_empty()
						
					"active_ability":
						AdminModulesControls.a_btn_title = "USE PROGRAM"
						AdminModulesControls.disable_active_btn = node.ref_data.is_disabled
					# ----------------------
					"passive_ability":
						AdminModulesControls.a_btn_title = "UNAVAILABLE" if node.ref_data.is_disabled else "TOGGLE" 
						AdminModulesControls.disable_active_btn = node.ref_data.is_disabled
					# ----------------------
		# -----------	
		MODE.ADMINISTRATION:
			AdminControls.disable_active_btn = is_room_empty
			AdminControls.a_btn_title = "MODULES" #if has_options else "NO ABILITIES"
			AdminControls.reveal(true)
			
			AdminControls.onAction = func() -> void:
				await AdminControls.reveal(false)
				current_mode = MODE.ADMINISTRATION_MODULES

			AdminControls.onCBtn = func() -> void:
				await AdminControls.reveal(false)				
				await show_programs([ROOM.CATEGORY.ADMIN_LINKABLE], "ADMIN PROGRAMS")
				AdminControls.reveal(true)

			AdminControls.onBack = func() -> void:
				await AdminControls.reveal(false)
				lock_actions(false)
				current_mode = MODE.ROOT
		# -----------	
		MODE.SECURITY:
			SecurityControls.reveal(true)
			SecurityControls.disable_active_btn = is_room_empty
			
			SecurityControls.onAction = func() -> void:
				await SecurityControls.reveal(false)
				GAME_UTIL.toggle_lockdown(false)
				await U.set_timeout(1.0)
				SecurityControls.reveal(true)
			
			SecurityControls.onCBtn = func() -> void:
				await SecurityControls.reveal(false)				
				await show_programs([ROOM.CATEGORY.SECURITY_LINKABLE], "SECURITY PROGRAMS")
				SecurityControls.reveal(true)

			SecurityControls.onBack = func() -> void:
				await SecurityControls.reveal(false)
				lock_actions(false)
				current_mode = MODE.ROOT
		# -----------
		MODE.SCIENCE:
			ScienceControls.reveal(true)
			ScienceControls.disable_active_btn = false #is_room_empty or !is_activated or at_max_level
			
			ScienceControls.onAction = func() -> void:
				await ScienceControls.reveal(false)				
				var confirm:bool = await GAME_UTIL.open_store()
				if confirm:
					await U.tick()
					on_current_location_update()	
				ScienceControls.reveal(true)			
			
			ScienceControls.onCBtn = func() -> void:
				await ScienceControls.reveal(false)				
				await show_programs([ROOM.CATEGORY.SCIENCE_LINKABLE], "SCIENCE PROGRAMS")			
				ScienceControls.reveal(true)

			ScienceControls.onBack = func() -> void:
				await ScienceControls.reveal(false)
				lock_actions(false)
				current_mode = MODE.ROOT
		# -----------
		MODE.MEDICAL:
			MedicalControls.reveal(true)
			
			MedicalControls.onAction = func() -> void:
				await MedicalControls.reveal(false)
				change_camera_to(CAMERA.TYPE.FLOOR_SELECT)
				current_mode = MODE.MEDICAL_OVERVIEW
				
			MedicalControls.onCBtn = func() -> void:
				await MedicalControls.reveal(false)
				await show_programs([ROOM.CATEGORY.MEDICAL_LINKABLE], "MEDICAL PROGRAMS")
				MedicalControls.reveal(true)
				
			MedicalControls.onBack = func() -> void:
				await MedicalControls.reveal(false)
				lock_actions(false)
				current_mode = MODE.ROOT
		# -----------
		MODE.MEDICAL_OVERVIEW:
			MedicalOverviewControls.onBack = func() -> void:
				reveal_medical(false)
				await MedicalOverviewControls.reveal(false)				
				change_camera_to(CAMERA.TYPE.WING_SELECT)
				current_mode = MODE.MEDICAL
		# -----------
		MODE.INTEL:
			var list:Array = GAME_UTIL.get_pending_events_list()
			var has_event_here:bool = false
			IntelControls.a_btn_title = "INVESTIGATE ANAMOLLY" if has_event_here else "NO ANAMOLLIES"
			IntelControls.disable_active_btn = !has_event_here
			IntelControls.reveal(true)
			
			IntelControls.onAction = func() -> void:				
				IntelControls.reveal(false)
				reveal_actionpanel_label(false)
				reveal_actionpanel_image(false)
				reveal_summarycard(false)
				reveal_telemetry(false)
				TransistionScreen.start(0.5, true)
				await change_camera_viewpoint(CAMERA.VIEWPOINT.DRAMATIC_ZOOM)
				
				
				# get triggerable event
				var event_ref:int = base_states.room[U.location_to_designation(current_location)].events_pending[0]
				# remove from base_state
				GAME_UTIL.remove_room_event_at_index(0)
				#trigger event
				await GAME_UTIL.run_event(event_ref)
				change_camera_viewpoint(CAMERA.VIEWPOINT.DISTANCE)
				
				
				reveal_telemetry(true)
				reveal_summarycard(true, false)
				await TransistionScreen.start(0.5, true)
				IntelControls.reveal(true)
				
			# logic to jump to the next anamolly
				#current_location
				#var list:Array = GAME_UTIL.get_pending_events_list()
				#telemetry_count = U.min_max(telemetry_count + 1, 0, list.size() - 1, true)
				#var next_item:Dictionary = list[telemetry_count]
				#SUBSCRIBE.current_location = next_item.location			
			
			IntelControls.onCBtn = func() -> void:
				await IntelControls.reveal(false)
				change_camera_to(CAMERA.TYPE.FLOOR_SELECT)
				current_mode = MODE.INTEL_OVERSIGHT

			IntelControls.onBack = func() -> void:
				reveal_telemetry(false)
				reveal_summarycard(false)
				await IntelControls.reveal(false)
				current_mode = MODE.ROOT
		# -----------
		MODE.INTEL_OVERSIGHT:
			IntelOverviewControls.reveal(true)

			IntelOverviewControls.onBack = func() -> void:
				await IntelOverviewControls.reveal(false)
				change_camera_to(CAMERA.TYPE.WING_SELECT)
				current_mode = MODE.INTEL
		# -----------	
		MODE.FABRICATION:	
			FabricationControls.a_btn_title = "RUSH" if is_under_construction else "BUILD HERE"
			FabricationControls.disable_active_btn = !is_under_construction and !is_room_empty
			FabricationControls.c_btn_title = "REMOVE or RECYCLE"
			FabricationControls.hide_c_btn = false			
			FabricationControls.reveal(true)
			
			# remove room
			FabricationControls.onCBtn = func() -> void:
				await FabricationControls.reveal(false)
				var confirm:bool
				if is_under_construction:
					confirm = await ROOM_UTIL.cancel_construction(current_location)
				else:
					confirm = await ROOM_UTIL.reset_room(current_location)
				
				if confirm:
					await U.tick()
					on_current_location_update()
				FabricationControls.reveal(true)
			
			FabricationControls.onAction = func() -> void:
				await FabricationControls.reveal(false)
				if is_room_empty or (!is_room_empty and !is_under_construction):
					await show_fabrication_options()
					FabricationControls.reveal(true)
					reveal_summarycard(true, false)
					return
			
				var confirm:bool = await GAME_UTIL.rush_construction_room()
				if confirm:
					on_current_location_update()
				FabricationControls.reveal(true)
						
			FabricationControls.onBack = func() -> void:
				reveal_blueprint(false)
				WingRenderNode.set_to_build_mode(false)	
				await FabricationControls.reveal(false)
				await U.set_timeout(0.5)
				current_mode = MODE.ROOT
		# -----------	
		MODE.ENGINEERING:
			EngineeringControls.reveal(true)
			
			EngineeringControls.onAction = func() -> void:		
				await EngineeringControls.reveal(false)
				current_mode = MODE.ENGINEERING_CONFIG
				
			EngineeringControls.onCBtn = func() -> void:		
				await EngineeringControls.reveal(false)
				await show_programs([ROOM.CATEGORY.ENGINEERING_LINKABLE], "ENGINEERING PROGRAMS")
				EngineeringControls.reveal(true)

			EngineeringControls.onBack = func() -> void:
				await EngineeringControls.reveal(false)
				current_mode = MODE.ROOT
		# -----------	
		MODE.LOGISTICS:
			LogisticsControls.reveal(true)
			LogisticsControls.disable_active_btn = is_room_empty or !is_activated or at_max_level
			
			LogisticsControls.onAction = func() -> void:		
				await LogisticsControls.reveal(false)
				await GAME_UTIL.upgrade_facility() 
				LogisticsControls.reveal(true)
				
			LogisticsControls.onCBtn = func() -> void:		
				await LogisticsControls.reveal(false)
				await show_programs([ROOM.CATEGORY.LOGISTICS_LINKABLE], "LOGISTICS PROGRAMS")
				LogisticsControls.reveal(true)

			LogisticsControls.onBack = func() -> void:
				await LogisticsControls.reveal(false)
				current_mode = MODE.ROOT
		# -----------	
		MODE.ETHICS:
			EthicsControls.reveal(true)	
			EthicsControls.onAction = func() -> void:		
				await EthicsControls.reveal(false)
				await U.set_timeout(1.0)
				EthicsControls.reveal(true)
				
			EthicsControls.onCBtn = func() -> void:		
				await EthicsControls.reveal(false)
				await show_programs([ROOM.CATEGORY.ETHICS_LINKABLE], "ETHICS PROGRAMS")
				EthicsControls.reveal(true)

			EthicsControls.onBack = func() -> void:
				await EthicsControls.reveal(false)
				current_mode = MODE.ROOT				
		# -----------	
		MODE.ENGINEERING_CONFIG:
			EngineeringConfigControls.reveal(true)
			
			EngineeringConfigControls.onBack = func() -> void:
				reveal_engineering(false)
				EngineeringConfigControls.reveal(false)
				GameplayNode.restore_player_hud()
				GBL.find_node(REFS.WING_RENDER).set_engineering_mode(false)
				current_mode = MODE.ENGINEERING
		# -----------	
		MODE.FABRICATION_LINKABLE:
			FabricationControls.a_btn_title = "BUILD HERE"
			FabricationControls.disable_active_btn = !is_room_empty or (current_location.room not in list_of_adjacent_rooms)
			
			FabricationControls.onAction = func() -> void:
				await FabricationControls.reveal(false)
				linkable_action.emit(true)
				
			FabricationControls.onBack = func() -> void:
				await FabricationControls.reveal(false)
				linkable_action.emit(false)
		# -----------
		MODE.CONTAIN:
			ContainControls.reveal(true)
			ContainControls.a_btn_title = "CONTAIN" if is_scp_empty else "ALREADY OCCUPIED"
			ContainControls.disable_active_btn = !can_contain or !is_scp_empty			
			
			ContainControls.onAction = func() -> void:
				current_mode = MODE.NO_INPUT
				await ContainControls.reveal(false)
				var selected_scp:int = await GAME_UTIL.select_scp()
				if selected_scp != -1:
					GAME_UTIL.trigger_initial_containment_event(selected_scp)
					
				current_mode = MODE.CONTAIN
			
			ContainControls.onBack = func() -> void:
				await ContainControls.reveal(false)
				current_mode = MODE.ROOT
		# -----------
		MODE.INFO:
			InfoControls.reveal(true)
			
			InfoControls.onAction = func() -> void:
				await InfoControls.reveal(false)
				await GAME_UTIL.open_objectives()
				InfoControls.reveal(true)
				
			InfoControls.onCBtn = func() -> void:
				await InfoControls.reveal(false)
				await GAME_UTIL.play_tutorial(chapter)
				InfoControls.reveal(true)					
				
			InfoControls.onBack = func() -> void:
				GameplayNode.TimelineContainer.show_details( false ) 
				await InfoControls.reveal(false)
				current_mode = MODE.ROOT			
# --------------------------------------------------------------------------------------------------
#endregion

#region reveals
# --------------------------------------------------------------------------------------------------	
func reveal_new_message(state:bool) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	NewMessageBtn.show()	if state else NewMessageBtn.hide()
	await reveal_notification(state)	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------				
func clear_lines() -> void:
	GBL.find_node(REFS.LINE_DRAW).clear()
	prev_draw_state = {}			
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------
func set_backdrop_state(state:bool) -> void:	
	await U.tween_node_property(Backdrop, 'color', Color(0, 0, 0, 0.7 if state else 0.0))	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func reveal_actionpanel_label(state:bool, duration:float = 0.3, title:String = "") -> void:
	var ActionPanel:Control = GBL.find_node(REFS.RENDERING).ActionPanel
	ActionPanel.title = title
	await ActionPanel.reveal(state)
	
	if !state:
		ActionPanel.title = ""


func reveal_actionpanel_image(state:bool, duration:float = 0.3, img_src:String = "", remove_before_clear:bool = false) -> void:
	var ActionPanel:Control = GBL.find_node(REFS.RENDERING).ActionPanel
	
	if state or remove_before_clear:
		ActionPanel.img_src = img_src
		
	await ActionPanel.reveal_image(state)
	
	
	
	if !state:
		ActionPanel.img_src = "" 
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
	if state:
		ModulesPanel.show()
		SummaryPanel.show()
	
	if show_modules:
		U.tween_node_property(ModulesPanel, "position:x", control_pos[ModulesPanel].show if state else control_pos[ModulesPanel].hide, duration)
	else:
		ModulesPanel.position.x = control_pos[ModulesPanel].hide
		
	await U.tween_node_property(SummaryPanel, "position:x", control_pos[SummaryPanel].show if state else control_pos[SummaryPanel].hide, duration)
	
	if !state:
		ModulesPanel.hide()
		SummaryPanel.hide()	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_engineering(state:bool, duration:float = 0.3) -> void:
	if !is_node_ready():return
		
	if state:
		EngineeringPanel.show()
		
		
	await U.tween_node_property(EngineeringPanel, "position:x", control_pos[EngineeringPanel].show if state else control_pos[EngineeringPanel].hide, duration)
	
	if !state:
		EngineeringPanel.hide()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_medical(state:bool, duration:float = 0.3) -> void:
	if !is_node_ready():return
	
	if state:
		TopographyPanel.show()
	
	if !state:	
		await TopographyComponent.end()
	
	await U.tween_node_property(TopographyPanel, "position:x", control_pos[TopographyPanel].show if state else control_pos[TopographyPanel].hide, duration)
	
	if state:
		await TopographyComponent.start()
	
	if !state:
		TopographyPanel.hide()		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_telemetry(state:bool, duration:float = 0.3) -> void:
	if !is_node_ready():return

	if state:
		TelemetryPanel.show()
	
	if !state:	
		await TelemetryComponent.end()
	
	await U.tween_node_property(TelemetryPanel, "position:x", control_pos[TelemetryPanel].show if state else control_pos[TelemetryPanel].hide, duration)
	
	if state:
		await TelemetryComponent.start()
	
	if !state:
		TelemetryPanel.hide()		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func reveal_blueprint(state:bool, duration:float = 0.3) -> void:
	if !is_node_ready():return
	
	if state:
		BlueprintComponent.start()
		BlueprintPanel.show()
	
	await U.tween_node_property(BlueprintPanel, "position:y", control_pos[BlueprintPanel].show if state else control_pos[BlueprintPanel].hide, duration)
	
	if !state:
		BlueprintComponent.end()
		BlueprintPanel.hide()		
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
#endregion

#region on_X_updates
# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos(true)

func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return

func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	U.debounce(str(self, "_check_btn_states"), check_btn_states)

func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	U.debounce(str(self, "_check_btn_states"), check_btn_states)

func on_base_states_update(new_val:Dictionary) -> void:
	base_states = new_val
	if !is_node_ready() or base_states.is_empty():return
	var pending_events_count:int = GAME_UTIL.get_pending_events_count()
	IntelBtn.is_flashing = pending_events_count > 0

func on_gameplay_conditionals_update(new_val:Dictionary) -> void:
	if !is_node_ready() or new_val.is_empty():return	
	IntelBtn.show() if new_val[CONDITIONALS.TYPE.SHOW_INFO_BTN] else IntelBtn.hide()
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
			MODE.ROOT:
				#NametagControl.show()
				LocationAndDirectivesContainer.reveal(true)
				RenderingNode.set_shader_strength(0)
				LocationAndDirectivesContainer.reveal(true)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = true
				
				reveal_actionpanel_label(false)			
				reveal_actionpanel_image(false)
				change_camera_viewpoint(CAMERA.VIEWPOINT.ANGLE_NEAR)
				lock_actions(false)
				set_backdrop_state(false)
				reveal_summarycard(false, false)
				# recenter...
				SUBSCRIBE.current_location =  {"floor": current_location.floor, "ring": current_location.ring, "room": 4}
			# --------------
			MODE.EVENT_BTN_TRIGGER:
				reveal_actionpanel_image(false)
				reveal_summarycard(false)
				reveal_telemetry(false)
				TransistionScreen.start(0.5, true)
				await change_camera_viewpoint(CAMERA.VIEWPOINT.DRAMATIC_ZOOM)
				
				#trigger event
				await GAME_UTIL.run_event( 	priority_events[0] )
				priority_events.remove_at(0)
				SUBSCRIBE.priority_events = priority_events				
				change_camera_viewpoint(CAMERA.VIEWPOINT.DISTANCE)
				TransistionScreen.start(0.5, true)
				current_mode = MODE.ROOT
			# --------------
			MODE.ADMINISTRATION:
				# NameControl.hide()
				LocationAndDirectivesContainer.reveal(false)
				RenderingNode.set_shader_strength(1)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false
				
				change_camera_viewpoint(CAMERA.VIEWPOINT.DISTANCE)
				reveal_summarycard(true, true)
				reveal_actionpanel_label(true, 0.4, "ADMINISTRATIVE")
				reveal_actionpanel_image(true, 0.4, portrait_img_src[PORTRAIT.ADMIN])
		
			# --------------
			MODE.ADMINISTRATION_MODULES:
				# NameControl.hide()
				LocationAndDirectivesContainer.reveal(false)
				RenderingNode.set_shader_strength(0)
				
				change_camera_viewpoint(CAMERA.VIEWPOINT.DISTANCE)
			# -------------
			MODE.INTEL:
				LocationAndDirectivesContainer.reveal(false)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false
				
				change_camera_viewpoint(CAMERA.VIEWPOINT.DISTANCE)
				reveal_summarycard(true, false)
				reveal_telemetry(true)
				reveal_actionpanel_label(true, 0.4, "INTEL")
				reveal_actionpanel_image(true, 0.4, portrait_img_src[PORTRAIT.ENGINEER])				
			# -------------	
			MODE.INTEL_OVERSIGHT:
				reveal_summarycard(false)
			# --------------
			MODE.FABRICATION:
				LocationAndDirectivesContainer.reveal(false)
				WingRenderNode.set_to_build_mode(true)
				RenderingNode.set_shader_strength(1)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false	
				
				change_camera_viewpoint(CAMERA.VIEWPOINT.OVERHEAD)				
				reveal_summarycard(true, false)
				reveal_blueprint(true)
				reveal_actionpanel_label(true, 0.4, "BLUEPRINTS")
				reveal_actionpanel_image(true, 0.4, portrait_img_src[PORTRAIT.ENGINEER])
			# --------------
			MODE.ENGINEERING:
				LocationAndDirectivesContainer.reveal(true)
				RenderingNode.set_shader_strength(1)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false	
				
				change_camera_viewpoint(CAMERA.VIEWPOINT.DISTANCE)
				reveal_actionpanel_label(true, 0.4, "ENGINEERING")
				reveal_actionpanel_image(true, 0.4, portrait_img_src[PORTRAIT.ENGINEER])				
			# --------------
			MODE.ETHICS:
				LocationAndDirectivesContainer.reveal(true)
				RenderingNode.set_shader_strength(1)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false	
				
				change_camera_viewpoint(CAMERA.VIEWPOINT.DISTANCE)
				reveal_actionpanel_label(true, 0.4, "ETHICS")
				reveal_actionpanel_image(true, 0.4, portrait_img_src[PORTRAIT.ADMIN])				
			# --------------
			MODE.LOGISTICS:
				# NameControl.hide()
				LocationAndDirectivesContainer.reveal(true)
				RenderingNode.set_shader_strength(1)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false	
				
				change_camera_viewpoint(CAMERA.VIEWPOINT.DISTANCE)
				reveal_actionpanel_label(true, 0.4, "LOGISTICS")
				reveal_actionpanel_image(true, 0.4, portrait_img_src[PORTRAIT.ADMIN])				
			# --------------
			MODE.ENGINEERING_CONFIG:
				LocationAndDirectivesContainer.reveal(false)
				GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer])	
				RenderingNode.set_engineering_mode(true)
				
				reveal_actionpanel_label(false)
				reveal_engineering(true)
				change_camera_viewpoint(CAMERA.VIEWPOINT.ANGLE_NEAR)
				change_camera_viewpoint(CAMERA.VIEWPOINT.SHIFT_RIGHT)
			# --------------
			MODE.SECURITY:
				LocationAndDirectivesContainer.reveal(false)
				RenderingNode.set_shader_strength(1)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false	
				
				change_camera_viewpoint(CAMERA.VIEWPOINT.DISTANCE)
				reveal_summarycard(true, false)
				reveal_actionpanel_label(true, 0.4, "SECURITY")
				reveal_actionpanel_image(true, 0.4, portrait_img_src[PORTRAIT.SECURITY])								
			# -----------	
			MODE.SCIENCE:
				LocationAndDirectivesContainer.reveal(false)
				RenderingNode.set_shader_strength(1)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false	
				
				change_camera_viewpoint(CAMERA.VIEWPOINT.DISTANCE)
				reveal_actionpanel_label(true, 0.4, "RESEARCH")
				reveal_actionpanel_image(true, 0.4, portrait_img_src[PORTRAIT.ENGINEER])								
			# -----------	
			MODE.MEDICAL:
				LocationAndDirectivesContainer.reveal(false)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false
				
				change_camera_viewpoint(CAMERA.VIEWPOINT.DISTANCE)
				reveal_actionpanel_label(true, 0.4, "MEDICAL")
				reveal_actionpanel_image(true, 0.4, portrait_img_src[PORTRAIT.ENGINEER])
			# -----------	
			MODE.MEDICAL_OVERVIEW:
				change_camera_to(CAMERA.TYPE.FLOOR_SELECT)
				reveal_medical(true)
				
				MedicalOverviewControls.reveal(true)
			# -----------	
			MODE.INFO:				
				LocationAndDirectivesContainer.reveal(false)
				GameplayNode.TimelineContainer.show_details( true ) 
				GameplayNode.show_marked_objectives = true
				GameplayNode.show_timeline = true
				
				set_backdrop_state(true)
			# -----------	
			MODE.CONTAIN:
				RenderingNode.set_shader_strength(1)
				GameplayNode.TimelineContainer.show_details( true ) 
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false
				
				change_camera_viewpoint(CAMERA.VIEWPOINT.DISTANCE)				
			# -----------	
			MODE.ACTIVE_MENU_OPEN:
				LocationAndDirectivesContainer.reveal(false)
				GameplayNode.show_marked_objectives = false
				GameplayNode.show_timeline = false
				
				set_backdrop_state(true)

				

		on_current_location_update()
		on_camera_settings_update()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:	
	if !is_node_ready() or !is_visible_in_tree() or GBL.has_animation_in_queue() or current_location.is_empty() or camera_settings.is_empty() or room_config.is_empty() or !is_started or is_in_transition or active_menu_is_open:return	
	var key:String = input_data.key
		

	match current_mode:
		# ----------------------------		
		MODE.ADMINISTRATION_MODULES:
			pass
		MODE.ENGINEERING_CONFIG:
			pass
		MODE.EVENT_BTN_TRIGGER:
			pass
		MODE.NO_INPUT:
			pass
		# ----------------------------		
		MODE.ROOT:
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
		MODE.ETHICS:
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
		MODE.MEDICAL:
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
		MODE.MEDICAL_OVERVIEW:
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
		MODE.INTEL_OVERSIGHT:
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
		MODE.SECURITY:
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
		MODE.SCIENCE:
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
		MODE.ENGINEERING:
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
		MODE.FABRICATION:
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
		# ----------------------------
		MODE.FABRICATION_LINKABLE:
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
		# ----------------------------		
		_:
			match key:
				# ----------------------------
				"W":
					U.room_up(true, false)
				# ----------------------------
				"S":
					U.room_down(true, false)
				# ----------------------------
				"D":
					U.room_right(true, false)
				# ----------------------------
				"A":
					U.room_left(true, false)
		
#endregion
