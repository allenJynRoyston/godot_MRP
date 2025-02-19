extends GameContainer

@onready var SummaryList:VBoxContainer = $HBoxContainer/SummaryList
@onready var DetailsPanel:PanelContainer = $DetailsPanel


# -----------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.FLOOR_INFO, self)

func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.FLOOR_INFO)

func _ready() -> void:
	super._ready()
# -----------------------------------------------

# --------------------------------------------------------
func on_camera_settings_update(new_val:Dictionary) -> void:
	super.on_camera_settings_update(new_val)
	if !is_node_ready() or camera_settings.is_empty():return	
	show() if camera_settings.type == CAMERA.TYPE.FLOOR_SELECT else hide()
	
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	super.on_room_config_update(new_val)

func on_purchased_facility_arr_update(new_val:Array) -> void:
	super.on_purchased_facility_arr_update(new_val)	

func on_resources_data_update(new_val:Dictionary) -> void:
	super.on_resources_data_update(new_val)	

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	super.on_hired_lead_researchers_arr_update(new_val)

func on_current_location_update(new_val:Dictionary) -> void:
	super.on_current_location_update(new_val)
# -----------------------------------------------

# -----------------------------------------------
func activate_toggle() -> void:
	var index:int = current_location.ring
# -----------------------------------------------	

# -----------------------------------------------
func update_details_panel() -> void:	
	pass
# -----------------------------------------------
