extends Node3D

@onready var SceneCamera:Camera3D = $Node3D/Camera3D
@onready var WorldEnv:WorldEnvironment = $Node3D/WorldEnvironment

@onready var world_environment:Environment = WorldEnv.get("environment").duplicate()

var animation_tween:Tween

func _ready() -> void:
	# start position
	SceneCamera.rotation_degrees = Vector3(36, 47, -36)
	SceneCamera.position.z = 100
	world_environment.volumetric_fog_density = 0.2
	WorldEnv.set("environment", world_environment)

func zoomIn() -> void:
	animation_tween = create_tween()
	tween_range(0.2, 0.06, 20.0, func(new_val:float): 
		world_environment.volumetric_fog_density = new_val
	)
	U.tween_node_property(SceneCamera, "rotation:x", U.generate_rand(-3, 3) * 0.1 if GBL.active_user_profile.boot_count > 0 else 0, 4.0, 2.0)
	U.tween_node_property(SceneCamera, "rotation:z", U.generate_rand(-3, 3) * 0.1 if GBL.active_user_profile.boot_count > 0 else 0, 5.0, 2.0)
	await U.tween_node_property(SceneCamera, "position:z", 12, 8.0, 0, Tween.TRANS_EXPO)

func zoomOut() -> void:
	tween_range(0.06, 0.2, 2.7, func(new_val:float): 
		world_environment.volumetric_fog_density = new_val
	)	
	U.tween_node_property(SceneCamera, "rotation_degrees:x", U.generate_rand(-25, 25) if GBL.active_user_profile.boot_count > 0 else 20, 4.0, 2.0)
	U.tween_node_property(SceneCamera, "rotation_degrees:z", U.generate_rand(-25, 25) if GBL.active_user_profile.boot_count > 0 else 30, 5.0, 1.0)	
	U.tween_node_property(SceneCamera, "position:z", -30, 5.0, 0, Tween.TRANS_EXPO)
	await U.set_timeout(4.0)

# -----------------------------------------------
func tween_range(start_at:float, end_at:float, duration:float, callback:Callable = func(_val):pass) -> void:
	if animation_tween.is_running():
		animation_tween.stop()
	animation_tween = create_tween()		
	#tween.set_ease(Tween.EASE_OUT_IN)
	animation_tween.set_trans(Tween.TRANS_EXPO)
	animation_tween.tween_method(callback, start_at, end_at, duration)
# -----------------------------------------------	
