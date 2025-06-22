extends PanelContainer

@onready var BtnControls:Control = $BtnControl
@onready var CategoryLabel:Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/CategoryLabel
@onready var List:VBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/List
@onready var WaitContainer:Control = $WaitContainer

@onready var EmailContentContainer:PanelContainer = $HBoxContainer/EmailContentContainer
@onready var EmailContent:MarginContainer = $HBoxContainer/EmailContentContainer/EmailContent
@onready var SubjectLabel:Label = $HBoxContainer/EmailContentContainer/EmailContent/VBoxContainer/HBoxContainer/SubjectLabel
@onready var FromLabel:Label = $HBoxContainer/EmailContentContainer/EmailContent/VBoxContainer/HBoxContainer2/FromLabel
@onready var DateLabel:Label = $HBoxContainer/EmailContentContainer/EmailContent/VBoxContainer/HBoxContainer3/DateLabel
@onready var EmailContentRichText:RichTextLabel = $HBoxContainer/EmailContentContainer/EmailContent/VBoxContainer/EmailContentRichText
@onready var AttachmentContainer:PanelContainer = $HBoxContainer/EmailContentContainer/EmailContent/VBoxContainer/AttachmentContainer

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var email_data:Array[Dictionary] = [] : 
	set(val):
		email_data = val
		on_email_data_update()

var read_emails:Array = [] : 
	set(val):
		read_emails = val
		on_read_emails_update()
		
var email_list:Array = []
var sidebar_list:Array = []
var selected_node:Control

var onBackToDesktop:Callable = func():pass
var markAsRead:Callable = func(_index:int):pass

# ------------------------------------------------------------------------------
func _ready() -> void:
	on_email_data_update()
	
	EmailContent.hide()
	
	BtnControls.directional_pref = "UD"
	
	BtnControls.onBack = func() -> void:
		onBackToDesktop.call()
	
	BtnControls.onUpdate = func(node:Control) -> void:
		EmailContent.show()
		WaitContainer.hide()
		for index in List.get_child_count():
			var n:Control = List.get_child(index)
			n.is_selected = node == n
			if node == n:
				selected_node = node
				var item:Dictionary = email_data[index]
				parse_email(item, index)
				
				BtnControls.hide_a_btn = sidebar_list.is_empty()	
	
	BtnControls.onAction = func() -> void:
		if selected_node == null:return
		var index:int = selected_node.index
		var item:Dictionary = email_data[index]
		
		if index not in read_emails:
			markAsRead.call(index)
			item.attachment.onClick.call(item.attachment)
		

func start() -> void:
	BtnControls.reveal(true)

func pause() -> void:
	await BtnControls.reveal(false)
	
func unpause() -> void:
	await BtnControls.reveal(true)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func parse_email(data:Dictionary, index:int) -> void:
	EmailContentContainer.show()	

	SubjectLabel.text = data.title
	FromLabel.text = data.from	
	DateLabel.text = data.date
	EmailContentRichText.text = data.content
	
	if ("attachment" in data) and (index not in read_emails):
		AttachmentContainer.show()
		AttachmentContainer.data = data.attachment
		sidebar_list = [AttachmentContainer]
		return
		
	AttachmentContainer.hide()
	sidebar_list = []
	if index not in read_emails:
		markAsRead.call(index)

func on_read_emails_update() -> void:
	for index in read_emails:
		var node:Control = List.get_child(index)
		node.icon = SVGS.TYPE.CHECKBOX
	
func on_email_data_update() -> void:
	if !is_node_ready():return
	for node in List.get_children():
		node.queue_free()
	
	email_list = []
	for index in email_data.size():
		var item:Dictionary = email_data[index]
		var new_btn:Control = TextBtnPreload.instantiate()
		
		new_btn.index = index
		new_btn.title = item.title
		new_btn.icon = SVGS.TYPE.CHECKBOX if index in read_emails else SVGS.TYPE.EMPTY_CHECKBOX
		new_btn.is_hoverable = false
		new_btn.panel_color = Color(1, 1, 1, 0)
		
		email_list.push_back(new_btn)
		List.add_child(new_btn)
		
	BtnControls.itemlist = email_list
	BtnControls.item_index = 0
# ------------------------------------------------------------------------------
