extends PanelContainer

@onready var ItemLabel:Label = $MarginContainer/VBoxContainer/DetailsContainer/HBoxContainer/VBoxContainer/Item/ItemLabel
@onready var ObjectLabel:Label = $MarginContainer/VBoxContainer/DetailsContainer/HBoxContainer/VBoxContainer/HBoxContainer/ObjectLabel

@onready var DetailsContainer:VBoxContainer = $MarginContainer/VBoxContainer/DetailsContainer
@onready var ContainmentContainer:VBoxContainer = $MarginContainer/VBoxContainer/ContainmentContainer
@onready var DescriptionContainer:VBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer2/DescriptionContainer

@onready var ContainmentLabel:Label = $MarginContainer/VBoxContainer/ContainmentContainer/ContainmentLabel
@onready var DescriptionLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer2/DescriptionContainer/DescriptionLabel

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

func _ready() -> void:
	on_data_update()

func set_label_defaults() -> void:
	ItemLabel.text = ""
	ObjectLabel.text = ""
	ContainmentLabel.text = ""
	DescriptionLabel.text = "" 
	ContainmentContainer.hide()
	DescriptionContainer.hide()
	DetailsContainer.hide()

func on_data_update() -> void:
	if !is_node_ready():return
	if data.is_empty():
		set_label_defaults()
		return

	ItemLabel.text = "SCP-%s" % [data.item_id]
	ObjectLabel.text = "KETER"
	
	var description:String = ""
	for item in data.description:
		for key in item:
			description += item[key]
	DescriptionLabel.text = description
	
	# add containment procedures that you've chosen so far
	ContainmentLabel.text = "Containment procedures ongoing."

	ContainmentContainer.show()
	DescriptionContainer.show()
	DetailsContainer.show()
