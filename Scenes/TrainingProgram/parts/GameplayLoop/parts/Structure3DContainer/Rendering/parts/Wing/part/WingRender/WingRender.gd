extends Node3D

@onready var SceneCamera:Camera3D = $Camera3D
@onready var MeshRender:Node3D = $MeshRender
@onready var Laser:SpotLight3D = $MeshRender/Laser
@onready var MeshSelector:MeshInstance3D = $MeshRender/MeshSelector
@onready var WingRenderMesh:Node3D = $MeshRender/WingRenderMesh

@onready var RoomContainer:Node3D = $MeshRender/Rooms
@onready var GateContainer:Node3D = $MeshRender/Gates
@onready var MarkersContainer:Node3D = $MeshRender/Markers
#
#@onready var LeftBillbordLabel:Label3D = $MeshRender/Billboards/Left/LeftWallLabel
#@onready var RightBillboardLabel:Label3D = $MeshRender/Billboards/Right/RightWallLabel

@onready var Fog:Node3D = $MeshRender/Fog
@onready var MiasmaFog:FogVolume = $MeshRender/Fog/MiasmaFog
@onready var MoodFog:FogVolume = $MeshRender/Fog/MoodFog

@onready var Lighting:Node3D = $MeshRender/Lighting
@onready var WorldLight:DirectionalLight3D = $MeshRender/Lighting/WorldLight
@onready var BaseLights:Node3D = $MeshRender/Lighting/BaseLights
@onready var DoorLight:SpotLight3D = $MeshRender/Lighting/DoorLight
@onready var EditLighting:Node3D = $MeshRender/Lighting/EditLighting
@onready var CautionLights:Node3D = $MeshRender/Lighting/CautionLights
@onready var BillboardLights:Node3D = $MeshRender/Lighting/BillboardLight
@onready var EmergencyLights:Node3D = $MeshRender/Lighting/EmergencyLights
@onready var EmergencyFlareLight:DirectionalLight3D = $MeshRender/Lighting/EmergencyLights/EmergencyFlareLight

@onready var LeftLabel:Label3D = $MeshRender/Labeling/LeftLabel
@onready var RightLabel:Label3D = $MeshRender/Labeling/RightLabel

const LOCKDOWN_LIGHT_COLOR:Color = Color.ORANGE_RED	
const CAUTION_LIGHT_COLOR:Color = Color.MEDIUM_VIOLET_RED
const WARNING_LIGHT_COLOR:Color = Color.ORANGE
const POLLUTION_LIGHT_COLOR:Color = Color(0.561, 0.239, 0.736)
const DEFAULT_WORLD_COLOR:Color = Color(0.949, 0.947, 0.993)
const DEFAULT_DOOR_LIGHT_COLOR:Color = Color(1.0, 1.0, 0.663)

var previous_floor:int = -1
var previous_ring:int = -1

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
#var is_powered:bool = false
#var in_brownout:bool = false
#var is_ventilated:bool  = false
#var is_overheated:bool = false

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

func _ready() -> void:
	set_engineering_mode(false)
	
	if !Engine.is_editor_hint():
		for node in [Lighting, Fog, RoomContainer, GateContainer]:
			node.show()
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
	update_mesh_values()
	
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
	LeftLabel.text = "WELCOME TO SECTOR %s%s" % [use_location.floor, U.ring_to_str(use_location.ring)]
	RightLabel.text = "WELCOME TO SECTOR %s%s" % [use_location.floor, U.ring_to_str(use_location.ring)]
	
	for i in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
		room_assign_designation(i, use_location)
	U.debounce(str(self, "_update_vars"), update_vars)

