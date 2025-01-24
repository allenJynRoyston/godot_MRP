@tool
extends GameContainer

# -----------------------------------------------
func _ready() -> void:
	super._ready()
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
# -----------------------------------------------

# -----------------------------------------------
func on_current_location_update(new_val:Dictionary) -> void:
	current_location = new_val
	if !is_node_ready():return
	#FloorLabel.text = "F%s" % [current_location.floor]
	#WingLabel.text = "WING %s" % [current_location.ring]
	# -----------------------------------------------
