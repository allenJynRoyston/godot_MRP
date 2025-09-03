extends SubscribeWrapper

@onready var UpgradeControl:Control = $Upgrade
@onready var UpgradePanel:PanelContainer = $Upgrade/PanelContainer
@onready var EnergyCountLabel:Label = $Upgrade/PanelContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/EnergyCountLabel

@onready var TempMonitor:PanelContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/TempMonitor
@onready var RealityMonitor:PanelContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/RealityMonitor
@onready var PollutionMonitor:PanelContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/PollutionMonitor
@onready var EnergyItem:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer4/MarginContainer/HBoxContainer/EnergyItem

@onready var DescriptionPanel:PanelContainer = $DescriptionControl/PanelContainer
@onready var DescriptionMargin:MarginContainer = $DescriptionControl/PanelContainer/MarginContainer
@onready var DescriptionLabel:Label = $DescriptionControl/PanelContainer/MarginContainer/HBoxContainer/DescriptionLabel

@onready var Heating:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Heating
@onready var Cooling:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Cooling
@onready var Ventilation:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Ventilation
@onready var SRA:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/SRA
@onready var Energy:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Energy
@onready var Logistics:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Logistics

@onready var component_list:Array = [
	{"node": Heating, "prop": "heating", "description": "Keeps rooms warm and comfortable."}, 
	{"node": Cooling, "prop": "cooling", "description": "Keeps temperatures cool and pleasant."}, 
	{"node": Ventilation, "prop": "ventilation", "description": "Circulates fresh air throughout the wing."}, 
	{"node": SRA, "prop": "sra", "description": "Set strength of localized Scranton Reality Anchors."}, 
	#{"node": Energy, "prop": "energy", "description": "Set the available energy for the wing."}, 
	#{"node": Logistics, "prop": "logistics", "description": "Support more rooms with higher logistics rating."}, 
]

var control_pos:Dictionary = {}
var is_active:bool = false
var ActiveNode:Control
var component_index:int = 0 : 
	set(val):
		component_index = val
		on_component_list_update()

# ------------------------------------------
func _init() -> void:
	super._init()
	GBL.subscribe_to_control_input(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unsubscribe_to_control_input(self)	

func _ready() -> void:
	await U.tick()
	control_pos[DescriptionPanel] = {
		"show": DescriptionPanel.position.y,
		"hide": DescriptionPanel.position.y - DescriptionMargin.size.y 
	}
	DescriptionPanel.position.y = control_pos[DescriptionPanel].hide
	
func start() -> void:
	is_active = true
	component_index = 0
	reveal_description(true)
	for index in component_list.size():
		var node:Control = component_list[index].node
		node.make_selectable = component_index == index
	
func end() -> void:
	is_active = false
	for index in component_list.size():
		var node:Control = component_list[index].node
		node.make_selectable = false
	reveal_description(false)
	
# ------------------------------------------

# ------------------------------------------
func reveal_description(state:bool) -> void:
	if state:
		DescriptionPanel.show()
		
	await U.tween_node_property(DescriptionPanel, "position:y", control_pos[DescriptionPanel].show if state else control_pos[DescriptionPanel].hide, 0.3, 0, Tween.TRANS_SINE)
	
	if !state:
		DescriptionPanel.hide()

func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val	
	U.debounce(str(self, "_update_node"), update_node)
	
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val	
	U.debounce(str(self, "_update_node"), update_node)

func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	U.debounce(str(self, "_update_node"), update_node)
	
func update_node() -> void:
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty():return
	var ring_config_data:Dictionary =room_config.floor[current_location.floor].ring[current_location.ring]
	var power_distribution:Dictionary = ring_config_data.power_distribution
	var energy_data:Dictionary = ring_config_data.energy
	var monitor:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].monitor
	var energy_available:int = GAME_UTIL.get_energy_available()
	
	
	# monitors
	TempMonitor.slider_val = monitor.temp
	RealityMonitor.slider_val = monitor.reality
	PollutionMonitor.slider_val = monitor.pollution
	
	EnergyCountLabel.text = str(energy_available)
	# update labels
	#EnergyCountLabel.text = str(resources_data[RESOURCE.CURRENCY.CORE].amount)
	#EnergyItem.amount = energy_data.used 
	#EnergyItem.max_amount = energy_data.available
	#EnergyItem.is_negative = energy_data.used > energy_data.available

	# update values
	Heating.active_level = power_distribution.heating
	Cooling.active_level = power_distribution.cooling
	Ventilation.active_level = power_distribution.ventilation
	SRA.active_level = power_distribution.sra
	#Energy.active_level = power_distribution.energy
	#Logistics.active_level = power_distribution.logistics
	#
	# check if they have the correct buildings to enable
	#Heating.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.ENGINEERING_LINK_1)
	#Cooling.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.ENGINEERING_LINK_2)
	#Ventilation.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.ENGINEERING_LINK_3)
	#SRA.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.ENGINEERING_LINK_4)
	#Energy.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.ENGINEERING_LINK_5)
	#Logistics.is_disabled = !ROOM_UTIL.owns_and_is_active(ROOM.REF.ENGINEERING_LINK_6)
	
	
func on_component_list_update() -> void:
	if !is_node_ready():return
	var power_distribution:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].power_distribution
	
	for index in component_list.size():
		var node:Control = component_list[index].node
		node.make_selectable = index == component_index
		if index == component_index:
			ActiveNode = node
			DescriptionLabel.text = component_list[index].description
			#UpgradePanel.position.y = node.position.y + 26
			

	GBL.find_node(REFS.WING_RENDER).update_engineering_stats(component_list[component_index])
# ------------------------------------------

# ------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_active or resources_data.is_empty(): 
		return

	var key:String = input_data.key
	var energy_available:int = GAME_UTIL.get_energy_available()	
	var power_distribution:Dictionary = base_states.ring[str(current_location.floor, current_location.ring)].power_distribution
	var prop_val:int = power_distribution[component_list[component_index].prop]
	print("prop_val: ", prop_val)
	
	match key:
		"W":
			component_index = U.min_max( component_index - 1, 0, component_list.size() - 1, true )
		"S":
			component_index = U.min_max( component_index + 1, 0, component_list.size() - 1, true )
		"A":
			if ActiveNode.is_disabled or prop_val <= 0:
				return
				
			#if prop_val > 1:
				#resources_data[RESOURCE.CURRENCY.CORE].amount = U.min_max(resources_data[RESOURCE.CURRENCY.CORE].amount + 1, 0, resources_data[RESOURCE.CURRENCY.CORE].capacity)
			base_states.ring[str(current_location.floor, current_location.ring)].power_distribution[component_list[component_index].prop] -= 1
			SUBSCRIBE.base_states = base_states
		"D":
			if ActiveNode.is_disabled or energy_available <= 0 or prop_val >= 4:
				return
				
			#if resources_data[RESOURCE.CURRENCY.CORE].amount > 0 and prop_val < 4:
				#resources_data[RESOURCE.CURRENCY.CORE].amount = U.min_max(resources_data[RESOURCE.CURRENCY.CORE].amount - 1, 0, resources_data[RESOURCE.CURRENCY.CORE].capacity)
			base_states.ring[str(current_location.floor, current_location.ring)].power_distribution[component_list[component_index].prop] += 1
			SUBSCRIBE.base_states = base_states
# ------------------------------------------	
