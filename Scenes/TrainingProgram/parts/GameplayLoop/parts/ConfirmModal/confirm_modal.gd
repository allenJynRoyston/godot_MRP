extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var ContentPanelContainer:PanelContainer = $ModalControl/PanelContainer
@onready var ImageTextureRect:TextureRect = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/ImageTextureRect
@onready var TitleLabel:Label = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/TitleLabel
@onready var SubLabel:Label = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/SubLabel

@onready var BtnMarginContainer:MarginContainer = $BtnControl/MarginContainer
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var AcceptBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/AcceptBtn
@onready var BackBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn


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

var content_restore_pos:int
var btn_restore_pos:int
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
	content_restore_pos = ContentPanelContainer.position.y			
	btn_restore_pos = BtnMarginContainer.position.y
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

	U.tween_node_property(ContentPanelContainer, "position:y", content_restore_pos if is_showing else content_restore_pos - 5, 0.3)
	await U.tween_node_property(BtnMarginContainer, "position:y", btn_restore_pos if is_showing else BtnMarginContainer.size.y + 20, 0.3)
	
	# reset confirm only state
	if !is_showing:
		confirm_only = false
	

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
