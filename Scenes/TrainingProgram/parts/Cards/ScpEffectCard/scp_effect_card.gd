extends Control

@onready var CardBody:Control = $SubViewport/CardBody
@onready var ScpName:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ScpName
@onready var ScpEffect:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ScpEffect
@onready var ScpBreach:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ScpBreach
@onready var ScpNeutralize:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ScpNeutralize

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

var freeze_inputs:bool = false
var index:int
var border_color:Color

var onClick:Callable = func():pass
var onHover:Callable = func():pass
var onDismiss:Callable = func():pass

# --------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_scp_data(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_scp_data(self)

func _ready() -> void:
	for node in []:
		node.hide()		
	
	on_scp_ref_update()
	on_is_highlighted_update()
	on_scp_data_update()
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
	if scp_ref == -1:
		for node in [ScpName, ScpEffect, ScpBreach, ScpNeutralize]:
			node.content = ""
		return
		
	var scp_details:Dictionary = SCP_UTIL.return_data(scp_ref)
	var level:int = 0 if scp_ref not in scp_data else scp_data[scp_ref].level
	
	ScpName.content = "%s\r%s" % [scp_details.name, scp_details.nickname]
	ScpEffect.content = scp_details.effects.description if level > 0 else "UNKNOWN\r(EVALUATION REQUIRED)"
	ScpBreach.content = scp_details.breach.description if level > 1 else "UNKNOWN\r(EVALUATION REQUIRED)"
	ScpNeutralize.content = scp_details.effects.description if level > 2 else "UNKNOWN\r(EVALUATION REQUIRED)"
# --------------------------------------		
