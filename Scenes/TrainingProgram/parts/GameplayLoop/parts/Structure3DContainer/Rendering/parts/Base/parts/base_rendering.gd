extends Node3D

@onready var FloorInstance:Node3D = $Node3D/FloorInstance
@onready var FloorInstanceContainer:Node3D = $Node3D/FloorInstanceContainer
@onready var Camera:Camera3D = $Node3D/Camera3D

const TransparencyShaderPreload:ShaderMaterial = preload("res://Shader/Spatial/Transparency.tres")
const RoomMaterialActive:StandardMaterial3D = preload("res://Materials/RoomMaterialUnderConstruction.tres")
const RoomMaterialInactive:StandardMaterial3D = preload("res://Materials/RoomMaterialInactive.tres")

var ActiveWingNode:Node3D
var camera_settings:Dictionary = {} 
var current_location:Dictionary = {} 
var camera_tween:Tween = create_tween()

# ------------------------------------------------
func _init() -> void:
	GBL.register_node(REFS.BASE_RENDER, self)
	SUBSCRIBE.subscribe_to_current_location(self)
	SUBSCRIBE.subscribe_to_camera_settings(self)
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.BASE_RENDER)
	SUBSCRIBE.unsubscribe_to_current_location(self)
	SUBSCRIBE.unsubscribe_to_camera_settings(self)

func _ready() -> void:	
	assign_floor_data()
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
func assign_floor_data() -> void:
	for index in FloorInstanceContainer.get_child_count():
		var FloorNode:Node3D = FloorInstanceContainer.find_child( str("F", index) )
		for ring_index in FloorNode.get_child_count():
			var WingNode:Node3D = FloorNode.find_child( str("W", ring_index) )		
			WingNode.assign_location = {"floor": index, "ring": ring_index}

# ------------------------------------------------

# ------------------------------------------------
func update_mesh() -> void:	
	if !is_node_ready() or current_location.is_empty() or camera_settings.is_empty() or FloorInstanceContainer.get_child_count() == 0:return	
	pass
# ------------------------------------------------

# ------------------------------------------------
func set_base_zoom(zoom_val:int) -> void:
	match zoom_val:
		0:
			#U.tween_node_property(Camera, "position:x", 150, 0.7, 0, Tween.TRANS_CUBIC)
			await U.tween_node_property(Camera, "size", 120, 0.7, 0, Tween.TRANS_SINE)
		1:
			U.tween_node_property(Camera, "position:x", -30, 0.7, 0, Tween.TRANS_SINE)
			await U.tween_node_property(Camera, "size", 50, 0.7, 0, Tween.TRANS_SINE)
		2:
			U.tween_node_property(Camera, "position:x", -35, 0.7, 0, Tween.TRANS_SINE)
			await U.tween_node_property(Camera, "size", 40, 0.7, 0, Tween.TRANS_SINE)
# ------------------------------------------------

# ------------------------------------------------
func animate_internals(state:bool) -> void:
	#var FloorNode:Node3D = FloorInstanceContainer.find_child( str("F", current_location.floor) )

	# first, hide all other floors
	if state:
		for index in FloorInstanceContainer.get_child_count():
			var FloorNode:Node3D = FloorInstanceContainer.find_child( str("F", index) )
			FloorNode.hide() if index != current_location.floor else FloorNode.show()
			if index == current_location.floor:
				ActiveWingNode = FloorNode.find_child( str("W", current_location.ring) )
				ActiveWingNode.remove_shell(true)
	# else 
	else:
		ActiveWingNode = null
		for index in FloorInstanceContainer.get_child_count():
			var FloorNode:Node3D = FloorInstanceContainer.find_child( str("F", index) )
			FloorNode.show()
			for ring_index in FloorNode.get_child_count():
				var WingNode:Node3D = FloorNode.find_child( str("W", ring_index) )
				WingNode.remove_shell(false)

# ------------------------------------------------
