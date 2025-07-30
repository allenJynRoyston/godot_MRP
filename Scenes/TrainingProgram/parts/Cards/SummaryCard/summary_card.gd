extends MouseInteractions

@onready var CardBody:Control = $CardBody
@onready var CardControlBody:PanelContainer = $CardBody/SubViewport/Control/CardBody
@onready var CardBodySubviewport:SubViewport = $CardBody/SubViewport

@onready var BusyPanel:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/BusyPanel

@onready var EmptyContainer:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/EmptyContainer

@onready var ActivationContainer:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ActivationContainer
@onready var CardDrawerResearchers:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ActivationContainer/CardDrawerResearchers


@onready var RoomDetailsContainer:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/RoomDetailsContainer
@onready var UpgradeBtn:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/RoomDetailsContainer/UpgradeBtn


@onready var AbilityContainer:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/AbilityContainer
@onready var CardDrawerActiveAbilities:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/AbilityContainer/CardDrawerActiveAbilities

@onready var PassiveContainer:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/PassiveContainer
@onready var CardDrawerPassiveAbilities:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/PassiveContainer/CardDrawerPassiveAbilities

@onready var ScpContinaer:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ScpContainer
@onready var CardDrawerScp:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ScpContainer/CardDrawerScp

@onready var node_list:Array = [CardDrawerActiveAbilities, CardDrawerPassiveAbilities, CardDrawerResearchers, CardDrawerScp]

@export var preview_mode:bool = false 

var use_location:Dictionary 
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass
var room_ref:int = -1 : 
	set(val):
		room_ref = val
		on_room_ref_update()
		
var room_config:Dictionary
var base_states:Dictionary
var hired_lead_researchers:Array

const scp_color:Color = Color(0.736, 0.247, 0.9)
const room_color:Color = Color(0.337, 0.275, 1.0)
const researcher_color:Color = Color(1.0, 0.108, 0.485)

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)
	
	
func _ready() -> void:
	BusyPanel.hide()
	
	for node in node_list:
		node.preview_mode = preview_mode
		#node.is_left_side = false
	
	for node in node_list:
		node.onLock = func() -> void:
			for child in node_list:
				child.lock_btns(true)
			
		node.onUnlock = func() -> void:
			for child in node_list:
				child.lock_btns(false)
				
	on_room_ref_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	U.debounce(str(self.name, "_on_update_room_label"), on_room_ref_update)

func on_base_states_update(new_val:Dictionary) -> void:
	base_states = new_val
	U.debounce(str(self.name, "_on_update_room_label"), on_room_ref_update)	

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	hired_lead_researchers = new_val
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
var previous_room_ref:int
func on_room_ref_update() -> void:
	if !is_node_ready() or room_config.is_empty() or base_states.is_empty():return

	if room_ref == -1:
		EmptyContainer.show()
		RoomDetailsContainer.hide()
		UpgradeBtn.title = "BUILD MODE"		
		UpgradeBtn.is_selected = true
		ActivationContainer.hide()		
		AbilityContainer.hide()
		PassiveContainer.hide()
		ScpContinaer.hide()
		await U.tick()
		CardControlBody.size = Vector2(1, 1)		
		return

	var ActionContainerNode:Control = GBL.find_node(REFS.ACTION_CONTAINER)	
	var extract_room_data:Dictionary = GAME_UTIL.extract_room_details()
	var room_details:Dictionary = ROOM_UTIL.return_data(room_ref)
	var is_activated:bool = false	
	var show_passives:bool = false
	var show_abilities:bool = false
	var show_researchers:bool = false	
	var show_scp:bool = room_details.can_contain and !preview_mode 
	var required_staffing:Array = room_details.required_staffing
	var abl_lvl:int = extract_room_data.room.abl_lvl 
	var max_upgrade_lvl:int = extract_room_data.room.max_upgrade_lvl 
	var at_max_level:bool = abl_lvl >= max_upgrade_lvl
	
	if !use_location.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
		is_activated = extract_data.room.is_activated
	
	# attach researcher data
	UpgradeBtn.title = "%s - LVL %s" % [room_details.name, abl_lvl if !at_max_level else "MAX"]
	UpgradeBtn.icon = SVGS.TYPE.DELETE if at_max_level else SVGS.TYPE.SETTINGS
	UpgradeBtn.hide_icon = at_max_level

	UpgradeBtn.hint_title = "HINT"
	UpgradeBtn.hint_icon =  SVGS.TYPE.SETTINGS
	UpgradeBtn.hint_description = "Room is at max level." if at_max_level else "Room can be upgraded to level %s." % (abl_lvl + 1)			
		
	UpgradeBtn.onClick = func() -> void:
		if preview_mode or !is_visible_in_tree():return	
		for node in node_list:
			node.onLock.call()
		await ActionContainerNode.before_use()
		await GAME_UTIL.upgrade_facility()
		ActionContainerNode.after_use()
		for node in node_list:
			node.onUnlock.call()

	CardDrawerResearchers.room_details = room_details
	CardDrawerResearchers.use_location = use_location			
	CardDrawerResearchers.required_staffing = required_staffing
	
	# attach passives
	if ("passive_abilities" not in room_details) or room_details.passive_abilities.call().is_empty():
		CardDrawerPassiveAbilities.hide()
	else:
		CardDrawerPassiveAbilities.show()
		CardDrawerPassiveAbilities.use_location = use_location		
		CardDrawerPassiveAbilities.room_details = room_details
		show_passives = true
	
	# attach abilities
	if ("abilities" not in room_details) or room_details.abilities.call().is_empty():
		CardDrawerActiveAbilities.hide()
	else:
		CardDrawerActiveAbilities.show()
		CardDrawerActiveAbilities.use_location = use_location			
		CardDrawerActiveAbilities.room_details = room_details
		show_abilities = true
	
	# card drawer scp
	CardDrawerScp.use_location = use_location
	
	# hide container
	EmptyContainer.hide()
	ActivationContainer.show() 	
	RoomDetailsContainer.show() if !room_details.is_empty() else RoomDetailsContainer.hide()
	#AbilityContainer.show() if show_abilities else AbilityContainer.hide()
	PassiveContainer.show() if show_passives else PassiveContainer.hide()
	ScpContinaer.show() if show_scp else ScpContinaer.hide()

	await U.tick()
	CardControlBody.size = Vector2(1, 1)
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func deselect_btns() -> void:
	var btn_list:Array = []
	for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities, CardDrawerResearchers, CardDrawerScp]:
		if node.is_visible_in_tree():
			for btn in node.get_btns():
				if "is_selected" in btn:
					btn.is_selected = false
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_ability_btns() -> Array:
	var btn_list:Array = []
	
	# activation buttons first
	for node in [CardDrawerResearchers]:
		for btn in node.get_btns():
			btn_list.push_back(btn)	
	
	# remove this later
	btn_list.push_back(UpgradeBtn)
	
	# add passive, active and scp button
	for node in [CardDrawerPassiveAbilities, CardDrawerActiveAbilities,  CardDrawerScp]:
		for btn in node.get_btns():
			btn_list.push_back(btn)
	
	return btn_list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_starting_btn_index() -> int:
	var abilty_btns:Array = get_ability_btns()
	for index in abilty_btns.size():
		if abilty_btns[index] == UpgradeBtn:
			print(index)
			return index
	return 0
# ------------------------------------------------------------------------------
		
# ------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if !is_node_ready():return
	CardBodySubviewport.size = CardControlBody.size
# ------------------------------------------------------------------------------
	
