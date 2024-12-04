extends PanelContainer

@onready var VList:PanelContainer = $HBoxContainer/ScrollContainer2/PanelContainer/MarginContainer/VList
@onready var EmailContentContainer:PanelContainer = $HBoxContainer/ScrollContainer/EmailContentContainer

@onready var SubjectLabel:Label = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/HBoxContainer/SubjectLabel
@onready var FromLabel:Label = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/HBoxContainer2/FromLabel
@onready var DateLabel:Label = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/HBoxContainer3/DateLabel
@onready var EmailContentRichText:RichTextLabel = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/EmailContentRichText
@onready var AttachmentContainer:PanelContainer = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/AttachmentContainer

var has_read:Array = [] : 
	set(val):
		has_read = val
		on_has_read_update()

var email_data:Array[Dictionary] = [] : 
	set(val):
		var new_email_data = val.map(func(data):
			for item in data.items:
				item.is_new = check_if_new
				item.onClick = mark_as_read_and_open
			return data
		)
		email_data = val 
		on_email_data_update()

var onHasReadUpdate:Callable = func(arr:Array):pass
	
# ------------------------------------------------------------------------------
func _ready() -> void:
	on_email_data_update()
	
	EmailContentContainer.hide()
	AttachmentContainer.hide()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_email_data_update() -> void:
	if is_node_ready():
		VList.data = email_data
		
func on_has_read_update() -> void:
	onHasReadUpdate.call(has_read)
	
func check_if_new(data:Dictionary) -> bool:
	var id_str:String = str(data.parent_index, data.index)
	return id_str not in has_read

func mark_as_read_and_open(data:Dictionary) -> void:
	var id_str:String = str(data.parent_index, data.index)
	if id_str not in has_read:
		has_read.push_back(id_str)
		has_read = has_read
		VList.data = email_data
	
	EmailContentContainer.show()	
	var details:Dictionary = data.details
	SubjectLabel.text = details.title
	FromLabel.text = details.from	
	DateLabel.text = details.date
	EmailContentRichText.text = details.content
	
	if "get_attachment_details" in details:
		AttachmentContainer.show()
		AttachmentContainer.data = details.get_attachment_details.call()
	else:
		AttachmentContainer.hide()
# ------------------------------------------------------------------------------
