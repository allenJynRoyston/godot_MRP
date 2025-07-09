@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var RootMargin:MarginContainer = $MarginContainer

@onready var Btn:TextureRect = $MarginContainer/Btn

@export var icon:SVGS.TYPE = SVGS.TYPE.DOT : 
	set(val):
		icon = val
		on_icon_update()

@export var icon_color:Color = COLORS.primary_black : 
	set(val): 
		icon_color = val
		update_color(icon_color)

@export var icon_size:Vector2 = Vector2(20, 20) : 
	set(val):
		icon_size = val
		on_icon_size_update()

@export var flip_h:bool = false : 
	set(val):
		flip_h = val
		on_flip_h_update()
		
@export var flip_v:bool = false : 
	set(val):
		flip_v = val
		on_flip_v_update()

# ------------------------------------------------------------------------------
func _ready() -> void:
	on_flip_h_update()
	on_flip_v_update()
	on_icon_update()
	on_icon_size_update()
	update_color()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_color(new_color:Color = icon_color) -> void:
	if !is_node_ready():return
	var shader_material:ShaderMaterial = Btn.material.duplicate()	
	shader_material.set_shader_parameter("tint_color", new_color )
	Btn.material = shader_material		
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_flip_h_update() -> void:
	if !is_node_ready():return
	Btn.flip_h = flip_h
	
func on_flip_v_update() -> void:
	if !is_node_ready():return
	Btn.flip_v = flip_v
	
func on_icon_size_update() -> void:
	if !is_node_ready():return
	RootPanel.custom_minimum_size = icon_size
	RootPanel.size = icon_size
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func on_icon_update() -> void:
	if !is_node_ready(): return
	if icon == SVGS.TYPE.NONE:
		update_color(Color(1, 1, 1, 0))
		return
	
	var texture:CompressedTexture2D = CACHE.fetch_svg(icon) 
	if texture != null:
		Btn.texture = texture
		update_color()
# ------------------------------------------------------------------------------
