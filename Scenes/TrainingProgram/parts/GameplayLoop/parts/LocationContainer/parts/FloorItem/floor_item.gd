@tool
extends MouseInteractions

enum STATUS {NO_ISSUES, WARNING, DANGER}

@onready var FloorLabel:Label = $Label
@onready var SelectedBtn:BtnBase = $SelectedBtn
@onready var StatusBtn:BtnBase = $StatusBtn
@onready var LockBtn:BtnBase = $LockBtn

@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
		
@export var status:STATUS = STATUS.NO_ISSUES : 
	set(val):
		status = val
		on_status_update()

@export var is_disabled = false : 
	set(val):
		is_disabled = val
		on_is_disabled_update()

var floor:int = 0 : 
	set(val):
		floor = val
		on_floor_update()

var onClick:Callable = func():pass

var room_config:Dictionary = {}
var purchased_base_arr:Array = []

# --------------------------------------	
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_room_config(self)

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_room_config(self)
# --------------------------------------		

# --------------------------------------	
func _ready() -> void:
	super._ready()
	on_is_selected_update()
	on_status_update()
	on_floor_update()
	update_colors()
	on_room_config_update()
# --------------------------------------	

# --------------------------------------	
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready():return
	LockBtn.hide() if room_config.floor[floor].is_powered else LockBtn.show()
	FloorLabel.show() if room_config.floor[floor].is_powered else FloorLabel.hide()


func on_floor_update() -> void:
	if !is_node_ready():return
	FloorLabel.text = "%sF" % [floor + 1]
	
func on_is_selected_update() -> void:
	if !is_node_ready():return
	SelectedBtn.icon = SVGS.TYPE.TARGET if is_selected else SVGS.TYPE.DOT
	update_colors()

func on_status_update() -> void:
	if !is_node_ready():return
	StatusBtn.hide() # not used currently
	match status:
		STATUS.NO_ISSUES:
			StatusBtn.icon = SVGS.TYPE.NO_ISSUES
		STATUS.WARNING:
			StatusBtn.icon = SVGS.TYPE.WARNING
		STATUS.DANGER:
			StatusBtn.icon = SVGS.TYPE.DANGER
				
func on_is_disabled_update() -> void:
	if !is_node_ready():return
	update_colors()
	is_hoverable = !is_disabled
# --------------------------------------

# --------------------------------------
func update_colors() -> void:
	var use_color:Color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE) if is_selected else COLOR_UTIL.get_text_color(COLORS.TEXT.INACTIVE)
	if is_disabled:
		use_color = COLOR_UTIL.get_text_color(COLORS.TEXT.DARK)
	if is_focused:
		use_color = COLOR_UTIL.get_text_color(COLORS.TEXT.LIGHT)
	
	var label_setting:LabelSettings = FloorLabel.label_settings.duplicate()
	label_setting.font_color = use_color
	FloorLabel.label_settings = label_setting
		
	for node in [SelectedBtn, StatusBtn]:
		node.static_color = use_color
# --------------------------------------
	

# --------------------------------------	
func on_focus(state:bool) -> void:
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
		
	update_colors()

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover and btn == MOUSE_BUTTON_LEFT and !room_config.floor[floor].is_locked:
		onClick.call()
# --------------------------------------			
