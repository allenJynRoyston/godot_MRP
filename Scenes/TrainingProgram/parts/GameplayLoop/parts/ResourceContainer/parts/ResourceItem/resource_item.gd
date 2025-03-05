@tool
extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var HeaderLabel:Label = $MarginContainer/ResourceItem/HeaderLabel
@onready var IconBtn:Control = $MarginContainer/ResourceItem/HBoxContainer/IconBtn
@onready var ItemLabel:Label = $MarginContainer/ResourceItem/HBoxContainer/ItemLabel
@onready var BtmItemLabel:Label = $MarginContainer/ResourceItem/BtmItemLabel

@export var icon:SVGS.TYPE = SVGS.TYPE.DOT : 
	set(val):
		icon = val
		on_icon_update()

@export var no_bg:bool = false : 
	set(val):
		no_bg = val
		on_no_bg_update()

@export var header:String = "" : 
	set(val):
		header = val
		on_header_update()

@export var title:String = ""	: 
	set(val):
		title = val
		on_title_update()	

@export var display_at_bottom:bool = false : 
	set(val):
		display_at_bottom = val
		on_display_at_bottom_update()
		
@export var is_negative: bool = false : 
	set(val):
		is_negative = val
		on_is_negative_update()
		
var onClick:Callable = func():pass
var onDismiss:Callable = func():pass
		
# --------------------------------------
func _ready() -> void:
	super._ready()
	on_header_update()
	on_icon_update()
	on_focus()
	on_display_at_bottom_update()
	on_is_negative_update()	
	on_title_update()
	on_no_bg_update.call_deferred()

func on_header_update() -> void:
	if !is_node_ready():return
	HeaderLabel.text = header

func on_icon_update() -> void:
	if !is_node_ready():return
	IconBtn.icon = 	icon

func on_title_update() -> void:
	if !is_node_ready():return	
	ItemLabel.text = title
	BtmItemLabel.text = title

func on_display_at_bottom_update() -> void:
	if !is_node_ready():return
	BtmItemLabel.show() if display_at_bottom else BtmItemLabel.hide()
	ItemLabel.hide() if display_at_bottom else ItemLabel.show()

func on_is_negative_update() -> void:
	if !is_node_ready():return
	IconBtn.static_color = Color.RED if is_negative else Color.WHITE
	var label_settings_btm:LabelSettings = BtmItemLabel.label_settings.duplicate()
	var label_settings:LabelSettings = ItemLabel.label_settings.duplicate() 
	label_settings.font_color = Color.RED if is_negative else Color.WHITE
	label_settings_btm.font_color = Color.RED if is_negative else Color.WHITE
	ItemLabel.label_settings = label_settings
	BtmItemLabel.label_settings = label_settings_btm
	
func on_no_bg_update() -> void:
	if !is_node_ready():return	
	var dupe_stylebox:StyleBoxFlat = StyleBoxFlat.new()
	dupe_stylebox.border_color = Color.TRANSPARENT if no_bg else Color.WHITE
	dupe_stylebox.bg_color = Color.TRANSPARENT  if no_bg else Color.BLACK
	RootPanel.add_theme_stylebox_override('panel', dupe_stylebox)	
# --------------------------------------

# --------------------------------------	
func on_focus(state:bool = false) -> void:
	if !is_node_ready():return
	ItemLabel.modulate = Color(1, 1, 1, 0.6 if state else 1)
	BtmItemLabel.modulate = Color(1, 1, 1, 0.6 if state else 1)
		
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
