extends PanelContainer

@onready var ImageRect:TextureRect = $MarginContainer2/HBoxContainer/ImageRect
@onready var ActivatedIcon:Control = $MarginContainer2/HBoxContainer/HBoxContainer/HBoxContainer/ActivatedIcon
@onready var RoomIndexLabel:Label = $MarginContainer2/HBoxContainer/HBoxContainer/MarginContainer/RoomIndex
@onready var RoomNameLabel:Label = $MarginContainer2/HBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer/RoomName
@onready var RoomStatus:Label = $MarginContainer2/HBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer/RoomStatus
@onready var StaffCountComponent:Control = $MarginContainer2/HBoxContainer/HBoxContainer/MarginContainer2/VBoxContainer/StaffCountComponent

@onready var room_status_label_settings:LabelSettings = RoomStatus.get("label_settings").duplicate()

const StaticMaterialPreload:ShaderMaterial = preload("res://Shader/Static.tres")

var index:int : 
	set(val):
		index = val
		on_index_update()
		
var room_level_config:Dictionary : 
	set(val):
		room_level_config = val
		on_room_level_config_update()
		
func _ready() -> void:
	RoomStatus.label_settings = room_status_label_settings
	
	on_index_update()
	on_room_level_config_update()
	
func on_index_update() -> void:
	if !is_node_ready():return
	RoomIndexLabel.text = str(index)
	
func on_room_level_config_update() -> void:
	if !is_node_ready() or room_level_config.is_empty():return
	var no_room:bool = room_level_config.room_data.is_empty()
	if no_room:
		RoomNameLabel.text = "UNALLOCATED"
		RoomStatus.text = "INACTIVE"
		ImageRect.texture = PlaceholderTexture2D.new()
		ImageRect.material = StaticMaterialPreload
		# -------------
		StaffCountComponent.is_negative = true
		StaffCountComponent.amount = 0
		# -------------
		ActivatedIcon.icon_color = Color.BLACK
		room_status_label_settings.font_color = Color.DARK_SLATE_GRAY
		return
	
	var room_data:Dictionary = room_level_config.room_data	
	RoomNameLabel.text = room_data.details.shortname
	RoomStatus.text = "ACTIVATED" if room_level_config.is_activated else "INACTIVE"
	
	ImageRect.texture = CACHE.fetch_image(room_data.details.img_src)
	ImageRect.material = null
	# -------------	
	StaffCountComponent.is_negative = !room_level_config.is_activated
	StaffCountComponent.amount = room_data.details.required_staffing.size() if room_level_config.is_activated else 0
	# -------------
	ActivatedIcon.icon_color = Color(0.0, 0.534, 0.129) if room_level_config.is_activated else Color(0.994, 0.205, 0.199)
	room_status_label_settings.font_color = ActivatedIcon.icon_color
	
