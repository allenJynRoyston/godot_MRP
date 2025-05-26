extends MouseInteractions

@onready var CardBody:Control = $CardBody
@onready var CardControlBody:PanelContainer = $CardBody/SubViewport/Control/CardBody
@onready var CardBodySubviewport:SubViewport = $CardBody/SubViewport

@onready var BusyPanel:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/BusyPanel

@onready var ListContainers:VBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ListContainers
@onready var CardDrawerActiveAbilities:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ListContainers/CardDrawerActiveAbilities
@onready var CardDrawerPassiveAbilities:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ListContainers/CardDrawerPassiveAbilities
@onready var CardDrawerResearchers:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ListContainers/CardDrawerResearchers
@onready var CardDrawerScp:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ListContainers/CardDrawerScp

@onready var RoomDetails:HBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/RoomDetails
#@onready var ScpDetails:HBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ScpDetails
#@onready var Researcher1Details:HBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/Researcher1Details
#@onready var Researcher2Details:HBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/Researcher2Details

@export var preview_mode:bool = false 

var use_location:Dictionary 
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass
var room_ref:int = -1 : 
	set(val):
		room_ref = val
		on_room_ref_update()
		
#var scp_ref:int = -1 : 
	#set(val):
		#scp_ref = val
		#on_scp_ref_update()
		#
#var researchers:Array = [] : 
	#set(val):
		#researchers = val
		#on_researchers_update() 

var room_config:Dictionary
var base_states:Dictionary

const scp_color:Color = Color(0.736, 0.247, 0.9)
const room_color:Color = Color(0.337, 0.275, 1.0)
const researcher_color:Color = Color(1.0, 0.108, 0.485)

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_base_states(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	
func _ready() -> void:
	BusyPanel.hide()
	var node_list:Array = [CardDrawerActiveAbilities, CardDrawerPassiveAbilities, CardDrawerResearchers, CardDrawerScp]
	
	for node in node_list:
		node.border_color = room_color
	
	for node in node_list:
		node.preview_mode = preview_mode
		node.is_left_side = false
	
	for node in node_list:
		node.onLock = func() -> void:
			BusyPanel.show()
			for child in node_list:
				child.lock_btns(true)
			
		node.onUnlock = func() -> void:
			BusyPanel.hide()
			for child in node_list:
				child.lock_btns(false)
				
	on_room_ref_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	U.debounce(str(self.name, "_on_room_ref_update"), update_room_label)

func on_base_states_update(new_val:Dictionary) -> void:
	base_states = new_val
	U.debounce(str(self.name, "_on_room_ref_update"), update_room_label)	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_room_label() -> void:
	if !is_node_ready() or room_config.is_empty() or base_states.is_empty() or room_ref == -1:return
	var room_details:Dictionary = ROOM_UTIL.return_data(room_ref)
	var ring_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]	
	var room_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	var abl_lvl:int = (room_config_data.abl_lvl + ring_config_data.abl_lvl)
	var TextNode:Control = RoomDetails.get_child(1)
	
	for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities]:
		node.abl_lvl = abl_lvl

	TextNode.content = "%s  (Lvl %s)" % [room_details.shortname if !room_details.is_empty() else "EMPTY", abl_lvl]

var previous_room_ref:int
func on_room_ref_update() -> void:
	if !is_node_ready() or room_config.is_empty() or base_states.is_empty():return
	var ImgNode:Control = RoomDetails.get_child(0)
	var TextNode:Control = RoomDetails.get_child(1)

	if room_ref == -1:
		RoomDetails.modulate = Color(1, 1, 1, 0.5)
		TextNode.content = "EMPTY"		
		ImgNode.img_src = ""
		ImgNode.use_static = true
		CardDrawerResearchers.hide()
		CardDrawerActiveAbilities.hide()
		CardDrawerPassiveAbilities.hide()
		ListContainers.hide()
		await U.tick()
		CardControlBody.size = Vector2(1, 1)		
		return
	
	var ring_base_states:Dictionary = base_states.ring[str(use_location.floor, use_location.ring)]
	var researchers_per_room:int = ring_base_states.researchers_per_room
	# --
	var room_details:Dictionary = ROOM_UTIL.return_data(room_ref)
	var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
	var show_passives:bool = false
	var show_abilities:bool = false
	var show_researchers:bool = false	
	
	RoomDetails.modulate = Color(1, 1, 1, 1)
	update_room_label()
	ImgNode.img_src = room_details.img_src	if !room_details.is_empty() else null
	ImgNode.use_static = false
	
	# attach scp data (if applicable)
	print(room_details.can_contain)
	CardDrawerScp.scp_ref = -1
	CardDrawerScp.show() if room_details.can_contain else CardDrawerScp.hide()
	
	# attach researcher data
	CardDrawerResearchers.use_location = use_location			
	CardDrawerResearchers.researchers_per_room = researchers_per_room
	CardDrawerResearchers.show() if researchers_per_room > 0 else CardDrawerResearchers.hide()

	# attach passives
	if "passive_abilities" not in room_details or room_details.passive_abilities.call().is_empty():
		CardDrawerPassiveAbilities.hide()
	else:
		CardDrawerPassiveAbilities.show()
		CardDrawerPassiveAbilities.use_location = use_location		
		CardDrawerPassiveAbilities.room_details = room_details
		show_passives = true
	
	# attach abilities
	if "abilities" not in room_details or room_details.abilities.call().is_empty():
		CardDrawerActiveAbilities.hide()
	else:
		CardDrawerActiveAbilities.show()
		CardDrawerActiveAbilities.use_location = use_location			
		CardDrawerActiveAbilities.room_details = room_details
		show_abilities = true
	
	# hide container
	ListContainers.show() if (show_passives or show_abilities or show_researchers) else ListContainers.hide()
	await U.tick()
	CardControlBody.size = Vector2(1, 1)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_ability_btns() -> Array:
	await U.tick()
	var btn_list:Array = []
	for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities, CardDrawerResearchers, CardDrawerScp]:
		if node.is_visible_in_tree():
			for btn in node.get_btns():
				btn_list.push_back(btn)
	#
	return btn_list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:	
	if !is_node_ready():return	
	is_focused = state
	onFocus.call(self) if state else onBlur.call(self)	
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT:		
		onClick.call()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if !is_node_ready():return
	CardBodySubviewport.size = CardControlBody.size
# ------------------------------------------------------------------------------
	
