@tool
extends FogVolume

var time:float = 0
var speed:float = 5.0
func _process(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree():return
	time += delta
	self.rotate_y(0.01)
	#self.material.density = 0.3 * sin(time * speed * 0.01)  # between -0.3 and 0.3
	#self.material.height_falloff = (sin(time * speed * 0.1) + 1.2) / 2.0  # Oscillates smoothly between 0 and 1	
	#
	#var hue := fmod(time * speed * 0.0001, 1.0)
	#var color := Color.from_hsv(hue, 1.0, 1.0).lightened(0.4)
	#color.a = 0.1
	#self.material.albedo = color