func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty():return	
	previous_floor = -1 # required to update lighting
	previous_ring = -1	
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
				update_camera_size(230)
				U.tween_node_property(MeshRender, "rotation_degrees", Vector3(0, 90, 45), 0.3, 0, Tween.TRANS_SINE)
				await U.tween_node_property(SceneCamera, "position", Vector3(5.3, 85, -15), 0.3, 0, Tween.TRANS_SINE)
			# ---------------------- 
			CAMERA.VIEWPOINT.SHIFT_LEFT:
				U.tween_node_property(SceneCamera, "position:x", -40, 0.3, 0, Tween.TRANS_SINE)
				update_camera_size(180)
			# ---------------------- 
			CAMERA.VIEWPOINT.SHIFT_RIGHT:
				U.tween_node_property(SceneCamera, "position:x", 62, 0.3, 0, Tween.TRANS_SINE)
				update_camera_size(180)				
			# ---------------------- 
			CAMERA.VIEWPOINT.DISTANCE:
				Laser.show()
				MeshSelector.show()
				update_camera_size(250)
				U.tween_node_property(MeshRender, "rotation_degrees", Vector3(2.5, 45, 2.5), 0.3, 0, Tween.TRANS_SINE)
				await U.tween_node_property(SceneCamera, "position", Vector3(8.5, 80, -15), 0.3, 0, Tween.TRANS_SINE)
			# ---------------------- ANGLE
			CAMERA.VIEWPOINT.ANGLE_NEAR:
				Laser.hide()
				MeshSelector.hide()
				update_camera_size(180)
				U.tween_node_property(MeshRender, "rotation_degrees", Vector3(-4.5, 45, -4.5), 0.3, 0, Tween.TRANS_SINE)
				await U.tween_node_property(SceneCamera, "position", Vector3(5.2, 67, -15), 0.3, 0, Tween.TRANS_SINE)
			
			# ---------------------- ANGLE
			CAMERA.VIEWPOINT.ANGLE_FAR:
				Laser.show()
				MeshSelector.show()			
				update_camera_size(200)
				U.tween_node_property(MeshRender, "rotation_degrees", Vector3(-4.5, 45, -4.5), 0.3, 0, Tween.TRANS_SINE)
				await U.tween_node_property(SceneCamera, "position", Vector3(6.7, 65, -15), 0.3, 0, Tween.TRANS_SINE)
			CAMERA.VIEWPOINT.DRAMATIC_ZOOM:
				await update_camera_size(350, 0.4)
				await update_camera_size(40, 0.3)
				
		U.debounce(str(self, "_update_room_lighting"), update_room_lighting)

func update_camera_size(size:int, duration:float = 0.3) -> void:
	await U.tween_node_property(SceneCamera, "size", size, duration, 0, Tween.TRANS_SINE)	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func update_vars() -> void:
	if room_config.is_empty() or use_location.is_empty():return
	var power_distribution:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].power_distribution
	in_lockdown = room_config.floor[use_location.floor].in_lockdown
	emergency_mode = room_config.floor[use_location.floor].ring[use_location.ring].emergency_mode		
	
	#is_powered = power_distribution.energy > 1
	#is_ventilated = power_distribution.ventilation > 1
	#is_overheated = false # TODO REVIST THIS

	U.debounce(str(self, "_update_engineering_stats"), update_engineering_stats)
	U.debounce(str(self, "_update_billboards"), update_billboards)
	U.debounce(str(self, "_update_room_buildings"), update_room_buildings)
	U.debounce(str(self, "_update_room_lighting"), update_room_lighting)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------
func set_engineering_mode(state:bool) -> void:
	WingRenderMesh.in_edit_mode = state
	
	if state:
		RoomContainer.hide()
		Lighting.hide()
	
	if !state:
		RoomContainer.show()
		Lighting.show()
#	
		WingRenderMesh.edit_cooling = false
		WingRenderMesh.edit_heating = false
		WingRenderMesh.edit_powergrid = false
		WingRenderMesh.edit_ventilation = false
		WingRenderMesh.edit_sra = false
		
		previous_floor = -1
		previous_ring = -1		
		await U.tick()
		update_room_lighting()
# --------------------------------------------------------

# --------------------------------------------------------
func set_to_build_mode(state:bool) -> void:
	WingRenderMesh.set_to_build_mode(state)
	
	if state:
		EditLighting.show() 
		Fog.hide()
	
	if !state:
		previous_floor = -1
		previous_ring = -1
		
		EditLighting.hide()
		Fog.show()
		update_room_lighting()
