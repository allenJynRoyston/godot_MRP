extends SubscribeWrapper

@onready var CoreAmountLabel:Label = $VBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer4/MarginContainer/VBoxContainer/HBoxContainer/CoreAmountLabel
@onready var TempMonitor:PanelContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/TempMonitor
@onready var RealityMonitor:PanelContainer = $VBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/RealityMonitor

@onready var DescriptionPanel:PanelContainer = $DescriptionControl/PanelContainer
@onready var DescriptionMargin:MarginContainer = $DescriptionControl/PanelContainer/MarginContainer
@onready var DescriptionLabel:Label = $DescriptionControl/PanelContainer/MarginContainer/HBoxContainer/DescriptionLabel

@onready var Heating:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Heating
@onready var Cooling:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Cooling
@onready var Ventilation:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Ventilation
@onready var SRA:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/SRA
@onready var Energy:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Energy

@onready var component_list:Array = [
	{"node": Heating, "prop": "heating", "description": "Keeps rooms warm and comfortable."}, 
	{"node": Cooling, "prop": "cooling", "description": "Keeps temperatures cool and pleasant."}, 
	{"node": Ventilation, "prop": "ventilation", "description": "Circulates fresh air throughout the wing."}, 
	{"node": SRA, "prop": "sra", "description": "Set strength of localized Scranton Reality Anchors."}, 
	{"node": Energy, "prop": "energy", "description": "Set the available energy for the wing."}, 
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
	for index in component_list.size():
		var node:Control = component_list[index].node
		node.make_selectable = false
	reveal_description(false)
	is_active = false
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
	var power_distribution:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].power_distribution
	var monitor:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].monitor
	
	# monitors
	TempMonitor.slider_val = monitor.temp
	RealityMonitor.slider_val = monitor.reality
	
	# update labels
	CoreAmountLabel.text = str(resources_data[RESOURCE.CURRENCY.CORE].amount)
	
	# update values
	Heating.active_level = power_distribution.heating
	Cooling.active_level = power_distribution.cooling
	Ventilation.active_level = power_distribution.ventilation
	SRA.active_level = power_distribution.sra
	Energy.active_level = power_distribution.energy
	
	# check if they have the correct buildings to enable
	Heating.is_disabled = false
	Cooling.is_disabled = false
	Ventilation.is_disabled = false
	SRA.is_disabled = false
	Energy.is_disabled = false
	
	# update active wing node
	update_wing_node()
	
func on_component_list_update() -> void:
	if !is_node_ready():return
	var power_distribution:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].power_distribution
	
	for index in component_list.size():
		var node:Control = component_list[index].node
		node.make_selectable = index == component_index
		if index == component_index:
			ActiveNode = node
			DescriptionLabel.text = component_list[index].description
	
	# update active wing node
	update_wing_node()
	
func update_wing_node() -> void:
	var ActiveWingNode:Node3D = GBL.find_node(REFS.BASE_RENDER).ActiveWingNode
	if ActiveWingNode != null:
		var power_distribution:Dictionary = room_config.floor[current_location.floor].ring[current_location.ring].power_distribution
		# update active wing node
		ActiveWingNode.highligh_item(component_list[component_index], power_distribution)		
# ------------------------------------------

# ------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_active or resources_data.is_empty(): 
		return

	var key:String = input_data.key
	var power_distribution:Dictionary = base_states.ring[str(current_location.floor, current_location.ring)].power_distribution
	var prop_val:int = power_distribution[component_list[component_index].prop]

	match key:
		"W":
			component_index = U.min_max( component_index - 1, 0, component_list.size() - 1, true )
		"S":
			component_index = U.min_max( component_index + 1, 0, component_list.size() - 1, true )
		"A":
			if ActiveNode.is_disabled:return
			if prop_val > 1:
				resources_data[RESOURCE.CURRENCY.CORE].amount = U.min_max(resources_data[RESOURCE.CURRENCY.CORE].amount + 1, 0, resources_data[RESOURCE.CURRENCY.CORE].capacity)
				base_states.ring[str(current_location.floor, current_location.ring)].power_distribution[component_list[component_index].prop] -= 1
				
				SUBSCRIBE.base_states = base_states
				SUBSCRIBE.resources_data = resources_data
		"D":
			if ActiveNode.is_disabled:return
			if resources_data[RESOURCE.CURRENCY.CORE].amount > 0 and prop_val < 4:
				resources_data[RESOURCE.CURRENCY.CORE].amount = U.min_max(resources_data[RESOURCE.CURRENCY.CORE].amount - 1, 0, resources_data[RESOURCE.CURRENCY.CORE].capacity)
				base_states.ring[str(current_location.floor, current_location.ring)].power_distribution[component_list[component_index].prop] += 1
				
				SUBSCRIBE.base_states = base_states
				SUBSCRIBE.resources_data = resources_data
		

# ------------------------------------------	
