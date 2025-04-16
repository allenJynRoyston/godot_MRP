extends PanelContainer

@onready var BtnControls:Control = $BtnControl
@onready var BackBtn:BtnBase = $HBoxContainer/ScrollContainer2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/BackBtn
@onready var CategoryLabel:Label = $HBoxContainer/ScrollContainer2/PanelContainer/MarginContainer/VBoxContainer/CategoryLabel
@onready var NextBtn:BtnBase = $HBoxContainer/ScrollContainer2/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextBtn
@onready var List:VBoxContainer = $HBoxContainer/ScrollContainer2/PanelContainer/MarginContainer/VBoxContainer/List

@onready var EmailContentContainer:PanelContainer = $HBoxContainer/ScrollContainer/EmailContentContainer
@onready var SubjectLabel:Label = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/HBoxContainer/SubjectLabel
@onready var FromLabel:Label = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/HBoxContainer2/FromLabel
@onready var DateLabel:Label = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/HBoxContainer3/DateLabel
@onready var EmailContentRichText:RichTextLabel = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/EmailContentRichText
@onready var AttachmentContainer:PanelContainer = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/AttachmentContainer

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var email_data:Array[Dictionary] = [] : 
	set(val):
		email_data = val
		on_email_data_update()

var previous_index:int
var read_emails:Array = [] : 
	set(val):
		read_emails = val
		on_read_emails_update()
		
var email_list:Array = []
var sidebar_list:Array = []

var onQuit:Callable = func():pass
var markAsRead:Callable = func(_index:int):pass

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)	

func _ready() -> void:
	hide()
	on_email_data_update()
	
	BtnControls.directional_pref = "UD"
	BtnControls.onBack = func() -> void:
		await BtnControls.reveal(false)
		await U.set_timeout(0.3)
		onQuit.call()


func start() -> void:
	BtnControls.reveal(true)
	show()
	
func unpause() -> void:
	BtnControls.on_item_index_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_read_emails_update() -> void:
	await U.tick()
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
		new_btn.title = item.title
		new_btn.icon = SVGS.TYPE.EMPTY_CHECKBOX	
		new_btn.active_color = Color(1, 1, 1, 1)
		new_btn.inactive_color = Color(1, 1, 1, 0.5)
		new_btn.custom_minimum_size = Vector2(1, 30)
		new_btn.panel_color = Color(1, 1, 1, 0)
		
		new_btn.onClick = func() -> void:
			parse_email(item, index)

		email_list.push_back(new_btn)
		List.add_child(new_btn)
		
	BtnControls.itemlist = email_list
	if email_data.size() == 0:
		EmailContentContainer.hide()
	else:
		parse_email(email_data[0], 0)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func parse_email(data:Dictionary, index:int) -> void:
	EmailContentContainer.show()	

	SubjectLabel.text = data.title
	FromLabel.text = data.from	
	DateLabel.text = data.date
	EmailContentRichText.text = data.content
	
	if "attachment" in data:
		AttachmentContainer.show()
		AttachmentContainer.data = data.attachment
		AttachmentContainer.onClick = func() -> void:
			data.attachment.onClick.call(data.attachment)
			
		sidebar_list = [AttachmentContainer]
	else:
		AttachmentContainer.hide()
		sidebar_list = []
		
	if index not in read_emails:
		markAsRead.call(index)
		
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func set_control_pos_visibility(state:bool) -> void:
	BtnControls.show() if state else BtnControls.hide()
	
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or sidebar_list.is_empty(): 
		return

	match input_data.key:
		"A":
			BtnControls.itemlist = email_list
			await U.tick()
			BtnControls.item_index = previous_index
		"D":
			previous_index = BtnControls.item_index
			BtnControls.itemlist = sidebar_list
# ------------------------------------------------------------------------------