# --------------------------------------------------------	
	

# --------------------------------------------------------
var engineering_stats:Dictionary = {}
func update_engineering_stats(stat:Dictionary = engineering_stats) -> void:
	engineering_stats = stat
	if !WingRenderMesh.in_edit_mode or engineering_stats.is_empty():return
	var power_distribution:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].power_distribution
	
	WingRenderMesh.edit_cooling = false
	WingRenderMesh.edit_heating = false
	WingRenderMesh.edit_powergrid = false
	WingRenderMesh.edit_ventilation = false
	WingRenderMesh.edit_sra = false

	match stat.prop:
		"heating":
			WingRenderMesh.edit_heating = true
		"cooling":
			WingRenderMesh.edit_cooling = true
		"sra":
			WingRenderMesh.edit_sra = true
		"ventilation":
			WingRenderMesh.edit_ventilation = true
		"energy":
			WingRenderMesh.edit_powergrid = true
	
	
	previous_floor = -1 # required to update correctly
	previous_ring = -1

	update_room_lighting()
	update_mesh_values()
# --------------------------------------------------------

# --------------------------------------------------------
func update_mesh_values() -> void:
	if !is_node_ready() or room_config.is_empty():return
	var power_distribution:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].power_distribution
	WingRenderMesh.heating_val = power_distribution.heating
	WingRenderMesh.cooling_val = power_distribution.cooling
	WingRenderMesh.sra_val = power_distribution.sra
	WingRenderMesh.ventilation_val = power_distribution.ventilation	
	WingRenderMesh.power_val = power_distribution.energy	
# --------------------------------------------------------

# --------------------------------------------------------
func update_room_lighting() -> void:
	#print("update room lighting....")
	if room_config.is_empty() or use_location.is_empty() or previous_camera_view == CAMERA.VIEWPOINT.OVERHEAD:return
	#print(previous_floor, previous_ring)
	if previous_floor != current_location.floor or previous_ring != current_location.ring:
		#print("now update lighting...")
		previous_floor = current_location.floor
		previous_ring = current_location.ring
		var monitor:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].monitor			
		var energy:Dictionary = room_config.floor[use_location.floor].ring[use_location.ring].energy			
		var lights:Array = [BaseLights, BillboardLights, EmergencyLights, CautionLights]
		var altered:bool = false
		
		# set defaults
		WorldLight.light_volumetric_fog_energy = 0
		WorldLight.light_indirect_energy = 0		
		EmergencyFlareLight.light_energy = 0
		DoorLight.light_color = DEFAULT_DOOR_LIGHT_COLOR
		for light in lights:
			light.hide()

		# reset lights after emergency
		if previous_emergency_mode != emergency_mode:		
			WorldLight.light_color = DEFAULT_WORLD_COLOR			
			WorldLight.light_energy = 0.0
			await U.set_timeout(0.5)		
			previous_emergency_mode = emergency_mode		
			
		# NUKE TRIGGERED
		if nuke_is_triggered and !altered:		
			WorldLight.light_color = LOCKDOWN_LIGHT_COLOR
			WorldLight.light_energy = 0.5
			EmergencyLights.show()
			CautionLights.show()
			altered = true
		
		# LOCKDOWN
		if in_lockdown and !altered:
			WorldLight.light_color = LOCKDOWN_LIGHT_COLOR
			WorldLight.light_energy = 1.2
			BillboardLights.show()
			altered = true

		# NO POWER (AVAILABLE)
		if energy.available == 0:
			CautionLights.show()	
			DoorLight.light_color = Color.WHITE
			WorldLight.light_color = Color.SLATE_BLUE
			WorldLight.light_energy = 2.0
			WorldLight.light_volumetric_fog_energy = 0.2
			WorldLight.light_indirect_energy = 0
			altered = true

		if !altered:
			match emergency_mode:
				ROOM.EMERGENCY_MODES.DANGER:
					WorldLight.light_color = LOCKDOWN_LIGHT_COLOR
					WorldLight.light_energy = 1.2
					BillboardLights.hide()
					EmergencyLights.show()
					CautionLights.show()	
					altered = true
							
				ROOM.EMERGENCY_MODES.WARNING:
					WorldLight.light_color = WARNING_LIGHT_COLOR
					WorldLight.light_energy = 1.2	
					BaseLights.hide()
					BillboardLights.show()
					CautionLights.show()	
					altered = true
					
				ROOM.EMERGENCY_MODES.CAUTION:
					WorldLight.light_color = CAUTION_LIGHT_COLOR
					WorldLight.light_energy = 1.8	
					BaseLights.hide()
					BillboardLights.show()
					CautionLights.show()
					altered = true
				
				# DEFAULT WHEN ROOM IS NORMAL
				ROOM.EMERGENCY_MODES.NORMAL:
					WorldLight.light_color = DEFAULT_WORLD_COLOR			
					WorldLight.light_energy = 1.2
					BaseLights.show()
					BillboardLights.show()
					CautionLights.hide()
					altered = true
		

		# set fog from monitor data
		MiasmaFog.hide() if monitor.pollution == 0 else MiasmaFog.show()
		MiasmaFog.material.emission = POLLUTION_LIGHT_COLOR #Color(0.725, 0.042, 0.543) if is_overheated else Color(0.561, 0.239, 0.736)
		MiasmaFog.min_density = monitor.pollution * 0.05
		MiasmaFog.max_density = monitor.pollution * 0.2
		

		# set previous state so can turn on/off 
		previous_billboard_state = BillboardLights.is_visible_in_tree()	
		previous_baselights_state = BaseLights.is_visible_in_tree()
		previous_emergency_state = EmergencyLights.is_visible_in_tree()
		
