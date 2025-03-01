extends GameContainer

@onready var MainPanel:PanelContainer = $Control/PanelContainer
@onready var LocationPanel:Control = $MarginContainer/HBoxContainer/LocationPanel
@onready var RoomLabel:Label = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ImageContainer/RoomLabel
@onready var ResearcherIconContainer:HBoxContainer = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ImageContainer/PanelContainer/TextureRect/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ResearcherIcons
@onready var RIcon1:Control = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ImageContainer/PanelContainer/TextureRect/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ResearcherIcons/RIcon1
@onready var RIcon2:Control = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ImageContainer/PanelContainer/TextureRect/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ResearcherIcons/RIcon2
@onready var ResourceDiffContainer:Control = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ResourceDiffContainer
@onready var ResourceGrid:GridContainer = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ResourceDiffContainer/PanelContainer/MarginContainer/ResourceGrid
@onready var StatusTag:PanelContainer = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ImageContainer/PanelContainer/TextureRect/MarginContainer/StatusTag
@onready var StatusLabel:Label = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ImageContainer/PanelContainer/TextureRect/MarginContainer/StatusTag/MarginContainer/StatusLabel
@onready var ImageContainer:VBoxContainer = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ImageContainer
@onready var ProfileImage:TextureRect = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer2/VBoxContainer/ImageContainer/SubViewport/ProfileImage

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")
const StaticShader:ShaderMaterial = preload("res://Shader/Static.tres")

var previous_location:Dictionary = {}
var metrics_tween_pos_val:float = 0
var panel_restore_pos:int
var is_ready:bool = false

# -----------------------------------------------
func _ready() -> void:
	super._ready()

	MainPanel.modulate = Color(1, 1, 1, 0)	
	await U.set_timeout(1.0)
	panel_restore_pos = MainPanel.position.x
	
	is_ready = true
	update_details_panel()
	on_camera_settings_update()
# -----------------------------------------------

# -----------------------------------------------
func on_is_showing_update() -> void:	
	if !is_node_ready() or camera_settings.is_empty():return	
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
	update_details_panel()

func on_purchased_facility_arr_update(new_val:Array) -> void:
	super.on_purchased_facility_arr_update(new_val)	

func on_resources_data_update(new_val:Dictionary) -> void:
	super.on_resources_data_update(new_val)	

func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	super.on_hired_lead_researchers_arr_update(new_val)
	update_details_panel()

func on_current_location_update(new_val:Dictionary) -> void:
	super.on_current_location_update(new_val)
	if !U.dictionaries_equal(previous_location, current_location):
		previous_location = new_val.duplicate(true)
		update_details_panel()
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
	
	for child in ResourceGrid.get_children():
		child.queue_free()

	var room_extract:Dictionary = ROOM_UTIL.extract_room_details(current_location)
	for key in room_extract.resource_details.total:
		var amount:int = room_extract.resource_details.total[key]
		var resource_details:Dictionary = RESOURCE_UTIL.return_data(key)
		var new_btn:Control = TextBtnPreload.instantiate()
		new_btn.is_hoverable = false
		new_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		new_btn.icon = resource_details.icon
		new_btn.title = "%s%s" % ["+" if amount > 0 else "", amount]
		ResourceGrid.add_child(new_btn)
	ResourceGrid.hide() if room_extract.resource_details.total.is_empty() else ResourceGrid.show()

	if room_extract.is_room_empty:
		if room_extract.is_room_under_construction:
			StatusTag.show()
			StatusLabel.text = "UNDER CONSTRUCTION"
			RoomLabel.text = room_extract.room.details.name
			ImageContainer.show()
			ResourceDiffContainer.hide()
			ResearcherIconContainer.hide()
			ProfileImage.material = null
			ProfileImage.texture = CACHE.fetch_image(room_extract.room.details.img_src)
		else:
			StatusTag.hide()
			RoomLabel.text = "NOTHING ASSIGNED" 
			ProfileImage.material = StaticShader
			ProfileImage.texture = CACHE.fetch_image("")
			ResourceDiffContainer.hide()
			ResearcherIconContainer.hide()
	else:		
		ResourceDiffContainer.hide() if room_extract.resource_details.total.is_empty() else ResourceDiffContainer.show()
		RoomLabel.text = room_extract.room.details.name
		ProfileImage.texture = CACHE.fetch_image(room_extract.room.details.img_src)
		ImageContainer.show()
		ProfileImage.material = null
		
		if !room_extract.is_activated:
			StatusTag.show()
			StatusLabel.text = "INACTIVE"
			ResourceDiffContainer.hide()
		else:
			StatusTag.hide()
			
			
		
	#ScpLabel.text = "" if room_extract.is_scp_empty else room_extract.scp.details.name
	#ScpContainer.hide() if room_extract.is_scp_empty else ScpContainer.show()
	

	RIcon1.static_color = Color.WHITE if room_extract.researchers.size()>= 1 else Color.RED
	RIcon2.static_color = Color.WHITE if room_extract.researchers.size()>= 2 else Color.RED
	
# -----------------------------------------------
