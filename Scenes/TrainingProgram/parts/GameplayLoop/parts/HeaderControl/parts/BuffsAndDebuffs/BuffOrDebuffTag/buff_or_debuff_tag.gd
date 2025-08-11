@tool
extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var TitleLabel:Label = $MarginContainer/HBoxContainer/TitleLabel
@onready var DurationLabel:Label = $MarginContainer/HBoxContainer/DurationLabel

@export var duration:int = 0 : 
	set(val):
		duration = val
		on_duration_update()
		
@export var title:String = "" : 
	set(val):
		title = val
		on_title_update()
		
@export var type:BASE.TYPE : 
	set(val):
		type = val
		on_type_update()

var onClick:Callable = func():pass
var onDismiss:Callable = func():pass

# --------------------------------------
func _ready() -> void:
	super._ready()
	on_duration_update()
	on_title_update()
	on_type_update()
	
	hint_icon = SVGS.TYPE.INFO
	hint_title = "HINT"
# --------------------------------------

# --------------------------------------
func on_title_update() -> void:
	if !is_node_ready():return
	TitleLabel.text = title

func on_duration_update() -> void:
	if !is_node_ready():return
	DurationLabel.hide() if duration >= 20 or duration < 0 else DurationLabel.show()
	DurationLabel.text = "(%s)" % duration

func on_type_update() -> void:
	if !is_node_ready():return
	match type:
		BASE.TYPE.BUFF:
			update_panel_color(RootPanel, Color(1.0, 0.749, 0.2, 0.863))
		BASE.TYPE.DEBUFF:
			update_panel_color(RootPanel, Color(1.0, 0.259, 0.2, 0.863))
# --------------------------------------

# --------------------------------------
func update_panel_color(node:Control, new_color:Color) -> void:
	var new_stylebox:StyleBoxFlat = node.get("theme_override_styles/panel").duplicate(true)
	new_stylebox.bg_color = new_color
	node.set("theme_override_styles/panel", new_stylebox)
# --------------------------------------

# --------------------------------------	
func on_focus(state:bool = false) -> void:
	if !is_node_ready():return
	self.modulate = Color(1, 1, 1, 0.6 if state else 1)
		
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
# --------------------------------------	

# --------------------------------------	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover:
		onClick.call()
	else:
		onDismiss.call()
# --------------------------------------		
