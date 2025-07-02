extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls
@onready var TextureRectUI:TextureRect = $TextureRect

@onready var ContentPanel:PanelContainer = $ModalControl/PanelContainer
@onready var ContentMargin:MarginContainer = $ModalControl/PanelContainer/MarginContainer2

@onready var ImageTextureRect:TextureRect = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/ImageTextureRect
@onready var TitleLabel:Label = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/TitleLabel
@onready var SubLabel:Label = $ModalControl/PanelContainer/MarginContainer2/VBoxContainer/SubLabel
@onready var Splash:Control = $ContainmentBreachSplash

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

var bg_color:Color = Color(0, 0, 0, 0)

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
	
	BtnControls.onAction = func() -> void:
		end(true)

	BtnControls.onBack = func() -> void:
		end(false)
			
	BtnControls.reveal(false)
		
	on_title_update()
	on_subtitle_update()
	on_image_update()

	await Splash.activate()
	Splash.start(true)
	

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

	var duplicate_material:Material = TextureRectUI.material.duplicate(true)
	TextureRectUI.material = duplicate_material

	await U.tween_range(TextureRectUI.material.get_shader_parameter("blur_radius"), 0.0, 0.3, func(val:float) -> void:
		TextureRectUI.material.set_shader_parameter("blur_radius", val)
	).finished	
	
	#U.tween_node_property(ResourcePanel, "position:x", control_pos[ResourcePanel].hide)
	await U.tween_node_property(self, "modulate:a", 0)

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
	
	ColorRectBG.modulate = Color(1, 1, 1, 1)
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
	BtnControls.disable_active_btn = cancel_only
		
func on_confirm_only_update() -> void:
	if !is_node_ready():return
	BtnControls.disable_back_btn = confirm_only
# --------------------------------------------------------------------------------------------------		
