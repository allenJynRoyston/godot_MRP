extends PanelContainer

@onready var BtnControls:Control = $BtnControl
@onready var CategoryLabel:Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/CategoryLabel
@onready var List:VBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/List
@onready var WaitContainer:Control = $WaitContainer

@onready var EmailContentContainer:PanelContainer = $HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/EmailContentContainer
@onready var EmailContent:MarginContainer = $HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/EmailContentContainer/EmailContent
@onready var SubjectLabel:Label = $HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/EmailContentContainer/EmailContent/VBoxContainer/HBoxContainer/SubjectLabel
@onready var FromLabel:Label = $HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/EmailContentContainer/EmailContent/VBoxContainer/HBoxContainer2/FromLabel
@onready var DateLabel:Label = $HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/EmailContentContainer/EmailContent/VBoxContainer/HBoxContainer3/DateLabel
@onready var EmailContentRichText:RichTextLabel = $HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/EmailContentContainer/EmailContent/VBoxContainer/EmailContentRichText
@onready var AttachmentContainer:PanelContainer = $HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/EmailContentContainer/EmailContent/VBoxContainer/AttachmentContainer

const SummaryBtnPreload:PackedScene = preload("res://UI/Buttons/SummaryBtn/SummaryBtn.tscn")

var email_data:Array[Dictionary] = OS_EMAIL.email_data
var tab_index:int = 0

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
				var item:Dictionary = email_data[tab_index].list[index]
				parse_email(item, index)
				
				BtnControls.hide_a_btn = sidebar_list.is_empty()	
	
	BtnControls.onAction = func() -> void:
		if selected_node == null:return
		var index:int = selected_node.index
		var item:Dictionary = email_data[tab_index].list[index]
		
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

func on_email_data_update() -> void:
	if !is_node_ready():return
	for node in List.get_children():
		node.queue_free()
	
	email_list = []
	for index in email_data[tab_index].list.size():
		var item:Dictionary = email_data[tab_index].list[index]
		var new_btn:Control = SummaryBtnPreload.instantiate()
		new_btn.index = index
		new_btn.title = item.title

		new_btn.show_checked_panel = true		
		new_btn.hide_icon = true
		new_btn.fill = true			
		new_btn.use_alt = index not in read_emails
		
		email_list.push_back(new_btn)
		List.add_child(new_btn)
		
	BtnControls.itemlist = email_list
	BtnControls.item_index = 0
# ------------------------------------------------------------------------------

func on_read_emails_update() -> void:
	for index in read_emails:
		var node:Control = List.get_child(index)
		node.use_alt = false
		node.is_checked = true
