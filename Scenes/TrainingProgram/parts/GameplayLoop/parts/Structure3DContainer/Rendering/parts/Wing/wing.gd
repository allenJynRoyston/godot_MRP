extends Control

@onready var RenderSubviewport:SubViewport = $SubViewport
@onready var TextureOutput:TextureRect = $TextureRect
@onready var WingRender:Node3D = $SubViewport/WingRender

#@onready var NodeContainer:Node3D = $SubViewport/RoomColumn/NodeContainer
#@onready var FloorMesh:MeshInstance3D = $SubViewport/RoomColumn/FloorMesh
#@onready var CursorLabelSprite:Sprite3D = $SubViewport/RoomColumn/MainCamera/CursorLabelSprite
#@onready var CursorMenuSprite:Sprite3D = $SubViewport/RoomColumn/MainCamera/CursorMenuSprite
#
#@onready var LeftBillboardLabel:Label3D = $SubViewport/RoomColumn/LeftBoard/MsgBoard/Sprite3D/LeftWallLabel
#@onready var RightBillboard:Label3D = $SubViewport/RoomColumn/RightBoard/MsgBoard/Sprite3D/RightWallLabel 
#
#@onready var LeftFloorLabel:Label3D = $SubViewport/RoomColumn/FloorMesh/LeftFloorLabel
#@onready var RightFloorLabel:Label3D = $SubViewport/RoomColumn/FloorMesh/RightFloorLabel
#
#@onready var StatusLabel:Label3D = $SubViewport/RoomColumn/MainCamera/StatusLabel
#@onready var MainCamera:Camera3D = $SubViewport/RoomColumn/MainCamera
#
#@onready var NoPowerLights:Node3D = $SubViewport/RoomColumn/NoPowerLights
#@onready var NormalLights:Node3D = $SubViewport/RoomColumn/NormalLights
#@onready var CautionLights:Node3D = $SubViewport/RoomColumn/CautionLights
#@onready var WarningLights:Node3D = $SubViewport/RoomColumn/WarningLights
#@onready var DangerLights:Node3D = $SubViewport/RoomColumn/DangerLights
#@onready var DangerSpotlights:Node3D = $SubViewport/RoomColumn/DangerLights/Spotlights
#var previous_nuke_state:bool = false
#var nuke_is_triggered:bool = false 

var previous_floor:int = -1
var previous_ring:int = -1

var designation:String
var current_location:Dictionary = {} 
var camera_settings:Dictionary = {}

@export var assigned_location:Dictionary = {} : 
	set(val):
		assigned_location = val
		on_assigned_location_update()


#var node_location:Vector3 
#var camera_settings:Dictionary = {}
#var resources_data:Dictionary = {} 

#var node_refs:Dictionary = {}
#var freeze_input:bool = false 
#var room_config:Dictionary = {}
#var menu_index:int = 0
#var default_camera_rotation:Vector3
#var menu_actions:Array = []

#var previous_nuke_state:bool = false
#var nuke_is_triggered:bool = false 
			
#var is_active:bool = false : 
	#set(val):
		#is_active = val
		#on_is_active_update()
		#
#var enable_room_focus:bool = false : 
	#set(val):
		#enable_room_focus = val
		#on_enable_room_focus()

#var previous_emergency_mode:int = -1
#var in_lockdown:bool = false
#var is_powered:bool = false
#var in_brownout:bool = false
#var emergency_mode:ROOM.EMERGENCY_MODES
#
#var camera_tween:Tween 

# --------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_camera_settings(self)
	#GBL.subscribe_to_control_input(self)
	#GBL.register_node(REFS.WING_RENDER, self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_camera_settings(self)

func _ready() -> void:
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
	var material_duplicate:ShaderMaterial =  TextureOutput.material.duplicate()
	var outline_color:Color = Color.WHITE
	
	match camera_settings.type:
		# ----------------------
		CAMERA.TYPE.ROOM_SELECT:
			outline_color = Color.WHITE	
		# ----------------------
		CAMERA.TYPE.FLOOR_SELECT:
			outline_color = Color.BLACK	
		# ----------------------
		CAMERA.TYPE.WING_SELECT:
			outline_color = Color.BLACK
			
	material_duplicate.set_shader_parameter("outline_color", outline_color )
	TextureOutput.material = material_duplicate
							
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------
func on_assigned_location_update(new_val:Dictionary = assigned_location) -> void:
	if !is_node_ready() or assigned_location.is_empty():return
	if previous_floor != assigned_location.floor or previous_ring != assigned_location.ring:
		previous_floor = assigned_location.floor
		previous_ring = assigned_location.ring
		WingRender.use_location = assigned_location
# --------------------------------------------------------


