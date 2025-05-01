extends PanelContainer

@onready var CardDrawerContainmentInfo:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/CardDrawerContainmentInfo
@onready var CardDrawerImage:Control = $CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/CardDrawerImage


@export var ref:int = -1 : 
	set(val):
		ref = val
		on_ref_update()
		
func _ready() -> void:
	on_ref_update()
	
func on_ref_update() -> void:
	if !is_node_ready() or ref == -1:return
	var scp_details:Dictionary = SCP_UTIL.return_data(ref)
	
	CardDrawerContainmentInfo.effects = scp_details.effects
	CardDrawerContainmentInfo.title = scp_details.name
	CardDrawerImage.img_src = scp_details.img_src
	
