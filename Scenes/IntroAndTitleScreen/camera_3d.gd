#extends Camera3D

## Wobble parameters
#@export var wobble_intensity : float = 0.05  # Wobble intensity
#@export var wobble_speed : float = 2.0       # Speed of the wobble
#
#var original_position : Vector3
#var original_rotation : Vector3
#var time_offset : float = 0.0
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	## Store the initial position and rotation of the camera
	#original_position = global_transform.origin
	#original_rotation = global_transform.basis.get_euler()
#
## Update the camera each frame
#func _process(delta: float):
	#time_offset += delta * wobble_speed
#
	## Apply a smooth wobble effect using sine functions for a smooth oscillation
	#var wobble_offset = Vector3(
		#sin(time_offset) * wobble_intensity,  # Wobble on X-axis
		#sin(time_offset * 1.3) * wobble_intensity,  # Wobble on Y-axis
		#sin(time_offset * 0.7) * wobble_intensity   # Wobble on Z-axis
	#)
#
	## Apply the wobble to the camera's position while keeping its original rotation
	#global_transform.origin = original_position + wobble_offset
	#global_transform.basis = Basis().from_euler(original_rotation)
