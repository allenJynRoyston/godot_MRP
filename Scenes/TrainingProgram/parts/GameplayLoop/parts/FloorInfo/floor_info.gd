extends GameContainer

#@onready var MainPanel:MarginContainer = $mARGINcONTAIN
@onready var StatusLabel:Label = $Control/MarginContainer/HBoxContainer/ExpandListContainer/PanelContainer/MarginContainer/VBoxContainer/StatusLabel
@onready var PreviewTextureRect:TextureRect = $Control/MarginContainer/HBoxContainer/ExpandListContainer/PanelContainer/MarginContainer/VBoxContainer/PreviewTextureRect
#@onready var ExpandListContainer:VBoxContainer = $Control/MarginContainer/HBoxContainer/ExpandListContainer
#@onready var ExpandSubListContainer:VBoxContainer = $Control/MarginContainer/HBoxContainer/ExpandListContainer/ExpandSubListContainer
#
#@onready var DetailsPanel:PanelContainer = $Control/MarginContainer/HBoxContainer/ExpandListContainer/ExpandSubListContainer/DetailsPanel

@export var expand:bool = false : 
	set(val):
		expand = val
		on_expand_update()


# -----------------------------------------------
func _init() -> void:
	super._init()
	GBL.register_node(REFS.FLOOR_INFO, self)

func _exit_tree() -> void:
	super._exit_tree()
	GBL.unregister_node(REFS.FLOOR_INFO)

func _ready() -> void:
	super._ready()
	await U.tick()
	#var subviewport:SubViewport = GBL.find_node(REFS.RENDERING).get_preview_viewport()
	#PreviewTextureRect.texture = subviewport.get_texture()
# -----------------------------------------------

# -----------------------------------------------
func on_is_showing_update() -> void:	
	if !is_node_ready() or camera_settings.is_empty():return	
	#if camera_settings.type == CAMERA.TYPE.FLOOR_SELECT and is_showing:
		#U.tween_node_property(MainPanel, "position:x", 0)
		##LocationPanel.show() 
	#else:
		#U.tween_node_property(MainPanel, "position:x", -MainPanel.size.x - 20)
		##LocationPanel.hide()	
# -----------------------------------------------	

# --------------------------------------------------------
func on_current_location_update(new_val:Dictionary) -> void:
	super.on_current_location_update(new_val)
	if is_node_ready():return
# --------------------------------------------------------	
	
# --------------------------------------------------------
func on_camera_settings_update(new_val:Dictionary) -> void:
	super.on_camera_settings_update(new_val)
	on_is_showing_update()
# -----------------------------------------------

# -----------------------------------------------
func activate_toggle() -> void:
	var index:int = current_location.ring
# -----------------------------------------------	

# -----------------------------------------------
func on_expand_update() -> void:
	if !is_node_ready():return
	#var expand_current_val:float = ExpandListContainer.get('theme_override_constants/separation')
	#U.tween_range(expand_current_val, 10 if expand else -60, 0.2, func(val:float) -> void:
		#ExpandListContainer.set("theme_override_constants/separation", val)
	#) 
	#
	#var expandsub_current_val:float = ExpandSubListContainer.get('theme_override_constants/separation')	
	#U.tween_range(expandsub_current_val, 10 if expand else -45, 0.2, func(val:float) -> void:
		#ExpandSubListContainer.set("theme_override_constants/separation", val)
	#)  	
	#
	#for node in [DetailsPanel]:
		#U.tween_node_property(node, "modulate", Color(1, 1, 1, 1 if expand else 0), 0.2)


func toggle_expand() -> void:
	expand = !expand
# -----------------------------------------------
