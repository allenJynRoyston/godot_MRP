extends Control

@onready var TransitionRect:TextureRect = $TransitionRect
@onready var RenderSubviewport:SubViewport = $SubViewport

@onready var NodeContainer:Node3D = $SubViewport/RoomColumn/NodeContainer
@onready var Column1:Node3D = $SubViewport/RoomColumn/NodeContainer/column1
@onready var Column2:Node3D = $SubViewport/RoomColumn/NodeContainer/column2
@onready var Column3:Node3D = $SubViewport/RoomColumn/NodeContainer/column3
@onready var LeftBoardRoomLabels:Node3D = $SubViewport/RoomColumn/LeftBoard/LeftBoardRoomLabels
@onready var RightBoardRoomLabels:Node3D = $SubViewport/RoomColumn/RightBoard/RightBoardRoomLabels

@onready var FloorMesh:MeshInstance3D = $SubViewport/RoomColumn/FloorMesh
@onready var CursorLabelSprite:Sprite3D = $SubViewport/RoomColumn/MainCamera/CursorLabelSprite
@onready var CursorMenuSprite:Sprite3D = $SubViewport/RoomColumn/MainCamera/CursorMenuSprite

@onready var LeftFloorLabel:Label3D = $SubViewport/RoomColumn/FloorMesh/LeftFloorLabel
@onready var RightFloorLabel:Label3D = $SubViewport/RoomColumn/FloorMesh/RightFloorLabel

@onready var StatusLabel:Label3D = $SubViewport/RoomColumn/MainCamera/StatusLabel
@onready var MainCamera:Camera3D = $SubViewport/RoomColumn/MainCamera
@onready var AccentLights:DirectionalLight3D = $SubViewport/RoomColumn/MainCamera/AccentLights

@onready var NoPowerLights:Node3D = $SubViewport/RoomColumn/NoPowerLights
@onready var NormalLights:Node3D = $SubViewport/RoomColumn/NormalLights
@onready var CautionLights:Node3D = $SubViewport/RoomColumn/CautionLights
@onready var WarningLights:Node3D = $SubViewport/RoomColumn/WarningLights
@onready var DangerLights:Node3D = $SubViewport/RoomColumn/DangerLights
@onready var DangerSpotlights:Node3D = $SubViewport/RoomColumn/DangerLights/Spotlights

@export var assigned_location:Dictionary = {} : 
	set(val):
		assigned_location = val
		on_assigned_location_update()

enum MENU_TYPE {RESEARCHER, ROOM, SCP, WING}

var designation:String
var node_location:Vector3 
var current_location:Dictionary = {} 
var camera_settings:Dictionary = {}
var resources_data:Dictionary = {} 
var previous_floor:int = -1
var previous_ring:int = -1
var is_setup:bool = false
var node_refs:Dictionary = {}
var node_ref_positions:Dictionary = {}
var camera_size_arr:Array = [20, 24, 28, 32, 36]
var freeze_input:bool = false 
var room_config:Dictionary = {}
var menu_index:int = 0
var menu_actions:Array = []

			
var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()
		
var enable_room_focus:bool = false : 
	set(val):
		enable_room_focus = val
		on_enable_room_focus()

var previous_emergency_mode:int = -1
var in_lockdown:bool = false
var is_powered:bool = false
var in_brownout:bool = false
var emergency_mode:ROOM.EMERGENCY_MODES


signal menu_response

