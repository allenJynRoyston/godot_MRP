extends PanelContainer

@onready var DescriptionLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/DescriptionLabel

var details:Dictionary = {} : 
	set(val):
		details = val
		on_details_update()

func _ready() -> void:
	on_details_update()

func on_details_update() -> void:
	if !is_node_ready() or details.is_empty():return
	DescriptionLabel.text = "%s" % [details.name]
		
