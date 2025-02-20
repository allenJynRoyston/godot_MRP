extends GameContainer

@onready var MainPanel:MarginContainer = $Control/MarginContainer
@onready var LocationPanel:Control = $MarginContainer/LocationPanel

# -----------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.FLOOR_INFO, self)

func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.FLOOR_INFO)

func _ready() -> void:
	super._ready()
# -----------------------------------------------

# -----------------------------------------------
func on_is_showing_update() -> void:	
	if !is_node_ready() or camera_settings.is_empty():return	
	if camera_settings.type == CAMERA.TYPE.FLOOR_SELECT and is_showing:
		U.tween_node_property(MainPanel, "position:x", 0, 0.7)
		LocationPanel.show() 
	else:
		U.tween_node_property(MainPanel, "position:x", -MainPanel.size.x - 20, 0.7)
		LocationPanel.hide()	
	
# -----------------------------------------------	

# --------------------------------------------------------
func on_camera_settings_update(new_val:Dictionary) -> void:
	super.on_camera_settings_update(new_val)
	on_is_showing_update()
# -----------------------------------------------

# -----------------------------------------------
func activate_toggle() -> void:
	var index:int = current_location.ring
# -----------------------------------------------	
