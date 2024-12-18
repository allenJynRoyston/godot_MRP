@tool
extends BtnBase

@onready var IconTextureRect:TextureRect = $MarginContainer/HBoxContainer/HBoxContainer/TextureRect
@onready var Title:Label = $MarginContainer/HBoxContainer/Title
@onready var Amount:Label = $MarginContainer/HBoxContainer/HBoxContainer/Amount

@export var title:String = "Title" : 
	set(val):
		title = val
		on_title_update()
		
@export var amount:int = 0 : 
	set(val):
		amount = val
		on_amount_update()		

@export var icon:SVGS.TYPE = SVGS.TYPE.DOT : 
	set(val):
		icon = val
		on_icon_update()

@export var static_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE) if !Engine.is_editor_hint() else Color.WHITE  : 
	set(val): 
		static_color = val
		update_color(static_color)
		
@export var active_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE) if !Engine.is_editor_hint() else Color.WHITE :
	set(val): 
		active_color = val
		on_focus()
		
@export var inactive_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.INACTIVE) if !Engine.is_editor_hint() else Color.WHITE  :
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
	on_title_update()
	on_amount_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_color(new_color:Color) -> void:
	if is_node_ready():
		var shader_material:ShaderMaterial = IconTextureRect.material.duplicate()	
		shader_material.set_shader_parameter("tint_color", static_color if !is_hoverable else new_color  )
		IconTextureRect.material = shader_material
		
		for node in [Title, Amount]:
			var label_setting:LabelSettings = node.label_settings.duplicate()
			label_setting.font_color = static_color if !is_hoverable else new_color 
			node.label_settings = label_setting

func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	if is_node_ready():
		update_color(active_color if state else inactive_color)

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_title_update() -> void:
	if !is_node_ready(): return
	Title.text = title

func on_amount_update() -> void:
	if !is_node_ready(): return
	Amount.text = str(amount)
	
func on_icon_update() -> void:
	if !is_node_ready(): return
	if icon == SVGS.TYPE.NONE:
		IconTextureRect.texture = null
		return

	var texture:CompressedTexture2D = CACHE.fetch_svg(icon) 
	if texture != null:
		IconTextureRect.texture = texture
# ------------------------------------------------------------------------------
