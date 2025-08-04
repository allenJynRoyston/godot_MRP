extends HBoxContainer

@onready var ContentLabel:Label = $ContentLabel

var content:String = "" 

var default_pos:Vector2

func _init() -> void:
	self.modulate = Color(1, 1, 1, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.modulate = Color(1, 1, 1, 1)
	#ContentLabel.text = content
	#await U.tick()
	#default_pos = position
	#position.x += 10
	#
	#U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3)	
	#await U.tween_node_property(self, "position:x", default_pos.x, 0.3)
	#
	#await U.set_timeout(3.0)
	#
	#U.tween_node_property(self, "modulate", Color(1, 1, 1, 0), 0.3)	
	#await U.tween_node_property(self, "position:x", default_pos.x - 10, 0.3)
	#
	#queue_free()
	#
