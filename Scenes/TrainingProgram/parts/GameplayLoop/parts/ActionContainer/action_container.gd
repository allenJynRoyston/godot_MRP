extends GameContainer

@onready var RootPanel:PanelContainer = $"."
@onready var MainPanel:MarginContainer = $BtnControl/MarginContainer
@onready var ActiveMenu:PanelContainer = $Control/ActiveMenu
@onready var Details:Control = $Details
@onready var DetailsPanel:PanelContainer = $Details/PanelContainer

@onready var Researchers:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/Researchers
@onready var ResearcherCount:Label = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/Researchers/HBoxContainer/ResearcherCount
@onready var ResearcherList:VBoxContainer = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/Researchers/ResearcherList
@onready var TraitContainer:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/TraitContainer
@onready var TraitList:VBoxContainer = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/TraitContainer/VBoxContainer/TraitList
@onready var SynergyContainer:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/SynergyContainer
@onready var SynergyTraitList:VBoxContainer = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/SynergyContainer/SynergyTraitList

@onready var ScpMiniCard:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/Room/ScpMiniCard
@onready var RoomMiniCard:Control = $Details/PanelContainer/MarginContainer/VBoxContainer/RoomAndResearchers/Room/RoomMiniCard


@onready var LeftSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var Backdrop:ColorRect = $Backdrop

const KeyBtnPreload:PackedScene = preload("res://UI/Buttons/KeyBtn/KeyBtn.tscn")
const ResearcherMiniCard:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ResearcherMiniCard/ResearcherMiniCard.tscn")
const TraitCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/TRAIT/TraitCard.tscn")

var disable_inputs_while_menu_is_open:bool = false
var previous_camera_type:int

var ref_btn:Control
var left_btn_list:Array = [] 
var right_btn_list:Array = []
var is_setup:bool = false

var control_pos:Dictionary
var restore_pos:int
var details_restore_pos:int
var traits_restore_pos:int

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.ACTION_CONTAINER, self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.ACTION_CONTAINER)
	