# --------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_base_states(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	GBL.subscribe_to_control_input(self)
	GBL.register_node(REFS.ROOM_NODES, self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_base_states(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)
	GBL.unsubscribe_to_control_input(self)
	GBL.unregister_node(REFS.ROOM_NODES)
	
func _ready() -> void:
	on_assigned_location_update()
	on_is_active_update()
	on_enable_room_focus()
# --------------------------------------------------------

# --------------------------------------------------------
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	
	if designation != U.location_to_designation(current_location):
		designation = U.location_to_designation(current_location)
		
		menu_index = 0
		transition()
		on_assigned_location_update()
		#assign_room_node_location(current_location.floor, current_location.ring, camera_settings.type == CAMERA.TYPE.WING_SELECT)

	assigned_location = current_location
# --------------------------------------------------------

# --------------------------------------------------------
func on_assigned_location_update(new_val:Dictionary = assigned_location) -> void:
	if !is_node_ready() or assigned_location.is_empty():return
		
	if previous_floor != assigned_location.floor or previous_ring != assigned_location.ring:
		previous_floor = assigned_location.floor
		previous_ring = assigned_location.ring
		
		previous_emergency_mode = -1
		
		update_nodes()
		update_boards()		
		update_room_lighting()	
# --------------------------------------------------------

# --------------------------------------------------------
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return	
	update_nodes()
	update_boards()	
	update_room_lighting(true)	
# --------------------------------------------------------

# ------------------------------------------------
func transition() -> void:
	TransitionRect.show()
	TransitionRect.texture = U.get_viewport_texture(RenderSubviewport)
	await U.tween_range(0.0, 1.0, 0.5, func(val:float) -> void:
		TransitionRect.material.set_shader_parameter("sensitivity", val)
	).finished	
	TransitionRect.hide()
	TransitionRect.material.set_shader_parameter("sensitivity", 0.0)
# ------------------------------------------------


# --------------------------------------------------------
func on_enable_room_focus() -> void:
	for node in NodeContainer.get_children():
		node.enable_focus = enable_room_focus
# --------------------------------------------------------	

# --------------------------------------------------------
func update_boards() -> void:
	if !is_node_ready() or room_config.is_empty():return
	# traverse and mark the wall labels
	for floor_index in room_config.floor.size():
		if floor_index == assigned_location.floor:
			for ring_index in room_config.floor[floor_index].ring.size():
				if ring_index == assigned_location.ring:
					for room_index in room_config.floor[floor_index].ring[ring_index].room.size():
						var room_node:Node3D = NodeContainer.get_child(room_index)
						var ref_index:int = room_node.ref_index
						var room_extract:Dictionary = GAME_UTIL.extract_room_details({"floor": floor_index, "ring": ring_index, "room": ref_index})
						
						# ----------------------------------------
						var left_label_3d:Label3D = LeftBoardRoomLabels.find_child(str(ref_index))
						var left_status_label:Label3D = left_label_3d.get_child(0)
						for text_node in [left_label_3d, left_status_label]:
							text_node.modulate = Color(0.984, 0.439, 0.184) if (room_extract.room.is_empty() or !room_extract.is_activated) else Color(0.525, 1, 0.443, 1)
						left_label_3d.text = "%s  %s" % [room_node.room_number, "EMPTY" if room_extract.room.is_empty() else room_extract.room.details.shortname]
						left_status_label.text = ""
						if !room_extract.room.is_empty():
							left_status_label.text = "NO ISSUES" if room_extract.is_activated else "NOT POWERED"
				
						# ----------------------------------------
						var right_label_3d:Label3D = RightBoardRoomLabels.find_child(str(ref_index))
						var right_status_label:Label3D = right_label_3d.get_child(0)				
						for text_node in [right_label_3d, right_status_label]:
							right_label_3d.modulate = Color(0.984, 0.439, 0.184) if room_extract.scp.is_empty() else Color(0.525, 1, 0.443, 1)		
						right_label_3d.text =  "%s  %s" % [room_node.room_number, "EMPTY" if room_extract.scp.is_empty() else room_extract.scp.details.name] 
						right_status_label.text = ""
						if !room_extract.scp.is_empty():							
							#if room_extract.scp.is_transfer:
								#right_status_label.text = "TRANSFERING"
							right_status_label.text = "CONTAINED" #if !room_extract.scp.testing.is_empty() else "TESTING..."	
# --------------------------------------------------------

# --------------------------------------------------------
func update_nodes() -> void:
	if assigned_location.is_empty():return
	var nodeArray:Array = []
	
	LeftFloorLabel.text = "FLOOR %s" % [assigned_location.floor]
	RightFloorLabel.text = "WING %s" % [assigned_location.ring]
	
	for node in NodeContainer.get_children():
		node.update_refs(assigned_location.floor, assigned_location.ring)

	for node in NodeContainer.get_children():
		node_refs[node.name] = node
		node_ref_positions[node.name] = node.position
		
		node.onFocus = func(room_data:Dictionary) -> void:
			node_location = node.global_position
			CursorLabelSprite.global_position = node.global_position - Vector3(0, -2, 0)
			CursorLabelSprite.position.z = -2
				
	var material_copy:StandardMaterial3D = FloorMesh.mesh.material
	match assigned_location.ring:
		0:
			material_copy.albedo_color = Color(0.318, 0.268, 0.108)
		1:
			material_copy.albedo_color = Color(0.108, 0.301, 0.349)
		2:
			material_copy.albedo_color = Color(0.153, 0.313, 0.197)
		3:
			material_copy.albedo_color = Color(0.401, 0.177, 0.347)
			
	FloorMesh.mesh.material = material_copy
# --------------------------------------------------------

# --------------------------------------------------------
func on_is_active_update() -> void:
	if !is_node_ready() or current_location.is_empty():return
	reset_node(current_location.room, is_active)
# --------------------------------------------------------

# --------------------------------------------------------
func reset_node(room:int, state:bool) -> void:
	if node_refs.is_empty():return
	var node:Node3D = node_refs[str(room)]		
	U.tween_node_property(node, "position:y", 2.5 if state else 0)
	node.show_internal = state
# --------------------------------------------------------	

# --------------------------------------------------------
func get_room_position(room_index:int) -> Vector2:
	#camera: Camera3D, world_position: Vector3, control: Control
	var RoomNode:Node3D = node_refs[str(room_index)]
	var viewport := MainCamera.get_viewport()
	var screen_position := MainCamera.unproject_position(RoomNode.position)
	
	# Convert screen position to Control node's local space
	return screen_position / self.size
# --------------------------------------------------------

# --------------------------------------------------------
func update_room_lighting(reset_lights:bool = false) -> void:
	if room_config.is_empty() or current_location.is_empty():return
	var lights:Array = [NoPowerLights, NormalLights, CautionLights, WarningLights, DangerLights]

	in_brownout = room_config.base.in_brownout
	in_lockdown = room_config.floor[current_location.floor].in_lockdown
	is_powered = room_config.floor[current_location.floor].is_powered
	emergency_mode = room_config.floor[current_location.floor].ring[current_location.ring].emergency_mode
	
	if !is_powered:
		for light in lights:
			light.hide()
		NoPowerLights.show()
		LeftBoardRoomLabels.hide()
		RightBoardRoomLabels.hide()
		return

	if in_brownout:
		return
	
	# reset lights
	if reset_lights and previous_emergency_mode != emergency_mode:		
		for light in lights:
			light.hide()			
		await U.set_timeout(0.5)	
		
	previous_emergency_mode = emergency_mode		
	
	LeftBoardRoomLabels.hide()
	RightBoardRoomLabels.hide()	
	
	if in_lockdown:
		for light in lights:
			light.hide()
		DangerLights.show()
	else:
		# floor-wide emergency mode
		match emergency_mode:
			ROOM.EMERGENCY_MODES.DANGER:
				for light in lights:
					light.hide()
				DangerLights.show()
			ROOM.EMERGENCY_MODES.WARNING:
				for light in lights:
					light.hide()
				WarningLights.show()
			ROOM.EMERGENCY_MODES.CAUTION:
				for light in lights:
					light.hide()
				CautionLights.show()
			ROOM.EMERGENCY_MODES.NORMAL:
				for light in lights:
					light.hide()
				NormalLights.show()
# --------------------------------------------------------

# --------------------------------------------------------
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
	
	match camera_settings.type:
		CAMERA.TYPE.ROOM_SELECT:
			update_camera_size(40)
		_:
			update_camera_size(31)
# --------------------------------------------------------

# --------------------------------------------------------
func update_camera_size(val:int) -> void:
	U.tween_node_property(MainCamera, "size", val, 0.7, 0)	
# --------------------------------------------------------

# --------------------------------------------------------
func on_select() -> void:
	menu_actions[menu_index].onSelect.call()

func on_back() -> void:
	menu_response.emit({"action": ACTION.ROOM_NODE.BACK})
# --------------------------------------------------------

# --------------------------------------------------------
func _process(delta: float) -> void:
	if !is_node_ready():return
	#if in_lockdown or emergency_mode == ROOM.EMERGENCY_MODES.DANGER:
	for child in DangerSpotlights.get_children():
		child.find_child("Spotlight").rotate_x(0.1)
		child.find_child("Spotlight").rotate_y(0.01)
# --------------------------------------------------------
