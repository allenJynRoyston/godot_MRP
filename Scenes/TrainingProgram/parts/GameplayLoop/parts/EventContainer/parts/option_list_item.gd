extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var MarginContainerPanel:MarginContainer = $MarginContainer
@onready var IconBtn:Control = $MarginContainer/HBoxContainer/MarginContainer/IconBtn
@onready var DescriptionListMarginContainer:MarginContainer = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer
@onready var DescriptionLabel:Label = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/DescriptionLabel
@onready var DescriptionListContainer:VBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/DescriptionListContainer
@onready var LockedTextBtn:Control = $MarginContainer/HBoxContainer/VBoxContainer/LockedTextBtn
@onready var OptionTextBtn:Control = $MarginContainer/HBoxContainer/VBoxContainer/OptionTextBtn

var onClick:Callable = func() -> void:
	pass
	
var onFocus:Callable = func() -> void:
	pass

var index:int
var enabled:bool = false 
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
		if !is_locked and is_enabled:
			onFocus.call(self)

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and node == self:
		if !is_locked and is_enabled:
			onClick.call()
# ----------------------	

# ----------------------	
func on_is_selected_update() -> void:
	if !is_node_ready():return
	IconBtn.icon = SVGS.TYPE.LOCK if is_locked and !is_selected else  SVGS.TYPE.MEDIA_PLAY if is_selected else SVGS.TYPE.NONE
	IconBtn.static_color = Color.RED if is_locked else COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE if is_selected else COLORS.TEXT.INACTIVE)
	OptionTextBtn.static_color = Color.RED if is_locked else COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE if is_selected else COLORS.TEXT.INACTIVE)
	var stylebox:StyleBoxFlat = RootPanel.get("theme_override_styles/panel").duplicate()
	stylebox.border_color = Color.RED if is_locked else (Color.WHITE if is_selected else Color.WEB_GRAY)
	RootPanel.set('theme_override_styles/panel', stylebox)
	
func on_show_description_update() -> void:
	if !is_node_ready():return
	MarginContainerPanel.add_theme_constant_override("margin_bottom", 10 if show_description else 5)
	IconBtn.size_flags_vertical = Control.SIZE_SHRINK_BEGIN if show_description else Control.SIZE_SHRINK_CENTER
	DescriptionLabel.show() if show_description else DescriptionLabel.hide()

func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	OptionTextBtn.title = data.title
	LockedTextBtn.title = data.title
	
	for node in DescriptionListContainer.get_children():
		node.queue_free()
	
	if "locked" in data and data.locked:
		LockedTextBtn.show() 
		OptionTextBtn.hide()
		is_locked = true
		on_is_selected_update()
	
	if "success_rate" in data:
		DescriptionLabel.text = "%s %s" % ["(%s rate of success)" % [str(data.success_rate,'%')], str(" - ", data.description) if "description" in data else ""]
		show_description = show_description
	else:
		show_description = false
	

	if "description_list" in data and data.description_list.size() > 0:
		var label_setting_copy:LabelSettings = DescriptionLabel.label_settings.duplicate()
		
		for item in data.description_list:
			var new_label:Label = Label.new()
			label_setting_copy.font_color = item.font_color
			
			new_label.label_settings = label_setting_copy
			new_label.text = item.text
			DescriptionListContainer.add_child(new_label)

	if !show_description and DescriptionListContainer.get_child_count() == 0:
		DescriptionListMarginContainer.hide()
	else:
		DescriptionListMarginContainer.show()
# ----------------------

# --------------------------------------------------------------------------------------------------		
func tween_option_color(node:Node, prop:String, new_color:Color, duration:float = 0.3) -> void:
	var tween:Tween = create_tween()
	tween.tween_property(node, prop, new_color, duration).set_trans(Tween.TRANS_QUAD)
	await tween.finished
# --------------------------------------------------------------------------------------------------		
