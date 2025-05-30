extends MouseInteractions

@onready var CardBody:Control = $SubViewport/CardBody
@onready var ScpImage:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage
#@onready var ScpName:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ScpName
#@onready var ScpEffect:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ScpEffect
@onready var InContainment:PanelContainer = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/InContainment
@onready var MaxLevel:PanelContainer = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/MaxLevel

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

var scp_data:Dictionary = {}

var check_in_containment:bool = false
var in_containment:bool = false : 
	set(val):
		in_containment = val
		U.debounce(str(self.name, "_on_panel_update"), on_panel_update)

var check_max_level:bool = false
var at_max_level:bool = false : 
	set(val):
		at_max_level = val
		U.debounce(str(self.name, "_on_panel_update"), on_panel_update)		

var freeze_inputs:bool = false
var index:int
var border_color:Color

var onClick:Callable = func():pass
var onHover:Callable = func():pass
var onDismiss:Callable = func():pass

# --------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_scp_data(self)

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_scp_data(self)


func _ready() -> void:
	super._ready()

	for node in []:
		node.hide()		
	
	on_focus()
	on_scp_ref_update()
	on_is_highlighted_update()
	on_scp_data_update()
	reset()
	
	
func reset() -> void:
	is_highlighted = false
	update_content()
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
	U.debounce(str(self.name, "_update_content"), update_content)

func on_scp_data_update(new_val:Dictionary = scp_data) -> void:
	scp_data = new_val
	if !is_node_ready():return
	U.debounce(str(self.name, "_update_content"), update_content)
# --------------------------------------		

# --------------------------------------		
func update_content() -> void:	
	if !is_node_ready():return

	var panel_nodes:Array = [InContainment, MaxLevel]
	for node in panel_nodes:
		node.hide()
		
	if scp_ref == -1:
		ScpImage.img_src = ""
		return
		
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	var level:int = 0 if scp_ref not in scp_data else scp_data[scp_ref].level
	
	ScpImage.title = "%s - LVL%s" % [scp_details.name, level]
	ScpImage.img_src = scp_details.img_src
	
	
	hint_title = "HINT"
	hint_icon = SVGS.TYPE.CONTAIN
	hint_description = scp_details.description 	
	
	if in_containment and check_in_containment:
		for node in panel_nodes:
			if node in [InContainment]:
				node.show() 
			else:
				node.hide()
		hint_icon = SVGS.TYPE.STOP
		hint_description = str(scp_details.description, " (ALREADY IN CONTAINMENT)")
		return	
	
	if at_max_level and check_max_level:
		for node in panel_nodes:
			if node in [MaxLevel]:
				node.show() 
			else:
				node.hide()
		hint_icon = SVGS.TYPE.STOP
		hint_description = str(scp_details.description, " (MAX LEVEL)")
		return

# --------------------------------------		

# --------------------------------------	
func is_clickable() -> bool:
	if scp_ref == -1 or (at_max_level and check_max_level) or (in_containment and check_in_containment):
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
