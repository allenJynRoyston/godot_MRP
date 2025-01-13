extends PanelContainer

@onready var StatusContainer:Control = $StatusContainer
@onready var ArticleContainer:Control = $ArticleContainer

@onready var ItemLabel:Label = $ArticleContainer/VBoxContainer/DetailsContainer/HBoxContainer/VBoxContainer/Item/ItemLabel
@onready var ObjectLabel:Label = $ArticleContainer/VBoxContainer/DetailsContainer/HBoxContainer/VBoxContainer/HBoxContainer/ObjectLabel

@onready var DetailsContainer:VBoxContainer = $ArticleContainer/VBoxContainer/DetailsContainer
@onready var ContainmentContainer:VBoxContainer = $ArticleContainer/VBoxContainer/ContainmentContainer
@onready var DescriptionContainer:HBoxContainer = $ArticleContainer/VBoxContainer/DescriptionContainer

@onready var ContainmentLabel:Label = $ArticleContainer/VBoxContainer/ContainmentContainer/ContainmentLabel
@onready var DescriptionLabel:Label = $ArticleContainer/VBoxContainer/DescriptionContainer/DescriptionContainer/DescriptionLabel

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
	ContainmentLabel.text = ""
	DescriptionLabel.text = "" 
	
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

	ItemLabel.text = "SCP-%s" % [data.item_id]
	ObjectLabel.text = "KETER"
	var status_details:Dictionary = {
		"use": false,
		"title": ""
	}
	
	match list_type:
		LIST_TYPE.AVAILABLE:
			var list:Array = scp_data.available_list.filter(func(i): return i.ref == data.ref)
			if list.size() > 0:
				var item:Dictionary = list[0]
				status_details.use = item.transfer_status.state
				status_details.title = "CONTAINMENT IN PROGRESS"
		LIST_TYPE.CONTAINED:
			var list:Array = scp_data.contained_list.filter(func(i): return i.ref == data.ref)
			if list.size() > 0:
				var item:Dictionary = scp_data.contained_list.filter(func(i): return i.ref == data.ref)[0]
				# TODO check for any active statuses
	
	var description:String = ""
	for item in data.description:
		for key in item:
			description += item[key]
	DescriptionLabel.text = description
	
	# add containment procedures that you've chosen so far
	ContainmentLabel.text = "Containment procedures ongoing."

	ArticleContainer.add_theme_constant_override('margin_top', 55 if status_details.use else 20)
	StatusContainer.show() if status_details.use else StatusContainer.hide()
	ArticleContainer.show()
# ----------------------------------------
