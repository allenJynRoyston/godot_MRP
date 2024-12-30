extends Node3D

@onready var Building:Node3D = $Building
@onready var FloorContainer:Node3D = $Building/FloorContainer
@onready var ElevatorNode:Node3D = $Building/Elevator
@onready var FloorTemplate:Node3D = $Building/FloorContainer/Floor0
@onready var CameraContainers:Node3D = $CameraContainers
@onready var RoamingCamera:Camera3D = $CameraContainers/RoamingCamera

@onready var OverviewCamera:Camera3D = $CameraContainers/OverviewCamera
@onready var FloorCamera:Camera3D = $CameraContainers/FloorCamera
@onready var RingCamera:Camera3D = $CameraContainers/RingCamera
@onready var RoomCamera:Camera3D = $CameraContainers/RoomCamera

@export var render_layer:int = 0 : 
	set(val): 
		render_layer = val
		on_render_layout_update()
		
@export var enable_change_on_update:bool = false		

const RoomMaterialActive:StandardMaterial3D = preload("res://Materials/RoomMaterialActive.tres")
const RoomMaterialInactive:StandardMaterial3D = preload("res://Materials/RoomMaterialInactive.tres")
const RoomMaterialUnavailable:StandardMaterial3D = preload("res://Materials/RoomMaterialUnavailable.tres")
const RoomMaterialActiveUnavailable:StandardMaterial3D = preload("res://Materials/RoomMaterialActiveUnavailable.tres")
const RoomMaterialUnderConstruction:StandardMaterial3D = preload("res://Materials/RoomMaterialUnderConstruction.tres")

var building_setup_complete:bool = false

var camera_settings:Dictionary
var previous_camera_settings:CAMERA.ZOOM
var current_location:Dictionary = {} 
var previous_location:Dictionary = current_location


var room_designations_list:Array = []
var unavailable_rooms:Array = []
var under_construction_rooms:Array = []

var floor_container_nodes:Dictionary = {}
var room_nodes:Dictionary = {}

var use_camera_node:Camera3D
var tween_queue:Array = []

var mesh_material_ref:Dictionary = {} 

var active_nodes:Dictionary = {
	"floor": null,
	"ring": null,
	"room": null
}

var rotate_ring_count:Dictionary = {
	0: 0,
	1: 0,
	2: 0
}

var room_node_refs:Dictionary = {}

# ------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	SUBSCRIBE.subscribe_to_unavailable_rooms(self)
	SUBSCRIBE.subscribe_to_under_construction_rooms(self)
	
	GBL.subscribe_to_process(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)	
	SUBSCRIBE.unsubscribe_to_unavailable_rooms(self)
	SUBSCRIBE.unsubscribe_to_under_construction_rooms(self)
	
	GBL.unsubscribe_to_process(self)
	GBL.remove_from_projected_3d_objects('active_room')
	for key in room_node_refs:
		GBL.remove_from_projected_3d_objects(key)
			
func _ready() -> void:
	camera_setup()
	await building_setup()
	after_ready.call_deferred()

func after_ready() -> void:
	
	on_render_layout_update()	
	on_camera_settings_update()
# ------------------------------------------------

# ------------------------------------------------
func building_setup() -> void:
	for count in [1, 2, 3, 4, 5]:
		var FloorCopy:Node3D = FloorTemplate.duplicate(true)
		FloorContainer.add_child(FloorCopy)
		FloorCopy.position.y = count * -10
		
	building_setup_complete = true

	var floor_func:Callable = func(floor:Node3D, d:Dictionary) -> void:pass
	var ring_func:Callable = func(ring:Node3D, d:Dictionary) -> void:pass
	var room_func:Callable = func(room:Node3D, d:Dictionary) -> void:
		var as_designation:String = "%s%s%s" % [d.floor_index, d.ring_index, d.room_index]
		mesh_material_ref[as_designation] = {
			"node": room
		}
		
	traverse_nodes(floor_func, ring_func, room_func)
	
	await U.tick()
