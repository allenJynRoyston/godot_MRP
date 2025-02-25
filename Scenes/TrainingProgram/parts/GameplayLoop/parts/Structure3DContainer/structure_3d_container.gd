extends GameContainer

@onready var SelectLocationInstructions:VBoxContainer = $PanelContainer/MarginContainer/SelectLocationInstructions
@onready var PlacementInstructions:VBoxContainer = $PanelContainer/MarginContainer/PlacementInstructions
@onready var Rendering:Node3D = $SubViewport/Rendering


var placement_instructions:Array = [] : 
	set(val):
		placement_instructions = val

		

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.STRUCTURE_3D, self)


func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.STRUCTURE_3D)

	
func _ready() -> void:
	super._ready()
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
# --------------------------------------------------------------------------------------------------		
