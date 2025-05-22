extends MouseInteractions

@onready var CardBody:Control = $CardBody
@onready var CardControlBody:PanelContainer = $CardBody/SubViewport/Control/CardBody
@onready var CardBodySubviewport:SubViewport = $CardBody/SubViewport

@onready var BusyPanel:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/BusyPanel

@onready var CardDrawerActiveAbilities:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerActiveAbilities
@onready var CardDrawerPassiveAbilities:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerPassiveAbilities

@onready var RoomDetails:HBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/RoomDetails
@onready var ScpDetails:HBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ScpDetails
@onready var Researcher1Details:HBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/Researcher1Details
@onready var Researcher2Details:HBoxContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/Researcher2Details

@export var preview_mode:bool = false 

var use_location:Dictionary 
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass
var room_ref:int = -1 : 
	set(val):
		room_ref = val
		on_room_ref_update()
		
var scp_ref:int = -1 : 
	set(val):
		scp_ref = val
		on_scp_ref_update()
		
var researchers:Array = [] : 
	set(val):
		researchers = val
		on_researchers_update() 

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
	
	for node in ScpDetails.get_children():
		node.border_color = scp_color
	
	for node in RoomDetails.get_children():
		node.border_color = room_color
		
	for child in [Researcher1Details, Researcher2Details]:
		for node in child.get_children():
			node.border_color = researcher_color 
	
	for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities]:
		node.preview_mode = preview_mode
		node.is_left_side = false
		
	CardDrawerActiveAbilities.onLock = func() -> void:
		BusyPanel.show()
		for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities]:
			node.lock_btns(true)
		
	CardDrawerActiveAbilities.onUnlock = func() -> void:
		BusyPanel.hide()
		for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities]:
			node.lock_btns(false)
			
	
	on_room_ref_update()
	on_scp_ref_update()
	on_researchers_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	
func on_base_states_update(new_val:Dictionary) -> void:
	base_states = new_val
# ------------------------------------------------------------------------------

var previous_room_ref:int
func on_room_ref_update() -> void:
	if !is_node_ready() or room_config.is_empty() or base_states.is_empty():return
	var ImgNode:Control = RoomDetails.get_child(0)
	var TextNode:Control = RoomDetails.get_child(1)
	
	if previous_room_ref == room_ref:return
	previous_room_ref = room_ref
	
	if room_ref == -1:
		RoomDetails.modulate = Color(1, 1, 1, 0.5)
		TextNode.content = "EMPTY"		
		ImgNode.img_src = ""
		ImgNode.use_static = true
		ScpDetails.hide()
		Researcher1Details.hide()
		Researcher2Details.hide()
		CardDrawerActiveAbilities.hide()
		CardDrawerPassiveAbilities.hide()
		return
	
	var ring_base_states:Dictionary = base_states.ring[str(use_location.floor, use_location.ring)]
	var researchers_per_room:int = ring_base_states.researchers_per_room
	# ---
	var ring_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring]
	var room_config_data:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].room[use_location.room]
	var abl_lvl:int = (room_config_data.abl_lvl + ring_config_data.abl_lvl)
	# --
	var room_details:Dictionary = ROOM_UTIL.return_data(room_ref)
	
	RoomDetails.modulate = Color(1, 1, 1, 1)
	TextNode.content = "%s  (Lvl %s)" % [room_details.shortname if !room_details.is_empty() else "EMPTY", abl_lvl]
	ImgNode.img_src = room_details.img_src	if !room_details.is_empty() else null
	ImgNode.use_static = false
	
	var level_with_details:Dictionary = ROOM_UTIL.return_pairs_with_details(room_details.ref)
	var nodes:Array = [Researcher1Details, Researcher2Details]
	
	if level_with_details.is_empty():
		for child in nodes:
			child.get_child(1).content = "NO SPECILIZATION REQUIRED"
	else:
		var spec_str:String = level_with_details.specilization.name
		var trait_str:String = level_with_details.trait.name
		for child in nodes:
			child.get_child(1).content = "RESEARCHER SLOT"# % [spec_str, trait_str]	
		
	if "passive_abilities" not in room_details or room_details.passive_abilities.call().is_empty():
		CardDrawerPassiveAbilities.hide()
	else:
		CardDrawerPassiveAbilities.show()
		CardDrawerPassiveAbilities.use_location = use_location		
		CardDrawerPassiveAbilities.room_details = room_details

	if "abilities" not in room_details or room_details.abilities.call().is_empty():
		CardDrawerActiveAbilities.hide()
	else:
		CardDrawerActiveAbilities.show()
		CardDrawerActiveAbilities.use_location = use_location			
		CardDrawerActiveAbilities.room_details = room_details
	
	# show/hide
	ScpDetails.show() if room_details.can_contain else ScpDetails.hide()
	Researcher1Details.show() if researchers_per_room >= 1 else Researcher1Details.hide()
	Researcher2Details.show() if researchers_per_room >= 2 else Researcher2Details.hide()

var previous_scp_ref:int
func on_scp_ref_update() -> void:
	if !is_node_ready():return
	var ImgNode:Control = ScpDetails.get_child(0)
	var TextNode:Control = ScpDetails.get_child(1)
	
	if previous_scp_ref == scp_ref:return
	previous_scp_ref = scp_ref
	
	if scp_ref == -1:
		ScpDetails.modulate = Color(1, 1, 1, 0.5)
		TextNode.content = "CONTAINMENT SLOT"
		ImgNode.img_src = ""
		ImgNode.use_static = true
		return

	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	ScpDetails.modulate = Color(1, 1, 1, 1)
	TextNode.content = scp_details.name
	ImgNode.img_src = scp_details.img_src
	ImgNode.use_static = false
		

var previous_researchers:Array
func on_researchers_update() -> void:
	if !is_node_ready():return
	var nodes:Array = [Researcher1Details, Researcher2Details]
	
	if previous_researchers == researchers:return
	previous_researchers = researchers
	
	if researchers.is_empty():
		for node in nodes:
			node.modulate = Color(1, 1, 1, 0.5)
			var ImgNode:Control = node.get_child(0)
			var TextNode:Control = node.get_child(1)
			#TextNode.content = "SLOT AVAILABLE"
			ImgNode.img_src = ""
			ImgNode.use_static = true
		return
	
	for index in [0, 1]:
		var node:Control = nodes[index]
		if researchers.size() > index:
			var ImgNode:Control = node.get_child(0)
			var TextNode:Control = node.get_child(1)
			var researcher:Dictionary = researchers[index]
			TextNode.content = researcher.name
			ImgNode.img_src = researcher.img_src
			ImgNode.use_static = false
			
			node.modulate = Color(1, 1, 1, 1)
			node.show()
		else:
			node.hide()
		

# ------------------------------------------------------------------------------
func get_ability_btns() -> Array:
	await U.tick()
	var btn_list:Array = []
	for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities]:
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
	
