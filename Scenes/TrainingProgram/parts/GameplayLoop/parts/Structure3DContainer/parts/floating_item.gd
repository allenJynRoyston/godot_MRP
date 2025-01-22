extends MouseInteractions

@onready var RoomName:Label = $VBoxContainer/MarginContainer/RoomName

var data:Dictionary = {} : 
	set(val):
		data = val
		on_data_update()

var room_details:Dictionary = {}

var location:Dictionary = {}

func _ready() -> void:
	super._ready()
	on_data_update()
	hide()

func use_empty_defaults() -> void:
	RoomName.text = "Empty"

func on_data_update() -> void:
	if !is_node_ready():return
	
	if data.is_empty():
		use_empty_defaults()
		return

	if "get_room_data" in data:
		room_details = data.get_room_data.call()
		RoomName.text = room_details.name

func on_focus(state:bool = is_focused) -> void:	
	if !is_node_ready():return	
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if is_focused and btn == MOUSE_BUTTON_LEFT:		
		SUBSCRIBE.current_location = location
