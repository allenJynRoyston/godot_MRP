@tool
extends Node3D

@onready var Building:Node3D = $Building
@onready var FloorContainer:Node3D = $Building/FloorContainer
@onready var ElevatorNode:Node3D = $Building/Elevator

@onready var CameraContainers:Node3D = $CameraContainers
@onready var RoamingCamera:Camera3D = $CameraContainers/RoamingCamera
@onready var PerspectiveCamera:Camera3D = $CameraContainers/PerspectiveCamera
@onready var OverheadCamera:Camera3D = $CameraContainers/OverheadCamera

@export var render_layer:int = 0 : 
	set(val): 
		render_layer = val
		on_render_layout_update()
		
@export var enable_change_on_update:bool = false		

var camera_type:CAMERA.TYPE = CAMERA.TYPE.PERSPECTIVE : 
	set(val):
		camera_type = val
		on_camera_type_update()

var current_location:Dictionary = {} : 
	set(val):
		current_location = val
		on_current_location_update()

var building_nodes:Dictionary = {}
var room_nodes:Dictionary = {}
var use_camera_node:Camera3D

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
				
	on_camera_type_update()
	on_render_layout_update()
	
	
func _init() -> void:
	GBL.subscribe_to_process(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)
# ------------------------------------------------

# ------------------------------------------------
func on_current_location_update() -> void:
	if !is_node_ready() or current_location.is_empty():return
	
	if enable_change_on_update:
		highlight_floor(current_location.floor)
	
	var new_pos:Vector3 = Building.position
	new_pos.y = (current_location.floor * 10)
	tween_node(Building, new_pos)
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
func on_camera_type_update() -> void:
	if !is_node_ready():return
	match camera_type:
		CAMERA.TYPE.PERSPECTIVE:
			use_camera_node = PerspectiveCamera
		CAMERA.TYPE.OVERHEAD:
			use_camera_node = OverheadCamera
	
	tween_node(RoamingCamera, use_camera_node.position, use_camera_node.rotation)
	
	on_current_location_update()
# ------------------------------------------------

# ------------------------------------------------
func tween_node(node:Node3D, new_position:Vector3, new_rotation:Vector3 = node.rotation) -> void:
	var set_camera_position:Callable = func(v3: Vector3) -> void:
		node.position = v3
		
	var set_camera_rotation:Callable = func(v3:Vector3) -> void:
		node.rotation = v3	
	
	var tween_pos:Tween = create_tween()
	tween_pos.tween_method(set_camera_position, node.position, new_position, 0.3).set_trans(Tween.TRANS_SINE)
	var tween_rot:Tween = create_tween()
	tween_rot.tween_method(set_camera_rotation, node.rotation, new_rotation, 0.3).set_trans(Tween.TRANS_SINE)
	await tween_rot.finished



# ------------------------------------------------

func on_process_update(delta: float) -> void:
	if is_node_ready():
		$Building.rotate_y(0.001)
# ------------------------------------------------
