extends MouseInteractions

@onready var RootPanel:Control = $HBoxContainer/Content
@onready var ActiveLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/Details/VBoxContainer/HBoxContainer/ActiveLabel
@onready var BookmarkCB:BtnBase = $HBoxContainer/Content/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/BookmarkCB
@onready var IndexLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/IndexLabel
@onready var DesignationLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/Details/VBoxContainer/DesignationLabel
@onready var RoomNameLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/Details/VBoxContainer/HBoxContainer/RoomNameLabel
@onready var StatusLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/Details/VBoxContainer/StatusLabel
@onready var RoomImage:TextureRect = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/Details/RoomImage
@onready var ExpandedDetails:Control = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/ExpandedDetails

var room_id:int = 0 : 
	set(val):
		room_id = val
		on_room_id_update()

var raw_designation:String = "" : 
	set(val):
		raw_designation = val
		on_raw_designation_update()

var designation:String = "" : 
	set(val):
		designation = val
		on_designation_update()
		
var data:Dictionary = {} : 
	set(val):		
		var previous_state = data.duplicate()
		data = val
		on_data_update(previous_state)

var is_expanded:bool = false : 
	set(val):
		is_expanded = val
		on_is_expanded_update.call_deferred()
		
var is_highlighted:bool = false : 
	set(val):
		is_highlighted = val
		on_is_highlighted_update.call_deferred()		
		
var bookmarked_rooms:Array = []
var is_empty:bool = false
var onClick:Callable = func():pass
var onFocus:Callable = func():pass

# --------------------------------------	
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_bookmarked_rooms(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_bookmarked_rooms(self)

func _ready() -> void:
	super._ready()
	on_data_update()
	on_designation_update()
	on_is_highlighted_update()
	on_room_id_update()
	on_raw_designation_update()
	on_focus(false)
	

	BookmarkCB.onChange = func(is_checked:bool) -> void:
		if is_checked:
			if raw_designation not in bookmarked_rooms:
				bookmarked_rooms.push_back(raw_designation)
		else: 
			bookmarked_rooms.erase(raw_designation)		
		SUBSCRIBE.bookmarked_rooms = bookmarked_rooms
# --------------------------------------	

# --------------------------------------	
func on_room_id_update() -> void:
	IndexLabel.text = str(room_id + 1)

func on_raw_designation_update() -> void:
	on_bookmarked_rooms_update()

func on_designation_update() -> void:
	if !is_node_ready():return
	DesignationLabel.text = "ROOM %s" % [designation]

func on_data_update(previous_state:Dictionary = {}) -> void:
	if !is_node_ready() or data.is_empty():return
	
	if data.room_data.is_empty() and data.build_data.is_empty():
		RoomNameLabel.text = "EMPTY"
		StatusLabel.text = ""
		RoomImage.texture = null
		is_empty = true
		return
	
	if !data.build_data.is_empty():
		var room_data:Dictionary = data.build_data.get_room_data.call()
		RoomNameLabel.text = "%s" % [room_data.name]
		StatusLabel.text = "[UNDER CONSTRUCTION]"
		RoomImage.texture = CACHE.fetch_image("res://Media/rooms/construction.jpg")
		is_empty = false
	else:
		StatusLabel.text = ""
				#
	if !data.room_data.is_empty():
		var room_data:Dictionary = data.room_data.get_room_data.call()
		RoomNameLabel.text = "%s" % [room_data.name]
		RoomImage.texture = CACHE.fetch_image(room_data.image_src)
		is_empty = false

func on_is_highlighted_update() -> void:
	if !is_node_ready():return
	ActiveLabel.show() if is_highlighted else ActiveLabel.hide()
	update_colors()

func on_is_expanded_update() -> void:
	ExpandedDetails.show() if (is_expanded and !is_empty) else ExpandedDetails.hide()
	update_colors()
	
func on_bookmarked_rooms_update(new_val:Array = bookmarked_rooms) -> void:
	bookmarked_rooms = new_val
	if !is_node_ready():return
	BookmarkCB.is_checked = raw_designation in bookmarked_rooms	
# --------------------------------------	

# --------------------------------------	
func update_colors() -> void:
	var new_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()	
	new_stylebox.bg_color = COLOR_UTIL.get_window_color(COLORS.WINDOW.SHADING) if is_highlighted else (COLOR_UTIL.get_window_color(COLORS.WINDOW.SHADING) if is_focused else COLOR_UTIL.get_window_color(COLORS.WINDOW.INACTIVE))
	RootPanel.add_theme_stylebox_override("panel", new_stylebox)	
# --------------------------------------	

# --------------------------------------	
func on_focus(state:bool) -> void:
	if !is_node_ready():return
	update_colors()
	
	if state:
		onFocus.call()
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
# --------------------------------------	

# --------------------------------------	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover:
		if is_highlighted:
			is_expanded = !is_expanded
		else:
			onClick.call()
# --------------------------------------		
