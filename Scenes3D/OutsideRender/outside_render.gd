extends Node3D

@onready var SceneCamera:Camera3D = $Node3D/Camera3D

func _ready() -> void:
	# start position
	SceneCamera.rotation_degrees = Vector3(36, 47, -36)
	SceneCamera.position.z = 100

func zoomIn() -> void:
	U.tween_node_property(SceneCamera, "rotation:x", 0.02, 4.0, 2.0)
	U.tween_node_property(SceneCamera, "rotation:z", 0.01, 5.0, 1.0)
	await U.tween_node_property(SceneCamera, "position:z", 12, 8.0, 0, Tween.TRANS_EXPO)

func zoomOut() -> void:
	U.tween_node_property(SceneCamera, "rotation_degrees:x", 20, 4.0, 2.0)
	U.tween_node_property(SceneCamera, "rotation_degrees:z", 30, 5.0, 1.0)	
	U.tween_node_property(SceneCamera, "position:z", -30, 5.0, 0, Tween.TRANS_EXPO)
	await U.set_timeout(4.0)
