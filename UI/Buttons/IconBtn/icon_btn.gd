@tool
extends BtnBase

@onready var Btn:TextureRect = $Btn

@export var icon:SVGS.TYPE = SVGS.TYPE.DOT : 
	set(val):
		icon = val
		on_icon_update()

@export var static_color:Color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if !Engine.is_editor_hint() else Color.WHITE  : 
	set(val): 
		static_color = val
		update_color(static_color)
		
@export var active_color:Color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) if !Engine.is_editor_hint() else Color.WHITE :
	set(val): 
		active_color = val
		on_focus()
		
@export var inactive_color:Color = COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE) if !Engine.is_editor_hint() else Color.WHITE  :
	set(val): 
		inactive_color = val
		on_focus()

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	if is_hoverable:
		on_focus(false)
	else:
		update_color(static_color)

	on_icon_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_color(new_color:Color) -> void:
	if is_node_ready():
		var shader_material:ShaderMaterial = Btn.material.duplicate()	
		shader_material.set_shader_parameter("tint_color", new_color )
		Btn.material = shader_material		

func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if is_node_ready():
		update_color(active_color if state else inactive_color)


func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_icon_update() -> void:
	if is_node_ready():
		if icon == SVGS.TYPE.NONE:
			Btn.texture = null
			return
		
		var texture:CompressedTexture2D = CACHE.fetch_svg(icon) 
		if texture != null:
			Btn.texture = texture
# ------------------------------------------------------------------------------


func _on_subviewport_child_changed() -> void:
	pass # Replace with function body.
