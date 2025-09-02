extends Control

@onready var RenderSubviewport:SubViewport = $SubViewport
@onready var TextureOutput:TextureRect = $TextureRect
@onready var WingRender:Node3D = $SubViewport/WingRender

@onready var texture_rect_shader:ShaderMaterial = TextureOutput.material.duplicate()

var previous_floor:int = -1
var previous_ring:int = -1

var designation:String
var current_location:Dictionary = {} 
var camera_settings:Dictionary = {}

@export var assigned_location:Dictionary = {} : 
	set(val):
		assigned_location = val
		on_assigned_location_update()

# --------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_camera_settings(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_camera_settings(self)

func _ready() -> void:
	TextureOutput.set("material", texture_rect_shader)
	on_assigned_location_update()
# --------------------------------------------------------

# --------------------------------------------------------
func get_preview_viewport() -> SubViewport:
	return RenderSubviewport
# --------------------------------------------------------

# --------------------------------------------------------
func set_current_location(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	
	if designation != U.location_to_designation(current_location):
		designation = U.location_to_designation(current_location)
		
		on_assigned_location_update()

	assigned_location = current_location
# --------------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
	var outline_color:Color = Color.WHITE
	
	match camera_settings.type:
		# ----------------------
		CAMERA.TYPE.ROOM_SELECT:
			outline_color = Color.WHITE	
		# ----------------------
		CAMERA.TYPE.FLOOR_SELECT:
			outline_color = Color.WHITE	
		# ----------------------
		CAMERA.TYPE.WING_SELECT:
			outline_color = Color.WHITE
	
	texture_rect_shader.set_shader_parameter("outline_color", outline_color )
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func set_outline(state:bool) -> void:
	texture_rect_shader.set_shader_parameter("outline_thickness", 10 if state else 0 )
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------
func on_assigned_location_update(new_val:Dictionary = assigned_location) -> void:
	if !is_node_ready() or assigned_location.is_empty():return
	if previous_floor != assigned_location.floor or previous_ring != assigned_location.ring:
		previous_floor = assigned_location.floor
		previous_ring = assigned_location.ring
		WingRender.use_location = assigned_location
# --------------------------------------------------------
