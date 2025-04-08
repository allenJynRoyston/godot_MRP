extends GameContainer

@onready var MarginControl:MarginContainer = $Control/MarginControl

@onready var MetricsContainer:Control = $Control/MarginControl/HBoxContainer2/MetricsContainer
@onready var LocationPanel:Control = $Control/MarginControl/HBoxContainer2/LocationPanel
@onready var CurrencyContainer:Control = $Control/MarginControl/HBoxContainer2/CurrencyContainer

@onready var CorePanel:PanelContainer = $Control/MarginControl/HBoxContainer2/CurrencyContainer/CorePanel
@onready var MaterialPanel:PanelContainer = $Control/MarginControl/HBoxContainer2/CurrencyContainer/MatPanel
@onready var SciencePanel:PanelContainer = $Control/MarginControl/HBoxContainer2/CurrencyContainer/SciencePanel
@onready var MoneyPanel:PanelContainer = $Control/MarginControl/HBoxContainer2/CurrencyContainer/MoneyPanel
@onready var EnergyPanel:Control = $Control/MarginControl/HBoxContainer2/EnergyPanel

@onready var Morale:Control = $Control/MarginControl/HBoxContainer/MetricsContainer/Morale
@onready var Safety:Control = $Control/MarginControl/HBoxContainer/MetricsContainer/Safety
@onready var Readiness:Control = $Control/MarginControl/HBoxContainer/MetricsContainer/Readiness
@onready var PersonnelPanel:Control = $Control/MarginControl/HBoxContainer/PersonnelContainer

var previous_location:Dictionary = {}

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	GBL.direct_ref["MetricsContainer"] = MetricsContainer
	GBL.direct_ref["LocationPanel"] = LocationPanel
	GBL.direct_ref["PersonnelPanel"] = PersonnelPanel
	GBL.direct_ref["EnergyPanel"] = EnergyPanel
	
	GBL.direct_ref["CorePanel"] = CorePanel
	GBL.direct_ref["MaterialPanel"] = MaterialPanel
	GBL.direct_ref["SciencePanel"] = SciencePanel
	GBL.direct_ref["MoneyPanel"] = MoneyPanel
	
	GBL.direct_ref["MoralePanel"] = Morale
	GBL.direct_ref["SafetyPanel"] = Safety
	GBL.direct_ref["ReadinessPanel"] = Readiness
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()
	
	control_pos_default[MarginControl] = MarginControl.position

	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos() -> void:	
	await U.tick()
	var h_diff:int = (1080 - 720) # difference between 1080 and 720 resolution - gives you 360
	var y_diff =  (0 if !GBL.is_fullscreen else h_diff) if !initalized_at_fullscreen else (0 if GBL.is_fullscreen else -h_diff)
	
	# for eelements in the top right
	control_pos[MarginControl] = {
		"show": control_pos_default[MarginControl].y, 
		"hide": control_pos_default[MarginControl].y - MarginControl.size.y
	}	
	
	on_is_showing_update(true)
# --------------------------------------------------------------------------------------------------	

# -----------------------------------------------
func on_is_showing_update(skip_animation:bool = false) -> void:	
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return
	U.tween_node_property(MarginControl, "position:y", control_pos[MarginControl].show if is_showing else control_pos[MarginControl].hide, 0 if skip_animation else 0.7)
# -----------------------------------------------	

# -----------------------------------------------	
func on_current_location_update(new_val:Dictionary) -> void:
	super.on_current_location_update(new_val)
	if !U.dictionaries_equal(previous_location, current_location):
		previous_location = new_val.duplicate(true)
		U.debounce(str(self.name, "_update_energy_panel"), update_metrics_labels)
# -----------------------------------------------			

# -----------------------------------------------			
func on_room_config_update(new_val:Dictionary) -> void:
	super.on_room_config_update(new_val)	
	U.debounce(str(self.name, "_update_energy_panel"), update_metrics_labels)
# -----------------------------------------------			


# -----------------------------------------------
func update_metrics_labels() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	var ring_data:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring]
	var extract_data:Dictionary = GAME_UTIL.extract_room_details(current_location)
	
	for key in ring_data.metrics:
		var amount:int = ring_data.metrics[key]
		match key:
			RESOURCE.BASE_METRICS.MORALE:
				Morale.value = amount
			RESOURCE.BASE_METRICS.READINESS:
				Readiness.value = amount
			RESOURCE.BASE_METRICS.SAFETY:
				Safety.value = amount
# -----------------------------------------------
