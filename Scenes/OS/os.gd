extends PanelContainer

@onready var MousePointer:TextureRect = $SubViewport/MousePointer
@onready var FinalScreen:TextureRect = $TextureRect

const mouse_cursor:CompressedTexture2D = preload("res://Media/mouse/icons8-select-cursor-24.png")
const mouse_busy:CompressedTexture2D = preload("res://Media/mouse/icons8-hourglass-24.png")
const mouse_pointer:CompressedTexture2D = preload("res://Media/mouse/icons8-click-24.png")

# -----------------------------------	
func _ready() -> void:
	if !Engine.is_editor_hint():
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	GBL.register_node(REFS.OS_ROOT, self)
	GBL.subscribe_to_mouse_icons(self)
	GBL.set_resolution([self, $SubViewport, $SubViewport2, $TextureRect])
# -----------------------------------		

# -----------------------------------		
func _exit_tree() -> void:
	GBL.unregister_node(REFS.OS_ROOT)
	GBL.unsubscribe_to_mouse_icons(self)
# -----------------------------------			

# -----------------------------------			
func update_fullscreen(state:bool) -> void:
	self.size = DisplayServer.screen_get_size() if state else GBL.resolution
	FinalScreen.stretch_mode = TextureRect.STRETCH_SCALE if state else TextureRect.EXPAND_KEEP_SIZE
# -----------------------------------			

# -----------------------------------	
func on_mouse_icon_update(mouse_icon:GBL.MOUSE_ICON) -> void:
	match mouse_icon:
		GBL.MOUSE_ICON.CURSOR:
			MousePointer.texture = mouse_cursor
		GBL.MOUSE_ICON.BUSY:
			MousePointer.texture = mouse_busy
		GBL.MOUSE_ICON.POINTER:
			MousePointer.texture = mouse_pointer
# -----------------------------------	

# -----------------------------------	
func _process(delta: float) -> void:
	var mouse_pos:Vector2 = get_global_mouse_position()
	GBL.mouse_pos = mouse_pos
	MousePointer.position = mouse_pos - Vector2(4, 0)
# -----------------------------------	