# ------------------------------------------------

# ------------------------------------------------	
func camera_setup() -> void:
	for camera in CameraContainers.get_children():
		camera.current = false
	RoamingCamera.current = true
	RoamingCamera.position = OverviewCamera.position
	RoamingCamera.rotation = OverviewCamera.rotation
# ------------------------------------------------	

# ------------------------------------------------	
func highlight_floor(floor:int) -> void:
	var floor_func:Callable = func(floor:Node3D, d:Dictionary) -> void:pass
	var ring_func:Callable = func(ring:Node3D, d:Dictionary) -> void:pass
	var room_func:Callable = func(room:Node3D, d:Dictionary) -> void:
		set_node_layer(room, 2 if floor == d.floor_index else 1)
	traverse_nodes(floor_func, ring_func, room_func)
# ------------------------------------------------		

# ------------------------------------------------		
func set_node_layer(node: Node3D, layer: int) -> void:
	var layer_mask = 0
	match layer:
		0:
			node.layers = 0xFFFFF  # Enables all layers (1-20)
		1:
			node.layers = (1 << 0)  # Enables only layer 1
		2:
			node.layers = (1 << 1)  # Enables only layer 2
		3:
			node.layers = (1 << 2)  # Enables only layer 3
		4:
			node.layers = (1 << 3)  # Enables only layer 4
		5:
			node.layers = (1 << 4)  # Enables only layer 5
		6:
			node.layers = (1 << 5)  # Enables only layer 6
		7:
			node.layers = (1 << 6)  # Enables only layer 7
		8:
			node.layers = (1 << 7)  # Enables only layer 8
		9:
			node.layers = (1 << 8)  # Enables only layer 9
		10:
			node.layers = (1 << 9)  # Enables only layer 10			
# ------------------------------------------------		

# ------------------------------------------------
func on_render_layout_update() -> void:
	if !is_node_ready():return
	for camera in CameraContainers.get_children():
		match render_layer:
			0:
				camera.cull_mask = 0xFFFFF  # Enables all layers (1-20)
			1:
				camera.cull_mask = (1 << 0)  # Enables only layer 1
			2:
				camera.cull_mask = (1 << 1)  # Enables only layer 2
			3:
				camera.cull_mask = (1 << 2)  # Enables only layer 3
			4:
				camera.cull_mask = (1 << 3)  # Enables only layer 4
			5:
				camera.cull_mask = (1 << 4)  # Enables only layer 5
			6:
				camera.cull_mask = (1 << 5)  # Enables only layer 6
			7:
				camera.cull_mask = (1 << 6)  # Enables only layer 7
			8:
				camera.cull_mask = (1 << 7)  # Enables only layer 8
			9:
				camera.cull_mask = (1 << 8)  # Enables only layer 9
			10:
				camera.cull_mask = (1 << 9)  # Enables only layer 10
# ------------------------------------------------	

# ------------------------------------------------
func traverse_nodes(floor_func:Callable, ring_func:Callable, room_func:Callable) -> void:
	if !building_setup_complete: return
		
	for floor_index in FloorContainer.get_child_count():
		var floor_node:Node3D = FloorContainer.get_child(floor_index)
		var dict:Dictionary = {"room_index": null, "ring_index": null, "floor_index": null}
		dict.floor_index = floor_index
		floor_func.call(floor_node, dict)
		
		var ring_nodes:Node3D = floor_node.get_child(1) # first child is "rings"
		for ring_index in ring_nodes.get_child_count():
			var ring_node:Node3D = ring_nodes.get_child(ring_index)
			dict.ring_index = ring_index
			ring_func.call(ring_node, dict)
			
			var room_nodes:Node3D = ring_node.get_child(1)  #first child is "rooms"
			for room_index in room_nodes.get_child_count():
				var room_node:Node3D = room_nodes.get_child(room_index)
				dict.room_index = room_index				
				room_func.call(room_node, dict)
				
# ------------------------------------------------