# --------------------------------------------------------

# --------------------------------------------------------
func update_billboards() -> void:
	if use_location.is_empty() or room_config.is_empty():return
	var altered:bool = false
	var left_billboard_text:String = "WELCOME TO WING %s%s" % [use_location.floor, use_location.ring]
	var right_billboard_text:String = "EVERYTHING IS FINE"

	if nuke_is_triggered:		
		left_billboard_text = "NUCLEAR DETONATION EMMINENT!"
		right_billboard_text = "EVACUATE IMMEDIATELY!"
		altered = true
		
	if in_lockdown and !altered:
		left_billboard_text = "LOCKDOWN"
		right_billboard_text = "SHELTER IN PLACE"
		altered = true
		
	#if !is_ventilated and !altered:
		#left_billboard_text = "STAY OUT"
		#right_billboard_text = "MIASMA DETECTED"
		#altered = true
		#
	#if is_overheated and !altered:		
		#left_billboard_text = "STAY OUT"
		#right_billboard_text = "DANGEROUS TEMPERATURE DETECTED"
		#altered = true
		#
	#if !is_powered and !altered:
		#left_billboard_text = "NO POWER"
		#right_billboard_text = "NO POWER"
		#altered = true
		

		
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


	#LeftBillbordLabel.text = left_billboard_text
	#RightBillboardLabel.text = right_billboard_text
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
func _process(delta: float) -> void:
	if !is_node_ready():return
	time += delta
	
	var val: float = sin(time * 1.5) * (8.5 + 7.5) # -1 to 16
	if val <= 0 and toggle_ready:
		toggle_color = !toggle_color
		toggle_ready = false
	elif val > 0:
		toggle_ready = true
	
	#var fluct_val: float = 0.85 + 0.25 * sin(time * 0.5)  # Oscillates between 0.6 and 1.1
	#WorldLight.light_energy = fluct_val
	if emergency_mode == ROOM.EMERGENCY_MODES.DANGER:
		EmergencyFlareLight.light_energy = val
		EmergencyFlareLight.light_color = Color.ROYAL_BLUE if toggle_color else Color.ORANGE_RED
