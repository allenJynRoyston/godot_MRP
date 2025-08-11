extends FogVolume

var time:float = 0
var speed:float = 5.0
var direction: Vector3 = Vector3(1, 0, 0) # Move along X

func _process(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree():return
	time += delta
	var raw_value = 0.4 + 0.4 * sin(time * 0.5)  # slow it down with * 0.5
	var clamped_value = clamp(raw_value, 0.2, 0.6)
	self.material.density = clamped_value
	self.rotate_y(0.025)
