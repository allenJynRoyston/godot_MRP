extends PanelContainer

@onready var FocusContainer:Control = $FocusContainer
@onready var DetailImage:TextureRect = $FocusContainer/HighlightContainer/Details/DetailImage
@onready var Title:Label = $FocusContainer/HighlightContainer/Details/Title
@onready var Description:Label = $FocusContainer/HighlightContainer/Details/Description
@onready var ConstructionTime:Label = $FocusContainer/HighlightContainer/Notes/ConstructionTime
@onready var EffectList:VBoxContainer = $FocusContainer/HighlightContainer/Effects/EffectList
@onready var OperatingCostsList:VBoxContainer = $FocusContainer/HighlightContainer/OperatingCosts/OperatingCostsList
@onready var ConstructionCostList:VBoxContainer = $FocusContainer/HighlightContainer/ConstructionCosts/ConstructionCostsList

const small_label_preload:LabelSettings = preload("res://Fonts/settings/small_label.tres")
const TextButtonPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var hide_details:bool = false : 
	set(val):
		hide_details = val
		on_hide_details_update()
		
var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_hide_details_update()
	on_data_update()

func on_hide_details_update() -> void:
	if is_node_ready():
		FocusContainer.show() if hide_details else FocusContainer.hide()
		if hide_details:
			for node in [EffectList, ConstructionCostList, OperatingCostsList]:
				for child in node.get_children():
					child.queue_free()

func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	
	Title.text = data.details.name
	Description.text = data.details.description
	DetailImage.texture = CACHE.fetch_image(data.details.image_src if "image_src" in data.details else "")		
	ConstructionTime.text = "Construction time: %s days" % [str(data.details.get_build_time.call())]
	
	var capacity_list:Array = ROOM_UTIL.return_resource_capacity(data.id)
	var amount_list:Array = ROOM_UTIL.return_resource_amount(data.id)
	var operating_cost_list:Array = ROOM_UTIL.return_operating_cost(data.id)
	var construction_cost_list:Array = ROOM_UTIL.return_build_cost(data.id)

	for item in capacity_list:
		var new_node:BtnBase = TextButtonPreload.instantiate()		
		new_node.icon = item.resource.icon
		new_node.title = "+%s capacity" % [item.amount]
		EffectList.add_child(new_node)
		
	for item in amount_list:
		var new_node:BtnBase = TextButtonPreload.instantiate()		
		new_node.icon = item.resource.icon
		new_node.title = "+%s amount" % [item.amount]
		EffectList.add_child(new_node)				
		
	for item in operating_cost_list:
		var new_node:BtnBase = TextButtonPreload.instantiate()		
		new_node.icon = item.resource.icon
		new_node.title = "-%s amount" % [item.amount]
		OperatingCostsList.add_child(new_node)			
		
	for item in construction_cost_list:
		var new_node:BtnBase = TextButtonPreload.instantiate()		
		new_node.icon = item.resource.icon
		new_node.title = "-%s amount" % [item.amount]
		ConstructionCostList.add_child(new_node)					
		
			