func _ready() -> void:
	super._ready()
	
	Details.modulate = Color(1, 1, 1, 0)
	
	for child in [RightSideBtnList, LeftSideBtnList, ResearcherList, SynergyTraitList, TraitList]:
		for node in child.get_children():
			node.queue_free()	
	
	await U.set_timeout(1.0)	
	restore_pos = MainPanel.position.y		
	details_restore_pos = DetailsPanel.position.y
	control_pos[LeftSideBtnList] = {"global": LeftSideBtnList.global_position.y, "show": LeftSideBtnList.position.y, "hide": LeftSideBtnList.position.y + LeftSideBtnList.size.y}

	U.tween_node_property(DetailsPanel, "position:y", details_restore_pos - DetailsPanel.size.y)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func toggle_camera_view() -> void:
	set_btn_disabled_state(true)
	
	is_showing = false
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			camera_settings.type = CAMERA.TYPE.ROOM_SELECT
		CAMERA.TYPE.ROOM_SELECT:
			camera_settings.type = CAMERA.TYPE.FLOOR_SELECT
	
	#GameplayNode.restore_player_hud()
	SUBSCRIBE.camera_settings = camera_settings	
	
	await U.set_timeout(0.2)
	set_btn_disabled_state(false)
	is_showing = true
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_is_showing_update() -> void:	
	super.on_is_showing_update()
	if !is_setup:return	
	U.tween_node_property(MainPanel, "position:y", restore_pos if is_showing else MainPanel.size.y + 20, 0.7)
	await U.set_timeout(1.0)
	MainPanel.set_anchors_preset(Control.PRESET_FULL_RECT)	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func get_menu_y_pos() -> int:
	return control_pos[LeftSideBtnList].global - ActiveMenu.size.y - LeftSideBtnList.size.y - 10	
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func show_details() -> void:
	# update room_extract
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)	
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var options_list := []
	var is_room_empty:bool = room_extract.is_room_empty
	var is_activated:bool = room_extract.is_activated
	var abilities:Array = [] if is_room_empty else room_extract.room.abilities
	var passive_abilities:Array = [] if is_room_empty else room_extract.room.passive_abilities
	var ap_val:int = 0 if is_room_empty else room_extract.room.ap
	var ap_charge_val:int = 0 if is_room_empty else room_extract.room.ap_diff
	var upgrade_level:int = 0 if is_room_empty else room_extract.room.upgrade_level
	var available_upgrade_levels:int = gameplay_conditionals[CONDITIONALS.TYPE.UPGRADE_LEVEL]

	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
		
	# clear list
	for child in [TraitList, SynergyTraitList, ResearcherList]:
		for item in child.get_children():
			item.queue_free()
				
	# animate in/out
	Details.modulate = Color(1, 1, 1, 1)
	U.tween_node_property(DetailsPanel, "position:y", details_restore_pos)	

	# setup cloes behavior
	ActiveMenu.onClose = func() -> void:
		await U.tween_node_property(DetailsPanel, "position:y", details_restore_pos - DetailsPanel.size.y)
		GameplayNode.restore_player_hud()
		set_btn_disabled_state(false)
		for child in ResearcherList.get_children():
			child.queue_free()

	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
	})
	
	if !is_room_empty and is_activated:
		# ----------------------- PASSIVE ABILITIES
		for n in passive_abilities.size():
			var ability:Dictionary = passive_abilities[n]
			var can_use:bool = upgrade_level >= ability.available_at_lvl
			var enough_ap_to_use:bool = ap_charge_val < ability.ap_cost				
			if available_upgrade_levels >= n:
				options_list.push_back({
					"title": "%s %s" % [ability.name, "" if !enough_ap_to_use else ""] if can_use else "[UPGRADE AVAILABLE]",
					"is_disabled": (ap_charge_val < ability.ap_cost and n not in base_states.room[U.location_to_designation(current_location)].passives_enabled) or !can_use,
					"cost": ability.ap_cost if can_use else -1,
					"is_togglable": true,
					"is_checked": n in base_states.room[U.location_to_designation(current_location)].passives_enabled,
					"onSelect": func() -> void:
						if n not in base_states.room[U.location_to_designation(current_location)].passives_enabled:
							base_states.room[U.location_to_designation(current_location)].passives_enabled.push_back(n)
						else:
							base_states.room[U.location_to_designation(current_location)].passives_enabled.erase(n)
						# updates toggle state in the base states
						SUBSCRIBE.base_states = base_states
						# rerenders the menu
						await U.tick()
						show_details()
				})
		# ----------------------- ACTIVE ABILITIES
		for n in abilities.size():
			var ability:Dictionary = abilities[n]
			var can_use:bool = upgrade_level >= ability.available_at_lvl
			var enough_ap_to_use:bool = ap_val < ability.ap_cost
			if available_upgrade_levels >= n:
				options_list.push_back({
					"title": "%s %s" % [ability.name, "" if !enough_ap_to_use else ""] if can_use else "%s [UPGRADE REQUIRED]" % [ability.name],
					"is_disabled": ap_val < ability.ap_cost or !can_use,
					"cost": ability.ap_cost if can_use else -1,
					"onSelect": func() -> void:				
						U.tween_node_property(DetailsPanel, "position:y", details_restore_pos - DetailsPanel.size.y)
						ActiveMenu.freeze_inputs = true	
						if "effect" in ability:
							var response:bool = await ability.effect.call(GameplayNode)
							if response:
								base_states.room[U.location_to_designation(current_location)].ap -= ability.ap_cost
								SUBSCRIBE.base_states = base_states
						U.tween_node_property(DetailsPanel, "position:y", details_restore_pos)
						ActiveMenu.freeze_inputs = false
						show_details(),
				})

	# ROOM DETAILS	
	RoomMiniCard.is_activated = is_activated
	RoomMiniCard.is_room_under_construction = room_extract.is_room_under_construction	
	RoomMiniCard.ref = room_extract.room.details.ref if !is_room_empty else -1

	#
	# SCP DETAILS
	if !room_extract.scp.is_empty():
		ScpMiniCard.ref = room_extract.scp.details.ref
	ScpMiniCard.show() if !room_extract.scp.is_empty() else ScpMiniCard.hide()
	
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
	
	
	GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer])
	
	ActiveMenu.ap_charge_val = ap_charge_val
	ActiveMenu.level = upgrade_level
	ActiveMenu.ap_val = ap_val
	ActiveMenu.show_ap = abilities.size() > 0 and is_activated
	ActiveMenu.show_ap_charge = passive_abilities.size() > 0 and is_activated
	ActiveMenu.header = "EMPTY" if is_room_empty else "%s" % [room_extract.room.details.name]
	ActiveMenu.use_color = Color(1, 0.745, 0.381)
	ActiveMenu.options_list = options_list
	await U.tick()
	ActiveMenu.size = Vector2(1, 1)
	ActiveMenu.custom_minimum_size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	ActiveMenu.open()
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------		
func open_scp_details() -> void:
	# setup cloes behavior
	ActiveMenu.onClose = func() -> void:	
		GBL.find_node(REFS.ROOM_NODES).is_active = false	
		set_btn_disabled_state(false)
	
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
	ActiveMenu.custom_minimum_size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	ActiveMenu.open()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------		
