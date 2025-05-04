@tool
extends MouseInteractions

@onready var CardBody:Control = $CardBody

@onready var CardDrawerResearcherPref:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerResearcherPref
@onready var CardDrawerActiveAbilities:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerActiveAbilities
@onready var CardDrawerPassiveAbilities:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerPassiveAbilities

@onready var CardDetails:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDetails
@onready var CardDrawerName:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDetails/CardDrawerName
@onready var CardDrawerImage:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDetails/CardDrawerImage

@onready var DeactivatedPanel:Control = $DeactivatedPanel

@export var preview_mode:bool = false 


var use_location:Dictionary 

var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass
var ref:int = -1 : 
	set(val):
		ref = val
		on_ref_update()

# ------------------------------------------------------------------------------
func _ready() -> void:
	for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities]:
		node.preview_mode = preview_mode
		
	CardDrawerActiveAbilities.onLock = func() -> void:
		for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities]:
			node.lock_btns(true)
		
	CardDrawerActiveAbilities.onUnlock = func() -> void:
		for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities]:
			node.lock_btns(false)
		
	on_ref_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_ref_update() -> void:
	if !is_node_ready():return

	if ref == -1:
		CardDrawerName.content = "EMPTY"
		CardDrawerImage.img_src = ""
		CardDrawerImage.use_static = true
		
		CardDrawerActiveAbilities.hide()
		CardDrawerPassiveAbilities.hide()
				
		CardDrawerActiveAbilities.title = ""
		CardDrawerPassiveAbilities.title = ""
		CardDrawerResearcherPref.content = ""
		CardDrawerActiveAbilities.clear()
		CardDrawerPassiveAbilities.clear()
		
		CardBody.card_size.y = 75
		return

	var room_details:Dictionary = ROOM_UTIL.return_data(ref)
	var is_locked:bool = false
	var is_activated:bool = true
	var no_passives:bool = false
	var no_abilities:bool = false
	
	if !use_location.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details({"floor": use_location.floor, "ring": use_location.ring, "room": use_location.room})
		is_activated = extract_data.is_activated
	
	#DeactivatedPanel.hide() if is_activated else DeactivatedPanel.show()
	for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities]:
		node.show()

	CardDetails.show()
	
	CardDrawerActiveAbilities.title = "%s PROGRAMS" % room_details.name
	CardDrawerPassiveAbilities.title = "%s MODULES" % room_details.name
	
	CardDrawerName.content = room_details.shortname if !room_details.is_empty() else "EMPTY"
	CardDrawerImage.img_src = room_details.img_src	if !room_details.is_empty() else null
	CardDrawerImage.use_static = room_details.is_empty()
	
	if "passive_abilities" not in room_details or room_details.passive_abilities.call().is_empty():
		CardDrawerPassiveAbilities.hide()
		no_passives = true
	else:
		CardDrawerPassiveAbilities.show()
		CardDrawerPassiveAbilities.room_details = room_details
		CardDrawerPassiveAbilities.use_location = use_location

	if "abilities" not in room_details or room_details.abilities.call().is_empty():
		CardDrawerActiveAbilities.hide()
		no_abilities = true
	else:
		CardDrawerActiveAbilities.show()
		CardDrawerActiveAbilities.room_details = room_details
		CardDrawerActiveAbilities.use_location = use_location
	
	# if no abilities
	if no_passives and no_abilities:
		CardBody.card_size.y = 75	
	else:
		CardBody.card_size.y = 330

	var level_with_details:Dictionary = ROOM_UTIL.return_pairs_with_details(room_details.ref)
	if level_with_details.is_empty():
		CardDrawerResearcherPref.content = "None"
	else:
		var spec_str:String = level_with_details.specilization.name
		var trait_str:String = level_with_details.trait.name
		CardDrawerResearcherPref.content = "%s or %s" % [spec_str, trait_str]
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func get_ability_btns() -> Array:
	await U.tick()
	var btn_list:Array = []
	for node in [CardDrawerActiveAbilities, CardDrawerPassiveAbilities]:
		if node.is_visible_in_tree():
			for btn in node.get_btns():
				btn_list.push_back(btn)
	
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
