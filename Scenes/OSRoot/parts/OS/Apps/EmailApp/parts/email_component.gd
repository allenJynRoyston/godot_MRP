extends PanelContainer

@onready var VList:PanelContainer = $HBoxContainer/ScrollContainer2/PanelContainer/MarginContainer/VList
@onready var EmailContentContainer:PanelContainer = $HBoxContainer/ScrollContainer/EmailContentContainer
@onready var BtnControls:Control = $BtnControl

@onready var SubjectLabel:Label = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/HBoxContainer/SubjectLabel
@onready var FromLabel:Label = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/HBoxContainer2/FromLabel
@onready var DateLabel:Label = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/HBoxContainer3/DateLabel
@onready var EmailContentRichText:RichTextLabel = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/EmailContentRichText
@onready var AttachmentContainer:PanelContainer = $HBoxContainer/ScrollContainer/EmailContentContainer/MarginContainer/VBoxContainer/AttachmentContainer

var not_new:Array = [] : 
	set(val):
		not_new = val
		on_not_new_update()

var email_data:Array[Dictionary] = [] : 
	set(val):
		var new_email_data = val.map(func(data):
			for item in data.items:
				item.is_new = check_if_new
				item.onClick = func(data:Dictionary) -> void:
					mark_as_old(data)
					on_click.call(data)
			return data
		)
		email_data = val 
		on_email_data_update()

var on_marked:Callable = func(arr:Array):pass

var on_data_changed:Callable = func(new_state:Array):pass
var on_click:Callable = func(data:Dictionary):pass


# ------------------------------------------------------------------------------
func _ready() -> void:
	hide()
	on_email_data_update()
	
	EmailContentContainer.hide()
	AttachmentContainer.hide()
	
	BtnControls.directional_pref = "UD"
	BtnControls.onBack = func() -> void:
		BtnControls.reveal(false)

	VList.on_data_changed = func(new_state) -> void:		
		on_data_changed.call(new_state)
		print(new_state)
		#var itemlist:Array = []
		#for btn in VList.get_btns():
			#itemlist.push_back(btn)
		#BtnControls.itemlist = itemlist
		

func start() -> void:
	BtnControls.reveal(true)
	show()
		
func pause() -> void:
	pass
	#PauseContainer.show()
	#TitleScreen.freeze_inputs = true
	
func unpause() -> void:
	pass
	#PauseContainer.hide()
	#TitleScreen.freeze_inputs = false		
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_email_data_update() -> void:
	if is_node_ready():
		VList.data = email_data
		
func on_not_new_update() -> void:
	on_marked.call(not_new)
	
func check_if_new(data:Dictionary) -> bool:
	var id_str:String = str(data.parent_index, data.index)
	return id_str not in not_new

func mark_as_old(data:Dictionary) -> void:
	var id_str:String = str(data.parent_index, data.index)
	if id_str not in not_new:
		not_new.push_back(id_str)
		not_new = not_new
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
