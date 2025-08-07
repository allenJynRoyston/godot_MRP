extends Node3D

@onready var SceneCamera:Camera3D = $Camera3D
@onready var MeshRender:Node3D = $MeshRender
@onready var Laser:SpotLight3D = $MeshRender/Laser
@onready var MeshSelector:MeshInstance3D = $MeshRender/MeshSelector

@onready var RoomContainer:Node3D = $MeshRender/Rooms
@onready var MarkersContainer:Node3D = $MeshRender/Markers

@onready var LeftBillbordLabel:Label3D = $MeshRender/Billboards/Left/LeftWallLabel
@onready var RightBillboardLabel:Label3D = $MeshRender/Billboards/Right/RightWallLabel

@onready var Fog:Node3D = $MeshRender/Fog
@onready var MiasmaFog:FogVolume = $MeshRender/Fog/MiasmaFog
@onready var MoodFog:FogVolume = $MeshRender/Fog/MoodFog

@onready var WorldLight:DirectionalLight3D = $MeshRender/Lighting/WorldLight
@onready var BaseLights:Node3D = $MeshRender/Lighting/BaseLights
@onready var CautionLights:Node3D = $MeshRender/Lighting/CautionLights
@onready var BillboardLights:Node3D = $MeshRender/Lighting/BillboardLight
@onready var EmergencyLights:Node3D = $MeshRender/Lighting/EmergencyLights
@onready var EmergencyFlareLight:DirectionalLight3D = $MeshRender/Lighting/EmergencyLights/EmergencyFlareLight
@onready var FloorLabel:Label3D = $MeshRender/Labeling/FloorLabel
@onready var WingLabel:Label3D = $MeshRender/Labeling/WingLabel

var current_location:Dictionary
var camera_settings:Dictionary 
var room_config:Dictionary
var purchased_facility_arr:Array

var previous_camera_type:int = -1
var previous_emergency_mode:int = -1
var previous_room_index:int = -1
var emergency_mode:ROOM.EMERGENCY_MODES

var previous_billboard_state:bool = false
var previous_baselights_state:bool = false
var previous_emergency_state:bool = false
var previous_nuke_state:bool = false
var nuke_is_triggered:bool = false 
var in_lockdown:bool = false
var is_powered:bool = false
var in_brownout:bool = false
var is_ventilated:bool  = false
var is_overheated:bool = false

var highlight_rooms:Array = [] : 
	set(val):
		highlight_rooms = val
		on_highlight_rooms_update()

var use_location:Dictionary : 
	set(val):
		use_location = val
		on_use_location_update()
		
