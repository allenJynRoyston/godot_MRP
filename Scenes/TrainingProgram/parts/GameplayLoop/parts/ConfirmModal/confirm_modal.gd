extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls
@onready var TextureRectUI:TextureRect = $TextureRect

@onready var ContentPanel:PanelContainer = $ModalControl/PanelContainer
@onready var ContentMargin:MarginContainer = $ModalControl/PanelContainer/MarginContainer2

@onready var ImageTextureRect:TextureRect = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/ImageTextureRect
@onready var TitleLabel:Label = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/TitleLabel
@onready var SubLabel:Label = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/SubLabel

@onready var ResourcePanel:PanelContainer = $ResourceControl/PanelContainer
@onready var ResourceMargin:MarginContainer = $ResourceControl/PanelContainer/MarginContainer

@onready var StaffingList:VBoxContainer = $ResourceControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/List
@onready var BeforeList:HBoxContainer = $ResourceControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BeforeAndAfter/before
@onready var AfterList:HBoxContainer = $ResourceControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BeforeAndAfter/after

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

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
	BtnControls.onDirectional = on_key_press
	
	BtnControls.onAction = func() -> void:
		end(true)

	BtnControls.onBack = func() -> void:
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
	BtnControls.reveal(false)
	
	await U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0))

	await U.tween_range(TextureRectUI.material.get_shader_parameter("blur_radius"), 0.0, 0.3, func(val:float) -> void:
		TextureRectUI.material.set_shader_parameter("blur_radius", val)
	).finished	
	
	U.tween_node_property(ResourcePanel, "position:x", control_pos[ResourcePanel].hide)
	await U.tween_node_property(ContentPanel, "position:x", control_pos[ContentPanel].hide)

	await U.set_timeout(0.3)
			
	user_response.emit(made_changes)
	queue_free()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func activate(auto_start:bool = true) -> void:
	await U.tick()
	
	control_pos[ContentPanel] = {
		"show": 0, 
		"hide": ContentMargin.size.x
	}
	
	control_pos[ResourcePanel] = {
		"show": 0, 
		"hide": -350
	}	
	


	ColorRectBG.modulate = Color(1, 1, 1, 0)
	ResourcePanel.position.x = control_pos[ResourcePanel].hide
	ContentPanel.position.x = control_pos[ContentPanel].hide
	
# --------------------------------------------------------------------------------------------------	


# -------------------------------------------------------------------------------------------------	
func start() -> void:
	if !allow_controls:
		TextureRectUI.show()
		TextureRectUI.texture = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))	
	
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))	
	await U.tween_node_property(ContentPanel, "position:x", control_pos[ContentPanel].show)
	
	BtnControls.reveal(true)
# -------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func check_for_unavailable_rooms() -> void:
	if current_location.is_empty():return
	var designation:String = U.location_to_designation(current_location)	
	BtnControls.disable_active_btn = designation in unavailable_rooms
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
#func on_is_showing_update(skip_animation:bool = false) -> void:
	#super.on_is_showing_update()
	#if !is_node_ready() or control_pos.is_empty():return
	#var duration:float = 0 if skip_animation else 0.3
	#
	#if !is_showing:
		#allow_input = false	
		#BtnControls.reveal(false)
	#
	#self.modulate = Color(1, 1, 1, 1)	
	#
	#U.tween_node_property(ColorRectBG, "modulate", Color(1, 1, 1, 0.6 if is_showing else 0), duration)
	#
	#
	#if !allow_controls:
		#U.tween_range(0 if is_showing else 4.0, 4 if is_showing else 0, duration, func(val:float) -> void:
			#TextureRectUI.material.set_shader_parameter("blur_radius", val)
		#).finished	
		#
	#U.tween_node_property(ContentPanel, "modulate", Color(1, 1, 1, 1 if is_showing else 0),  duration)
	#U.tween_node_property(ResourcePanel, "position:y", control_pos[ResourcePanel].show if is_showing else control_pos[ResourcePanel].hide, duration)
	#await U.tween_node_property(ContentPanelContainer, "position:y", control_pos[ContentPanelContainer].show if is_showing else control_pos[ContentPanelContainer].hide, duration)
	#
	## reset confirm only state
	#if is_showing:
		#allow_input = true
		#BtnControls.reveal(true)


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
		return
	
	U.tween_node_property(ResourcePanel, "position:x", control_pos[ResourcePanel].show)
	
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
		new_node.title =  "%s %s required.  (You have %s)" % [abs(item.amount), item.resource.name, current_amount]
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
