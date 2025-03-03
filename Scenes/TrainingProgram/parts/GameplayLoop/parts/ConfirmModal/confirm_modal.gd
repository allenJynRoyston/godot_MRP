extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var ContentPanelContainer:PanelContainer = $ModalControl/PanelContainer
@onready var ImageTextureRect:TextureRect = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/ImageTextureRect
@onready var TitleLabel:Label = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/TitleLabel
@onready var SubLabel:Label = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/SubLabel

@onready var StaffingControl:Control = $StaffingControl
@onready var StaffingControlPanel:PanelContainer = $StaffingControl/StaffingControlPanel
@onready var StaffingList:VBoxContainer = $StaffingControl/StaffingControlPanel/MarginContainer/VBoxContainer/List

@onready var BtnMarginContainer:MarginContainer = $BtnControl/MarginContainer
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var AcceptBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/AcceptBtn
@onready var BackBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn

const CheckboxBtnPreload:PackedScene = preload("res://UI/Buttons/Checkbox/Checkbox.tscn")

var title:String = "" : 
	set(val):
		title = val
		on_title_update()
		
var subtitle:String = "" : 
	set(val):
		subtitle = val
		on_subtitle_update()
		
var confirm_only:bool = false : 
	set(val):
		confirm_only = val
		on_confirm_only_update()
		
var image:String = "" : 
	set(val):
		image = val
		on_image_update()
		
var cancel_only:bool = false : 
	set(val):
		cancel_only = val
		on_cancel_only_update()

var activation_requirements:Array = [] : 
	set(val): 
		activation_requirements = val
		on_activation_requirements_update()


var control_pos:Dictionary

var is_setup:bool = false

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	AcceptBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.NEXT})
	BackBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.BACK})
		
	on_title_update()
	on_subtitle_update()
	on_image_update()
	
	await U.set_timeout(1.0)	
	control_pos[ContentPanelContainer] = {"show": ContentPanelContainer.position.x, "hide": ContentPanelContainer.position.x + ContentPanelContainer.size.x}
	control_pos[BtnMarginContainer] = {"show": BtnMarginContainer.position.y, "hide": BtnMarginContainer.position.y + BtnMarginContainer.size.y}
	control_pos[StaffingControlPanel] = {"show": StaffingControlPanel.position.y, "hide": StaffingControlPanel.position.x + StaffingControlPanel.size.y}
	
	is_setup = true
	on_is_showing_update()

func set_props(new_title:String = "", new_subtitle:String = "", new_image:String = "") -> void:
	title = new_title
	subtitle = new_subtitle
	image = new_image
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------	
func on_is_showing_update() -> void:
	super.on_is_showing_update()
	if !is_setup:return

	for btn in RightSideBtnList.get_children():
		btn.is_disabled = !is_showing

	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1 if is_showing else 0))
	U.tween_node_property(ContentPanelContainer, "modulate", Color(1, 1, 1, 1 if is_showing else 0), 0.3)
	
	U.tween_node_property(StaffingControlPanel, "position:y", control_pos[StaffingControlPanel].show if is_showing else control_pos[StaffingControlPanel].hide)
	U.tween_node_property(ContentPanelContainer, "position:x", control_pos[ContentPanelContainer].show if is_showing else control_pos[ContentPanelContainer].hide)
	await U.tween_node_property(BtnMarginContainer, "position:y", control_pos[BtnMarginContainer].show if is_showing else control_pos[BtnMarginContainer].hide)
	
	# reset confirm only state
	if !is_showing:
		confirm_only = false
		activation_requirements = []
		U.tween_node_property(StaffingControlPanel, "position:y", control_pos[StaffingControlPanel].hide)

	

func on_image_update() -> void:
	if !is_node_ready():return	
	ImageTextureRect.texture = CACHE.fetch_image("res://Media/rooms/redacted.jpg" if image.is_empty() else image)
	
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title
		
func on_subtitle_update() -> void:
	if !is_node_ready():return
	SubLabel.text = subtitle	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_activation_requirements_update() -> void:
	if !is_node_ready():return

	for child in StaffingList.get_children():
		child.free()
		
	if activation_requirements.is_empty():
		StaffingControl.hide()
		return
		
	StaffingControl.show()
	U.tween_node_property(StaffingControlPanel, "position:y", control_pos[StaffingControlPanel].show)

		
	for item in activation_requirements:
		var current_amount:int = resources_data[item.resource.ref].amount
		var has_enough:bool = current_amount + item.amount < 0
		var new_node:Control = CheckboxBtnPreload.instantiate()
		new_node.is_hoverable = false
		new_node.no_bg = true
		new_node.is_checked = !has_enough
		new_node.modulate = Color(1, 0, 0, 1) if has_enough else Color(1, 1, 1, 1)
		new_node.title =  "%s REQUIRED: %s (YOU HAVE %s)" % [item.resource.name, abs(item.amount), current_amount]
		StaffingList.add_child(new_node)		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_cancel_only_update() -> void:
	if !is_node_ready():return
	if cancel_only:
		AcceptBtn.hide()
	else:
		AcceptBtn.show()
		
func on_confirm_only_update() -> void:
	if !is_node_ready():return
	if confirm_only:
		BackBtn.hide()
	else:
		BackBtn.show()
# --------------------------------------------------------------------------------------------------		
