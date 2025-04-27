extends GameContainer

@onready var LocationPanel:Control = $MarginContainer/HBoxContainer/LocationPanel
@onready var MainControlPanel:PanelContainer = $Control/PanelContainer

@onready var ExpandListContainer:VBoxContainer = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/ExpandListContainer
@onready var ExpandSubListContainer:VBoxContainer = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/ExpandListContainer/ExpandSubListContainer

@onready var RoomDetailsPanel:Control = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/ExpandListContainer/HBoxContainer/RoomDetailsPanel
@onready var ScpPanel:Control = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/ExpandListContainer/HBoxContainer/ScpPanel
@onready var StaffingPanel:Control = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/ExpandListContainer/ExpandSubListContainer/StaffingPanel
@onready var ResourcePanel:Control = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/ExpandListContainer/ExpandSubListContainer/ResourcePanel
@onready var Abilities:Control = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/ExpandListContainer/ExpandSubListContainer/Abilities


var previous_location:Dictionary = {}
var metrics_tween_pos_val:float = 0
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

	MainControlPanel.modulate = Color(1, 1, 1, 0)	

	update_details_panel()
	on_camera_settings_update()
	on_expand_update()
	
	control_pos[MainControlPanel] = {"show": MainControlPanel.position.x, "hide": MainControlPanel.position.x - MainControlPanel.size.x}
	is_ready = true
	on_is_showing_update(true)
# -----------------------------------------------

# -----------------------------------------------
func on_is_showing_update(skip_animation:bool = false) -> void:	
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty() or camera_settings.is_empty():return
	
	U.tween_node_property(MainControlPanel, "modulate", Color(1, 1, 1, 1 if is_showing else 0), 0.3 if !skip_animation else 0)
	
	if is_showing and camera_settings.type == CAMERA.TYPE.WING_SELECT:
		U.tween_node_property(MainControlPanel, "position:x", control_pos[MainControlPanel].show, 0.3 if !skip_animation else 0)
	
	if !is_showing:
		U.tween_node_property(MainControlPanel, "position:x", control_pos[MainControlPanel].hide, 0.3 if !skip_animation else 0)
# -----------------------------------------------	

# --------------------------------------------------------
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	super.on_camera_settings_update(new_val)
	if !is_node_ready() or camera_settings.is_empty() or !is_ready:return	
	match camera_settings.type:
		CAMERA.TYPE.WING_SELECT:
			is_showing = true
			LocationPanel.show()
		CAMERA.TYPE.FLOOR_SELECT:
			is_showing = false
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
	var extract_data:Dictionary = GAME_UTIL.extract_room_details(current_location)
	var is_room_empty:bool = extract_data.is_room_empty
	var is_activated:bool = extract_data.is_activated
	var is_scp_empty:bool = extract_data.is_scp_empty

	RoomDetailsPanel.extract_data = extract_data	
	Abilities.extract_data = extract_data
	
	#StaffingPanel.list = [] if is_room_empty else [] #ROOM_UTIL.return_activation_cost(extract_data.room.details.ref)
	#ResourcePanel.list = extract_data.resources_as_list
	
	if !is_scp_empty:
		ScpPanel.ref = extract_data.scp.details.ref
	
	ScpPanel.hide() if is_scp_empty else ScpPanel.show()
	StaffingPanel.show() if is_activated else StaffingPanel.hide()
	Abilities.show() if is_activated else Abilities.hide()
# -----------------------------------------------

# -----------------------------------------------
func on_expand_update() -> void:
	if !is_node_ready():return
	var expand_current_val:float = ExpandListContainer.get('theme_override_constants/separation')
	U.tween_range(expand_current_val, 10 if expand else -60, 0.2, func(val:float) -> void:
		ExpandListContainer.set("theme_override_constants/separation", val)
	) 
	
	var expandsub_current_val:float = ExpandSubListContainer.get('theme_override_constants/separation')
	U.tween_range(expandsub_current_val, 10 if expand else -45, 0.2, func(val:float) -> void:
		ExpandSubListContainer.set("theme_override_constants/separation", val)
	)  	
	
	for node in [StaffingPanel, ResourcePanel, Abilities]:
		U.tween_node_property(node, "modulate", Color(1, 1, 1, 1 if expand else 0), 0.2)


func toggle_expand() -> void:
	expand = !expand
# -----------------------------------------------
