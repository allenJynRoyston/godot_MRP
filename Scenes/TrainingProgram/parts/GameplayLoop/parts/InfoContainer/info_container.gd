@tool
extends GameContainer

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.INFO_CONTAINER, self)	

func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.INFO_CONTAINER)	

func _ready() -> void:
	super._ready()	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
# --------------------------------------------------------------------------------------------------		
