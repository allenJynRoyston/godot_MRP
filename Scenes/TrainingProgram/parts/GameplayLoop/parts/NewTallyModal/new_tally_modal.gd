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
@onready var ResourceHBox:HBoxContainer = $ResourceControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer

const CheckboxBtnPreload:PackedScene = preload("res://UI/Buttons/Checkbox/Checkbox.tscn")
const ResourceItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ResourceContainer/parts/ResourceItem/ResourceItem.tscn")

@onready var allow_controls:bool = false : 
	set(val):
		allow_controls = val

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

signal tally_complete

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
	
	BtnControls.onAction = func() -> void:
		initiate_tally()	
		await tally_complete
				
		end(true)

	BtnControls.reveal(false)
		
	on_title_update()
	on_subtitle_update()
	on_image_update()
	

func set_props(new_title:String = "", new_subtitle:String = "", new_image:String = "", bg_color:Color = bg_color) -> void:
	title = new_title
	subtitle = new_subtitle
	image = new_image
	ColorRectBG.color = bg_color
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end(made_changes:bool) -> void:
	BtnControls.reveal(false)
	
	var duplicate_material:Material = TextureRectUI.material.duplicate(true)
	TextureRectUI.material = duplicate_material

	await U.tween_range(TextureRectUI.material.get_shader_parameter("blur_radius"), 0.0, 0.3, func(val:float) -> void:
		TextureRectUI.material.set_shader_parameter("blur_radius", val)
	).finished	
	
	U.tween_node_property(ContentPanel, "position:y", control_pos[ContentPanel].hide)
	await U.tween_node_property(ResourcePanel, "position:y", control_pos[ResourcePanel].hide)	
	
	await U.tween_node_property(self, "modulate:a", 0)

	await U.set_timeout(0.3)
	
	# update amount
	GAME_UTIL.update_daily_resources()
	
			
	user_response.emit(made_changes)

	queue_free()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func activate(auto_start:bool = true) -> void:
	await U.tick()
	
	control_pos[ContentPanel] = {
		"show": 0, 
		"hide": -ContentMargin.size.y
	}
	
	control_pos[ResourcePanel] = {
		"show": 0, 
		"hide": ResourceMargin.size.y
	}	
	
	ResourcePanel.position.y = control_pos[ResourcePanel].hide
	ContentPanel.position.y = control_pos[ContentPanel].hide
	
	var index:int = 0
	for ref in resources_data:
		var resource_details:Dictionary = RESOURCE_UTIL.return_currency(ref)
		var ResourceNode:VBoxContainer = ResourceHBox.get_child(index)
		var CostPanel:Control = ResourceNode.get_child(0)
		var DiffLabel:Label = ResourceNode.get_child(1)
		
		CostPanel.amount = resources_data[ref].amount
		CostPanel.icon = resource_details.icon
		DiffLabel.text =  "%s %s" % ["+" if resources_data[ref].diff >= 0 else "-", absi(resources_data[ref].diff)]
		#
		index += 1
			
# --------------------------------------------------------------------------------------------------	

# -------------------------------------------------------------------------------------------------	
func start() -> void:
	if !allow_controls:
		TextureRectUI.show()
		TextureRectUI.texture = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))	
	
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))	
	U.tween_node_property(ContentPanel, "position:y", control_pos[ContentPanel].show)
	await U.tween_node_property(ResourcePanel, "position:y", control_pos[ResourcePanel].show)
	
	BtnControls.reveal(true)
# -------------------------------------------------------------------------------------------------	

# -------------------------------------------------------------------------------------------------
func initiate_tally() -> void:
	var index:int = 0
	for ref in resources_data:
		var resource_details:Dictionary = RESOURCE_UTIL.return_currency(ref)
		var ResourceNode:VBoxContainer = ResourceHBox.get_child(index)
		var CostPanel:Control = ResourceNode.get_child(0)
		var DiffLabel:Label = ResourceNode.get_child(1)

		var current_amount:int = resources_data[ref].amount
		var diff:int = resources_data[ref].diff
		var target_amount:int = current_amount + diff

		# Animate increasing the amount incrementally
		animate_amount_increment( absi(diff) , 0, -10, 0.02, func(val):
			DiffLabel.text = "%s %s" % ["+" if val >= 0 else "-", absi(val)]
		)
		
		await animate_amount_increment(current_amount, target_amount, 10 if diff >= 0 else -10, 0.02, func(val): 
			CostPanel.amount = U.min_max(val, 0, resources_data[ref].capacity )
		)

		index += 1
	
	await U.set_timeout(1.0)
	tally_complete.emit()
# -------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------
func animate_amount_increment(start:int, target:int, step:int, delay:float, callback:Callable) -> void:
	var amount = start
	#var step = 10 if target > start else 0
	while amount != target:
		amount += step
		callback.call(amount)
		await get_tree().create_timer(delay).timeout
# -------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------	
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
