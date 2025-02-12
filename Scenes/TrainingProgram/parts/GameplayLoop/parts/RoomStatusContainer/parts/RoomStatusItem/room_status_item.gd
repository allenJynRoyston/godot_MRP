extends MouseInteractions

@onready var RootPanel:Control = $HBoxContainer/Content
@onready var BookmarkCB:BtnBase = $HBoxContainer/Content/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/BookmarkCB
@onready var IndexLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/IndexLabel

@onready var RoomDetails:HBoxContainer = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/RoomDetails
@onready var ActiveLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/RoomDetails/VBoxContainer/HBoxContainer/ActiveLabel
@onready var RoomNameLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/RoomDetails/VBoxContainer/HBoxContainer/RoomNameLabel
@onready var StatusLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/RoomDetails/VBoxContainer/StatusLabel
@onready var RoomImage:TextureRect = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/RoomDetails/RoomImage
@onready var RoomDesignationLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/RoomDetails/VBoxContainer/RoomDesignationLabel

@onready var ContainmentDetails:HBoxContainer = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/ContainmentDetails
@onready var ObjectDesignationLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/ContainmentDetails/SCPDetails/HBoxContainer/ObjectDesignationLabel
@onready var ObjectClassLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/ContainmentDetails/SCPDetails/HBoxContainer/ObjectClassLabel
@onready var ObjectNameLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/ContainmentDetails/SCPDetails/ObjectNameLabel

@onready var ProgressLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/ProgressBarContainer/ProgressLabel
@onready var ProgressAmountLabel:Label = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/ProgressBarContainer/HBoxContainer2/ProgressAmountLabel
@onready var ProgressBarContainer:VBoxContainer = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/ProgressBarContainer
@onready var ActionProgressBar:ProgressBar = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/ProgressBarContainer/HBoxContainer2/ProgressBar

@onready var ExpandedDetails:Control = $HBoxContainer/Content/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/ExpandedDetails


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

var progress_bar_value:float = -1.0 : 
	set(val):
		progress_bar_value = val
		on_progress_bar_value_update()
		
var action_queue_data:Array = []
var bookmarked_rooms:Array = []

var is_empty:bool = false
var onClick:Callable = func():pass
var onFocus:Callable = func():pass

# --------------------------------------	
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_bookmarked_rooms(self)
	SUBSCRIBE.subscribe_to_action_queue_data(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_bookmarked_rooms(self)
	SUBSCRIBE.unsubscribe_to_action_queue_data(self)

func _ready() -> void:
	super._ready()
	on_data_update()
	on_designation_update()
	on_is_highlighted_update()
	on_room_id_update()
	on_raw_designation_update()
	on_focus(false)
	
	ProgressBarContainer.hide()
	
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
# --------------------------------------	

# --------------------------------------	
func on_action_queue_data_update(new_val:Array = action_queue_data) -> void:
	action_queue_data = new_val
	on_data_update()
# --------------------------------------	

# --------------------------------------	
func on_raw_designation_update() -> void:
	on_bookmarked_rooms_update()
# --------------------------------------	

# --------------------------------------	
func on_designation_update() -> void:
	if !is_node_ready():return
	RoomDesignationLabel.text = "ROOM %s" % [designation]

func on_data_update(previous_state:Dictionary = {}) -> void:
	if !is_node_ready() or data.is_empty():return
	var action_queue_filter:Array = []
	
	# --------------------------
	if data.room_data.is_empty() and data.build_data.is_empty():
		RoomNameLabel.text = "EMPTY"
		StatusLabel.text = ""
		RoomImage.texture = null
		progress_bar_value = -1.0
		
	is_empty = false
	ContainmentDetails.hide() if data.scp_data.is_empty() else ContainmentDetails.show()	
	# --------------------------
	
	# --------------------------
	if !data.build_data.is_empty():
		var room_data:Dictionary = ROOM_UTIL.return_data(data.build_data.ref)
		RoomNameLabel.text = "%s" % [room_data.name]
		RoomImage.texture = CACHE.fetch_image("res://Media/rooms/construction.jpg")
		StatusLabel.text = ""
		ProgressLabel.text = "CONSTRUCTING"
		
		action_queue_filter = action_queue_data.filter(func(i): return i.action == ACTION.AQ.BUILD_ITEM and i.ref == room_data.ref)
	# --------------------------
	
	# --------------------------
	if !data.room_data.is_empty():
		var room_data:Dictionary = ROOM_UTIL.return_data(data.room_data.ref)
		RoomNameLabel.text = "%s" % [room_data.name]
		RoomImage.texture = CACHE.fetch_image(room_data.img_src)
		StatusLabel.text = ""
	# --------------------------

	# --------------------------
	if !data.scp_data.is_empty():
		var scp_data:Dictionary = SCP_UTIL.return_data(data.scp_data.ref)
		ObjectDesignationLabel.text = "%s" % [scp_data.name]
		ObjectClassLabel.text = "KETER"
		ObjectNameLabel.text = "%s" % [scp_data.name]
		action_queue_filter = action_queue_data.filter(func(i): return (i.action == ACTION.AQ.CONTAIN or i.action == ACTION.AQ.TRANSFER) and i.ref == scp_data.ref)
	# --------------------------
	
	## -------------------------- 
	#if action_queue_filter.size() > 0:
		#if "note" in action_queue_filter[0]:
			#ProgressLabel.text = action_queue_filter[0].note		
		#var action_queue_item:Dictionary = action_queue_filter[0]
		#progress_bar_value = (action_queue_item.days_in_queue*1.0 / action_queue_item.build_time*1.0)
		#ProgressAmountLabel.text = str(int(progress_bar_value * 100)) + "%"
	#else:
		#progress_bar_value = -1
	## --------------------------
	
	StatusLabel.hide() if StatusLabel.text == "" else StatusLabel.show()
# --------------------------------------	

# --------------------------------------	
func on_progress_bar_value_update() -> void:
	if progress_bar_value == -1:
		ProgressBarContainer.hide()
		ActionProgressBar.value = 0
	else:
		ProgressBarContainer.show()
		ActionProgressBar.value = progress_bar_value
	
	
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
