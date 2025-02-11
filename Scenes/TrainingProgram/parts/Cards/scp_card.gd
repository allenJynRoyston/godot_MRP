@tool
extends MouseInteractions

@onready var CardTextureRect:TextureRect = $VBoxContainer/TextureRect
@onready var ImageTextureRect:TextureRect = $SubViewport/SCPCard/Front/Image
@onready var DesignationLabel:Label = $SubViewport/SCPCard/Front/MarginContainer/VBoxContainer/Designation/DesignationLabel

@onready var Front:VBoxContainer = $SubViewport/SCPCard/Front
@onready var Back:VBoxContainer = $SubViewport/SCPCard/Back

@onready var DetailsBtn:BtnBase = $VBoxContainer/DetailsBtn

@export var ref:int = -1: 
	set(val):
		ref = val
		on_ref_update()

@export var flip:bool = false : 
	set(val):
		if flip != val:
			flip = val
			on_flip_update()
		
@export var reveal:bool = false : 
	set(val):
		reveal = val
		on_reveal_update()		

@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
		
@export var show_details_btn:bool = false : 
	set(val):
		show_details_btn = val
		on_show_details_btn_update()		

enum MODE { SELECT, CONFIRM }

var index:int = -1
var onFocus:Callable = func(node:Control):pass
var onBlur:Callable = func(node:Control):pass
var onClick:Callable = func():pass
var current_mode:MODE = MODE.SELECT

func _ready() -> void:
	super._ready()
	Front.show()
	Back.hide()
	
	on_ref_update()
	on_reveal_update()
	on_is_selected_update()
	on_show_details_btn_update()
	
	DetailsBtn.onClick = func() -> void:
		flip = !flip
	

func on_flip_update() -> void:
	if !is_node_ready():return
	CardTextureRect.pivot_offset = self.size/2
	await U.tween_node_property(CardTextureRect, "scale:x", 0, 0.1)
	await U.set_timeout(0.2)
	Front.hide() if flip else Front.show()
	Back.show() if flip else Back.hide()
	U.tween_node_property(CardTextureRect, "scale:x", 1, 0.1)

func on_show_details_btn_update() -> void:
	if !is_node_ready():return
	DetailsBtn.hide() if !show_details_btn else DetailsBtn.show()

func on_is_selected_update() -> void:
	if !is_node_ready():return
	U.tween_node_property(CardTextureRect, "modulate", Color(1, 1, 1, 1) if is_selected else Color(1, 1, 1, 0.5))

func on_reveal_update() -> void:
	if !is_node_ready():return
	await U.tween_node_property(CardTextureRect, "modulate", Color(1, 1, 1, 1) if reveal else Color(1, 1, 1, 0))
	if show_details_btn:
		DetailsBtn.hide() if !reveal else DetailsBtn.show()


func on_ref_update() -> void:
	if !is_node_ready() or ref not in SCP_UTIL.reference_data:return	
	var scp_data:Dictionary = SCP_UTIL.return_data(ref)
	#print(scp_data)


# ------------------------------------------------------------------------------
func on_focus(state:bool = is_focused) -> void:	
	if !is_node_ready():return	
	is_focused = state
	onFocus.call(self) if state else onBlur.call(self)	
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)


func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT:
		onClick.call()
# ------------------------------------------------------------------------------
