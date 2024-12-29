@tool
extends BtnBase

@onready var RootPanel:PanelContainer = $"."
@onready var IconBtn:BtnBase = $MarginContainer/HBoxContainer/IconBtn
@onready var TitleLabel:Label = $MarginContainer/HBoxContainer/Label

@export var no_bg:bool = false : 
	set(val):
		no_bg = val
		bg_color_update()

@export var bg_color:Color = Color(0.055, 0.055, 0.055, 0.796) : 
	set(val):
		bg_color = val
		bg_color_update()

@export var is_checked:bool = false : 
	set(val):
		is_checked = val
		on_is_checked_update()
		
@export var title:String = "" : 
	set(val):
		title = val
		on_title_update()

var onChange = func(is_checked:bool):pass

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()

func _exit_tree() -> void:
	super._exit_tree()

func _ready() -> void:
	super._ready()
	on_is_checked_update()
	on_title_update()
	bg_color_update()	
	onChange.call(is_checked)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
	if on_hover:
		is_checked = !is_checked
		onChange.call(is_checked)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func bg_color_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		var new_stylebox = RootPanel.get_theme_stylebox('panel').duplicate()
		new_stylebox.bg_color = Color.TRANSPARENT if no_bg else bg_color
		if RootPanel != null:
			RootPanel.add_theme_stylebox_override("panel", new_stylebox)
		
func on_is_checked_update() -> void:
	if !is_node_ready():return
	IconBtn.icon = SVGS.TYPE.CHECKBOX if is_checked else SVGS.TYPE.EMPTY_CHECKBOX
	
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.hide() if title.is_empty() else TitleLabel.show()
	TitleLabel.text = title
# ------------------------------------------------------------------------------	
	
