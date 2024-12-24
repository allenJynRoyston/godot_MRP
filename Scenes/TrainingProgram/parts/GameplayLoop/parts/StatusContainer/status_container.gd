@tool
extends GameContainer

@onready var DayLabel:Label = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/DayLabel

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_progress_data_update(new_val:Dictionary = progress_data) -> void:
	progress_data = new_val
	if is_node_ready() and !progress_data.is_empty():
		DayLabel.text = "DAY %s" % [progress_data.day]
# --------------------------------------------------------------------------------------------------			
	