# ------------------------------------------------	
func on_under_construction_rooms_update(new_val:Array = under_construction_rooms) -> void:
	under_construction_rooms = new_val
	color_active_node()
# ------------------------------------------------	
	
# ------------------------------------------------	
func on_unavailable_rooms_update(new_val:Array = unavailable_rooms) -> void:
	unavailable_rooms = new_val
	color_active_node()
# ------------------------------------------------		

# ------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:	
	current_location = new_val
	if !is_node_ready() or current_location.is_empty() or !building_setup_complete or camera_settings.is_empty():return
	GBL.add_to_animation_queue(self)
	
	if room_node_refs.is_empty():
		var floor_func:Callable = func(floor:Node3D, d:Dictionary) -> void:pass
		var ring_func:Callable = func(ring:Node3D, d:Dictionary) -> void:pass
		var room_func:Callable = func(room:Node3D, d:Dictionary) -> void:
			var ref_name:String = "%s%s%s" % [d.floor_index, d.ring_index, d.room_index]
			room_node_refs[ref_name] = room
		traverse_nodes(floor_func, ring_func, room_func)	
	
	
	if enable_change_on_update:
		highlight_floor(current_location.floor)

	var new_pos:Vector3 = Building.position
	new_pos.y = (current_location.floor * 10)

	var floor_distance:int = 1 if previous_location.is_empty() else abs(previous_location.floor - current_location.floor)
	var ring_distance:int = 1 if previous_location.is_empty() else abs(previous_location.ring - current_location.ring)
	var room_distance:int = 1 if previous_location.is_empty() else abs(previous_location.room - current_location.room)	
	
	var floor_wait_time = floor_distance * 0.2
	var ring_wait_time = ring_distance * 0.2
	var room_wait_time = room_distance * 0.2
	
	var wait_time:float = max(0.02, floor_wait_time, ring_wait_time, room_wait_time)

	var rotate_building:Callable = func(time:float = 0.3) -> void:
		tween_rotation(Building, Vector3(0, 30 + (current_location.room * 60), 0), time)
	var zoom_to_floor:Callable = func(floor:int = current_location.floor, time:float = 0.3) -> void:
		tween_position(Building, Vector3(0, floor * 10, 0), time)	
	

	match camera_settings.zoom:
		# ------------------
		CAMERA.ZOOM.OVERVIEW:			
			ElevatorNode.visible = true
			if previous_camera_settings != camera_settings.zoom:
				rotate_building.call()
			zoom_to_floor.call(0)
			var floor_func:Callable = func(floor:Node3D, d:Dictionary) -> void:
				floor.visible = true
			var ring_func:Callable = func(ring:Node3D, d:Dictionary) -> void:
				ring.visible = true
			var room_func:Callable = func(room:MeshInstance3D, d:Dictionary) -> void:
				room.visible = true	

			traverse_nodes(floor_func, ring_func, room_func)
		# ------------------
		
		# ------------------
		CAMERA.ZOOM.FLOOR:			
			ElevatorNode.visible = false
			zoom_to_floor.call()
			var floor_func:Callable = func(floor:Node3D, d:Dictionary) -> void:
				floor.visible = current_location.floor <= d.floor_index
			var ring_func:Callable = func(ring:Node3D, d:Dictionary) -> void:
				ring.visible = true
			var room_func:Callable = func(room:MeshInstance3D, d:Dictionary) -> void:
				room.visible = true	
			traverse_nodes(floor_func, ring_func, room_func)
		# ------------------
		
		# ------------------
		CAMERA.ZOOM.RING:				
			zoom_to_floor.call()
			var floor_func:Callable = func(floor:Node3D, d:Dictionary) -> void:
				floor.visible = current_location.floor == d.floor_index
			var ring_func:Callable = func(ring:Node3D, d:Dictionary) -> void:
				ring.visible = true #current_location.ring == d.ring_index
			var room_func:Callable = func(room:MeshInstance3D, d:Dictionary) -> void:
				room.visible = true	
			traverse_nodes(floor_func, ring_func, room_func)
		# ------------------
		
		# ------------------
		CAMERA.ZOOM.RM:			
			rotate_building.call()
			zoom_to_floor.call()
			
			var camera_position:Vector3 = RoomCamera.position
			camera_position.x += (current_location.ring * 10)
			camera_position.z -= (current_location.ring * 5)
			tween_position(RoamingCamera, camera_position, ring_wait_time)
			
			var floor_func:Callable = func(floor:Node3D, d:Dictionary) -> void:
				floor.visible = current_location.floor == d.floor_index
			var ring_func:Callable = func(ring:Node3D, d:Dictionary) -> void:
				ring.visible = current_location.ring == d.ring_index
			var room_func:Callable = func(room:MeshInstance3D, d:Dictionary) -> void:
				room.visible = true
			traverse_nodes(floor_func, ring_func, room_func)
		# ------------------
	
	await color_active_node()
			
	await U.set_timeout(wait_time)
	previous_location = current_location
	GBL.remove_from_animation_queue(self)