func open_room_menu() -> void:
	# pull data, create the options list
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var room_is_empty:bool = room_extract.is_room_empty
	var is_room_under_construction:bool = room_extract.is_room_under_construction
	var is_room_active:bool = room_extract.is_activated
	var can_destroy:bool = room_extract.can_destroy
	var room_category:int = room_extract.room_category
	var researchers_count:int = room_extract.researchers_count
	var is_scp_empty:bool = room_extract.is_scp_empty
	var options_list:Array = []
	
	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
			set_btn_disabled_state(false)
	})
	
	if room_is_empty:
		options_list.push_back({
			"title": "CONSTRUCT ROOM...",
			"onSelect": func() -> void:
				ActiveMenu.freeze_inputs = true				
				var response:Dictionary = await GameplayNode.construct_room()
				ActiveMenu.freeze_inputs = false				
				open_room_menu()
		})	
	
	if is_room_under_construction:
		options_list.push_back({
			"title": "CANCEL CONSTRUCTION",
			"onSelect": func() -> void:
				ActiveMenu.freeze_inputs = true			
				var response:Dictionary = await GameplayNode.cancel_construction(current_location.duplicate())
				ActiveMenu.freeze_inputs = false
				open_room_menu()
		})		

	if !room_is_empty:
		if !is_room_active:
			options_list.push_back({
				"title": "ACTIVATE ROOM",
				"onSelect": func() -> void:
					ActiveMenu.freeze_inputs = true	
					var response:Dictionary =  await GameplayNode.activate_room(current_location.duplicate(), room_extract.room.details.ref)
					ActiveMenu.freeze_inputs = false
					open_room_menu()
			})		
		else:
			options_list.push_back({
				"title": "DEACTIVATE ROOM",
				"onSelect": func() -> void:
					ActiveMenu.freeze_inputs = true	
					var response:Dictionary =  await GameplayNode.deactivate_room(current_location.duplicate(), room_extract.room.details.ref)
					ActiveMenu.freeze_inputs = false
					open_room_menu()
			})				
	
	if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_UPGRADES]:
		options_list.push_back({
			"title": "UPGRADE",
			"icon": SVGS.TYPE.UP_ARROW,
			"is_disabled": false,
			"onSelect": func() -> void:
				pass
		})
		
	
	if !room_is_empty:
		options_list.push_back({
			"title": "CANNOT DESTROY ROOM" if !is_scp_empty or !can_destroy else "DESTROY ROOM",
			"is_disabled": !is_scp_empty or !can_destroy,
			"onSelect": func() -> void:
				ActiveMenu.freeze_inputs = true	
				var response:Dictionary = await GameplayNode.reset_room(current_location.duplicate())
				ActiveMenu.freeze_inputs = false	
				open_room_menu()
		})



	# setup cloes behavior
	ActiveMenu.onClose = func() -> void:	
		GBL.find_node(REFS.ROOM_NODES).is_active = false	
		set_btn_disabled_state(false)
		GameplayNode.restore_player_hud()
		
	# make room nodes active
	GBL.find_node(REFS.ROOM_NODES).is_active = true
	
	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	GameplayNode.show_only([GameplayNode.Structure3dContainer, GameplayNode.ActionContainer])
	
	
	ActiveMenu.show_ap = false
	ActiveMenu.header = "FACILITY"
	ActiveMenu.use_color = Color(0, 0.529, 1)
	ActiveMenu.options_list = options_list
	await U.tick()
	ActiveMenu.size = Vector2(1, 1)
	ActiveMenu.custom_minimum_size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	ActiveMenu.open()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func open_scp_menu() -> void:
	# setup cloes behavior
	ActiveMenu.onClose = func() -> void:	
		GBL.find_node(REFS.ROOM_NODES).is_active = false	
		set_btn_disabled_state(false)
	
	# make room nodes active
	GBL.find_node(REFS.ROOM_NODES).is_active = true
	
	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	# pull data, create the options list
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var room_is_empty:bool = room_extract.is_room_empty
	var is_room_under_construction:bool = room_extract.is_room_under_construction
	var is_room_active:bool = room_extract.is_activated
	var room_category:int = room_extract.room_category
	var is_scp_empty:bool = room_extract.is_scp_empty
	#var	is_scp_transfering:bool = room_extract.is_scp_transfering
	#var is_scp_contained:bool = room_extract.is_scp_contained
	var researchers_count:int = room_extract.researchers_count	
	var options_list:Array = []
			
	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
			set_btn_disabled_state(false)
	})
	
	if is_scp_empty:
		options_list.push_back({
			"title": "CONTAIN SCP",
			"is_disabled": scp_data.available_list.size() == 0,
			"onSelect": func() -> void:
				ActiveMenu.freeze_inputs = true
				await GameplayNode.contain_scp(current_location.duplicate(), scp_data.available_list[0].ref)
				ActiveMenu.freeze_inputs = false
				open_scp_menu()
		})
	else:
		options_list.push_back({
			"title": "DETAILS",
			"onSelect": func() -> void:
				ActiveMenu.freeze_inputs = true
				await GameplayNode.view_scp_details(room_extract.scp.details.ref)
				ActiveMenu.freeze_inputs = false
				open_scp_menu()
		})					
		

	ActiveMenu.show_ap = false
	ActiveMenu.header = "CONTAINMENT"
	ActiveMenu.use_color = Color(0.511, 0.002, 0.717)
	ActiveMenu.options_list = options_list		
	await U.tick()
	ActiveMenu.size = Vector2(1, 1)
	ActiveMenu.custom_minimum_size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	ActiveMenu.open()
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------				
func open_researcher_menu() -> void:
	# setup cloes behavior
	ActiveMenu.onClose = func() -> void:	
		GBL.find_node(REFS.ROOM_NODES).is_active = false	
		set_btn_disabled_state(false)
	
	# make room nodes active
	GBL.find_node(REFS.ROOM_NODES).is_active = true
	
	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	# pull data, create the options list
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var room_is_empty:bool = room_extract.is_room_empty
	var researchers_count:int = room_extract.researchers_count
	var is_room_active:bool = room_extract.is_activated
	var room_is_active
	
	var options_list := []
	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:	
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
			set_btn_disabled_state(false)
	})
	
	options_list.push_back({
		"title": "ASSIGN RESEARCHER...",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var response:Dictionary = await GameplayNode.assign_researcher(current_location.duplicate())
			ActiveMenu.freeze_inputs = false
			open_researcher_menu(),
	})		
	
	for researcher in room_extract.researchers:
		options_list.push_back({
			"title": "REMOVE %s" % [researcher.name],
			"onSelect": func() -> void:
				ActiveMenu.freeze_inputs = true
				var response:Dictionary = await GameplayNode.unassign_researcher(researcher, room_extract.room.details)
				ActiveMenu.freeze_inputs = false
				open_researcher_menu(),
		})

	ActiveMenu.header = "RESEARCHER"
	ActiveMenu.use_color = Color(0, 0.965, 0.278)
	ActiveMenu.options_list = options_list		
	await U.tick()
	ActiveMenu.size = Vector2(1, 1)
	ActiveMenu.custom_minimum_size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	ActiveMenu.open()
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------				
func open_debug_menu() -> void:
	# setup cloes behavior
	ActiveMenu.onClose = func() -> void:	
		GBL.find_node(REFS.ROOM_NODES).is_active = false	
		set_btn_disabled_state(false)
	
	# make room nodes active
	GBL.find_node(REFS.ROOM_NODES).is_active = true
	
	# enable/disable buttons
	ActiveMenu.freeze_inputs = false
	set_btn_disabled_state(true)
	
	# pull data, create the options list
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var can_take_action:bool = true #is_powered and (!in_lockdown and !in_brownout)	
	var room_is_empty:bool = room_extract.is_room_empty
	var researchers_count:int = room_extract.researchers_count
	var is_room_active:bool = room_extract.is_activated
	var room_is_active
	
	var options_list := []
	options_list.push_back({
		"title": "BACK",
		"onSelect": func() -> void:	
			GBL.find_node(REFS.ROOM_NODES).is_active = false
			ActiveMenu.close()
			set_btn_disabled_state(false)
	})
	
	options_list.push_back({
		"title": "TRIGGER MORALE EVENT...",
		"onSelect": func() -> void:
			ActiveMenu.freeze_inputs = true
			var props:Dictionary = {"onSelection": func(selected):print(selected)}
			await GameplayNode.triggger_event(EVT.TYPE.MORALE, props)
			ActiveMenu.freeze_inputs = false
			open_debug_menu(),
	})		
	

	ActiveMenu.header = "DEBUG"
	ActiveMenu.use_color = Color.WHITE
	ActiveMenu.options_list = options_list		
	await U.tick()
	ActiveMenu.size = Vector2(1, 1)
	ActiveMenu.custom_minimum_size = Vector2(1, 1)
	ActiveMenu.global_position = Vector2(ref_btn.global_position.x, get_menu_y_pos())
	ActiveMenu.open()
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
## --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func auto_order() -> void:
	set_btn_disabled_state(true)
	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var room_is_empty:bool = room_extract.is_room_empty
	var is_room_under_construction:bool = room_extract.is_room_under_construction
	var is_room_active:bool = room_extract.is_activated
	var room_category:int = room_extract.room_category
	var researchers_count:int = room_extract.researchers_count
	var is_scp_empty:bool = room_extract.is_scp_empty
	
	# first add the room - either a containment cell or a facility
	if room_is_empty:
		if is_room_under_construction:
			await GameplayNode.cancel_construction(current_location.duplicate())
		else:
			await GameplayNode.construct_room()
		set_btn_disabled_state(false)
		return
	
	# if it's not activated, activate it 
	if !is_room_active:
		await GameplayNode.activate_room(current_location.duplicate(), room_extract.room.details.ref)
		set_btn_disabled_state(false)
		return
		
	match room_category:
		# if it's a containment cell
		ROOM.CATEGORY.CONTAINMENT_CELL:
			# ... assign researcher first
			if researchers_count == 0:	
				await GameplayNode.assign_researcher(current_location.duplicate())
				set_btn_disabled_state(false)
				return	
						
			# then add an scp
			if is_scp_empty:
				await GameplayNode.contain_scp(current_location.duplicate())
				set_btn_disabled_state(false)
				return			
			
			# no other actions available
			set_btn_disabled_state(false)
			return							
			

		# if the room is a facility, add a researcher
		ROOM.CATEGORY.FACILITY:
			if researchers_count < 2:	
				await GameplayNode.assign_researcher(current_location.duplicate())
				set_btn_disabled_state(false)
				return	
			
			# no other actions available
			set_btn_disabled_state(false)
			return					
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	U.debounce("build_btns", buildout_btns)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	await U.set_timeout(0.3)
	U.debounce("build_btns", buildout_btns)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
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
	var reload:bool = false
	
	if camera_settings.type != previous_camera_type:
		previous_camera_type = camera_settings.type	
		reload = true
		
	print("is_disabled: ", floor_is_powered)
	
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			# ---- LEFT SIDE
			new_left_btn_list.push_back({
				"title": "UNLOCK",
				"assigned_key": "E",
				"is_disabled": floor_is_powered,
				"icon": SVGS.TYPE.TARGET,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						ActiveMenu.freeze_inputs = true
						set_btn_disabled_state(true)
						var has_changes:bool = await GameplayNode.activate_floor(current_location.duplicate())
						ActiveMenu.freeze_inputs = false
						await set_btn_disabled_state(false)						
						buildout_btns()
			})						
						
			# ---- RIGHT SIDE
			new_right_btn_list.push_back({
				"title": "QUICKSAVE",
				"assigned_key": "F5",
				"icon": SVGS.TYPE.SAVE,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						GameplayNode.quicksave()
			})		
			
			new_right_btn_list.push_back({
				"title": "QUICKLOAD",
				"assigned_key": "F8",
				"icon": SVGS.TYPE.LOADING,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						GameplayNode.quickload()
			})					
						
			new_right_btn_list.push_back({
				"title": "GOTO WING",
				"assigned_key": "TAB",
				"icon": SVGS.TYPE.TARGET,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						toggle_camera_view()
			})		
						
			new_right_btn_list.push_back({
				"title": "NEXT (%s)" % [end_of_turn_metrics_event_count] if end_of_turn_metrics_event_count > 0 else "NEXT",
				"assigned_key": "ENTER",
				"icon": SVGS.TYPE.CAUTION if end_of_turn_metrics_event_count > 0 else SVGS.TYPE.NEXT,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						GameplayNode.next_day(),
			})
			
			
		CAMERA.TYPE.ROOM_SELECT:	
			# ---- LEFT SIDE
			new_left_btn_list.push_back({
				"title": "ABILITIES",
				"assigned_key": "E",
				"is_disabled": !gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_ACTION_DETAILS] or !is_activated,
				"icon": SVGS.TYPE.TARGET,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						show_details()
			})						
			
			new_left_btn_list.push_back({
				"title": "FACILITY",
				"assigned_key": "1",
				"icon": SVGS.TYPE.MONEY,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						open_room_menu()
			})
			
			
			new_left_btn_list.push_back({
				"title": "RESEARCHER",
				"is_disabled": !gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_ACTIONS_RESEARCHER],
				"assigned_key": "2",
				"icon": SVGS.TYPE.CONTAIN,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						open_researcher_menu()
			})
				
			
			new_left_btn_list.push_back({
				"title": "CONTAINMENT",
				"is_disabled": !gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_ACTIONS_SCP] or !can_contain,
				"assigned_key": "3",
				"icon": SVGS.TYPE.CONTAIN if room_category == ROOM.CATEGORY.CONTAINMENT_CELL else SVGS.TYPE.CLEAR,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						open_scp_menu()
			})
			

			
			# ---- RIGHT SIDE
			new_right_btn_list.push_back({
				"title": "DEBUG",
				"assigned_key": "-",
				"icon": SVGS.TYPE.DOWNLOAD,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied():  
						open_debug_menu()
			})							
			
			if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_DATABASE_BTN]:
				new_right_btn_list.push_back({
					"title": "DATABASE",
					"assigned_key": "-",
					"icon": SVGS.TYPE.CONVERSATION,
					"onClick": func() -> void:
						if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied():  
							GameplayNode.open_scp_database()
				})				
			
			if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_OBJECTIVES_BTN]:
				new_right_btn_list.push_back({
					"title": "OBJECTIVES",
					"assigned_key": "O",
					"icon": SVGS.TYPE.TXT_FILE,
					"onClick": func() -> void:
						if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied():  
							GameplayNode.open_objectives()
				})				
			
			if gameplay_conditionals[CONDITIONALS.TYPE.ENABLE_ROOM_DETAILS_BTN]:
				new_right_btn_list.push_back({
					"title": "DETAILS",
					"assigned_key": "SPACEBAR",
					"icon": SVGS.TYPE.CHECKBOX if GBL.find_node(REFS.ROOM_INFO).expand else SVGS.TYPE.EMPTY_CHECKBOX,
					"onClick": func() -> void:
						if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied():  
							GBL.find_node(REFS.ROOM_INFO).toggle_expand()
							buildout_btns()
				})	
						
			new_right_btn_list.push_back({
				"title": "GOTO",
				"assigned_key": "TAB",
				"icon": SVGS.TYPE.CAMERA_B,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						toggle_camera_view()
			})

			
			new_right_btn_list.push_back({
				"title": "NEXT (%s)" % [end_of_turn_metrics_event_count] if end_of_turn_metrics_event_count > 0 else "NEXT",
				"assigned_key": "ENTER",
				"icon": SVGS.TYPE.CAUTION if end_of_turn_metrics_event_count > 0 else SVGS.TYPE.NEXT,
				"onClick": func() -> void:
					if !disable_inputs_while_menu_is_open and !GameplayNode.is_occupied(): 
						GameplayNode.next_day(),
			})

	on_left_btn_list_update(new_left_btn_list, reload)
	on_right_btn_list_update(new_right_btn_list, reload)
	await U.tick()
	is_setup = true
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func set_backdrop_state(state:bool) -> void:
	await U.tween_node_property(Backdrop, 'color', Color(0, 0.1, 0, 0.4 if state else 0.0))	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func set_btn_disabled_state(state:bool) -> void:	
	await U.tick() # DO NOT REMOVE
	
	for index in LeftSideBtnList.get_child_count():
		var btn_node:Control = LeftSideBtnList.get_child(index)
		var is_disabled_state:bool = left_btn_list[index].is_disabled if "is_disabled" in left_btn_list[index] else false
		btn_node.is_disabled = true if state else is_disabled_state
		
	for index in RightSideBtnList.get_child_count():
		var btn_node:Control = RightSideBtnList.get_child(index)
		btn_node.is_disabled = true if state else right_btn_list[index].is_disabled if "is_disabled" in right_btn_list[index] else false
		
	disable_inputs_while_menu_is_open = state
	set_backdrop_state(state)	
	

