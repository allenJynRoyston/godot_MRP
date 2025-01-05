extends MouseInteractions

@onready var SelectedIcon:BtnBase = $MarginContainer/HBoxContainer2/SelectedIcon
@onready var NameLabel:Label = $MarginContainer/HBoxContainer2/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/NameLabel
@onready var DangerLabel:Label = $MarginContainer/HBoxContainer2/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/DangerLabel
@onready var StatusLabel:Label = $MarginContainer/HBoxContainer2/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/StatusLabel
@onready var ItemImage:TextureRect = $MarginContainer/HBoxContainer2/VBoxContainer/ItemImage

var index:int

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

var is_active:bool = false : 
	set(val):
		is_active = val
		on_is_active_update()

var use_icon:SVGS.TYPE = SVGS.TYPE.NONE

var onIsActiveUpdate:Callable = func(is_active:bool):pass
var onHover:Callable = func():pass
var onBlur:Callable = func():pass
var onClick:Callable = func():pass

# --------------------------------------	
func _ready() -> void:
	super._ready()
	on_data_update()
	on_focus(false)
	on_is_active_update()
# --------------------------------------	

# --------------------------------------	
func on_data_update() -> void:
	if !is_node_ready() or data.is_empty():return
	var scp_data:Dictionary = SCP_UTIL.return_data(data.id)
	NameLabel.text = "SCP-%s:" % [scp_data.item_id]
	DangerLabel.text = "UNKNOWN"
	ItemImage.texture = CACHE.fetch_image(scp_data.image_src)
	
	if "expires_in" in data:
		StatusLabel.text = "EXPIRES IN %s" % [data.expires_in]
# --------------------------------------	

# --------------------------------------	
func on_is_active_update() -> void:
	if !is_node_ready():return
	
	SelectedIcon.icon = SVGS.TYPE.NEXT if is_active else use_icon 
	onIsActiveUpdate.call(is_active)
# --------------------------------------	

# --------------------------------------	
func on_focus(state:bool) -> void:
	if !is_node_ready():return
		
	if state:
		SelectedIcon.icon = SVGS.TYPE.NEXT
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
		use_icon = SVGS.TYPE.DOT
	else:
		SelectedIcon.icon = SVGS.TYPE.NONE
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
		use_icon = SVGS.TYPE.NONE
	
	on_is_active_update()
# --------------------------------------	

# --------------------------------------	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if !is_node_ready():return
	
	if on_hover:
		onClick.call()
# --------------------------------------		
