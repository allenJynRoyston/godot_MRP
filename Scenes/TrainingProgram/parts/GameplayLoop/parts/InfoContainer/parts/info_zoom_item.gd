@tool
extends BtnBase

@export var set_camera_to:CAMERA.ZOOM : 
	set(val):
		set_camera_to = val
		on_set_camera_to_update()

@onready var IconBtn:BtnBase = $IconBtn 
@onready var IndicatorBtn:BtnBase = $IndicatorBtn

var camera_settings:Dictionary

# ------------------------------------------------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_camera_settings(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_camera_settings(self)	

func _ready() -> void:
	super._ready()
	on_camera_settings_update()
	on_set_camera_to_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_set_camera_to_update() -> void:
	if !is_node_ready():return
	match set_camera_to:
		CAMERA.ZOOM.OVERVIEW:
			IconBtn.icon = SVGS.TYPE.CONTAIN
		CAMERA.ZOOM.FLOOR:
			IconBtn.icon = SVGS.TYPE.CONTAIN
		CAMERA.ZOOM.RING:
			IconBtn.icon = SVGS.TYPE.CONTAIN
		CAMERA.ZOOM.RM:
			IconBtn.icon = SVGS.TYPE.CONTAIN
	
func on_camera_settings_update(new_val:Dictionary = camera_settings) -> void:
	camera_settings = new_val
	update_icons()

func on_focus(state:bool = is_focused) -> void:
	super.on_focus(state)
	update_icons()

func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	super.on_mouse_click(node, btn, on_hover)
	if on_hover and !camera_settings.is_locked:
		camera_settings.zoom = set_camera_to
		SUBSCRIBE.camera_settings = camera_settings
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func update_icons() -> void:
	if !is_node_ready() or camera_settings.is_empty():return
	if "is_locked" in camera_settings:
		IndicatorBtn.icon = SVGS.TYPE.LOCK if camera_settings.is_locked else (SVGS.TYPE.DOT if set_camera_to == camera_settings.zoom else SVGS.TYPE.NONE)
	IndicatorBtn.static_color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE if set_camera_to == camera_settings.zoom else COLORS.TEXT.INACTIVE)
	IconBtn.static_color = COLOR_UTIL.get_text_color(COLORS.TEXT.ACTIVE if set_camera_to == camera_settings.zoom else COLORS.TEXT.INACTIVE)
# ------------------------------------------------------------------------------	
	
