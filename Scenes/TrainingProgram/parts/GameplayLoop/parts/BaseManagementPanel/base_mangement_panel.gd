extends SubscribeWrapper

@onready var FloorLabel:Label = $VBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/FloorLabel
@onready var RingLabel:Label = $VBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer/RingLabel
@onready var CoreAmountLabel:Label = $VBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer2/VBoxContainer2/HBoxContainer4/MarginContainer/VBoxContainer/HBoxContainer/CoreAmountLabel

@onready var DescriptionPanel:PanelContainer = $DescriptionControl/PanelContainer
@onready var DescriptionMargin:MarginContainer = $DescriptionControl/PanelContainer/MarginContainer
@onready var DescriptionLabel:Label = $DescriptionControl/PanelContainer/MarginContainer/HBoxContainer/DescriptionLabel

@onready var Heating:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Heating
@onready var Cooling:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Cooling
@onready var Ventilation:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Ventilation
@onready var Security:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Security
@onready var Energy:Control = $VBoxContainer/Content/MarginContainer/HBoxContainer/VBoxContainer/Energy

@onready var component_list:Array = [
	{"node": Heating, "prop": "heating", "description": "Keeps rooms warm and comfortable."}, 
	{"node": Cooling, "prop": "cooling", "description": "Keeps temperatures cool and pleasant."}, 
	{"node": Ventilation, "prop": "ventilation", "description": "Circulates fresh air throughout the wing."}, 
	#{"node": Security, "prop": "security", "description": "Protects the wing from intruders and hazards."}, 
	{"node": Energy, "prop": "energy", "description": "Tracks and manages available energy for the wing."}, 
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
	print(control_pos[DescriptionPanel])
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
	
	# update labels
	FloorLabel.text = str(current_location.floor)
	RingLabel.text = str(current_location.ring)
	CoreAmountLabel.text = str(resources_data[RESOURCE.CURRENCY.CORE].amount)
	
	# update values
	Heating.active_level = power_distribution.heating
	Cooling.active_level = power_distribution.cooling
	Ventilation.active_level = power_distribution.ventilation
	Security.active_level = power_distribution.security
	Energy.active_level = power_distribution.energy
	
func on_component_list_update() -> void:
	if !is_node_ready():return
	for index in component_list.size():
		var node:Control = component_list[index].node
		node.make_selectable = index == component_index
		if index == component_index:
			ActiveNode = node
			DescriptionLabel.text = component_list[index].description
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
			if prop_val > 1:
				resources_data[RESOURCE.CURRENCY.CORE].amount = U.min_max(resources_data[RESOURCE.CURRENCY.CORE].amount + 1, 0, resources_data[RESOURCE.CURRENCY.CORE].capacity)
				base_states.ring[str(current_location.floor, current_location.ring)].power_distribution[component_list[component_index].prop] -= 1
				
				SUBSCRIBE.base_states = base_states
				SUBSCRIBE.resources_data = resources_data
		"D":
			if resources_data[RESOURCE.CURRENCY.CORE].amount > 0 and prop_val < 4:
				resources_data[RESOURCE.CURRENCY.CORE].amount = U.min_max(resources_data[RESOURCE.CURRENCY.CORE].amount - 1, 0, resources_data[RESOURCE.CURRENCY.CORE].capacity)
				base_states.ring[str(current_location.floor, current_location.ring)].power_distribution[component_list[component_index].prop] += 1
				
				SUBSCRIBE.base_states = base_states
				SUBSCRIBE.resources_data = resources_data
		

# ------------------------------------------	
