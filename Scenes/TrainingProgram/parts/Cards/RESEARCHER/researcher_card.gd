@tool
extends MouseInteractions

@onready var CardBody:Control = $CardBody
@onready var CardTextureRect:TextureRect = $CardBody/TextureRect
@onready var InnerCardBody:Control = $CardBody/SubViewport/Control/CardBody

# status panel
@onready var StatusPanel:MarginContainer = $CardBody/SubViewport/Control/CardBody/StatusPanel
@onready var StatusIcon:BtnBase = $CardBody/SubViewport/Control/CardBody/StatusPanel/PanelContainer/VBoxContainer/StatusIcon
@onready var StatusLabel:Label = $CardBody/SubViewport/Control/CardBody/StatusPanel/PanelContainer/VBoxContainer/HBoxContainer/StatusLabel

# FRONT
@onready var FrontImage:PanelContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/FrontImage
@onready var FrontName:PanelContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/FrontName
@onready var FrontLevel:PanelContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/FrontLevel
@onready var AssignedTo:PanelContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/AssignedTo
@onready var Spec:PanelContainer = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/Spec

# BACK
@onready var BackName:PanelContainer = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/BackName
@onready var Health:PanelContainer = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/HBoxContainer/Health
@onready var Sanity:PanelContainer = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/HBoxContainer/Sanity
@onready var BackImage:PanelContainer = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/BackImage
@onready var BackTrait:PanelContainer = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/HBoxContainer2/BackTrait
@onready var BackMood:PanelContainer = $CardBody/SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer/HBoxContainer2/BackMood

@export var card_border_color:Color = Color(0.0, 0.638, 0.337) : 
	set(val): 
		card_border_color = val 
		on_is_selected_update()

const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")
#const CardShader:ShaderMaterial = preload("res://CanvasShader/CardShader/CardShader.tres")

@export var uid:String = "": 
	set(val):
		uid = val
		on_uid_update()

@export var flip:bool = false : 
	set(val):
		flip = val
		on_flip_update()
		
@export var reveal:bool = false : 
	set(val):
		reveal = val
		on_reveal_update()		

@export var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()
		
@export var show_checkbox:bool = false : 
	set(val):
		show_checkbox = val
		on_show_checkbox_update()
		
@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
		
@export var is_deselected:bool = false : 
	set(val):
		is_deselected = val
		on_is_deselected_update()
		
@export var promotion_preview:bool = false : 
	set(val):
		promotion_preview = val
		on_promotion_preview_update()
		
@export var show_assigned:bool = false : 
	set(val):
		show_assigned = val
		on_show_assigned_update()
		
var researcher_details:Dictionary = {} : 
	set(val):
		researcher_details = val
		on_researcher_details_update()
		
const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var index:int = -1
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_hired_lead_researchers_arr(self)
	super._init()

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_hired_lead_researchers_arr(self)
	super._exit_tree()	
	
func _ready() -> void:
	super._ready()
	
	StatusPanel.hide()

	on_uid_update()
	on_reveal_update()
	on_is_active_update()
	on_is_selected_update()
	on_is_deselected_update()
	on_show_assigned_update()
	on_researcher_details_update()
	
	await U.tick()
	CardTextureRect.pivot_offset = self.size/2
	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func shake(shake_intensity:int = 5) -> void:
	var steps := 5
	for i in range(steps):
		var decay := 1.0 - (i / steps)  # decreases from 1.0 to 0.0
		var offset := shake_intensity * decay
		var duration := 0.05 + (0.05 * (1.0 - decay))  # can tweak to feel right

		await U.tween_node_property(CardBody, "position:x", offset, duration)
		await U.tween_node_property(CardBody, "position:x", -offset, duration)

func disappear() -> void:
	U.tween_node_property(CardBody, "position:y", 200, 0.3)
	await U.tween_node_property(self, 'modulate:a', 0)

func on_flip_update() -> void:
	if !is_node_ready():return
	CardBody.flip = flip

func on_is_active_update() -> void:
	if !is_node_ready():return

func on_show_checkbox_update() -> void:
	if !is_node_ready():return

func on_is_selected_update() -> void:
	if !is_node_ready():return
	CardBody.border_color = card_border_color if is_selected else card_border_color.darkened(0.1)
	
func on_is_deselected_update() -> void:
	if !is_node_ready():return
	CardTextureRect.material = BlackAndWhiteShader if is_deselected else null

func on_reveal_update() -> void:
	if !is_node_ready():return
	CardBody.reveal = reveal

func on_show_assigned_update() -> void:
	if !is_node_ready():return
	#CardDrawerAssigned.show() if show_assigned else CardDrawerAssigned.hide()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_hired_lead_researchers_arr_update(new_val:Array) -> void:
	var filtered:Array = new_val.filter(func(x): return x[0]== uid)
	# updates when there are changes
	if !filtered.is_empty():
		update_nodes( RESEARCHER_UTIL.return_data_with_uid(filtered[0][0]) ) 
	
func on_researcher_details_update() -> void:
	if !is_node_ready() or researcher_details.is_empty():return
	update_nodes(researcher_details)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_uid_update() -> void:
	if !is_node_ready():return		
	
	var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(uid)		
	
	if uid == "-1" or researcher_details.is_empty():
		FrontImage.use_static = true
		for node in [FrontName, BackName, FrontLevel, BackTrait, BackMood]:
			node.content = "-"
		return
	
	
	update_nodes(researcher_details)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_nodes(researcher_details:Dictionary) -> void:
	FrontImage.use_static = false
	
	for node in [FrontImage, BackImage]:
		node.img_src = researcher_details.img_src
		node.use_static = false
		node.title = researcher_details.name
		
	FrontName.content = researcher_details.name
	FrontLevel.content = str(researcher_details.level)
	BackMood.content = researcher_details.mood.details.name
	BackTrait.content = researcher_details.trait.details.name
	Spec.content = researcher_details.specialization.details.name
		
	Health.content = str(researcher_details.health.current)
	Sanity.content = str(researcher_details.sanity.current)
	
	match researcher_details.status:
		RESEARCHER.STATUS.INSANE:
			StatusLabel.text = "INSANE"
			StatusPanel.show()
		RESEARCHER.STATUS.KIA:
			StatusLabel.text = "KILLED IN ACTION"
			StatusPanel.show()
		RESEARCHER.STATUS.WOUNDED:
			StatusLabel.text = "REQUIRES MEDICAL ATTENTION"
			StatusPanel.show()
		_:
			StatusPanel.hide()
	
	if !researcher_details.props.assigned_to_room.is_empty():
		var extract_data:Dictionary = GAME_UTIL.extract_room_details(researcher_details.props.assigned_to_room)
		if extract_data.is_empty():return
		AssignedTo.content = extract_data.room.details.name
	else:
		AssignedTo.content = "None"
# ------------------------------------------------------------------------------
	
# ------------------------------------------------------------------------------
func on_promotion_preview_update() -> void:
	if !is_node_ready():return
	on_uid_update()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:	
	if !is_node_ready():return	
	is_focused = state
	onFocus.call(self) if state else onBlur.call(self)	
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)


func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT:		
		onClick.call()
# ------------------------------------------------------------------------------
