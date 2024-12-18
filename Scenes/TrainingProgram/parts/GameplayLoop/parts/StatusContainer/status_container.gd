@tool
extends GameContainer

@onready var DayLabel:Label = $SubViewport/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/DayLabel

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	on_progress_data_update()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_progress_data_update() -> void:
	if is_node_ready() and !progress_data.is_empty():
		DayLabel.text = "DAY %s" % [progress_data.day]
# --------------------------------------------------------------------------------------------------			
	
