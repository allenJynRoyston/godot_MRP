@tool
extends MouseInteractions
class_name IconBtn

@onready var Btn:TextureRect = $Btn

enum SVG {
	BIN, CLEAR, 
	DELETE, DOT, DOWNLOAD, EMAIL, EXE_FILE, TXT_FILE,
	MEDIA_FORWARD, MEDIA_PAUSE, MEDIA_PLAY, MINUS, MUSIC, 
	NEW, PLUS, SETTINGS, STOP
}

@export var icon:SVG = SVG.DOT : 
	set(val):
		icon = val
		on_icon_update()

@export var static_color:Color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) : 
	set(val): 
		static_color = val
		update_color(static_color)
		
@export var active_color:Color = COLOR_REF.get_text_color(COLORS.TEXT.ACTIVE) :
	set(val): 
		active_color = val
		on_focus()
		
@export var inactive_color:Color = COLOR_REF.get_text_color(COLORS.TEXT.INACTIVE) :
	set(val): 
		inactive_color = val
		on_focus()

var onClick:Callable = func():pass
var onFocus:Callable = func(node:Control) -> void:pass
var onBlur:Callable = func(node:Control) -> void:pass

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
	if is_node_ready():
		is_focused = state
		update_color(active_color if state else inactive_color)


func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT:
		onClick.call()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_icon_update() -> void:
	if is_node_ready():
		var texture:CompressedTexture2D 
		match icon:
			SVGS.BIN:
				texture = load("res://SVGs/bin-xmark-fill-svgrepo-com.svg")
			SVGS.CLEAR:
				texture = load("res://SVGs/clear-svgrepo-com.svg")
			SVGS.DELETE:
				texture = load("res://SVGs/clear-svgrepo-com.svg")
			SVGS.DOT:
				texture = load("res://SVGs/dot-filled-svgrepo-com.svg")
			SVGS.DOWNLOAD:
				texture = load("res://SVGs/download-window-svgrepo-com.svg")
			SVGS.EMAIL:
				texture = load("res://SVGs/email-svgrepo-com.svg")
			SVGS.EXE_FILE:
				texture = load("res://SVGs/exe-svgrepo-com.svg")
			SVGS.TXT_FILE:
				texture = load("res://SVGs/txt-text-file-svgrepo-com.svg")
			SVGS.MEDIA_FORWARD:
				texture = load("res://SVGs/media-forward-svgrepo-com.svg")
			SVGS.MEDIA_PAUSE:
				texture = load("res://SVGs/media-pause-svgrepo-com.svg")
			SVGS.MEDIA_PLAY:
				texture = load("res://SVGs/media-play-svgrepo-com.svg")
			SVGS.MINUS:
				texture = load("res://SVGs/minus-svgrepo-com.svg")
			SVGS.MUSIC:
				texture = load("res://SVGs/music-svgrepo-com.svg")
			SVGS.NEW:
				texture = load("res://SVGs/new-rectangle-solid-svgrepo-com.svg")
			SVGS.PLUS:
				texture = load('res://SVGs/plus-svgrepo-com.svg')
			SVGS.SETTINGS:
				texture = load("res://SVGs/settings-svgrepo-com.svg")
			SVGS.STOP:
				texture = load("res://SVGs/stop-svgrepo-com.svg")
		
		if texture != null:
			Btn.texture = texture
# ------------------------------------------------------------------------------
