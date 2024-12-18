@tool
extends GameContainer

@onready var TitleLabel:Label = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var DescriptionList:VBoxContainer = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/DescriptionList

@onready var NextBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextBtn
@onready var SkipBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/SkipBtn

const small_label_preload:LabelSettings = preload("res://Fonts/settings/small_label.tres")

var on_item:int = 0
var has_more:bool = false : 
	set(val):
		has_more = val
		on_has_more_update()

var completed_build_items:Array = [] : 
	set(val):
		completed_build_items = val
		on_completed_build_items_update()
	

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	TextureRectNode = $TextureRect
	Subviewport = $SubViewport
	
	NextBtn.onClick = func() -> void:
		on_item = on_item + 1
		if !has_more:
			user_response.emit({"action": ACTION.DONE})
			return
			
		update_display()
		
	SkipBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.SKIP})
		
	on_has_more_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func update_display() -> void:
	var data:Dictionary = completed_build_items[on_item]
	
	has_more = on_item + 1 < completed_build_items.size() 
	
	for child in DescriptionList.get_children():
		child.queue_free()
		
	match data.action:
		ACTION.BUILD:
			var room_data:Dictionary = ROOM_UTIL.return_data(data.data.id)
			TitleLabel.text = "%s Built!" % [room_data.name]
			var capacity_list:Array = ROOM_UTIL.return_resource_capacity(data.data.id)
			var amount_list:Array = ROOM_UTIL.return_resource_amount(data.data.id)
			
			for item in capacity_list:
				var label_node:Label = Label.new()
				label_node.label_settings = small_label_preload
				label_node.text = "%s +%s capacity" % [item.resource.name, item.amount]
				DescriptionList.add_child(label_node)
				
			for item in amount_list:
				var label_node:Label = Label.new()
				label_node.label_settings = small_label_preload
				label_node.text = "%s +%s amount" % [item.resource.name, item.amount]
				DescriptionList.add_child(label_node)				
				
				

	get_parent().goto_location(data.location)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func on_completed_build_items_update() -> void:
	on_item = 0
	
	for child in DescriptionList.get_children():
		child.queue_free()
	
	if completed_build_items.is_empty():
		return
		
	update_display()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_has_more_update() -> void:
	if is_node_ready():
		NextBtn.title = "Next" if has_more else "Close"
		SkipBtn.show() if has_more else SkipBtn.hide()
# --------------------------------------------------------------------------------------------------
