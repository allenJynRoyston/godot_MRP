extends MouseInteractions

@onready var CardBody:Control = $SubViewport/CardBody
@onready var CardImage:Control =  $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage
@onready var Level:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/Lvl
@onready var Name:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/HBoxContainer/Name
@onready var Spec:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/Spec

@onready var AlreadyAssigned:PanelContainer = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/AlreadyAssignedPanel
@onready var CannotPromote:PanelContainer = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/CannotPromote

@onready var IncompatablePanel:PanelContainer = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/IncompatablePanel
@onready var IncompatableLabel:Label = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/IncompatablePanel/CenterContainer/Label

@onready var AssignedElsewhere:PanelContainer = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/AssignedElsewhere
@onready var AssignedElsewhereLabel:Label = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/AssignedElsewhere/CenterContainer/Label

enum CARD_TYPE {UNLOCK, PURCHASE}

@export var card_type:CARD_TYPE = CARD_TYPE.UNLOCK

@export var flip:bool = false : 
	set(val):
		flip = val
		on_flip_update()

@export var is_highlighted:bool = false : 
	set(val):
		is_highlighted = val
		on_is_highlighted_update()
		
@export var uid:String = "": 
	set(val):
		uid = val
		on_uid_update()
		
const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")

var freeze_inputs:bool = false
var index:int
var border_color:Color

var is_already_assigned:bool = false : 
	set(val):
		is_already_assigned = val
		U.debounce(str(self.name, "_on_panel_update"), on_panel_update)
		
var spec_required:Dictionary = {} 
var is_incompatable:bool = false : 
	set(val):
		is_incompatable = val
		U.debounce(str(self.name, "_on_panel_update"), on_panel_update)
		
var assigned_elsewhere_data:Dictionary = {}
var is_assigned_elsewhere:bool = false :
	set(val):
		is_assigned_elsewhere = val
		U.debounce(str(self.name, "_on_panel_update"), on_panel_update)

var check_for_promotions:bool = false 
var can_be_promoted:bool = false : 
	set(val):
		can_be_promoted = val
		U.debounce(str(self.name, "_on_panel_update"), on_panel_update)

var onClick:Callable = func():pass
var onHover:Callable = func():pass
var onDismiss:Callable = func():pass

# --------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_shop_unlock_purchases(self)	

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_shop_unlock_purchases(self)	

func _ready() -> void:
	super._ready()

	for node in [AlreadyAssigned, IncompatablePanel, AssignedElsewhere, CannotPromote]:
		node.hide()		

	on_focus()
	on_uid_update()
	on_is_highlighted_update()
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
	self.modulate = Color(1, 1, 1, 1 if is_highlighted else 0.7)
# --------------------------------------		

# --------------------------------------	
func on_flip_update() -> void:
	if !is_node_ready():return
	CardBody.flip = flip
	
func on_uid_update() -> void:
	if !is_node_ready():return	
	CardBody.instant_flip(uid == "")	
	update_content()
# --------------------------------------		

# --------------------------------------		
func update_content() -> void:	
	if !is_node_ready():return
	
	var panel_nodes:Array = [AlreadyAssigned, IncompatablePanel, AssignedElsewhere, CannotPromote]
	for node in panel_nodes:
		node.hide()				
	
	if uid == "":
		return
		
	var researcher_details:Dictionary = RESEARCHER_UTIL.return_data_with_uid(uid)
	var spec_str:String = ""
	var hint_des_str:String = ""
	
	spec_str += str(researcher_details.specialization.details.name, "\r")
	hint_des_str += researcher_details.specialization.details.name
			
	Name.content = researcher_details.name
	CardImage.img_src = researcher_details.img_src
	Level.content = str(researcher_details.level)
	Spec.content = spec_str

	var name_title_str:String = "%s" % [researcher_details.name]
	
	hint_title = "HINT"
	hint_icon = SVGS.TYPE.DRS	
	hint_description = name_title_str
	
	if !can_be_promoted and check_for_promotions:
		for node in panel_nodes:
			if node in [CannotPromote]:
				node.show() 
			else:
				node.hide()
		hint_icon = SVGS.TYPE.STOP
		hint_description = "%s %s" % [name_title_str, "(not eligible for promotion)."]
		return

	if is_already_assigned:
		for node in panel_nodes:
			if node in [AlreadyAssigned]:
				node.show() 
			else:
				node.hide()
		hint_icon = SVGS.TYPE.CHECKBOX
		hint_description = "%s %s" % [name_title_str, "(currently assigned here)."]
		return
	
	if is_incompatable:
		for node in panel_nodes:
			if node in [IncompatablePanel]:
				node.show() 
			else:
				node.hide()
		hint_icon = SVGS.TYPE.STOP
		hint_description = "%s %s" % [name_title_str, "(not compatable)."]
		
		if !spec_required.is_empty():
			hint_icon = SVGS.TYPE.DRS
			hint_description = "%s specialization required." % spec_required.name
			IncompatableLabel.text = "INCOMPATABLE" 
		return
	
	if is_assigned_elsewhere:
		for node in panel_nodes:
			if node in [AssignedElsewhere]:
				node.show() 
			else:
				node.hide()
		hint_icon = SVGS.TYPE.STOP
		hint_description = "%s %s" % [name_title_str, "(assigned to %s)." % [assigned_elsewhere_data.room.details.name]]
		AssignedElsewhereLabel.text = "ASSIGNED to\r%s" % [assigned_elsewhere_data.room.details.shortname]
		return
# --------------------------------------		

# --------------------------------------	
func is_clickable() -> bool:
	if uid == "" or freeze_inputs or is_incompatable or is_already_assigned or (!can_be_promoted and check_for_promotions):
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
