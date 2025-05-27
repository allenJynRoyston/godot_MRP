extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls
@onready var TextureRectUI:TextureRect = $TextureRect

@onready var ContentPanelContainer:PanelContainer = $ModalControl/PanelContainer
@onready var ImageTextureRect:TextureRect = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/ImageTextureRect
@onready var TitleLabel:Label = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/TitleLabel
@onready var SubLabel:Label = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/SubLabel

@onready var StaffingControl:Control = $StaffingControl
@onready var StaffingControlPanel:PanelContainer = $StaffingControl/PanelContainer
@onready var StaffingControlMargin:MarginContainer = $StaffingControl/PanelContainer/MarginContainer

@onready var StaffingList:VBoxContainer = $StaffingControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/List
@onready var BeforeList:HBoxContainer = $StaffingControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BeforeAndAfter/before
@onready var AfterList:HBoxContainer = $StaffingControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BeforeAndAfter/after

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

var bg_color:Color = Color(0, 0, 0, 0)

var allow_input:bool = false

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
	BtnControls.onDirectional = on_key_press
	
	BtnControls.onAction = func() -> void:
		if is_showing and allow_input:
			end(true)

	BtnControls.onBack = func() -> void:
		if is_showing and allow_input:
			end(false)
			
	BtnControls.reveal(false)
		
	on_title_update()
	on_subtitle_update()
	on_image_update()
	on_activation_requirements_update()
	

func set_props(new_title:String = "", new_subtitle:String = "", new_image:String = "", bg_color:Color = bg_color) -> void:
	title = new_title
	subtitle = new_subtitle
	image = new_image
	ColorRectBG.color = bg_color
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end(made_changes:bool) -> void:
	allow_controls = false
	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0))

	U.tween_range(1.0, 0.0, 0.3, func(val:float) -> void:
		TextureRectUI.material.set_shader_parameter("bend_amount", val)
	).finished	
	
	U.tween_node_property(ContentPanelContainer, "position:y", control_pos[ContentPanelContainer].hide)
	U.tween_node_property(StaffingControlPanel, "position:y", control_pos[StaffingControlPanel].hide)
	
	await BtnControls.reveal(false)

	await U.set_timeout(0.3)
	
	confirm_only = false
	activation_requirements = []
			
	user_response.emit(made_changes)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func activate(auto_start:bool = true) -> void:
	show()
	await U.tick()
	
	control_pos_default[ContentPanelContainer] = ContentPanelContainer.position
	control_pos_default[StaffingControlPanel] = StaffingControlPanel.position
	
	await update_control_pos(auto_start)
# --------------------------------------------------------------------------------------------------	


# -------------------------------------------------------------------------------------------------	
func start() -> void:
	TextureRectUI.show()
	TextureRectUI.texture = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))	
	
	self.modulate = Color(1, 1, 1, 1)
	is_showing = true
# -------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos(true)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func check_for_unavailable_rooms() -> void:
	var designation:String = U.location_to_designation(current_location)	
	BtnControls.disable_active_btn = designation in unavailable_rooms
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos(auto_start:bool) -> void:	
	await U.tick()

	control_pos[ContentPanelContainer] = {
		"show": 0, 
		"hide": control_pos_default[ContentPanelContainer].y - ContentPanelContainer.size.y
	}
	
	control_pos[StaffingControlPanel] = {
		"show": 0, 
		"hide": -StaffingControlMargin.size.y
	}	
	
	if auto_start:
		on_is_showing_update(true)
	else:
		await U.tick()
		ColorRectBG.modulate = Color(1, 1, 1, 0)
		StaffingControlPanel.position.y = control_pos[StaffingControlPanel].hide
		ContentPanelContainer.position.y = control_pos[ContentPanelContainer].hide
		await U.tick()
# --------------------------------------------------------------------------------------------------	
	
# --------------------------------------------------------------------------------------------------	
func on_is_showing_update(skip_animation:bool = false) -> void:
	super.on_is_showing_update()
	if !is_node_ready() or control_pos.is_empty():return
	var duration:float = 0 if skip_animation else 0.3
	
	if !is_showing:
		allow_input = false	
		BtnControls.reveal(false)
	
	self.modulate = Color(1, 1, 1, 1)	
	
	U.tween_range(0.0 if is_showing else 1.0, 1.0 if is_showing else 0.0, 1.0, func(val:float) -> void:
		TextureRectUI.material.set_shader_parameter("bend_amount", val)
	).finished	
		
	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 1 if is_showing else 0), duration)
	U.tween_node_property(ContentPanelContainer, "modulate", Color(1, 1, 1, 1 if is_showing else 0),  duration)
	U.tween_node_property(StaffingControlPanel, "position:y", control_pos[StaffingControlPanel].show if is_showing else control_pos[StaffingControlPanel].hide, duration)
	await U.tween_node_property(ContentPanelContainer, "position:y", control_pos[ContentPanelContainer].show if is_showing else control_pos[ContentPanelContainer].hide, duration)
	
	# reset confirm only state
	if is_showing:
		allow_input = true
		BtnControls.reveal(true)


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
		new_node.title =  "%s Required: %s (currenctly at %s)" % [item.resource.name, abs(item.amount), current_amount]
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
	BtnControls.disable_active_btn = disable_btn
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_cancel_only_update() -> void:
	if !is_node_ready():return
	BtnControls.disable_active_btn = cancel_only
		
func on_confirm_only_update() -> void:
	if !is_node_ready():return
	BtnControls.disable_back_btn = confirm_only
# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------	
func on_key_press(key:String) -> void:
	if !allow_controls:return

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
