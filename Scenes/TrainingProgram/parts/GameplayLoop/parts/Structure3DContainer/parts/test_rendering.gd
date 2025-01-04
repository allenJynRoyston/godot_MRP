extends Node3D
@onready var TestCamera:Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if !is_node_ready():return
	##$Building.rotate_y(0.01)
	### get the mouse position's relative position 
	#var container_node:Control = GBL.find_node(REFS.STRUCTURE_3D)
	#var relative_mouse_pos:Vector2 = (GBL.mouse_pos - container_node.global_position)
	#var container_size:Vector2 = container_node.size #+ container_node.global_position 
	### converts the mouse position into (0,0) -> (1,1)
	#var normalized_mouse_pos:Vector2 = Vector2(relative_mouse_pos.x / container_size.x, relative_mouse_pos.y / container_size.y)
	#
	### converts mouse position into a value that fits in the resolution (0,0) -> (640, 480) 
	#var screen_position:Vector2 = Vector2(normalized_mouse_pos * (get_viewport().size * 1.0))
	#
	## Get the ray origin and direction from the camera
	#var ray_origin = TestCamera.project_ray_origin(screen_position)
	#var ray_direction = TestCamera.project_ray_normal(screen_position)
#
	## Create a PhysicsRayQueryParameters3D object
	#var ray_query = PhysicsRayQueryParameters3D.new()
	#ray_query.from = ray_origin
	#ray_query.to = ray_origin + ray_direction * 20  # Length of the ray (1000 units)
#
	## Perform the raycast with the 3D query
	#var space_state = get_world_3d().direct_space_state
	#var result = space_state.intersect_ray(ray_query)
#
	### Check if a collision happened
	#if result:
		#print(result.collider.get_parent())
	#else:
		#print("")
