extends FogVolume

var angle: float = 0.0
var radius: float = 100.0
var speed: float = 1.0 # Radians per second

func _process(delta: float) -> void:
	angle += speed * delta
	var x = cos(angle) * radius
	var z = sin(angle) * radius
	global_transform.origin.x = x
	global_transform.origin.z = z
