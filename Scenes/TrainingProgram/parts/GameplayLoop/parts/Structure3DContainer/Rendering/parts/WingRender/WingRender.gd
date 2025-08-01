extends Node3D

@onready var SceneCamera:Camera3D = $Camera3D
@onready var MeshRender:Node3D = $MeshRender
@onready var Laser:SpotLight3D = $MeshRender/Laser
@onready var MeshSelector:MeshInstance3D = $MeshRender/MeshSelector

#@onready var GateContainer:Node3D = $MeshRender/Gates
@onready var RoomContainer:Node3D = $MeshRender/Rooms
@onready var MarkersContainer:Node3D = $MeshRender/Markers

@onready var LeftBillbordLabel:Label3D = $MeshRender/Billboards/Left/LeftWallLabel
@onready var RightBillboardLabel:Label3D = $MeshRender/Billboards/Right/RightWallLabel

@onready var WorldLight:DirectionalLight3D = $MeshRender/Lighting/WorldLight
@onready var BaseLights:Node3D = $MeshRender/Lighting/BaseLights
@onready var BillboardLights:Node3D = $MeshRender/Lighting/BillboardLight
@onready var EmergencyLights:Node3D = $MeshRender/Lighting/EmergencyLights
@onready var EmergencyFlareLight:DirectionalLight3D = $MeshRender/Lighting/EmergencyLights/EmergencyFlareLight

@onready var FloorLabel:Label3D = $MeshRender/Labeling/FloorLabel
@onready var WingLabel:Label3D = $MeshRender/Labeling/WingLabel

var current_location:Dictionary
var camera_settings:Dictionary 
var room_config:Dictionary
var purchased_facility_arr:Array

var previous_nuke_state:bool = false
var nuke_is_triggered:bool = false 

var previous_room_index:int = -1
var previous_billboard_state:bool = false
var previous_baselights_state:bool = false
var previous_emergency_state:bool = false

var previous_camera_type:int = -1
var previous_emergency_mode:int = -1
var in_lockdown:bool = false
var is_powered:bool = false
var in_brownout:bool = false
var emergency_mode:ROOM.EMERGENCY_MODES


var use_location:Dictionary : 
	set(val):
		use_location = val
		on_use_location_update()
		
var enable_room_focus:bool = false : 
	set(val):
		enable_room_focus = val
		on_enable_room_focus()
		
var is_animating:bool = false : 
	set(val):
		if is_animating != val:
			is_animating = val
			on_is_animating_update()
		
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
func room_is_under_construction(index:int) -> void:
	if !is_node_ready(): return
	var actual:int = index_to_room_lookup(index)	
	var RoomNode:Node3D = RoomContainer.get_child(actual)
	RoomNode.set_under_construction(true)	
	
func room_is_constructed(index:int) -> void:
	if !is_node_ready(): return
	var actual:int = index_to_room_lookup(index)	
	var RoomNode:Node3D = RoomContainer.get_child(actual)
	RoomNode.set_build_room(true)
	
func room_is_destroyed(use_location:Dictionary) -> void:	
	if !is_node_ready(): return
	var actual:int = index_to_room_lookup(use_location.room)
	var RoomNode:Node3D = RoomContainer.get_child(actual)
	RoomNode.destroy_room()

func construction_is_canceled(use_location:Dictionary) -> void:
	if !is_node_ready(): return
	var actual:int = index_to_room_lookup(use_location.room)
	var RoomNode:Node3D = RoomContainer.get_child(actual)
	RoomNode.cancel_construction()	
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
func on_purchased_facility_arr_update(new_val:Array) -> void:
	purchased_facility_arr = new_val
	if !is_node_ready() or purchased_facility_arr.is_empty():return
	U.debounce(str(self, "_update_room_buildings"), update_room_buildings)

func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	var index:int = current_location.room
	var actual:int = index_to_room_lookup(current_location.room)
	var marker:Marker3D = MarkersContainer.get_child(actual)
	var new_pos:Vector3 = Vector3( marker.position.x, Laser.position.y, marker.position.z)	
	MeshSelector.position = Vector3(new_pos.x, MeshSelector.position.y, new_pos.z)
	await U.tween_node_property(Laser, "position", new_pos, 0.2, 0, Tween.TRANS_SINE, Tween.EASE_OUT)

func on_use_location_update() -> void:
	if !is_node_ready() or use_location.is_empty():return
	FloorLabel.text = "FLOOR %s" % use_location.floor
	WingLabel.text = "WING %s" % use_location.ring
	U.debounce(str(self, "_update_billboards"), update_billboards)
	U.debounce(str(self, "_update_room_buildings"), update_room_buildings)
	U.debounce(str(self, "_update_room_lighting"), update_room_lighting)	
	
	
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return	
	U.debounce(str(self, "_update_room_lighting"), update_room_lighting)

func on_base_states_update(new_base_state:Dictionary) -> void:
	if !is_node_ready() or new_base_state.is_empty():return
	if previous_nuke_state != new_base_state.base.onsite_nuke.triggered:
		nuke_is_triggered = new_base_state.base.onsite_nuke.triggered
		previous_nuke_state = nuke_is_triggered
	U.debounce(str(self, "_update_billboards"), update_billboards)