func on_left_btn_list_update(new_list:Array, reload:bool) -> void:
	if !is_node_ready():return

	if reload or LeftSideBtnList.get_child_count() != new_list.size():
		await U.tick()
		for node in LeftSideBtnList.get_children():
			node.queue_free()
		
		for item in new_list:
			var new_btn:BtnBase = KeyBtnPreload.instantiate()
			new_btn.title = item.title
			new_btn.assigned_key = item.assigned_key
			new_btn.icon = item.icon
			new_btn.is_disabled = item.is_disabled if "is_disabled" in item else false
			new_btn.hide() if ("is_hidden" in item and item.is_hidden) else new_btn.show()

			new_btn.onClick = func() -> void:
				if !new_btn.is_disabled:
					ref_btn = new_btn
					item.onClick.call()
			LeftSideBtnList.add_child(new_btn)
		left_btn_list = new_list.duplicate()
	else:		
		for index in new_list.size():
			var item:Dictionary = new_list[index]
			var btn_node:BtnBase = LeftSideBtnList.get_child(index)
			var is_disabled_state:bool = new_list[index].is_disabled if "is_disabled" in new_list[index] else false
			btn_node.title = item.title
			btn_node.icon = item.icon
			btn_node.is_disabled = item.is_disabled if "is_disabled" in item else false
			btn_node.hide() if ("is_hidden" in item and item.is_hidden) else btn_node.show()
	

