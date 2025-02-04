@tool
extends GameContainer

@onready var TitleLabel:Label = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var DescriptionList:VBoxContainer = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/DescriptionList
@onready var ImageContainer:TextureRect = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ImageContainer

@onready var NextBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextBtn
@onready var SkipBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/SkipBtn
@onready var Activate:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Activate

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")
const CheckboxBtnPreload:PackedScene = preload("res://UI/Buttons/Checkbox/Checkbox.tscn")
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
		
	on_has_more_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_next() -> void:
	on_item = on_item + 1
	if !has_more:
		print("exit...")
		user_response.emit()
		return
	update_display()
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
			var activation_requirements:Array = ROOM_UTIL.return_activation_cost(data.ref)

			TitleLabel.text = "%s Built!" % [details.name]
			ImageContainer.texture = CACHE.fetch_image(details.img_src)

			var can_activate:bool = RESOURCE_UTIL.check_if_have_enough(ROOM_UTIL.return_activation_cost(data.ref), resources_data)

			DescriptionList.hide() if activation_requirements.size() == 0 else DescriptionList.show()
			NextBtn.show()
			Activate.show()
			Activate.is_disabled = !can_activate
			Activate.onClick = func() -> void:
				if can_activate:
					var GameplayNode:Control = GBL.find_node(REFS.GAMEPLAY_LOOP)
					GameplayNode.activate_room(data.location, data.ref, true, false)
					on_next()

			for item in activation_requirements:
				var current_amount:int = resources_data[item.resource.ref].amount
				var has_enough:bool = current_amount + item.amount < 0
				var new_node:Control = CheckboxBtnPreload.instantiate()
				new_node.is_hoverable = false
				new_node.no_bg = true
				new_node.is_checked = !has_enough
				new_node.title =  "%s required: %s (you have %s)" % [item.resource.name, abs(item.amount), current_amount]
				DescriptionList.add_child(new_node)
		# ------------------------------------------------------------------------------------------
		ACTION.AQ.BASE_ITEM:			
			var details:Dictionary = BASE_UTIL.return_data(data.ref)
			var build_complete_list:Array = BASE_UTIL.return_build_complete(data.ref)

			TitleLabel.text = "%s Built!" % [details.name]
			ImageContainer.texture = CACHE.fetch_image(details.img_src)
			

			
			
			#for item in build_complete_list:
				#var label_node:Control = TextBtnPreload.instantiate()
				#label_node.is_hoverable = false
				#label_node.icon = item.resource.icon
				#label_node.title =  "+%s [%s]" % [item.amount, item.type]
				#DescriptionList.add_child(label_node)
		# ------------------------------------------------------------------------------------------		
		ACTION.AQ.RESEARCH_ITEM:
			var details:Dictionary = RD_UTIL.return_data(data.ref)
			TitleLabel.text = "Research complete: %s" % [details.name]
			ImageContainer.texture = CACHE.fetch_image(details.img_src)		
		# ------------------------------------------------------------------------------------------
		ACTION.AQ.CONTAIN:
			var details:Dictionary = SCP_UTIL.return_data(data.ref)
			TitleLabel.text = "SCP %s successfully contained." % [details.name]
			ImageContainer.texture = CACHE.fetch_image(details.img_src)
		# ------------------------------------------------------------------------------------------
		ACTION.AQ.TRANSFER:
			var details:Dictionary = SCP_UTIL.return_data(data.ref)
			TitleLabel.text = "SCP %s successfully transfered." % [details.name]
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
		SUBSCRIBE.current_location = data.location
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
	if !is_node_ready():return
	NextBtn.title = "Next" if has_more else "Close"
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_showing:return
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"ENTER":
			on_next()
		"E":
			on_next()
# --------------------------------------------------------------------------------------------------	
