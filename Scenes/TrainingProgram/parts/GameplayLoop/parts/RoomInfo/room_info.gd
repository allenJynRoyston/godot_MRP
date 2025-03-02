@tool
extends GameContainer

@onready var MainPanel:PanelContainer = $Control/PanelContainer
@onready var LocationPanel:Control = $MarginContainer/HBoxContainer/LocationPanel
@onready var MainControlPanel:PanelContainer = $Control/PanelContainer

@onready var ExpandListContainer:VBoxContainer = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer
@onready var RoomDetailsPanel:Control = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/RoomDetailsPanel
@onready var StaffingPanel:Control = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/StaffingPanel
@onready var ResourcePanel:Control = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ResourcePanel
@onready var Abilities:Control = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/Abilities

var control_pos:Dictionary 
var previous_location:Dictionary = {}
var metrics_tween_pos_val:float = 0
var panel_restore_pos:int
var is_ready:bool = false

@export var expand:bool = false : 
	set(val):
		expand = val
		on_expand_update()

# -----------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.ROOM_INFO, self)
	
func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.ROOM_INFO)
	
func _ready() -> void:
	super._ready()

	MainPanel.modulate = Color(1, 1, 1, 0)	
	await U.set_timeout(1.0)
	panel_restore_pos = MainPanel.position.x
	
	is_ready = true
	update_details_panel()
	on_camera_settings_update()
	
	control_pos[MainControlPanel] = {"show": MainControlPanel.position.x, "hide": MainControlPanel.position.x - MainControlPanel.size.x}
	print(control_pos)
# -----------------------------------------------

# -----------------------------------------------
func on_is_showing_update() -> void:	
	if !is_node_ready() or camera_settings.is_empty() or control_pos.is_empty():return	
	U.tween_node_property(MainControlPanel, "position:x", control_pos[MainControlPanel].show if is_showing else control_pos[MainControlPanel].hide)
# -----------------------------------------------	

# --------------------------------------------------------
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	super.on_camera_settings_update(new_val)
	if !is_node_ready() or camera_settings.is_empty() or !is_ready:return	
	if camera_settings.type == CAMERA.TYPE.ROOM_SELECT:
		MainPanel.modulate = Color(1, 1, 1, 1)
		U.tween_node_property(MainPanel, "position:x", panel_restore_pos, 0.7)
		LocationPanel.show()
	else:
		U.tween_node_property(MainPanel, "position:x", panel_restore_pos - MainPanel.size.x - 20, 0.7)
		LocationPanel.hide()

func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return		
	U.debounce("update_details_panel", update_details_panel)

func on_purchased_facility_arr_update(new_val:Array) -> void:
	super.on_purchased_facility_arr_update(new_val)	

func on_resources_data_update(new_val:Dictionary) -> void:
	super.on_resources_data_update(new_val)	

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	super.on_hired_lead_researchers_arr_update(new_val)
	U.debounce("update_details_panel", update_details_panel)

func on_current_location_update(new_val:Dictionary) -> void:
	super.on_current_location_update(new_val)
	if !U.dictionaries_equal(previous_location, current_location):
		previous_location = new_val.duplicate(true)
		U.debounce("update_details_panel", update_details_panel)
# -----------------------------------------------

# -----------------------------------------------
func merge_metric_data(arr:Array) -> Array:
	var dict:Dictionary = {}
	for item in arr:
		if item.resource_data.ref not in dict:
			dict[item.resource_data.ref] = item
		dict[item.resource_data.ref].amount += item.amount
	
	var return_as_list:Array = []
	for key in dict:
		return_as_list.push_back(dict[key])
	return return_as_list
# -----------------------------------------------	

# -----------------------------------------------
func update_details_panel() -> void:	
	if !is_node_ready() or current_location.is_empty() or room_config.is_empty() or resources_data.is_empty():return
	var extract_data:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	var is_room_empty:bool = extract_data.is_room_empty
	var is_activated:bool = extract_data.is_activated
	

	RoomDetailsPanel.extract_data = extract_data	
	Abilities.extract_data = extract_data
	
	StaffingPanel.list = [] if is_room_empty else ROOM_UTIL.return_activation_cost(extract_data.room.details.ref)
	ResourcePanel.list = extract_data.resources_as_list
	
	StaffingPanel.show() if is_activated else StaffingPanel.hide()
	Abilities.show() if is_activated else Abilities.hide()
# -----------------------------------------------

# -----------------------------------------------
func on_expand_update() -> void:
	if !is_node_ready():return
	var current_val:float = ExpandListContainer.get('theme_override_constants/separation')
	await U.tween_range(current_val, 10 if expand else -45, 0.2, func(val:float) -> void:
		ExpandListContainer.set("theme_override_constants/separation", val)
	).finished  

func toggle_expand() -> void:
	expand = !expand
# -----------------------------------------------
