extends FogVolume

var time:float = 0
var speed:float = 5.0
func _process(delta: float) -> void:
	if !is_node_ready() or !is_visible_in_tree():return
	time += delta
	self.rotate_y(0.01)
