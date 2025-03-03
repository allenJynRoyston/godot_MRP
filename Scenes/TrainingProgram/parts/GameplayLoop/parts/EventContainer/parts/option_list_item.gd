extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var MarginContainerPanel:MarginContainer = $MarginContainer
@onready var IconBtn:Control = $MarginContainer/HBoxContainer/IconBtn
@onready var DescriptionLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/DescriptionLabel

@onready var LockedTextBtn:Control = $MarginContainer/HBoxContainer/VBoxContainer/LockedTextBtn
@onready var OptionTextBtn:Control = $MarginContainer/HBoxContainer/VBoxContainer/OptionTextBtn

var onClick:Callable = func() -> void:pass
var onFocus:Callable = func() -> void:pass

var enabled:bool = false 
var index:int

var is_locked:bool = false

var is_enabled:bool = true

var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

var show_description:bool = false : 
	set(val):
		show_description = val 
		on_show_description_update()

# ----------------------
func _ready() -> void:
	super._ready()
	on_data_update()
	on_show_description_update()
	on_is_selected_update()
# ----------------------

# ----------------------	
func fade_out() -> void:
	tween_option_color(DescriptionLabel, "modulate", Color(1, 0, 0, 0.3), 0.3)
	for node in [IconBtn, LockedTextBtn, OptionTextBtn]:
		tween_option_color(node, "static_color", Color(1, 1, 1, 0.3), 0.3)
		
# ----------------------		

# ----------------------
func on_focus(state:bool) -> void:
	if state and is_enabled:
		onFocus.call(self)

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and node == self:
		if !is_locked and is_enabled:
			onClick.call()
# ----------------------	

# ----------------------	
func on_is_selected_update() -> void:
	if !is_node_ready():return
	IconBtn.icon = (SVGS.TYPE.CLEAR if is_locked else SVGS.TYPE.NEXT) if is_selected else SVGS.TYPE.NONE
	OptionTextBtn.inactive_color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE if is_selected else COLORS.TEXT.INACTIVE)
	var stylebox:StyleBoxFlat = RootPanel.get("theme_override_styles/panel").duplicate()
	stylebox.border_color = Color.WHITE if is_selected else Color.WEB_GRAY
	RootPanel.set('theme_override_styles/panel', stylebox)
	
func on_show_description_update() -> void:
	if !is_node_ready():return
	MarginContainerPanel.add_theme_constant_override("margin_bottom", 10 if show_description else 5)
	IconBtn.size_flags_vertical = Control.SIZE_SHRINK_BEGIN if show_description else Control.SIZE_SHRINK_CENTER
	DescriptionLabel.show() if show_description else DescriptionLabel.hide()

func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	show_description = false
	OptionTextBtn.title = data.title
	LockedTextBtn.title = data.title
	
	if "locked" in data and data.locked:
		LockedTextBtn.show() 
		OptionTextBtn.hide()
		is_locked = true
		on_is_selected_update()
	
	if "description" in data and data.description.length() > 0:
		DescriptionLabel.text = "     %s" % data.description
		show_description = true
# ----------------------

# --------------------------------------------------------------------------------------------------		
func tween_option_color(node:Node, prop:String, new_color:Color, duration:float = 0.3) -> void:
	var tween:Tween = create_tween()
	tween.tween_property(node, prop, new_color, duration).set_trans(Tween.TRANS_QUAD)
	await tween.finished
# --------------------------------------------------------------------------------------------------		