## --------------------------------------------------------
#func update_nodes() -> void:
	#if assigned_location.is_empty():return
	#var nodeArray:Array = []
	#
	#LeftFloorLabel.text = "FLOOR %s" % [assigned_location.floor]
	#RightFloorLabel.text = "WING %s" % [assigned_location.ring]
	#
	#for node in NodeContainer.get_children():
		#node.update_refs(assigned_location.floor, assigned_location.ring)
#
	#for node in NodeContainer.get_children():
		#node_refs[node.name] = node.get_marker()
		#
		#node.onFocus = func(room_data:Dictionary) -> void:
			#node_location = node.global_position
#
	#var material_copy:StandardMaterial3D = FloorMesh.mesh.material
	#match assigned_location.ring:
		#0:
			#material_copy.albedo_color = Color(0.318, 0.268, 0.108)
		#1:
			#material_copy.albedo_color = Color(0.108, 0.301, 0.349)
		#2:
			#material_copy.albedo_color = Color(0.153, 0.313, 0.197)
		#3:
			#material_copy.albedo_color = Color(0.401, 0.177, 0.347)
			#
	#FloorMesh.mesh.material = material_copy
## --------------------------------------------------------

## --------------------------------------------------------
#func on_room_config_update(new_val:Dictionary = room_config) -> void:
	#room_config = new_val
	#if !is_node_ready() or room_config.is_empty():return	
	#update_nodes()
	##update_boards()	
	#update_room_lighting(true)	
	#U.debounce(str(self.name, "_update_billboards"), update_billboards)
## --------------------------------------------------------

## ------------------------------------------------
#func on_base_states_update(new_base_state:Dictionary) -> void:
	#if !is_node_ready() or new_base_state.is_empty():return
	#if previous_nuke_state != new_base_state.base.onsite_nuke.triggered:
		#nuke_is_triggered = new_base_state.base.onsite_nuke.triggered
		#previous_nuke_state = nuke_is_triggered
		#
	#U.debounce(str(self.name, "_update_billboards"), update_billboards)
## ------------------------------------------------

## --------------------------------------------------------------------------------------------------		
#func tween_node_property(tween:Tween, node:Node, prop:String, new_val, duration:float = 0.3, delay:float = 0, trans:int = Tween.TRANS_QUAD) -> void:
	#if duration == 0:
		#duration = 0.02
		#
	#tween.tween_property(node, prop, new_val, duration).set_trans(trans).set_delay(delay)
	#await tween.finished
## --------------------------------------------------------------------------------------------------		
#
## --------------------------------------------------------
#func on_enable_room_focus() -> void:
	#for node in NodeContainer.get_children():
		#node.enable_focus = enable_room_focus
## --------------------------------------------------------	

## --------------------------------------------------------
#func on_is_active_update() -> void:
	#if !is_node_ready() or current_location.is_empty():return
	#reset_node(current_location.room, is_active)
## --------------------------------------------------------
#
## --------------------------------------------------------
#func reset_node(room:int, state:bool) -> void:
	#if node_refs.is_empty():return
	#var node:Node3D = node_refs[str(room)]		
	#U.tween_node_property(node, "position:y", 2.5 if state else 0)
	#node.show_internal = state
## --------------------------------------------------------	

## --------------------------------------------------------
#func get_room_position(room_index:int) -> Vector2:
	#if node_refs.is_empty():
		#return Vector2(-1, -1)
#
	#var RoomNode:Node3D = node_refs[str(room_index)]
	#var viewport := MainCamera.get_viewport()
	#var screen_position := MainCamera.unproject_position(RoomNode.global_position)
#
	## Convert screen position to Control node's local space
	#return screen_position / self.size
## --------------------------------------------------------
#
## --------------------------------------------------------
#func camera_rotate_left() -> void:
	#await U.tween_node_property(MainCamera, "rotation:y", default_camera_rotation.y + 0.1, 0.5)
	#
#func camera_rotate_right() -> void:
	#await U.tween_node_property(MainCamera, "rotation:y", default_camera_rotation.y - 0.1, 0.5)
#
#func camera_center() -> void:
	#await U.tween_node_property(MainCamera, "rotation:y", default_camera_rotation.y, 0.5)
## --------------------------------------------------------
#


#
## --------------------------------------------------------
#func update_camera_size(val:int) -> void:
	#U.tween_node_property(MainCamera, "size", val, 0.7, 0)	
## --------------------------------------------------------
#
## --------------------------------------------------------
#func _process(delta: float) -> void:
	#if !is_node_ready():return
	#if in_lockdown or emergency_mode == ROOM.EMERGENCY_MODES.DANGER:
		#for child in DangerSpotlights.get_children():
			#child.find_child("Spotlight").rotate_x(0.1)
			#child.find_child("Spotlight").rotate_y(0.01)
## --------------------------------------------------------