# ------------------------------------------------	

# ------------------------------------------------
func color_active_node() -> void:
	if render_layer != 2 or mesh_material_ref.is_empty() or current_location.is_empty():return
	var current_designation:String = "%s%s%s" % [current_location.floor, current_location.ring, current_location.room]

	for key in mesh_material_ref:
		var node:Node3D = mesh_material_ref[key].node
		var box_mesh_copy:BoxMesh = node.mesh.duplicate()
		
		box_mesh_copy.material = RoomMaterialActive if key == current_designation else RoomMaterialInactive
		
		if key in unavailable_rooms:
			box_mesh_copy.material = RoomMaterialUnavailable
			if key == current_designation:
				var material_copy:StandardMaterial3D = RoomMaterialUnavailable.duplicate()
				material_copy.albedo_color = material_copy.albedo_color.lerp(Color(0, 0, 0), 0.5)
				box_mesh_copy.material = material_copy
		
		if key in under_construction_rooms:
			box_mesh_copy.material = RoomMaterialUnderConstruction
			if key == current_designation:
				var material_copy:StandardMaterial3D = RoomMaterialUnderConstruction.duplicate()
				material_copy.albedo_color = material_copy.albedo_color.lerp(Color(0, 0, 0), 0.5)
				box_mesh_copy.material = material_copy			
			
			
		node.mesh = box_mesh_copy
# ------------------------------------------------

# --------------------------------------------------------------------------------------------------		
func rotate_ring(ring_index:int, amount:int) -> void:
	rotate_ring_count[ring_index] += amount
	var val:int = rotate_ring_count[ring_index]
		
	var floor_func:Callable = func(floor:Node3D, d:Dictionary) -> void:pass
	var ring_func:Callable = func(ring:Node3D, d:Dictionary) -> void:
		if d.floor_index == current_location.floor and d.ring_index == current_location.ring:
			await tween_rotation(ring, Vector3(0, val * 60, 0))
			
	var room_func:Callable = func(room:MeshInstance3D, d:Dictionary) -> void:pass
					
	traverse_nodes(floor_func, ring_func, room_func)
# --------------------------------------------------------------------------------------------------		


