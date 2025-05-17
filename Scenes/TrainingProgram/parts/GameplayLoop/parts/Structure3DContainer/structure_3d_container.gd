extends GameContainer

@onready var Rendering:Control = $SubViewport/Rendering


# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
# --------------------------------------------------------------------------------------------------		
