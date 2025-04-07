extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var ContentPanelContainer:PanelContainer = $ModalControl/PanelContainer
@onready var ImageTextureRect:TextureRect = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/ImageTextureRect
@onready var TitleLabel:Label = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/TitleLabel
@onready var SubLabel:Label = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/SubLabel
@onready var BeforeList:HBoxContainer = $StaffingControl/StaffingControlPanel/PanelContainer/MarginContainer/VBoxContainer/BeforeAndAfter/before
@onready var AfterList:HBoxContainer = $StaffingControl/StaffingControlPanel/PanelContainer/MarginContainer/VBoxContainer/BeforeAndAfter/after

@onready var StaffingControl:Control = $StaffingControl
@onready var StaffingControlPanel:MarginContainer = $StaffingControl/StaffingControlPanel
@onready var StaffingList:VBoxContainer = $StaffingControl/StaffingControlPanel/PanelContainer/MarginContainer/VBoxContainer/List

@onready var BtnControlPanel:MarginContainer = $BtnControl/MarginContainer
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var AcceptBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/AcceptBtn
@onready var BackBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn

const CheckboxBtnPreload:PackedScene = preload("res://UI/Buttons/Checkbox/Checkbox.tscn")
const ResourceItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResourceContainer/parts/ResourceItem/ResourceItem.tscn")

@onready var allow_controls:bool = false : 
	set(val):
		allow_controls = val
		check_for_unavailable_rooms()
		#GBL.find_node(REFS.ROOM_NODES).enable_room_focus = val

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


var allow_input:bool = false

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()

	AcceptBtn.onClick = func() -> void:
		if is_showing and allow_input:
			end(true)
	BackBtn.onClick = func() -> void:
		if is_showing and allow_input:
			end(false)
		
	on_title_update()
	on_subtitle_update()
	on_image_update()
	on_activation_requirements_update()
	


func set_props(new_title:String = "", new_subtitle:String = "", new_image:String = "") -> void:
	title = new_title
	subtitle = new_subtitle
	image = new_image
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end(made_changes:bool) -> void:
	allow_controls = false
	
	for btn in RightSideBtnList.get_children():
		btn.is_disabled = true
		#
	U.tween_node_property(ContentPanelContainer, "position:y", control_pos[ContentPanelContainer].hide)
	U.tween_node_property(StaffingControlPanel, "position:y", control_pos[StaffingControlPanel].hide)
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide)
	
	
	confirm_only = false
	activation_requirements = []
			
	user_response.emit(made_changes)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()
	
	control_pos_default[ContentPanelContainer] = ContentPanelContainer.position
	control_pos_default[BtnControlPanel] = BtnControlPanel.position
	control_pos_default[StaffingControlPanel] = StaffingControlPanel.position
	
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func check_for_unavailable_rooms() -> void:
	var designation:String = U.location_to_designation(current_location)	
	AcceptBtn.is_disabled = designation in unavailable_rooms
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos() -> void:	
	await U.tick()
	var h_diff:int = (1080 - 720) # difference between 1080 and 720 resolution - gives you 360
	var y_diff =  (0 if !GBL.is_fullscreen else h_diff) if !initalized_at_fullscreen else (0 if GBL.is_fullscreen else -h_diff)
	
	control_pos[ContentPanelContainer] = {
		"show": control_pos_default[ContentPanelContainer].y, 
		"hide": control_pos_default[ContentPanelContainer].y - ContentPanelContainer.size.y
	}
	
	control_pos[BtnControlPanel] = {
		"show": control_pos_default[BtnControlPanel].y + y_diff, 
		"hide": control_pos_default[BtnControlPanel].y + y_diff + BtnControlPanel.size.y
	}
	
	control_pos[StaffingControlPanel] = {
		"show": control_pos_default[StaffingControlPanel].y , 
		"hide": control_pos_default[StaffingControlPanel].y - StaffingControlPanel.size.y
	}	
	
	on_is_showing_update(true)
# --------------------------------------------------------------------------------------------------	
	
# --------------------------------------------------------------------------------------------------	
func on_is_showing_update(skip_animation:bool = false) -> void:
	super.on_is_showing_update()
	allow_input = false
	if !is_node_ready() or control_pos.is_empty():return
		
	for btn in RightSideBtnList.get_children():
		btn.is_disabled = !is_showing

	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1 if is_showing else 0), 0 if skip_animation else 0.3)
	U.tween_node_property(ContentPanelContainer, "modulate", Color(1, 1, 1, 1 if is_showing else 0),  0 if skip_animation else 0.3)
	
	U.tween_node_property(StaffingControlPanel, "position:y", control_pos[StaffingControlPanel].show if is_showing else control_pos[StaffingControlPanel].hide,  0 if skip_animation else 0.3)
	U.tween_node_property(ContentPanelContainer, "position:y", control_pos[ContentPanelContainer].show if is_showing else control_pos[ContentPanelContainer].hide,  0 if skip_animation else 0.3)
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show if is_showing else control_pos[BtnControlPanel].hide,  0 if skip_animation else 0.3)
	
	# reset confirm only state
	allow_input = true

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
	
	for node in [BeforeList, AfterList, StaffingList]:
		for child in node.get_children():
			child.free()
		
	if activation_requirements.is_empty():
		StaffingControl.hide()
		return
	
	StaffingControl.show()
	U.tween_node_property(StaffingControlPanel, "position:y", control_pos[StaffingControlPanel].show)
	
	var disable_btn:bool = false
		
	for item in activation_requirements:
		var current_amount:int = resources_data[item.resource.ref].amount		
		var has_enough:bool = current_amount - absi(item.amount) >= 0
		var new_node:Control = CheckboxBtnPreload.instantiate()
		var new_resource_node:Control = ResourceItemPreload.instantiate()
		
		if !disable_btn and !has_enough:
			disable_btn = true
		
		new_node.is_hoverable = false
		new_node.no_bg = true
		new_node.is_checked = has_enough
		new_node.modulate = Color(1, 0, 0, 1) if !has_enough else Color(1, 1, 1, 1)
		new_node.title =  "%s REQUIRED: %s (YOU HAVE %s)" % [item.resource.name, abs(item.amount), current_amount]
		StaffingList.add_child(new_node)
		
		new_resource_node.is_hoverable = false
		new_resource_node.no_bg = true
		new_resource_node.display_at_bottom = true
		new_resource_node.icon = item.resource.icon
		new_resource_node.title = str(current_amount)
		BeforeList.add_child(new_resource_node)
		
		var after_node:Control = new_resource_node.duplicate()
		after_node.title = str(current_amount - abs(item.amount))
		after_node.is_negative = disable_btn
		AfterList.add_child(after_node) 

	await U.tick()
	AcceptBtn.is_disabled = disable_btn
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


# --------------------------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	if !allow_controls:return
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		# ----------------------------
		"W":
			U.room_up()
		# ----------------------------
		"S":
			U.room_down()
		# ----------------------------
		"D":
			U.room_right()
		# ----------------------------
		"A":
			U.room_left()
	
	check_for_unavailable_rooms()
# --------------------------------------------------------------------------------------------------	