func on_right_btn_list_update(new_list:Array, reload:bool) -> void:
	if !is_node_ready():return
	
	if reload or RightSideBtnList.get_child_count() != new_list.size():
		await U.tick()
		for node in RightSideBtnList.get_children():
			node.queue_free()
		
		for item in new_list:
			var new_btn:BtnBase = KeyBtnPreload.instantiate()
			new_btn.title = item.title
			new_btn.assigned_key = item.assigned_key
			new_btn.icon = item.icon
			new_btn.is_disabled = item.is_disabled if "is_disabled" in item else false
			new_btn.onClick = func() -> void:			
				ref_btn = new_btn
				item.onClick.call()
			RightSideBtnList.add_child(new_btn)
			
		right_btn_list = new_list		
	else:
		for index in new_list.size():
			var item:Dictionary = new_list[index]
			var btn_node:BtnBase = RightSideBtnList.get_child(index)
			var is_disabled_state:bool = new_list[index].is_disabled if "is_disabled" in new_list[index] else false
			btn_node.title = item.title
			btn_node.icon = item.icon
			#btn_node.is_disabled = (item.is_disabled if "is_disabled" in item else false) if !disable_inputs_while_menu_is_open else btn_node.is_disabled
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_showing or GameplayNode.is_occupied() or current_location.is_empty() or room_config.is_empty() or freeze_inputs or disable_inputs_while_menu_is_open:return
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"W":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					current_location.floor = clampi(current_location.floor - 1, 0, room_config.floor.size() - 1)
					SUBSCRIBE.current_location = current_location
				CAMERA.TYPE.ROOM_SELECT:
					U.room_up()
					
					
		"S":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					current_location.floor = clampi(current_location.floor + 1, 0, room_config.floor.size() - 1)
					SUBSCRIBE.current_location = current_location
				CAMERA.TYPE.ROOM_SELECT:
					U.room_down()
		"D":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					current_location.ring = clampi(current_location.ring + 1, 0, 3)
					SUBSCRIBE.current_location = current_location
				CAMERA.TYPE.ROOM_SELECT:
					U.room_right()
		"A":
			match camera_settings.type:
				CAMERA.TYPE.FLOOR_SELECT:
					current_location.ring = clampi(current_location.ring - 1, 0, 3)				
					SUBSCRIBE.current_location = current_location
				CAMERA.TYPE.ROOM_SELECT:
					U.room_left()
					
# --------------------------------------------------------------------------------------------------	
