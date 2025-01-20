@tool
extends GameContainer

@onready var TitleLabel:Label = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var DescriptionList:VBoxContainer = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/DescriptionList
@onready var ImageContainer:TextureRect = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ImageContainer

@onready var NextBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextBtn
@onready var SkipBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/SkipBtn

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")
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
		on_next()
		
	SkipBtn.onClick = func() -> void:
		on_skip()
		
	on_has_more_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_next() -> void:
	on_item = on_item + 1
	if !has_more:
		user_response.emit({"action": ACTION.DONE})
		return
	update_display()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_skip() -> void:
	user_response.emit({"action": ACTION.SKIP})
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
func update_display() -> void:
	var data:Dictionary = completed_build_items[on_item]
	
	has_more = on_item + 1 < completed_build_items.size() 
	
	for child in DescriptionList.get_children():
		child.queue_free()
		
	match data.action:
		# ------------------------------------------------------------------------------------------
		ACTION.AQ.BUILD_ITEM:
			var details:Dictionary = ROOM_UTIL.return_data(data.ref)
			var build_complete_list:Array = ROOM_UTIL.return_build_complete(data.ref)

			TitleLabel.text = "%s Built!" % [details.name]
			ImageContainer.texture = CACHE.fetch_image(details.img_src)

			for item in build_complete_list:
				var label_node:Control = TextBtnPreload.instantiate()
				label_node.is_hoverable = false
				label_node.icon = item.resource.icon
				label_node.title =  "+%s [%s]" % [item.amount, item.type]
				DescriptionList.add_child(label_node)
		# ------------------------------------------------------------------------------------------
		ACTION.AQ.BASE_ITEM:
			var details:Dictionary = BASE_UTIL.return_data(data.ref)
			var build_complete_list:Array = BASE_UTIL.return_build_complete(data.ref)

			TitleLabel.text = "%s Built!" % [details.name]
			ImageContainer.texture = CACHE.fetch_image(details.img_src)
			
			for item in build_complete_list:
				var label_node:Control = TextBtnPreload.instantiate()
				label_node.is_hoverable = false
				label_node.icon = item.resource.icon
				label_node.title =  "+%s [%s]" % [item.amount, item.type]
				DescriptionList.add_child(label_node)
		# ------------------------------------------------------------------------------------------		
		ACTION.AQ.RESEARCH_ITEM:
			var details:Dictionary = RD_UTIL.return_data(data.ref)
			TitleLabel.text = "Research complete: %s" % [details.name]
			ImageContainer.texture = CACHE.fetch_image(details.img_src)		
		# ------------------------------------------------------------------------------------------
		ACTION.AQ.CONTAIN:
			var details:Dictionary = SCP_UTIL.return_data(data.ref)
			TitleLabel.text = "SCP %s successfully contained." % [details.item_id]
			ImageContainer.texture = CACHE.fetch_image(details.img_src)
		# ------------------------------------------------------------------------------------------
		ACTION.AQ.TRANSFER:
			var details:Dictionary = SCP_UTIL.return_data(data.ref)
			TitleLabel.text = "SCP %s successfully transfered." % [details.item_id]
			ImageContainer.texture = CACHE.fetch_image(details.img_src)
		# ------------------------------------------------------------------------------------------
		ACTION.AQ.ACCESSING:
			var details:Dictionary = SCP_UTIL.return_data(data.ref)
			TitleLabel.text = "Accessing complete."
			ImageContainer.texture = CACHE.fetch_image(details.img_src)
		# ------------------------------------------------------------------------------------------
		ACTION.AQ.TESTING:
			var details:Dictionary = SCP_UTIL.return_data(data.ref)
			TitleLabel.text = "Testing complete."
			ImageContainer.texture = CACHE.fetch_image(details.img_src)
		# ------------------------------------------------------------------------------------------	
					
	if "location" in data:
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

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_showing:return
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"ENTER":
			on_skip()
		"E":
			on_next()
# --------------------------------------------------------------------------------------------------	
