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

var onClick:Callable = func():pass
var onFocus:Callable = func(node:Control) -> void:pass
var onBlur:Callable = func(node:Control) -> void:pass

# ------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	on_focus(false)
	on_icon_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_focus(state:bool) -> void:
	onFocus.call(self) if state else onBlur.call(self)
	var shader_material:ShaderMaterial = Btn.material.duplicate()	
	shader_material.set_shader_parameter("tint_color", Color(0, 0.965, 0.278, 1) if state else Color(0, 0.529, 0.278, 1))
	Btn.material = shader_material	

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT:
		onClick.call()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_icon_update() -> void:
	if is_node_ready():
		var texture:CompressedTexture2D 
		match icon:
			SVG.BIN:
				texture = load("res://SVGs/bin-xmark-fill-svgrepo-com.svg")
			SVG.CLEAR:
				texture = load("res://SVGs/clear-svgrepo-com.svg")
			SVG.DELETE:
				texture = load("res://SVGs/clear-svgrepo-com.svg")
			SVG.DOT:
				texture = load("res://SVGs/dot-filled-svgrepo-com.svg")
			SVG.DOWNLOAD:
				texture = load("res://SVGs/download-window-svgrepo-com.svg")
			SVG.EMAIL:
				texture = load("res://SVGs/email-svgrepo-com.svg")
			SVG.EXE_FILE:
				texture = load("res://SVGs/exe-svgrepo-com.svg")
			SVG.TXT_FILE:
				texture = load("res://SVGs/txt-text-file-svgrepo-com.svg")
			SVG.MEDIA_FORWARD:
				texture = load("res://SVGs/media-forward-svgrepo-com.svg")
			SVG.MEDIA_PAUSE:
				texture = load("res://SVGs/media-pause-svgrepo-com.svg")
			SVG.MEDIA_PLAY:
				texture = load("res://SVGs/media-play-svgrepo-com.svg")
			SVG.MINUS:
				texture = load("res://SVGs/minus-svgrepo-com.svg")
			SVG.MUSIC:
				texture = load("res://SVGs/music-svgrepo-com.svg")
			SVG.NEW:
				texture = load("res://SVGs/new-rectangle-solid-svgrepo-com.svg")
			SVG.PLUS:
				texture = load('res://SVGs/plus-svgrepo-com.svg')
			SVG.SETTINGS:
				texture = load("res://SVGs/settings-svgrepo-com.svg")
			SVG.STOP:
				texture = load("res://SVGs/stop-svgrepo-com.svg")
		
		if texture != null:
			Btn.texture = texture
# ------------------------------------------------------------------------------