func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	if !is_node_ready() or camera_settings.is_empty():return
	
	if previous_camera_type != camera_settings.type:
		previous_camera_type = camera_settings.type
	
		match camera_settings.type:
			# ----------------------
			CAMERA.TYPE.ROOM_SELECT:
				Laser.show()		
				BillboardLights.hide()
				BaseLights.hide()
				U.tween_node_property(MeshRender, "rotation_degrees", Vector3(0, 90, 45), 0.7, 0, Tween.TRANS_SINE)
			# ----------------------
			_:
				Laser.hide()
				BaseLights.show() if previous_baselights_state else BaseLights.hide()
				BillboardLights.show() if previous_billboard_state else BillboardLights.hide()
				EmergencyLights.show() if previous_emergency_state else EmergencyLights.hide()
				U.tween_node_property(MeshRender, "rotation_degrees", Vector3(-4.5, 45, -4.5), 0.7, 0, Tween.TRANS_SINE)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------
func update_room_lighting() -> void:
	if room_config.is_empty() or use_location.is_empty():return
	
	var lights:Array = [BaseLights, BillboardLights, EmergencyLights]
	in_lockdown = room_config.floor[use_location.floor].in_lockdown
	is_powered = room_config.floor[use_location.floor].is_powered
	emergency_mode = room_config.floor[use_location.floor].ring[use_location.ring].emergency_mode
	var default_world_light_color:Color = Color(0.949, 0.947, 0.993)
	var lockdown_light_color:Color = Color.ORANGE_RED	
	
	EmergencyFlareLight.light_energy = 0
	for light in lights:
		light.hide()
		
	# no power
	if !is_powered:
		WorldLight.light_color = default_world_light_color
		WorldLight.light_energy = 0.5
		return

	if in_lockdown:
		WorldLight.light_color = lockdown_light_color
		WorldLight.light_energy = 1.2
		return

	# reset lights after emergency
	if previous_emergency_mode != emergency_mode:		
		WorldLight.light_color = default_world_light_color			
		WorldLight.light_energy = 0.8
		await U.set_timeout(0.5)		
		previous_emergency_mode = emergency_mode		
	
	match emergency_mode:
		ROOM.EMERGENCY_MODES.DANGER:
			WorldLight.light_color = lockdown_light_color
			WorldLight.light_energy = 1.2
			EmergencyLights.show()
		ROOM.EMERGENCY_MODES.WARNING:
			BaseLights.show()
			BillboardLights.show()
		ROOM.EMERGENCY_MODES.CAUTION:
			BaseLights.show()
			BillboardLights.show()
		ROOM.EMERGENCY_MODES.NORMAL:
			WorldLight.light_color = default_world_light_color			
			WorldLight.light_energy = 1.2
			BaseLights.show()
			BillboardLights.show()
	
	# set previous state so can turn on/off 
	previous_billboard_state = BillboardLights.is_visible_in_tree()	
	previous_baselights_state = BaseLights.is_visible_in_tree()
	previous_emergency_state = EmergencyLights.is_visible_in_tree()
# --------------------------------------------------------

# --------------------------------------------------------
func update_billboards() -> void:
	if use_location.is_empty() or room_config.is_empty():return

	LeftBillbordLabel.text = "WELCOME TO WING %s-%s" % [use_location.floor, use_location.ring]
	RightBillboardLabel.text = "EVERYTHING IS FINE"
	
	if in_lockdown:
		RightBillboardLabel.text = "SHELTER IN PLACE"
	if !is_powered:
		RightBillboardLabel.text = "NO POWER"
	if nuke_is_triggered:
		RightBillboardLabel.text = "EVACUATE IMMEDIATELY!"
	
# --------------------------------------------------------

# --------------------------------------------------------
func on_is_animating_update() -> void:
	if !is_node_ready():return
	for node in RoomContainer.get_children():
		node.skip_animation = is_animating	
# --------------------------------------------------------	

# --------------------------------------------------------
func on_enable_room_focus() -> void:
	pass
	#for node in NodeContainer.get_children():
		#node.enable_focus = enable_room_focus
# --------------------------------------------------------	

# --------------------------------------------------------
func update_camera_size(val:int) -> void:
	U.tween_node_property(SceneCamera, "size", val, 0.7)	
# --------------------------------------------------------

# --------------------------------------------------------
func update_room_buildings() -> void:
	if use_location.is_empty():return

	var empty_rooms_list:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8]
	
	for item in purchased_facility_arr:
		if item.location.floor == use_location.floor and item.location.ring == use_location.ring:
			empty_rooms_list.erase(item.location.room)
			if item.under_construction:
				room_is_under_construction(item.location.room)
			else:	
				room_is_constructed(item.location.room)	
	
	for index in empty_rooms_list:
		var actual:int = index_to_room_lookup(index)	
		var RoomNode:Node3D = RoomContainer.get_child(actual)
		RoomNode.reset_to_default()
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
func _process(delta: float) -> void:
	if !is_node_ready():return
	time += delta
	
	is_animating =  GBL.has_animation_in_queue()

	if emergency_mode == ROOM.EMERGENCY_MODES.DANGER:
		var val: float = sin(time * 1.5) * (8.5 + 7.5) # -1 to 16
		if val <= 0 and toggle_ready:
			toggle_color = !toggle_color
			toggle_ready = false
		elif val > 0:
			toggle_ready = true
		EmergencyFlareLight.light_energy = val
		EmergencyFlareLight.light_color = Color.ROYAL_BLUE if toggle_color else Color.ORANGE_RED
