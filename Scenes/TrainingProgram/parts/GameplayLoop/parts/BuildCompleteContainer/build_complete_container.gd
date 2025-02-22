extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var ContentMarginContainer:MarginContainer = $ContentControl/MarginContainer
@onready var TitleLabel:Label = $ContentControl/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var DescriptionList:VBoxContainer = $ContentControl/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/DescriptionList
@onready var ImageContainer:TextureRect = $ContentControl/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ImageContainer

@onready var BtnMarginContainer:MarginContainer = $BtnControl/MarginContainer
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var NextOrCloseBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/NextOrCloseBtn

#@onready var NextBtn:Control = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextBtn
#@onready var SkipBtn:Control = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/SkipBtn
#@onready var Activate:Control = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Activate

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

var content_restore_pos:int
var btn_restore_pos:int
var is_setup:bool = false

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	NextOrCloseBtn.onClick = func() -> void:
		on_next()

	on_has_more_update()
	
	await U.set_timeout(1.0)	
	content_restore_pos = ContentMarginContainer.position.y			
	btn_restore_pos = BtnMarginContainer.position.y
	is_setup = true
	on_is_showing_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_next() -> void:
	on_item = on_item + 1
	if !has_more:		
		user_response.emit()
		return
	update_display()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_is_showing_update() -> void:
	super.on_is_showing_update()
	if !is_node_ready():return
	if !is_setup:return
	
	if !is_showing:
		for btn in RightSideBtnList.get_children():
			btn.is_disabled = true

	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1 if is_showing else 0))
	U.tween_node_property(ContentMarginContainer, "modulate", Color(1, 1, 1, 1 if is_showing else 0), 0.3)

	U.tween_node_property(ContentMarginContainer, "position:y", content_restore_pos if is_showing else content_restore_pos - 20, 0.3)
	U.tween_node_property(BtnMarginContainer, "position:y", btn_restore_pos if is_showing else BtnMarginContainer.size.y + 20, 0.3)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func update_display() -> void:
	var data:Dictionary = completed_build_items[on_item]
	
	has_more = on_item + 1 < completed_build_items.size() 
	
	for child in DescriptionList.get_children():
		child.queue_free()
		
	for btn in RightSideBtnList.get_children():
		btn.is_disabled = false		
		
	match data.action:
		# ------------------------------------------------------------------------------------------
		ACTION.AQ.BUILD_ITEM:
			var details:Dictionary = ROOM_UTIL.return_data(data.ref)
			var activation_requirements:Array = ROOM_UTIL.return_activation_cost(data.ref)

			TitleLabel.text = "%s Built!" % [details.name]
			ImageContainer.texture = CACHE.fetch_image(details.img_src)

			var can_activate:bool = RESOURCE_UTIL.check_if_have_enough(ROOM_UTIL.return_activation_cost(data.ref), resources_data)

			DescriptionList.hide() if activation_requirements.size() == 0 else DescriptionList.show()
			#NextBtn.show()
			#Activate.show()
			#Activate.is_disabled = !can_activate
			#Activate.onClick = func() -> void:
				#if can_activate:
					#GameplayNode.activate_room(data.location, data.ref, true, false)
					#on_next()

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
	NextOrCloseBtn.title = "NEXT" if has_more else "CLOSE"
# --------------------------------------------------------------------------------------------------
