extends PanelContainer

# INFOCONTAINER
@onready var InfoContainer:PanelContainer = $MarginContainer/VBoxContainer/InfoContainer
@onready var ImageTextureRect:TextureRect = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect
@onready var NameTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/NameTag
@onready var LvlTag:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/VBoxContainer/ImageTextureRect/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/LvlTag

# status
@onready var StatusOverlay:PanelContainer = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/StatusOverlay
@onready var StatusLabel:Label = $MarginContainer/VBoxContainer/InfoContainer/MarginContainer/StatusOverlay/CenterContainer/StatusLabel

# activation
@onready var ActivationContainer:VBoxContainer = $MarginContainer/VBoxContainer/ActivationContainer
@onready var ActivationGrid:GridContainer = $MarginContainer/VBoxContainer/ActivationContainer/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/ActivationGrid

# modules
@onready var ModuleContainer:VBoxContainer = $MarginContainer/VBoxContainer/ModuleContainer
@onready var ModuleComponent:PanelContainer = $MarginContainer/VBoxContainer/ModuleContainer/ModuleComponent

# programs
@onready var ProgramContainer:VBoxContainer = $MarginContainer/VBoxContainer/ProgramContainer
@onready var ProgramComponent:PanelContainer = $MarginContainer/VBoxContainer/ProgramContainer/ProgramComponent

# scpcontainer
@onready var ScpContainer:VBoxContainer = $MarginContainer/VBoxContainer/ScpContainer
@onready var ScpComponent:PanelContainer = $MarginContainer/VBoxContainer/ScpContainer/ScpComponent

@onready var node_list:Array = [StatusOverlay, ActivationContainer, ModuleContainer, ProgramContainer, ScpContainer]

@export var preview_mode:bool = false 

var use_location:Dictionary : 
	set(val):
		use_location = val
		on_use_location_update()

var room_config:Dictionary
var base_states:Dictionary
var hired_lead_researchers:Array

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
	pass
	#BusyPanel.hide()
	#
	#for node in node_list:
		#node.preview_mode = preview_mode
		##node.is_left_side = false
	#
	#for node in node_list:
		#node.onLock = func() -> void:
			#for child in node_list:
				#child.lock_btns(true)
			#
		#node.onUnlock = func() -> void:
			#for child in node_list:
				#child.lock_btns(false)
				#
	#on_use_location_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_use_location_update() -> void:
	U.debounce(str(self, "_on_update"), on_update)
	
func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	U.debounce(str(self, "_on_update"), on_update)

func on_base_states_update(new_val:Dictionary) -> void:
	base_states = new_val
	U.debounce(str(self, "_on_update"), on_update)	

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	hired_lead_researchers = new_val
	U.debounce(str(self, "_on_update"), on_update)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func on_update() -> void:
	if !is_node_ready() or room_config.is_empty() or base_states.is_empty() or use_location.is_empty():return	
	var extract_room_data:Dictionary = GAME_UTIL.extract_room_details()

	# no room
	if extract_room_data.room.is_empty():
		hide()
		return
	
	# hide all nodes
	for node in node_list:
		node.hide()
	
	# extract
	show()
	var room_details:Dictionary = extract_room_data.room
	var scp_details:Dictionary = extract_room_data.scp
	var is_under_construction:bool = room_details.is_under_construction
	var is_activated:bool = room_details.is_activated
	var can_contain:bool = room_details.can_contain
	var lvl:int = room_details.abl_lvl 
	var max_upgrade_lvl:int = room_details.max_upgrade_lvl 
	var at_max_level:bool = lvl >= max_upgrade_lvl

	# assign details
	NameTag.text = room_details.details.name
	LvlTag.text = "LVL %s" % [lvl if !at_max_level else "★"]
	ImageTextureRect.texture = CACHE.fetch_image(room_details.details.img_src) 
	
	# under construction
	if is_under_construction:
		StatusLabel.text = "UNDER CONSTRUCTION"
		StatusOverlay.show()
		return

	# is activated
	if !is_activated:
		StatusLabel.text = "INACTIVE"
		StatusOverlay.show()
		ActivationContainer.show()
		return
	
	# assign modules
	if ("passive_abilities" not in room_details.details) or room_details.details.passive_abilities.call().is_empty():
		ModuleContainer.hide()
	else:
		ModuleContainer.show()
		ModuleComponent.use_location = use_location		
		ModuleComponent.room_details = room_details.details
	
	# assign programs
	if ("abilities" not in room_details.details) or room_details.details.abilities.call().is_empty():
		ProgramContainer.hide()
	else:
		ProgramContainer.show()
		ProgramComponent.use_location = use_location			
		ProgramComponent.room_details = room_details.details
		
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func deselect_btns() -> void:
	for node in [ModuleComponent, ProgramComponent]:
		for btn in node.get_btns():
			if "is_selected" in btn:
				btn.is_selected = false
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_ability_btns() -> Array:
	var btn_list:Array = []
	
	for node in [ModuleComponent, ProgramComponent]:
		for btn in node.get_btns():
			btn_list.push_back(btn)
	#
	return btn_list
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_starting_btn_index() -> int:
	var abilty_btns:Array = get_ability_btns()
	return 0
# ------------------------------------------------------------------------------
		
# ------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if !is_node_ready():return
	#CardBodySubviewport.size = CardControlBody.size
# ------------------------------------------------------------------------------
	
