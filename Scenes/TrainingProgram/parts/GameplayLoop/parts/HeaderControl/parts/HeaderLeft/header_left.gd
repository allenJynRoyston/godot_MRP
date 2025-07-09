extends Control

@onready var RootPanel:PanelContainer = $PanelContainer
@onready var MarginPanel:MarginContainer = $PanelContainer/MarginContainer

@onready var CurrencyMoney:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/HBoxContainer/Money
@onready var CurrencyMaterials:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/HBoxContainer/Material
@onready var CurrencyResearch:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/HBoxContainer/Research
@onready var CurrencyCore:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/HBoxContainer/Core

@onready var CurrenyTag:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/CurrencyTag
@onready var MaterialTag:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/MaterialTag
@onready var ScienceTag:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/ScienceTag
@onready var CoreTag:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Currencies/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/CoreTag

@onready var VibesContainer:PanelContainer = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Vibes
@onready var VibeMorale:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Vibes/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VibeMorale
@onready var VibeSafety:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Vibes/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VibeSafety
@onready var VibeReadiness:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Vibes/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/VibeReadiness

@onready var MoraleTag:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Vibes/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/MoraleTag
@onready var SafetyTag:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Vibes/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/SafetyTag
@onready var ReadinessTag:Control = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Left/Vibes/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer2/ReadinessTag

var current_location:Dictionary = {}
var camera_settings:Dictionary = {}
var room_config:Dictionary = {}
var control_pos:Dictionary = {}
var resources_data:Dictionary = {}

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)	
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	SUBSCRIBE.subscribe_to_resources_data(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)

func _ready() -> void:	
	await U.tick()
	
	control_pos[RootPanel] = {
		"show": 0,
		"hide": -MarginPanel.size.y
	}
		
	reveal(false, true)
	update.call_deferred()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal(state:bool, instant:bool = false) -> void:
	if control_pos.is_empty():return
	
	var new_pos:int = control_pos[RootPanel].show if state else control_pos[RootPanel].hide
	
	if instant:
		RootPanel.position.y = new_pos
		return
	
	await U.tween_node_property(RootPanel, "position:y", new_pos)
# --------------------------------------------------------------------------------------------------

# -----------------------------------------------	
func on_resources_data_update(new_val:Dictionary) -> void:
	resources_data = new_val
	if !is_node_ready() or new_val.is_empty():return
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------	

# -----------------------------------------------	
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if !is_node_ready() or new_val.is_empty():return
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------			

# ----------------------------------------------			
func on_room_config_update(new_val:Dictionary) -> void: 
	room_config = new_val
	if !is_node_ready() or new_val.is_empty():return
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------			

# -----------------------------------------------			
func on_camera_settings_update(new_val:Dictionary) -> void:
	camera_settings = new_val
	if !is_node_ready() or new_val.is_empty():return
	U.debounce(str(self.name, "_update"), update)
# -----------------------------------------------			
	
# -----------------------------------------------
func update() -> void:
	if !is_node_ready() or camera_settings.is_empty() or current_location.is_empty() or room_config.is_empty() or resources_data.is_empty():return
	var base_config_data:Dictionary = room_config.base
	var floor_config_data:Dictionary = room_config.floor[current_location.floor]
	var ring_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]	
	var room_config_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].room[current_location.room]	
	var current_vibe:Dictionary = GAME_UTIL.get_vibes_summary(current_location)	
	var summary_data:Dictionary = {}
	
	
	VibesContainer.show() if ROOM_UTIL.owns_and_is_active(ROOM.REF.HQ) else VibesContainer.hide()
	
	## update everything else
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			summary_data = GAME_UTIL.get_floor_summary(current_location)
		CAMERA.TYPE.WING_SELECT:
			summary_data = GAME_UTIL.get_ring_summary(current_location)	
		CAMERA.TYPE.ROOM_SELECT:
			summary_data = GAME_UTIL.get_room_summary(current_location)		
	
	# update economy
	CurrencyMoney.amount = resources_data[RESOURCE.CURRENCY.MONEY].amount
	CurrencyResearch.amount = resources_data[RESOURCE.CURRENCY.SCIENCE].amount
	CurrencyMaterials.amount = resources_data[RESOURCE.CURRENCY.MATERIAL].amount
	CurrencyCore.amount = resources_data[RESOURCE.CURRENCY.CORE].amount	
	
	# update vibes
	VibeMorale.value = str(current_vibe[RESOURCE.METRICS.MORALE])
	VibeSafety.value = str(current_vibe[RESOURCE.METRICS.SAFETY])
	VibeReadiness.value = str(current_vibe[RESOURCE.METRICS.READINESS])	

	# update economy
	CurrenyTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.MONEY] 
	MaterialTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.MATERIAL] 
	ScienceTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.SCIENCE] 
	CoreTag.val = summary_data.currency_diff[RESOURCE.CURRENCY.CORE]	
	
	# update metrics
	MoraleTag.val = summary_data.metric_diff[RESOURCE.METRICS.MORALE]
	SafetyTag.val = summary_data.metric_diff[RESOURCE.METRICS.SAFETY]
	ReadinessTag.val = summary_data.metric_diff[RESOURCE.METRICS.READINESS]
	
# -----------------------------------------------
