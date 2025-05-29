extends MouseInteractions

@onready var CardBody:Control = $SubViewport/CardBody
@onready var ScpName:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerTitle
@onready var ScpImage:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage

@export var flip:bool = false : 
	set(val):
		flip = val
		on_flip_update()

@export var is_highlighted:bool = false : 
	set(val):
		is_highlighted = val
		on_is_highlighted_update()
		
@export var scp_ref:int = -1: 
	set(val):
		scp_ref = val
		on_scp_ref_update()
		
const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")

var freeze_inputs:bool = false
var index:int
var border_color:Color

var onClick:Callable = func():pass
var onHover:Callable = func():pass
var onDismiss:Callable = func():pass

# --------------------------------------
func _init() -> void:
	super._init()

func _exit_tree() -> void:
	super._exit_tree()


func _ready() -> void:
	super._ready()

	for node in []:
		node.hide()		
	
	on_focus()
	on_scp_ref_update()
	on_is_highlighted_update()
	reset()
	
	
func reset() -> void:
	for node in []:
		node.hide()			

	await U.tick()
	
	modulate = Color(1, 1, 1, 0.6)
	border_color = Color.BLACK
# --------------------------------------

# --------------------------------------
func on_panel_update() -> void:
	if !is_node_ready():return
	update_content()
# --------------------------------------

# --------------------------------------	
func on_is_highlighted_update() -> void:
	if !is_node_ready():return
	CardBody.border_color = border_color.lightened(0.3) if is_highlighted else border_color
	self.modulate = Color(1, 1, 1, 1 if is_highlighted else 0.6)
# --------------------------------------		

# --------------------------------------	
func on_flip_update() -> void:
	if !is_node_ready():return
	CardBody.flip = flip
	
func on_scp_ref_update() -> void:
	if !is_node_ready():return	
	CardBody.instant_flip(scp_ref == -1)	
	update_content()
# --------------------------------------		

# --------------------------------------		
func update_content() -> void:	
	if !is_node_ready():return
	
	if scp_ref == -1:
		return
		
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	
	ScpName.content = "%s\r%s" % [scp_details.name, scp_details.nickname]
	ScpImage.img_src = scp_details.img_src
# --------------------------------------		

# --------------------------------------	
func is_clickable() -> bool:
	if scp_ref == -1:
		return false
	return true 
# --------------------------------------	

# --------------------------------------	
func on_focus(state:bool = false) -> void:
	if !is_node_ready():return
		
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
		onHover.call()
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
# --------------------------------------	

# --------------------------------------	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover:
		if !is_clickable:return
		onClick.call()
	else:
		onDismiss.call()
# --------------------------------------		
