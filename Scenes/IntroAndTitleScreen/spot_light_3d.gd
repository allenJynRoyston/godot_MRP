extends SpotLight3D

@export var rotation_intensity : float = 5.0  # How much to rotate left and right
@export var rotation_speed : float = 0.5      # Speed of the rotation

var time_offset : float = 0.0  # Time accumulator for the sine wave

# Called every frame
func _process(delta: float) -> void:
	if !is_visible_in_tree():return
	time_offset += delta * rotation_speed  # Accumulate time for oscillation

	# Rotate around the Y-axis using a sine wave for smooth left-right rotation
	rotation_degrees.x = sin(time_offset) * rotation_intensity