# --------------------------------------------------------
func _init() -> void:
	GBL.register_node(REFS.WING_RENDER, self)	
	SUBSCRIBE.subscribe_to_room_config(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.WING_RENDER)
	SUBSCRIBE.unsubscribe_to_room_config(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
# --------------------------------------------------------

# --------------------------------------------------------
func room_change_viewpoint(index:int, assigned_location:Dictionary, camera_viewpoint:CAMERA.VIEWPOINT) -> void:
	if !is_node_ready(): return
	var actual:int = index_to_room_lookup(index)	
	var RoomNode:Node3D = RoomContainer.get_child(actual)
	RoomNode.camera_viewpoint = camera_viewpoint
	
func room_assign_designation(index:int, assigned_location:Dictionary) -> void:
	if !is_node_ready(): return
	var actual:int = index_to_room_lookup(index)	
	var RoomNode:Node3D = RoomContainer.get_child(actual)
	RoomNode.assigned_location = {"floor": assigned_location.floor, "ring": assigned_location.ring, "room": index}

func start_construction(use_location:Dictionary) -> void:	
	if !is_node_ready(): return
	var actual:int = index_to_room_lookup(use_location.room)
	var RoomNode:Node3D = RoomContainer.get_child(actual)
	await RoomNode.start_construction()
	
func complete_construction(use_location:Dictionary) -> void:	
	if !is_node_ready(): return
	var actual:int = index_to_room_lookup(use_location.room)
	var RoomNode:Node3D = RoomContainer.get_child(actual)
	await RoomNode.complete_construction()
	
func destroy_room(use_location:Dictionary) -> void:	
	if !is_node_ready(): return
	var actual:int = index_to_room_lookup(use_location.room)
	var RoomNode:Node3D = RoomContainer.get_child(actual)
	await RoomNode.destroy_room()

func construction_is_canceled(use_location:Dictionary) -> void:
	if !is_node_ready(): return
	var actual:int = index_to_room_lookup(use_location.room)
	var RoomNode:Node3D = RoomContainer.get_child(actual)
	await RoomNode.cancel_construction()	
# --------------------------------------------------------

# --------------------------------------------------------
func index_to_room_lookup(val:int) -> int:
	match val:
		0: return 2
		1: return 1
		2: return 5
		4: return 4
		5: return 8
		6: return 3
		7: return 7
		8: return 6
		
	return 0
# --------------------------------------------------------

# --------------------------------------------------------
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	var index:int = current_location.room
	var actual:int = index_to_room_lookup(current_location.room)
	var marker:Marker3D = MarkersContainer.get_child(actual)
	var new_pos:Vector3 = Vector3( marker.position.x, Laser.position.y, marker.position.z)	
	MeshSelector.position = Vector3(new_pos.x, MeshSelector.position.y, new_pos.z)
	await U.tween_node_property(Laser, "position", new_pos, 0.2, 0, Tween.TRANS_SINE, Tween.EASE_OUT)

func on_purchased_facility_arr_update(new_val:Array) -> void:
	purchased_facility_arr = new_val
	if !is_node_ready() or purchased_facility_arr.is_empty():return
	#U.debounce(str(self, "_update_room_buildings"), update_room_buildings)

func on_use_location_update() -> void:
	if !is_node_ready() or use_location.is_empty():return
	FloorLabel.text = "FLOOR %s" % use_location.floor
	WingLabel.text = "WING %s" % use_location.ring
	
	for i in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
		room_assign_designation(i, use_location)
	U.debounce(str(self, "_update_vars"), update_vars)

func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return	
	U.debounce(str(self, "_update_vars"), update_vars)

func on_base_states_update(new_base_state:Dictionary) -> void:
	if !is_node_ready() or new_base_state.is_empty():return
	if previous_nuke_state != new_base_state.base.onsite_nuke.triggered:
		nuke_is_triggered = new_base_state.base.onsite_nuke.triggered
		previous_nuke_state = nuke_is_triggered
	U.debounce(str(self, "_update_vars"), update_vars)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
var previous_camera_view:CAMERA.VIEWPOINT = -1
func change_camera_view(val:CAMERA.VIEWPOINT) -> void:
	if previous_camera_view != val:
		previous_camera_view = val
		
		for i in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
			room_change_viewpoint(i, use_location, val)		
		
		match val:
			# ---------------------- 
			CAMERA.VIEWPOINT.OVERHEAD:				
				Laser.show()		
				BillboardLights.hide()
				BaseLights.hide()
				CautionLights.hide()
				MeshSelector.show()
				
				update_camera_size(180)
				U.tween_node_property(MeshRender, "rotation_degrees", Vector3(0, 90, 45), 0.3, 0, Tween.TRANS_SINE)
				await U.tween_node_property(SceneCamera, "position", Vector3(5.3, 65, -15), 0.3, 0, Tween.TRANS_SINE)
			
			# ---------------------- 
			CAMERA.VIEWPOINT.DISTANCE:
				Laser.show()
				MeshSelector.show()
				update_room_lighting()
				
				update_camera_size(250)
				U.tween_node_property(MeshRender, "rotation_degrees", Vector3(2.5, 45, 2.5), 0.3, 0, Tween.TRANS_SINE)
				await U.tween_node_property(SceneCamera, "position", Vector3(8.5, 50, -15), 0.3, 0, Tween.TRANS_SINE)
			# ---------------------- ANGLE
			CAMERA.VIEWPOINT.ANGLE_NEAR:
				Laser.hide()
				MeshSelector.hide()
				update_room_lighting()
				
				update_camera_size(145)
				U.tween_node_property(MeshRender, "rotation_degrees", Vector3(-4.5, 45, -4.5), 0.3, 0, Tween.TRANS_SINE)
				await U.tween_node_property(SceneCamera, "position", Vector3(5.2, 67, -15), 0.3, 0, Tween.TRANS_SINE)
			
			# ---------------------- ANGLE
			CAMERA.VIEWPOINT.ANGLE_FAR:
				Laser.show()
				MeshSelector.show()
				update_room_lighting()
				update_camera_size(165)
				U.tween_node_property(MeshRender, "rotation_degrees", Vector3(-4.5, 45, -4.5), 0.3, 0, Tween.TRANS_SINE)
				await U.tween_node_property(SceneCamera, "position", Vector3(5.5, 65, -15), 0.3, 0, Tween.TRANS_SINE)


func update_camera_size(size:int) -> void:
	await U.tween_node_property(SceneCamera, "size", size, 0.3)	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func update_vars() -> void:
	if room_config.is_empty() or use_location.is_empty():return
	in_lockdown = room_config.floor[use_location.floor].in_lockdown
	is_powered = room_config.floor[use_location.floor].is_powered
	emergency_mode = room_config.floor[use_location.floor].ring[use_location.ring].emergency_mode		
	is_ventilated = room_config.floor[use_location.floor].ring[use_location.ring].is_ventilated	
	is_overheated = room_config.floor[use_location.floor].ring[use_location.ring].is_overheated
	
	U.debounce(str(self, "_update_billboards"), update_billboards)
	U.debounce(str(self, "_update_room_buildings"), update_room_buildings)
	U.debounce(str(self, "_update_room_lighting"), update_room_lighting)		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------
func update_room_lighting() -> void:
	if room_config.is_empty() or use_location.is_empty() or previous_camera_view == CAMERA.VIEWPOINT.OVERHEAD:return
	var lights:Array = [BaseLights, BillboardLights, EmergencyLights, CautionLights]
	var default_world_light_color:Color = Color(0.949, 0.947, 0.993)
	var overheated_color:Color = Color.RED
	var miasma_light_color:Color = Color.MEDIUM_PURPLE
	var lockdown_light_color:Color = Color.ORANGE_RED	
	var caution_light_color:Color = Color.MEDIUM_VIOLET_RED
	var warning_light_color:Color = Color.ORANGE
	var altered:bool = false
	
	MiasmaFog.hide()
	MoodFog.hide()
	
	
	EmergencyFlareLight.light_energy = 0
	for light in lights:
		light.hide()
		
	# NUKE TRIGGERED
	if nuke_is_triggered and !altered:		
		WorldLight.light_color = lockdown_light_color
		WorldLight.light_energy = 0.5
		EmergencyLights.show()
		CautionLights.show()
		altered = true
	
	# has not ventilated
	if !is_ventilated and !altered:
		MiasmaFog.material.emission = Color(0.725, 0.042, 0.543) if is_overheated else Color(0.561, 0.239, 0.736)
		WorldLight.light_color = miasma_light_color
		WorldLight.light_energy = 0.5
		BillboardLights.show()		
		MiasmaFog.show()
		altered = true
	
	# is overheated
	if is_overheated and !altered:
		WorldLight.light_color = overheated_color
		WorldLight.light_energy = 1.2
		BillboardLights.show()		
		altered = true
		
	# no power	
	if !is_powered and !altered:
		WorldLight.light_color = default_world_light_color
		WorldLight.light_energy = 0.15
		BillboardLights.show()
		MoodFog.show()
		altered = true

	if in_lockdown and !altered:
		WorldLight.light_color = lockdown_light_color
		WorldLight.light_energy = 1.2
		BillboardLights.show()
		altered = true

	# reset lights after emergency
	if previous_emergency_mode != emergency_mode:		
		WorldLight.light_color = default_world_light_color			
		WorldLight.light_energy = 0.0
		await U.set_timeout(0.5)		
		previous_emergency_mode = emergency_mode		
	
	if !altered:
		match emergency_mode:
			ROOM.EMERGENCY_MODES.DANGER:
				WorldLight.light_color = lockdown_light_color
				WorldLight.light_energy = 1.2
				BillboardLights.hide()
				EmergencyLights.show()
				CautionLights.show()	
						
			ROOM.EMERGENCY_MODES.WARNING:
				WorldLight.light_color = warning_light_color
				WorldLight.light_energy = 1.2	
				BaseLights.hide()
				BillboardLights.show()
				CautionLights.show()	
				
			ROOM.EMERGENCY_MODES.CAUTION:
				WorldLight.light_color = caution_light_color
				WorldLight.light_energy = 1.8	
				BaseLights.hide()
				BillboardLights.show()
				CautionLights.show()

			ROOM.EMERGENCY_MODES.NORMAL:
				WorldLight.light_color = default_world_light_color			
				WorldLight.light_energy = 1.2
				BaseLights.show()
				BillboardLights.show()
				CautionLights.hide()

	# set previous state so can turn on/off 
	previous_billboard_state = BillboardLights.is_visible_in_tree()	
	previous_baselights_state = BaseLights.is_visible_in_tree()
	previous_emergency_state = EmergencyLights.is_visible_in_tree()
	
	# set light energy constant
	light_energy_val = WorldLight.light_energy
# --------------------------------------------------------

# --------------------------------------------------------
func update_billboards() -> void:
	if use_location.is_empty() or room_config.is_empty():return
	var altered:bool = false
	var left_billboard_text:String = "WELCOME TO WING %s%s" % [use_location.floor, use_location.ring]
	var right_billboard_text:String = "EVERYTHING IS FINE"

	if nuke_is_triggered and !altered:		
		left_billboard_text = "NUCLEAR DETONATION EMMINENT!"
		right_billboard_text = "EVACUATE IMMEDIATELY!"
		altered = true

	if !is_ventilated and !altered:
		left_billboard_text = "STAY OUT"
		right_billboard_text = "MIASMA DETECTED"
		altered = true
		
	if is_overheated and !altered:		
		left_billboard_text = "STAY OUT"
		right_billboard_text = "DANGEROUS TEMPERATURE DETECTED"
		altered = true
		
	if !is_powered and !altered:
		left_billboard_text = "NO POWER"
		right_billboard_text = "NO POWER"
		altered = true
		
	if in_lockdown and !altered:
		left_billboard_text = "LOCKDOWN"
		right_billboard_text = "SHELTER IN PLACE"
		altered = true
		
	if !altered:
		match emergency_mode:
			ROOM.EMERGENCY_MODES.DANGER:
				left_billboard_text = "DANGER"
				right_billboard_text = "DANGER"
						
			ROOM.EMERGENCY_MODES.WARNING:
				left_billboard_text = "WARNING"
				right_billboard_text = "WARNING"
				
			ROOM.EMERGENCY_MODES.CAUTION:
				left_billboard_text = "CAUTION"
				right_billboard_text = "CAUTION"


	LeftBillbordLabel.text = left_billboard_text
	RightBillboardLabel.text = right_billboard_text
# --------------------------------------------------------

# --------------------------------------------------------	
func on_highlight_rooms_update() -> void:
	if !is_node_ready():return
	if highlight_rooms.is_empty():
		for node in RoomContainer.get_children():
			node.is_selected = true
		return
	
	var actual_list:Array = highlight_rooms.map(func(x): return index_to_room_lookup(x))

	for index in RoomContainer.get_child_count():
		var actual:int = index_to_room_lookup(index)
		var RoomNode:Node3D = RoomContainer.get_child(actual)
		if actual in actual_list:
			print(actual)
		RoomNode.is_selected = actual in actual_list
			
# --------------------------------------------------------		

# --------------------------------------------------------
func update_room_buildings() -> void:
	if use_location.is_empty():return

	#var empty_rooms_list:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8]
	#
	#for item in purchased_facility_arr:
		#if item.location.floor == use_location.floor and item.location.ring == use_location.ring:
			#empty_rooms_list.erase(item.location.room)
			#
			#if item.under_construction:
				#room_is_under_construction(item.location.room)
			#else:	
				#room_is_constructed(item.location.room)	
	
# --------------------------------------------------------

# --------------------------------------------------------
func get_room_position(room_index:int) -> Vector2:
	if !is_node_ready():
		return Vector2(-1, -1)

	var marker:Marker3D = MarkersContainer.get_child( index_to_room_lookup(room_index) ) 
	var viewport := SceneCamera.get_viewport()
	var screen_position := SceneCamera.unproject_position(marker.global_position)

	# Convert screen position to Control node's local space
	return screen_position / Vector2(viewport.size)
# --------------------------------------------------------


# --------------------------------------------------------
var time:float = 0
var toggle_color:bool = false
var toggle_ready:bool = false
var light_energy_val:float 
func _process(delta: float) -> void:
	if !is_node_ready():return
	time += delta
	
	var val: float = sin(time * 1.5) * (8.5 + 7.5) # -1 to 16
	if val <= 0 and toggle_ready:
		toggle_color = !toggle_color
		toggle_ready = false
	elif val > 0:
		toggle_ready = true
	
	var fluct_val: float = 0.85 + 0.25 * sin(time * 0.5)  # Oscillates between 0.6 and 1.1
	WorldLight.light_energy = fluct_val
	if emergency_mode == ROOM.EMERGENCY_MODES.DANGER:
		EmergencyFlareLight.light_energy = val
		EmergencyFlareLight.light_color = Color.ROYAL_BLUE if toggle_color else Color.ORANGE_RED
