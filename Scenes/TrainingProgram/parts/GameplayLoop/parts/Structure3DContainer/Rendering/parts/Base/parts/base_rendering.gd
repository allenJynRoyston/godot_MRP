extends Node3D

@onready var FloorInstance:Node3D = $Node3D/FloorInstance
@onready var FloorInstanceContainer:Node3D = $Node3D/FloorInstanceContainer
@onready var Camera:Camera3D = $Node3D/Camera3D

const TransparencyShaderPreload:ShaderMaterial = preload("res://Shader/Spatial/Transparency.tres")
const RoomMaterialActive:StandardMaterial3D = preload("res://Materials/RoomMaterialUnderConstruction.tres")
const RoomMaterialInactive:StandardMaterial3D = preload("res://Materials/RoomMaterialInactive.tres")

var camera_settings:Dictionary = {} 
var current_location:Dictionary = {} 
var camera_tween:Tween = create_tween()

# ------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_process(self)
	GBL.register_node(REFS.BASE_RENDER, self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	
func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)
	GBL.unregister_node(REFS.BASE_RENDER)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)

func _ready() -> void:	
	#build_floors()
	set_base_zoom(0)
	camera_tween = create_tween()
# ------------------------------------------------

# -----------------------------------------------
func custom_tween_range(start_at:float, end_at:float, duration:float, callback:Callable = func(_val):pass) -> Tween:
	if camera_tween.is_running():
		camera_tween.stop()
		
	camera_tween = create_tween()
	camera_tween.set_trans(Tween.TRANS_SINE)
	camera_tween.set_ease(Tween.EASE_OUT)
	camera_tween.tween_method(callback, start_at, end_at, duration)
	
	return camera_tween
# -----------------------------------------------	

# ------------------------------------------------
var previous_floor:int = -1
var previous_ring:int = -1
func on_current_location_update(new_val:Dictionary = current_location) -> void:
	current_location = new_val
	if !is_node_ready() or current_location.is_empty():return
	U.debounce(str(self.name, "_update_mesh"), update_mesh)
	
	# rotate ring
	if previous_ring != current_location.ring:
		previous_ring = current_location.ring
		custom_tween_range(FloorInstanceContainer.rotation_degrees.y, -(current_location.ring * 90), 0.3, 
			func(val:float) -> void:
				FloorInstanceContainer.rotation_degrees.y = val
		)	
	
	# move to floor
	if previous_floor != current_location.floor:
		previous_floor = current_location.floor
		custom_tween_range(Camera.position.y, -(current_location.floor * 25) + 20, 0.3, 
			func(val:float) -> void:
				Camera.position.y = val
		)
# ------------------------------------------------

# -----------------------------------------------			
func on_camera_settings_update(new_val:Dictionary) -> void: 
	camera_settings = new_val
	if !is_node_ready() or current_location.is_empty():return
	U.debounce(str(self.name, "_update_mesh"), update_mesh)
# -----------------------------------------------			

# ------------------------------------------------
func build_floors() -> void:
	for n in range(7):
		var floor_duplicate:Node3D = FloorInstance.duplicate()
		floor_duplicate.show()
		floor_duplicate.position.y = n * -27
		FloorInstanceContainer.add_child(floor_duplicate)
	FloorInstance.queue_free()
# ------------------------------------------------

# ------------------------------------------------
func update_mesh() -> void:	
	if !is_node_ready() or current_location.is_empty() or camera_settings.is_empty() or FloorInstanceContainer.get_child_count() == 0:return	
	pass
	#for floor_index in FloorInstanceContainer.get_child_count():
		#var floor_node:Node3D = FloorInstanceContainer.get_child(floor_index)
		#for ring_index in floor_node.get_child_count():
			#var child:MeshInstance3D = floor_node.get_child(ring_index)
			#var mesh_duplicate = child.mesh.duplicate()
			#if camera_settings.is_locked:
				#mesh_duplicate.material = TransparencyShaderPreload.duplicate()	
				#var material_copy:StandardMaterial3D = RoomMaterialActive.duplicate() if floor_index == current_location.floor else RoomMaterialInactive.duplicate()
				#material_copy.albedo_color = material_copy.albedo_color.lerp(Color(0, 0, 0), 0.5)
				#mesh_duplicate.material = material_copy	
			#else:
				#if floor_index < current_location.floor:
					#mesh_duplicate.material = TransparencyShaderPreload.duplicate()		
				#else:					
					#var material_copy:StandardMaterial3D = RoomMaterialActive.duplicate() if floor_index == current_location.floor and ring_index == current_location.ring else RoomMaterialInactive.duplicate()
					#material_copy.albedo_color = material_copy.albedo_color.lerp(Color(0, 0, 0), 0.5)
					#mesh_duplicate.material = material_copy		
			#child.mesh = mesh_duplicate	
# ------------------------------------------------


# ------------------------------------------------
func set_base_zoom(zoom_val:int) -> void:
	match zoom_val:
		0:
			#U.tween_node_property(Camera, "position:x", 150, 0.7, 0, Tween.TRANS_CUBIC)
			await U.tween_node_property(Camera, "size", 120, 0.7, 0, Tween.TRANS_CUBIC)
		1:
			await U.tween_node_property(Camera, "size", 50, 0.7, 0, Tween.TRANS_CUBIC)

# ------------------------------------------------

# ------------------------------------------------
func on_process_update(_delta:float, _time_passed:float) -> void:
	if !is_node_ready():return
	
	#FloorInstanceContainer.rotate_y(0.005)
# ------------------------------------------------
