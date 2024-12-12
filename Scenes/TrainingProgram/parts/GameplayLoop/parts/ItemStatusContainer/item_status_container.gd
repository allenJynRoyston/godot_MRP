@tool
extends GameContainer

@onready var SubviewPanelContainer:PanelContainer = $SubViewport/PanelContainer

var max_height:int : 
	set(val): 
		max_height = val
		on_max_height_update()
		

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func _on_subviewport_child_changed() -> void:pass
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------				
func on_max_height_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		Subviewport.get_child(0).size.y = max_height - 1
		Subviewport.size = Subviewport.get_child(0).size
# --------------------------------------------------------------------------------------------------					
