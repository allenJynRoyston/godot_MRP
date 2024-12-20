@tool
extends Node3D

@onready var Building:Node3D = $Building
@onready var FloorContainer:Node3D = $Building/FloorContainer
@onready var ElevatorNode:Node3D = $Building/Elevator

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

var current_camera_zoom:CAMERA.ZOOM = CAMERA.ZOOM.FLOOR : 
	set(val):
		previous_state = current_camera_zoom
		current_camera_zoom = val
		on_current_camera_zoom_update()		
var previous_state:CAMERA.ZOOM = current_camera_zoom

var current_location:Dictionary = {} : 
	set(val):
		previous_location = current_location
		current_location = val
		on_current_location_update()
var previous_location:Dictionary = current_location

var building_nodes:Dictionary = {}
var room_nodes:Dictionary = {}
var use_camera_node:Camera3D
var tween_queue:Array = []


# ------------------------------------------------
func _ready() -> void:
	for floor_index in FloorContainer.get_child_count():
		var floor_container:Node3D = FloorContainer.get_child(floor_index)
		var ring_container:Node3D = floor_container.find_child("rings")
		
		room_nodes[floor_index] = []
		
		building_nodes[floor_index] = {
			"floor_container": floor_container,
			"ring_container": ring_container,
			"rings": {}
		}		
		
		for ring_index in ring_container.get_child_count():
			var ring_child:Node3D = ring_container.get_child(ring_index)
			var room_container:Node3D = ring_child.find_child("rooms")
			building_nodes[floor_index].rings[ring_index] = {
				"node": ring_child,
				"room_container": room_container,
				"room": {}
			}
			
			for room_index in room_container.get_child_count():
				var room_child:Node3D = room_container.get_child(room_index)
				building_nodes[floor_index].rings[ring_index].room[room_index] = room_child
				room_nodes[floor_index].push_back(room_child)
				
	camera_setup()
	on_render_layout_update()
	on_current_camera_zoom_update()
	
	
func _init() -> void:
	GBL.subscribe_to_process(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)
# ------------------------------------------------

# ------------------------------------------------	
func camera_setup() -> void:
	for camera in CameraContainers.get_children():
		camera.current = false
	RoamingCamera.current = true
# ------------------------------------------------	

# ------------------------------------------------	
func highlight_floor(floor:int) -> void:
	for index in room_nodes:				
		for room in room_nodes[index]:
			set_node_layer(room, 2 if floor == index else 1)
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
func on_current_location_update() -> void:	
	if !is_node_ready() or current_location.is_empty():return
	GBL.add_to_animation_queue(self)
	
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

	match current_camera_zoom:
		CAMERA.ZOOM.OVERVIEW:
			tween_position(Building, Vector3(0, current_location.floor * 10, 0), floor_wait_time)
		CAMERA.ZOOM.FLOOR:
			tween_position(Building, Vector3(0, current_location.floor * 10, 0), floor_wait_time)
			var camera_position:Vector3 = FloorCamera.position
			camera_position.x -= (current_location.ring * 10)
			tween_position(RoamingCamera, camera_position, 0.3)
			tween_rotation(Building, Vector3(0, 30 + (current_location.room * 60), 0), room_wait_time)
		CAMERA.ZOOM.RING:	
			tween_position(Building, Vector3(0, current_location.floor * 10, 0), floor_wait_time)
			tween_rotation(Building, Vector3(0, 30 + (current_location.room * 60), 0), room_wait_time)
		CAMERA.ZOOM.RM:
			tween_position(Building, Vector3(0, current_location.floor * 10, 0), floor_wait_time)
			var camera_position:Vector3 = RoomCamera.position
			camera_position.x += (current_location.ring * 10)
			camera_position.z -= (current_location.ring * 5)
			tween_position(RoamingCamera, camera_position, ring_wait_time)
			tween_rotation(Building, Vector3(0, 30 + (current_location.room * 60), 0), room_wait_time)
			
	await U.set_timeout(wait_time)
	previous_location = current_location
	GBL.remove_from_animation_queue(self)
# ------------------------------------------------	

# ------------------------------------------------
func on_current_camera_zoom_update() -> void:	
	GBL.add_to_animation_queue(self)
	
	if previous_state == CAMERA.ZOOM.OVERVIEW and current_camera_zoom == CAMERA.ZOOM.FLOOR:
		await tween_rotation(Building, Vector3(0, 30 + (current_location.room * 60), 0))
	
	match current_camera_zoom:
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

func on_process_update(delta: float) -> void:	
	if !is_node_ready():return
	if current_camera_zoom == CAMERA.ZOOM.OVERVIEW:
		Building.rotate_y(0.001)
# ------------------------------------------------
