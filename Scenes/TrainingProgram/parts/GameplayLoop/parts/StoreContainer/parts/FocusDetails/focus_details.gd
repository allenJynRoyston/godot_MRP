extends PanelContainer

@onready var FocusContainer:Control = $FocusContainer
@onready var DetailImage:TextureRect = $FocusContainer/HighlightContainer/VBoxContainer/DetailImage
@onready var Title:Label = $FocusContainer/HighlightContainer/VBoxContainer/Title
@onready var Description:Label = $FocusContainer/HighlightContainer/VBoxContainer/Description
@onready var ConstructionTime:Label = $FocusContainer/HighlightContainer/VBoxContainer3/ConstructionTime
@onready var EffectList:VBoxContainer = $FocusContainer/HighlightContainer/VBoxContainer2/EffectList

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
			for child in EffectList.get_children():
				child.queue_free()

func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	
	Title.text = data.details.name
	Description.text = data.details.description
	DetailImage.texture = CACHE.fetch_image(data.details.image_src if "image_src" in data.details else "")		
	ConstructionTime.text = "Construction time: %s days" % [str(data.details.get_build_time.call())]
	
	var capacity_list:Array = ROOM_UTIL.return_resource_capacity(data.id)
	var amount_list:Array = ROOM_UTIL.return_resource_amount(data.id)

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
