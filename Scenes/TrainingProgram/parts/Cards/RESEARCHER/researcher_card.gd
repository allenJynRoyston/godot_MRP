extends MouseInteractions

@onready var RootContainer:PanelContainer = $SubViewport/PanelContainer
@onready var CardTextureRect:TextureRect = $VBoxContainer/TextureRect
@onready var ImageTextureRect:TextureRect = $SubViewport/PanelContainer/Front/Image
@onready var SelectedCheckbox:BtnBase = $SubViewport/PanelContainer/Front/Image/MarginContainer2/SelectedCheckbox
@onready var Front:VBoxContainer = $SubViewport/PanelContainer/Front
@onready var Back:VBoxContainer = $SubViewport/PanelContainer/Back

@onready var LevelLabel:Label = $SubViewport/PanelContainer/Front/Image/PanelContainer/MarginContainer/HBoxContainer/LevelLabel
@onready var ProfileImage:TextureRect = $SubViewport/PanelContainer/Front/Image
@onready var NameLabel:Label = $SubViewport/PanelContainer/Front/MarginContainer/VBoxContainer/Name/NameLabel
@onready var SpecilizationList:VBoxContainer = $SubViewport/PanelContainer/Front/MarginContainer/VBoxContainer/Specilizations/VBoxContainer
@onready var TraitsList:VBoxContainer = $SubViewport/PanelContainer/Front/MarginContainer/VBoxContainer/Traits/VBoxContainer

const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")

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
func _ready() -> void:
	super._ready()
	Front.show()
	Back.hide()

	on_uid_update()
	on_reveal_update()
	on_is_active_update()
	on_is_selected_update()
	on_is_deselected_update()
	on_researcher_details_update()	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_flip_update() -> void:
	if !is_node_ready():return
	CardTextureRect.pivot_offset = self.size/2
	await U.tween_node_property(CardTextureRect, "scale:x", 0, 0.1)
	await U.set_timeout(0.2)
	Front.hide() if flip else Front.show()
	Back.show() if flip else Back.hide()
	U.tween_node_property(CardTextureRect, "scale:x", 1, 0.1)

func on_is_active_update() -> void:
	if !is_node_ready():return
	var dup_stylebox:StyleBoxFlat = RootContainer.get_theme_stylebox('panel').duplicate()
	dup_stylebox.border_color = Color.WHITE if is_active else Color.BLACK
	RootContainer.add_theme_stylebox_override('panel', dup_stylebox)

func on_show_checkbox_update() -> void:
	if !is_node_ready():return
	SelectedCheckbox.show() if show_checkbox else SelectedCheckbox.hide()

func on_is_selected_update() -> void:
	if !is_node_ready():return
	SelectedCheckbox.icon = SVGS.TYPE.CHECKBOX if is_selected else SVGS.TYPE.EMPTY_CHECKBOX
	SelectedCheckbox.static_color = Color.GREEN if is_selected else Color.DIM_GRAY

func on_is_deselected_update() -> void:
	if !is_node_ready():return
	CardTextureRect.material = BlackAndWhiteShader if is_deselected else null

func on_reveal_update() -> void:
	if !is_node_ready():return
	await U.tween_node_property(CardTextureRect, "modulate", Color(1, 1, 1, 1) if reveal else Color(1, 1, 1, 0))
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_uid_update() -> void:
	if !is_node_ready() or uid == "":return		
	researcher_details = RESEARCHER_UTIL.return_data_with_uid(uid)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_promotion_preview_update() -> void:
	if !is_node_ready():return
	on_researcher_details_update()
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_researcher_details_update() -> void:
	if !is_node_ready():return
	
	for node in [SpecilizationList, TraitsList]:
		for child in node.get_children():
			child.queue_free()
			
	if researcher_details.is_empty():return
	NameLabel.text = researcher_details.name
	ProfileImage.texture = CACHE.fetch_image(researcher_details.img_src)
	LevelLabel.text = str(researcher_details.level + 1 if promotion_preview else 0)
	
	for spec_id in researcher_details.specializations:
		var dict:Dictionary = RESEARCHER_UTIL.return_specialization_data(spec_id)
		var new_btn:BtnBase = TextBtnPreload.instantiate()
		new_btn.title = dict.name
		new_btn.icon = dict.icon
		new_btn.is_hoverable = false
		SpecilizationList.add_child(new_btn)
		
	for trait_id in researcher_details.traits:
		var dict:Dictionary = RESEARCHER_UTIL.return_trait_data(trait_id)
		var new_btn:BtnBase = TextBtnPreload.instantiate()
		new_btn.title = dict.name
		new_btn.icon = dict.icon
		new_btn.is_hoverable = false
		TraitsList.add_child(new_btn)
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

# ------------------------------------------------------------------------------
func _process(delta:float) -> void:
	if !is_node_ready() or !is_visible_in_tree():return
	#print(CardTextureRect.material.shader)
	##CardTextureRect.set_instance_shader_parameter("mouse_position", get_global_mouse_position())
	#CardTextureRect.material.set_shader_parameter("mouse_position",get_global_mouse_position())
	#CardTextureRect.material.set_shader_parameter("sprite_position",global_position)
# ------------------------------------------------------------------------------
