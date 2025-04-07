@tool
extends SubscribeWrapper

@onready var ResourceItem:Control = $MarginContainer/VBoxContainer/HBoxContainer2/Resources/MarginContainer/HBoxContainer2/ResourceItem

@onready var HeaderLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/Label

@export var header_label:String = "MONEY" : 
	set(val):
		header_label = val
		on_header_update()

@export var resource:RESOURCE.CURRENCY = RESOURCE.CURRENCY.MONEY :
	set(val):
		resource = val
		on_resource_update()
		
func _ready() -> void:
	if !is_node_ready():return
	on_resource_update()
	on_header_update()
	
func on_header_update() -> void:
	if !is_node_ready():return
	HeaderLabel.text = header_label
		
func on_resource_update() -> void:
	if !is_node_ready():return
	match resource:
		RESOURCE.CURRENCY.MONEY:
			ResourceItem.icon = SVGS.TYPE.MONEY
		RESOURCE.CURRENCY.SCIENCE:
			ResourceItem.icon = SVGS.TYPE.RESEARCH
		RESOURCE.CURRENCY.MATERIAL:
			ResourceItem.icon = SVGS.TYPE.QUESTION_MARK
		RESOURCE.CURRENCY.CORE:
			ResourceItem.icon = SVGS.TYPE.DOT
			
func on_resources_data_update(new_val:Dictionary) -> void:
	resources_data = new_val
	if !is_node_ready():return
	ResourceItem.title = str(resources_data[resource].amount)
	
