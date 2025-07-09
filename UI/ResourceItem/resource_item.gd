@tool
extends MouseInteractions

@onready var RootPanel:PanelContainer = $"."
@onready var HeaderLabel:Label = $MarginContainer/ResourceItem/VBoxContainer/HeaderLabel
@onready var IconBtn:Control = $MarginContainer/ResourceItem/VBoxContainer/HBoxContainer/IconBtn
@onready var ItemLabel:Label = $MarginContainer/ResourceItem/VBoxContainer/HBoxContainer/ItemLabel
@onready var BtmItemLabel:Label = $MarginContainer/ResourceItem/VBoxContainer/BtmItemLabel

@onready var SecondValContainer:VBoxContainer = $MarginContainer/ResourceItem/SecondValContainer
@onready var SecondValIcon:BtnBase = $MarginContainer/ResourceItem/SecondValContainer/IconBtn
@onready var SecondValLabel:Label = $MarginContainer/ResourceItem/SecondValContainer/MarginContainer/Label

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

@export var actual_val:int

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
		
@export var icon_size:Vector2 = Vector2(20, 20) : 
	set(val):
		icon_size = val
		on_icon_size_update()

@export var is_faded:bool = false : 
	set(val):
		is_faded = val
		on_is_faded_updated()
		
@export var use_second_val:bool = false : 
	set(val):
		use_second_val = val
		on_use_second_val_update()
		
@export var second_val:int  = -1 : 
	set(val):
		second_val = val
		on_second_val_update()


		
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
	on_icon_size_update()
	on_is_faded_updated()
	on_use_second_val_update()
	on_second_val_update()
	on_no_bg_update.call_deferred()

func on_use_second_val_update() -> void:
	if !is_node_ready():return
	SecondValContainer.show() if use_second_val else SecondValContainer.hide()

func on_second_val_update() -> void:
	if !is_node_ready() or !use_second_val:return	
	SecondValLabel.text = str(second_val)
	SecondValContainer.modulate = Color(1, 1, 1, 1 if actual_val != second_val else 0)
	
	var sv_label_settings:LabelSettings = SecondValLabel.label_settings.duplicate()
	var use_color:Color = Color.WHITE if second_val == 0 else (Color.GREEN if second_val > actual_val else Color.RED)
	sv_label_settings.font_color = use_color
	SecondValIcon.static_color = use_color
	SecondValLabel.label_settings = sv_label_settings	

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

func on_icon_size_update() -> void:
	if !is_node_ready():return	
	IconBtn.size = Vector2(1, 1)
	await U.tick()
	IconBtn.custom_minimum_size = icon_size


func on_display_at_bottom_update() -> void:
	if !is_node_ready():return
	BtmItemLabel.show() if display_at_bottom else BtmItemLabel.hide()
	ItemLabel.hide() if display_at_bottom else ItemLabel.show()

func on_is_negative_update() -> void:
	if !is_node_ready():return
	U.debounce( str(self, "_update_all"), update_all)

func on_is_faded_updated() -> void:
	if !is_node_ready():return	
	U.debounce( str(self, "_update_all"), update_all)

	
func update_all() -> void:
	var label_settings_btm:LabelSettings = BtmItemLabel.label_settings.duplicate()
	var label_settings:LabelSettings = ItemLabel.label_settings.duplicate() 	
	var a:float = 0.8 if is_faded else 1.0
	var new_color:Color = Color(1, 0, 0, a) if is_negative else Color(1, 1, 1, a)
	
	label_settings.font_color = new_color
	label_settings_btm.font_color = new_color
	IconBtn.static_color = new_color

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
