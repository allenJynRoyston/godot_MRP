@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."
@onready var ContentLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/ContentLabel
@onready var YouHaveLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/YouHaveLabel
@onready var IconBtn:BtnBase = $MarginContainer/HBoxContainer/IconBtn

var content:String = "Objective"
var you_have:String = ""
var is_completed:bool = false
var is_expired:bool = false
var is_upcoming:bool = false

var use_color:Color = Color(1, 1, 1, 1)

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()

func _exit_tree() -> void:
	super._exit_tree()

func _ready() -> void:
	super._ready()
	
	ContentLabel.text = str("[s]%s[/s]" % content) if is_expired else content
	YouHaveLabel.text = "" if is_expired or is_upcoming else ("(You currently have %s.)" % you_have)
	YouHaveLabel.hide() if you_have == "" else YouHaveLabel.show()
	IconBtn.icon = SVGS.TYPE.CLEAR if is_expired else (SVGS.TYPE.CHECKBOX if is_completed else SVGS.TYPE.EMPTY_CHECKBOX)
	
	use_color = Color.GREEN
	
	if !is_completed:
		use_color = Color.WHITE
	if is_expired:
		use_color = Color(0.337, 0.275, 1.0).lightened(0.5)
		
	hint_title = "HINT"
	hint_description = content
	hint_icon = SVGS.TYPE.INFO
	
	if is_hoverable:
		on_focus(false)	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_color(new_color:Color) -> void:
	if !is_node_ready():return

func on_focus(state:bool = is_focused) -> void:
	if !is_disabled:	
		super.on_focus(state)
		var _color:Color = Color(use_color.r, use_color.g, use_color.b, 0.7 if !state else 1)
		self.modulate = _color
		IconBtn.static_color = _color
	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if !is_node_ready() or !is_visible_in_tree() or !is_hoverable or is_disabled:return
	super.on_mouse_click(node, btn, on_hover)
# ------------------------------------------------------------------------------
