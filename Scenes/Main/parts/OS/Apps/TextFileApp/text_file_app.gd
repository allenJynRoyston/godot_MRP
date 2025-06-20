extends AppWrapper

@onready var TitleLabel:Label = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VBoxContainer/Label
@onready var ContentRTL:RichTextLabel = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/VBoxContainer/RichTextLabel

## ------------------------------------------------------------------------------
#func _ready() -> void:
	#WindowUI = $WindowUI
	#super._ready()
	#on_data_update()
## ------------------------------------------------------------------------------
#
## ------------------------------------------------------------------------------
#func on_data_update() -> void:
	#if !is_node_ready():return
	##if "title" in app_props:
		##TitleLabel.text = app_props.title
	##if "content" in app_props:
		##ContentRTL.text = app_props.content
		#
## ------------------------------------------------------------------------------	
