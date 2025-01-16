extends PanelContainer

@onready var StatusContainer:Control = $StatusContainer
@onready var ArticleContainer:Control = $ArticleContainer

@onready var ItemLabel:Label = $ArticleContainer/VBoxContainer/DetailsContainer/HBoxContainer/VBoxContainer/Item/ItemLabel
@onready var ObjectLabel:Label = $ArticleContainer/VBoxContainer/DetailsContainer/HBoxContainer/VBoxContainer/HBoxContainer/ObjectLabel
@onready var StatusLabel:Label = $StatusContainer/MarginContainer/VBoxContainer/HBoxContainer/StatusLabel

@onready var DetailsContainer:VBoxContainer = $ArticleContainer/VBoxContainer/DetailsContainer
@onready var ContainmentContainer:VBoxContainer = $ArticleContainer/VBoxContainer/HBoxContainer/VBoxContainer/ContainmentContainer
@onready var DescriptionContainer:HBoxContainer = $ArticleContainer/VBoxContainer/HBoxContainer/VBoxContainer/DescriptionContainer
@onready var ImageSrcTextureRect:TextureRect = $ArticleContainer/VBoxContainer/HBoxContainer/PanelContainer/ImageSrcTextureRect

@onready var ContainmentProceduresList:VBoxContainer = $ArticleContainer/VBoxContainer/HBoxContainer/VBoxContainer/ContainmentContainer/ContainmentProceduresList
@onready var DescriptionList:VBoxContainer = $ArticleContainer/VBoxContainer/HBoxContainer/VBoxContainer/DescriptionContainer/DescriptionContainer/DescriptionList

const description_label_setting:LabelSettings = preload("res://Fonts/game/label_small.tres")

enum LIST_TYPE {CONTAINED, AVAILABLE}

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

var list_type:LIST_TYPE = LIST_TYPE.AVAILABLE : 
	set(val):
		list_type = val
		on_list_type_update()

var scp_data:Dictionary = {} 

# ----------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_scp_data(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_scp_data(self)

func _ready() -> void:
	on_data_update()
# ----------------------------------------

# ----------------------------------------
func set_label_defaults() -> void:
	ItemLabel.text = ""
	ObjectLabel.text = ""
	
	ImageSrcTextureRect.texture = null
	
	for node in [DescriptionList, ContainmentProceduresList]:
		for child in node.get_children():
			child.queue_free()
	
	StatusContainer.hide()
	ArticleContainer.hide()
# ----------------------------------------

# ----------------------------------------
func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
	on_data_update.call_deferred()
# ----------------------------------------

# --------------------------------------------------------------------------------------------------		
func on_list_type_update() -> void:
	on_scp_data_update()
# --------------------------------------------------------------------------------------------------		

# ----------------------------------------
func on_data_update() -> void:
	if !is_node_ready():return
	if data.is_empty():
		set_label_defaults()
		return

	for node in [DescriptionList, ContainmentProceduresList]:
		for child in node.get_children():
			child.queue_free()

	
	ItemLabel.text = "SCP-%s" % [data.item_id]
	ObjectLabel.text = "KETER"
	ImageSrcTextureRect.texture = CACHE.fetch_image(data.img_src)
	
	var status_details:Dictionary = {
		"use": false,
		"text": ""
	}
	var unlocked:Array = []

	match list_type:
		LIST_TYPE.AVAILABLE:
			var list:Array = scp_data.available_list.filter(func(i): return i.ref == data.ref)
			if list.size() > 0:
				var item:Dictionary = list[0]
				status_details.use = item.transfer_status.state
				status_details.text = "CONTAINMENT IN PROGRESS"
			add_line("Containment procedures unavailable at this time.", ContainmentProceduresList)
		LIST_TYPE.CONTAINED:
			var list:Array = scp_data.contained_list.filter(func(i): return i.ref == data.ref)
			if list.size() > 0:
				var item:Dictionary = scp_data.contained_list.filter(func(i): return i.ref == data.ref)[0]
				status_details.use = item.transfer_status.state
				status_details.text = "TRANSFER IN PROGRESS"
				unlocked = item.unlocked
	
	# get refs in unlockables
	var unlocked_refs:Array = unlocked.map(func(i):return i.ref)
	
	# add to containment procedures
	var containment_procedures:Array = data.containment_procedures.call(data)
	for index in containment_procedures.size():
		add_line(containment_procedures[index], ContainmentProceduresList)
	for key in unlocked_refs:
		if "add_to" in data.unlockables[key]:
			var add_to:Dictionary = data.unlockables[key].add_to
			if "containment_procedures" in add_to:
				var add_to_containment_procedures:Array = add_to.containment_procedures.call(data)
				for index in add_to_containment_procedures.size():
					add_line(add_to_containment_procedures[index], ContainmentProceduresList)		
	
	# add to description
	var description:Array = data.description.call(data)
	for index in description.size():
		add_line(description[index], DescriptionList)
	for key in unlocked_refs:
		if "add_to" in data.unlockables[key]:
			var add_to:Dictionary = data.unlockables[key].add_to
			if "description" in add_to:
				var add_to_description:Array = add_to.description.call(data)
				for index in add_to_description.size():
					add_line(add_to_description[index], DescriptionList)

	ArticleContainer.show()
	ArticleContainer.add_theme_constant_override('margin_top', 55 if status_details.use else 20)
	StatusContainer.show() if status_details.use else StatusContainer.hide()
	StatusLabel.text = status_details.text
# ----------------------------------------

# ----------------------------------------
func add_line(text:String, node:VBoxContainer) -> void:
	var new_label:Label = Label.new()
	new_label.text = text
	new_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	new_label.custom_minimum_size = Vector2(1, 1)
	new_label.label_settings = description_label_setting
	node.add_child(new_label)
# ----------------------------------------
	
