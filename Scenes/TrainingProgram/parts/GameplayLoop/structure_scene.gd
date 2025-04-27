extends Node3D

@onready var RoomNodeViewport:SubViewport = $SubViewport
@onready var RoomNode:Control = $SubViewport/RoomNode

@onready var ActiveCamera:Camera3D = $CameraContainers/ActiveCamera
@onready var FloorPlaceholderCamera:Camera3D = $CameraContainers/FloorPlaceholderCamera
@onready var RoomPlaceholderCamera:Camera3D = $CameraContainers/RoomPlaceholderCamera

@onready var FloorScene:Node3D = $FloorScene
@onready var FloorInstance:Node3D = $FloorScene/FloorInstance
@onready var FloorInstanceContainer:Node3D = $FloorScene/FloorInstanceContainer
@onready var FloorNodeSprite:Sprite3D = $FloorScene/FloorNodeSprite

@onready var RoomScene:Node3D = $RoomScene
@onready var RoomInstance:MeshInstance3D = $RoomScene/RoomInstance
@onready var RoomColumnContainer:Node3D = $RoomScene/RoomColumnContainer
@onready var RoomNodeSprite:Sprite3D = $RoomScene/RoomNodeContainer/Sprite3D

const TransparencyShaderPreload:ShaderMaterial = preload("res://Shader/Spatial/Transparency.tres")
const RoomMaterialActive:StandardMaterial3D = preload("res://Materials/RoomMaterialUnderConstruction.tres")
const RoomMaterialInactive:StandardMaterial3D = preload("res://Materials/RoomMaterialInactive.tres")

var camera_settings:Dictionary = {} 
var current_location:Dictionary = {} 

var previous_grid_size:Vector2
var previous_location_data:String = "" 
var previous_floor:int = -1
var previous_ring:int = -1

var freeze_input:bool = false 
var previous_camera_type:int = -1 

signal animate_next_complete
signal menu_response

# ------------------------------------------------
func _init() -> void:
	GBL.register_node(REFS.RENDERING, self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.RENDERING)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)	
	
func _ready() -> void:	
	build_floors()
	assign_room_node_location(0, 0, false)
# ------------------------------------------------

# ------------------------------------------------
func get_preview_viewport() -> SubViewport:
	return RoomNodeViewport
# ------------------------------------------------

# ------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	
	update_cameras()
# ------------------------------------------------

# ------------------------------------------------
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
	
	var skip_ani:bool = camera_settings.type == CAMERA.TYPE.WING_SELECT and previous_camera_type == CAMERA.TYPE.ROOM_SELECT
	
	if previous_camera_type != camera_settings.type:
		previous_camera_type = camera_settings.type
		await update_cameras()
		
		GBL.add_to_animation_queue(self)
	
		match camera_settings.type:
			CAMERA.TYPE.FLOOR_SELECT:
				await U.tween_node_property(ActiveCamera, "size", 0, 0.3 )
				await U.set_timeout(0.3)
				ActiveCamera.rotation = FloorPlaceholderCamera.rotation
				ActiveCamera.position = FloorPlaceholderCamera.position
				await U.tween_node_property(ActiveCamera, "size", FloorPlaceholderCamera.size, 0.3)	
			CAMERA.TYPE.WING_SELECT:
				if !skip_ani:
					await U.tween_node_property(ActiveCamera, "size", 0, 0.3 )
					await U.set_timeout(0.3)
					ActiveCamera.rotation = RoomPlaceholderCamera.rotation
					ActiveCamera.position = RoomPlaceholderCamera.position
					await U.tween_node_property(ActiveCamera, "size", RoomPlaceholderCamera.size, 0.3)	

			
		GBL.remove_from_animation_queue(self)
# ------------------------------------------------


# ------------------------------------------------
func assign_room_node_location(floor_val:int, ring_val:int, animate:bool) -> void:
	GBL.add_to_animation_queue(self)
	
	if animate:
		U.tween_node_property(ActiveCamera, "size", 1, 0.2)
		await U.tween_node_property(RoomNodeSprite, "scale:x", 0, 0.2)

	RoomNode.assigned_location = {"floor": floor_val, "ring": ring_val}
	
	if animate:
		await U.set_timeout(0.1)
		U.tween_node_property(ActiveCamera, "size", RoomPlaceholderCamera.size, 0.2)
		await U.tween_node_property(RoomNodeSprite, "scale:x", 1, 0.2)
	
	if !animate:
		await U.tick()
	
	
	
	GBL.remove_from_animation_queue(self)	
	animate_next_complete.emit()
# ------------------------------------------------

# ------------------------------------------------
func update_cameras() -> void:	
	if !is_node_ready() or camera_settings.is_empty() or current_location.is_empty() or FloorInstanceContainer.get_child_count() == 0:return	

	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			for floor_index in FloorInstanceContainer.get_child_count():
				var floor_node:Node3D = FloorInstanceContainer.get_child(floor_index)
				for ring_index in floor_node.get_child_count():
					var child:MeshInstance3D = floor_node.get_child(ring_index)
					var mesh_duplicate = child.mesh.duplicate()
					if floor_index < current_location.floor:
						mesh_duplicate.material = TransparencyShaderPreload.duplicate()		
					else:					
						var material_copy:StandardMaterial3D = RoomMaterialActive.duplicate() if floor_index == current_location.floor and ring_index == current_location.ring else RoomMaterialInactive.duplicate()
						material_copy.albedo_color = material_copy.albedo_color.lerp(Color(0, 0, 0), 0.5)
						mesh_duplicate.material = material_copy		
					child.mesh = mesh_duplicate	
#
		#
		#CAMERA.TYPE.WING_SELECT:
	if previous_ring != current_location.ring or previous_floor != current_location.floor:
		previous_ring = current_location.ring
		previous_floor = current_location.floor
		assign_room_node_location(current_location.floor, current_location.ring, camera_settings.type == CAMERA.TYPE.WING_SELECT)

		#U.tween_range(FloorScene.rotation.y, deg_to_rad( (90 * current_location.ring) + 45), 0.3, func(val:float) -> void:
			#FloorScene.rotation.y = val
		#)
# ------------------------------------------------

# ------------------------------------------------
func build_floors() -> void:
	for n in range(7):
		var floor_duplicate:Node3D = FloorInstance.duplicate()
		floor_duplicate.show()
		floor_duplicate.position.y = n * -10
		FloorInstanceContainer.add_child(floor_duplicate)
	FloorInstance.queue_free()
# ------------------------------------------------
