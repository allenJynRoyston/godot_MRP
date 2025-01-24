extends Node3D

@onready var SpriteLayer:Node3D = $SpriteLayer
@onready var ControlSubViewport:SubViewport = $ControlSubViewport
@onready var ControlPanelContainer:PanelContainer = $ControlSubViewport/ControlPanelContainer

@onready var FloorScene:Node3D = $FloorScene
@onready var FloorInstance:MeshInstance3D = $FloorScene/FloorInstance
@onready var FloorInstanceContainer:Node3D = $FloorScene/FloorInstanceContainer

@onready var RoomScene:Node3D = $RoomScene
@onready var RoomInstance:MeshInstance3D = $RoomScene/RoomInstance
@onready var RoomColumnContainer:Node3D = $RoomScene/RoomColumnContainer
@onready var CursorLabel:Label = $ControlSubViewport/ControlPanelContainer/MarginContainer/VBoxContainer/CursorLabel
#
@onready var ActiveCamera:Camera3D = $CameraContainers/ActiveCamera
@onready var FloorPlaceholderCamera:Camera3D = $CameraContainers/FloorPlaceholderCamera
@onready var RoomPlaceholderCamera:Camera3D = $CameraContainers/RoomPlaceholderCamera


const RoomMaterialActive:StandardMaterial3D = preload("res://Materials/RoomMaterialUnderConstruction.tres")
const RoomMaterialInactive:StandardMaterial3D = preload("res://Materials/RoomMaterialInactive.tres")
#const RoomMaterialUnavailable:StandardMaterial3D = preload("res://Materials/RoomMaterialUnavailable.tres")
#const RoomMaterialActiveUnavailable:StandardMaterial3D = preload("res://Materials/RoomMaterialActiveUnavailable.tres")
#const RoomMaterialUnderConstruction:StandardMaterial3D = preload("res://Materials/RoomMaterialUnderConstruction.tres")
#const RoomMaterialBuilt:StandardMaterial3D = preload("res://Materials/RoomMaterialBuilt.tres")

var room_config:Dictionary = {}
var camera_settings:Dictionary = {} 
var current_location:Dictionary = {} 
var setup_complete:bool = false
var previous_grid_size:Vector2
var previous_location_data:String = "" 
var previous_floor:int = -1
var previous_ring:int = -1


var default_positions:Dictionary = {}

# ------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	SUBSCRIBE.subscribe_to_unavailable_rooms(self)
	SUBSCRIBE.subscribe_to_under_construction_rooms(self)
	SUBSCRIBE.subscribe_to_built_rooms(self)
	SUBSCRIBE.subscribe_to_room_config(self)
	GBL.subscribe_to_process(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)	
	SUBSCRIBE.unsubscribe_to_unavailable_rooms(self)
	SUBSCRIBE.unsubscribe_to_under_construction_rooms(self)
	SUBSCRIBE.unsubscribe_to_built_rooms(self)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	GBL.unsubscribe_to_process(self)

func _ready() -> void:
	_on_panel_container_item_rect_changed()
	after_ready.call_deferred()

func after_ready() -> void:
	on_camera_settings_update()
	on_current_location_update()
# ------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready():return
	if !setup_complete:
		setup_complete = true
		build_floors()
# --------------------------------------------------------------------------------------------------

# ------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	update_cameras()
# ------------------------------------------------

# ------------------------------------------------
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
	await update_cameras()
	
	GBL.add_to_animation_queue(self)
	
	match camera_settings.type:
		CAMERA.TYPE.FLOOR_SELECT:
			tween_property(ActiveCamera, "size", FloorPlaceholderCamera.size, 0.3)	
			tween_property(ActiveCamera, "rotation", FloorPlaceholderCamera.rotation, 0.5)	
			await tween_property(ActiveCamera, "position", FloorPlaceholderCamera.position, 0.5)	
			
		CAMERA.TYPE.ROOM_SELECT:
			tween_property(ActiveCamera, "size", RoomPlaceholderCamera.size, 0.3)	
			tween_property(ActiveCamera, "rotation", RoomPlaceholderCamera.rotation, 0.5)	
			await tween_property(ActiveCamera, "position", RoomPlaceholderCamera.position, 0.5)		
			
	GBL.remove_from_animation_queue(self)
	
	
# ------------------------------------------------


# ------------------------------------------------
func update_cameras() -> void:
	if !is_node_ready() or camera_settings.is_empty():return	

	match camera_settings.type:
		CAMERA.TYPE.ROOM_SELECT:
			if previous_ring != current_location.ring:
				previous_ring = current_location.ring
				GBL.add_to_animation_queue(self)
				await tween_property(ActiveCamera, "rotation_degrees:y", -90 * current_location.ring, 0.5)
				GBL.remove_from_animation_queue(self)	
				
				
		CAMERA.TYPE.FLOOR_SELECT:
			CursorLabel.text = ">> FLOOR %s" % [current_location.floor]

			if previous_floor != current_location.floor:
				previous_floor = current_location.floor
				
				for index in FloorInstanceContainer.get_child_count():
					var floor_node:MeshInstance3D = FloorInstanceContainer.get_child(index)
					var mesh_duplicate = floor_node.mesh.duplicate()
					var material_copy:StandardMaterial3D = RoomMaterialActive.duplicate() if index == current_location.floor else RoomMaterialInactive.duplicate()
					material_copy.albedo_color = material_copy.albedo_color.lerp(Color(0, 0, 0), 0.5)
					mesh_duplicate.material = material_copy		
					floor_node.mesh = mesh_duplicate	
	
				GBL.add_to_animation_queue(self)
				await tween_property(SpriteLayer, "position", FloorInstanceContainer.get_child(current_location.floor).position + Vector3(-30, 15, 0) , 0.2)	
				GBL.remove_from_animation_queue(self)	

# ------------------------------------------------

# ------------------------------------------------
func build_floors() -> void:
	for n in range(room_config.floor.size() ):
		var floor_duplicate:MeshInstance3D = FloorInstance.duplicate()
		floor_duplicate.show()
		floor_duplicate.position.y = n * -10
		FloorInstanceContainer.add_child(floor_duplicate)
# ------------------------------------------------


# ------------------------------------------------
func tween_property(node:Node3D, property:String, new_val, duration:float = 0.3) -> void:
	var tween_pos:Tween = create_tween()
	tween_pos.tween_property(node, property, new_val, duration).set_trans(Tween.TRANS_SINE)
	await tween_pos.finished
# ------------------------------------------------


# ------------------------------------------------
func on_process_update(delta: float) -> void:	
	if !is_node_ready():return
# ------------------------------------------------

# ------------------------------------------------
func _on_panel_container_item_rect_changed() -> void:
	if !is_node_ready():return
	await U.tick()
	ControlSubViewport.size = ControlPanelContainer.size
# ------------------------------------------------