# ------------------------------------------------
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:	
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return

	GBL.add_to_animation_queue(self)
	
	# adjust the camera prior to changing types
	if previous_camera_settings == CAMERA.ZOOM.OVERVIEW and camera_settings.zoom == CAMERA.ZOOM.FLOOR:
		await tween_rotation(Building, Vector3(0, 30, 0))
		
	# adds some stylish zoom animation	
	if previous_camera_settings == CAMERA.ZOOM.RING and camera_settings.zoom == CAMERA.ZOOM.RM:
		var camera_position:Vector3 = RoamingCamera.position
		var camera_rotation_degree:Vector3 = RoamingCamera.rotation_degrees
		camera_position.y -= 45
		camera_rotation_degree.y -= 90
		await tween_position(RoamingCamera, camera_position, 0.3)
		await tween_rotation(RoamingCamera, camera_rotation_degree, 0.6)

	match camera_settings.zoom:
		CAMERA.ZOOM.OVERVIEW:
			tween_rotation(RoamingCamera, OverviewCamera.rotation_degrees)
			await tween_position(RoamingCamera, OverviewCamera.position)
		CAMERA.ZOOM.FLOOR:
			tween_rotation(RoamingCamera, FloorCamera.rotation_degrees)
			await tween_position(RoamingCamera, FloorCamera.position)			
		CAMERA.ZOOM.RING:
			tween_rotation(RoamingCamera, RingCamera.rotation_degrees)
			await tween_position(RoamingCamera, RingCamera.position)			
		CAMERA.ZOOM.RM:
			tween_rotation(RoamingCamera, RoomCamera.rotation_degrees)
			await tween_position(RoamingCamera, RoomCamera.position)
	
	previous_camera_settings = camera_settings.zoom
	on_current_location_update()
# ------------------------------------------------	

# ------------------------------------------------
func tween_position(node:Node3D, new_position:Vector3, duration:float = 0.3) -> void:
	var position_func:Callable = func(v3: Vector3) -> void:
		node.position = v3
		
	var tween_pos:Tween = create_tween()
	tween_pos.tween_method(position_func, node.position, new_position, duration).set_trans(Tween.TRANS_SINE)
	await tween_pos.finished
# ------------------------------------------------

# ------------------------------------------------
func tween_rotation(node:Node3D, new_rotation:Vector3, duration:float = 0.3) -> void:
	var rotation_func:Callable = func(v3:Vector3) -> void:
		node.rotation_degrees = v3	
	
	var tween_rot:Tween = create_tween()
	tween_rot.tween_method(rotation_func, node.rotation_degrees, new_rotation, duration).set_trans(Tween.TRANS_SINE)
	await tween_rot.finished	
# ------------------------------------------------	

# ------------------------------------------------
func normalize_rotation_degrees(node:Node3D):
	# Normalize each component of rotation_degrees to the range [0, 360)
	node.rotation_degrees.y = fmod(node.rotation_degrees.y, 360)
	if node.rotation_degrees.y < 0:
		node.rotation_degrees.y += 360
# ------------------------------------------------

# ------------------------------------------------
func get_room_position(key:String) -> Vector3:
	var room_node:Node3D = room_node_refs[key]
	var ring_node:Node3D = room_node.get_parent().get_parent()
	var floor_node:Node3D = ring_node.get_parent().get_parent()
	match camera_settings.zoom:
		CAMERA.ZOOM.OVERVIEW:	
			return (room_node.global_position + ring_node.global_position - floor_node.position if camera_settings.zoom == CAMERA.ZOOM.OVERVIEW else 0 ) 
		_:
			return (room_node.global_position + ring_node.global_position ) 
# ------------------------------------------------

# ------------------------------------------------
func on_process_update(delta: float) -> void:	
	if !is_node_ready() or current_location.is_empty() or camera_settings.is_empty():return
	# ensures that building rotation cannot be > 360 degrees
	normalize_rotation_degrees(Building)
	

	if camera_settings.zoom == CAMERA.ZOOM.OVERVIEW:
		Building.rotate_y(0.001)
	
	if room_node_refs.is_empty(): return

	# update active room by moving sprite into location
	var global_pos:Vector3 = get_room_position("%s%s%s" % [current_location.floor, current_location.ring, current_location.room])
	var normalized_position:Vector2 = U.convert_to_normalized_position(get_viewport().size, RoamingCamera.unproject_position(global_pos))
	GBL.update_projected_3D_objects_position('active_room', normalized_position)
	
	# update other room by moving sprite into location
	for key in room_node_refs:
		global_pos = get_room_position(key)
		normalized_position = U.convert_to_normalized_position(get_viewport().size, RoamingCamera.unproject_position(global_pos))
		GBL.update_projected_3D_objects_position(key, normalized_position)	

	
# ------------------------------------------------
