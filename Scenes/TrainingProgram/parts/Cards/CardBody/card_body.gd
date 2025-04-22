@tool
extends PanelContainer

@onready var CardBody:PanelContainer = $SubViewport/Control/CardBody
@onready var CardTextureRect:TextureRect = $TextureRect
@onready var Subviewport:SubViewport = $SubViewport

@onready var Front:Control = $SubViewport/Control/CardBody/Front
@onready var Back:Control = $SubViewport/Control/CardBody/Back

@onready var FrontPanel:PanelContainer = $SubViewport/Control/CardBody/Front/PanelContainer
@onready var BackPanel:PanelContainer = $SubViewport/Control/CardBody/Back/PanelContainer

@onready var FrontDrawerContainer:Control = $SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer
@onready var BackDrawerContainer:Control = $SubViewport/Control/CardBody/Back/PanelContainer/MarginContainer/BackDrawerContainer

@export var reveal:bool = true : 
	set(val):
		reveal = val
		on_reveal_update()

@export var flip:bool = false : 
	set(val):
		flip = val
		on_flip_update()

@export var fold:bool = false : 
	set(val):
		fold = val
		on_fold_update()

@export var border_color:Color = Color(1.0, 0.108, 0.485) : 
	set(val):
		border_color = val
		on_border_color_update()

var showing_front:bool 

# ------------------------------------------------
func _ready() -> void:
	await U.tick()
	CardTextureRect.pivot_offset = self.size/2
	
	on_reveal_update(true)
	update_drawer_items(true)
	on_border_color_update()
	CardTextureRect.texture = Subviewport.get_texture()
# ------------------------------------------------

# ------------------------------------------------	
func on_reveal_update(skip_animation:bool = false) -> void:
	if !is_node_ready():return
	var duration:float = 0 if skip_animation else 0.3
	U.tween_node_property(CardTextureRect, "scale:x", 1 if reveal else 0, duration)
# ------------------------------------------------	


# ------------------------------------------------	
func on_fold_update() -> void:
	if !is_node_ready() or !reveal:return
	await U.tween_node_property(CardTextureRect, "scale:y", 0, 0.1)
	await U.set_timeout(0.2)
	Front.hide() if fold else Front.show()
	Back.show() if fold else Back.hide()
	U.tween_node_property(CardTextureRect, "scale:y", 1, 0.1)
	update_drawer_items(!fold)
# ------------------------------------------------

# ------------------------------------------------
func on_flip_update() -> void:
	if !is_node_ready() or !reveal:return
	await U.tween_node_property(CardTextureRect, "scale:x", 0, 0.3)
	await U.set_timeout(0.2)
	Front.hide() if flip else Front.show()
	Back.show() if flip else Back.hide()
	U.tween_node_property(CardTextureRect, "scale:x", 1, 0.3)
	update_drawer_items(!flip)	
# ------------------------------------------------

# ------------------------------------------------
func on_border_color_update() -> void:
	if !is_node_ready():return
	for panel in [FrontPanel, BackPanel]:
		var panel_stylebox:StyleBoxFlat = panel.get('theme_override_styles/panel').duplicate()
		panel_stylebox.border_color = border_color
		panel.set('theme_override_styles/panel', panel_stylebox)
	update_drawer_items()
# ------------------------------------------------

func drawer_child(child:Control, is_left_side:bool) -> void:
	if "is_left_side" in child:
		child.is_left_side = is_left_side
	if "border_color" in child:
		child.border_color = border_color	

# ------------------------------------------------
func update_drawer_items(_showing_front:bool = showing_front) -> void:
	showing_front = _showing_front
	if showing_front:
		for child in FrontDrawerContainer.get_children():
			if child is HBoxContainer:
				for _child in child.get_children():
					drawer_child(_child, showing_front)
			drawer_child(child, showing_front)

	else:
		for child in BackDrawerContainer.get_children():
			if child is HBoxContainer:
				for _child in child.get_children():
					drawer_child(_child, showing_front)
			drawer_child(child, showing_front)
# ------------------------------------------------
