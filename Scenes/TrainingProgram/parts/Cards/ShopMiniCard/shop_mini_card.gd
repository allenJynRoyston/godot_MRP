@tool
extends MouseInteractions

@onready var CardBody:Control = $SubViewport/CardBody
@onready var CardTitle:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage/CardDrawerTitle
@onready var CardResource:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerResource
@onready var CardDrawerImage:Control = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage

@onready var AlreadyResearched:PanelContainer = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage/AlreadyResearched
@onready var LevelRequired:PanelContainer = $SubViewport/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardDrawerImage/LevelRequired

@export var flip:bool = false : 
	set(val):
		flip = val
		on_flip_update()

@export var is_highlighted:bool = false : 
	set(val):
		is_highlighted = val
		on_is_highlighted_update()
		
@export var ref:int = -1: 
	set(val):
		ref = val
		on_ref_update()
		
const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")

var index:int
var resources_data:Dictionary = {} 
var shop_unlock_purchase:Array = []
var room_config:Dictionary = {}

var border_color:Color
var is_clickable:bool = false
var show_card:bool = true

var onClick:Callable = func():pass
var onHover:Callable = func():pass
var onDismiss:Callable = func():pass

# --------------------------------------
func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_shop_unlock_purchases(self)
	SUBSCRIBE.subscribe_to_room_config(self)

func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_shop_unlock_purchases(self)	
	SUBSCRIBE.unsubscribe_to_room_config(self)

func _ready() -> void:
	super._ready()
	
	on_focus()
	on_ref_update()
	on_is_highlighted_update()

func reset() -> void:
	is_highlighted = false
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
	
func on_shop_unlock_purchases_update(new_val:Array) -> void:
	shop_unlock_purchase = new_val
	U.debounce( str(self.name, "_update_content"), update_content )
	
func on_resources_data_update(new_val:Dictionary) -> void:
	resources_data = new_val
	U.debounce( str(self.name, "_update_content"), update_content )

func on_room_config_update(new_val:Dictionary) -> void:
	room_config = new_val
	U.debounce( str(self.name, "_update_content"), update_content )

func on_ref_update() -> void:
	if !is_node_ready():return
	CardBody.instant_flip(ref == -1)
	update_content()
# --------------------------------------		

# --------------------------------------		
func update_content() -> void:	
	if !is_node_ready() or resources_data.is_empty() or room_config.is_empty() or ref == -1:return
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)
	var panel_nodes:Array = [AlreadyResearched, LevelRequired]
	var room_unlock_val:int = room_config.base.room_unlock_val
	
	for node in panel_nodes:
		node.hide()
	
	CardTitle.content = room_details.name
	CardDrawerImage.img_src = room_details.img_src
	is_clickable = true
	show_card = true
	
	# -------------------- ALREADY PURCHASED
	if !room_details.requires_unlock or room_details.ref in shop_unlock_purchase:
		for node in panel_nodes:
			if node in [AlreadyResearched]:
				node.show() 
			else:
				node.hide()

		is_clickable = false
		
		hint_title = room_details.name
		hint_icon = SVGS.TYPE.BUILD
		hint_description = room_details.description
		return
	
	# -------------------- LEVEL REQUIRED
	if room_details.ref not in shop_unlock_purchase and room_details.unlock_level > room_unlock_val:
		for node in panel_nodes:
			if node in [LevelRequired]:
				node.show() 
			else:
				node.hide()

		CardTitle.content = '???'
		CardDrawerImage.img_src = ""
		show_card = false

		is_clickable = false
		LevelRequired.title = "LEVEL %s REQUIRED" % [room_details.unlock_level]
		hint_title = "???"
		hint_icon = SVGS.TYPE.QUESTION_MARK
		hint_description = "Prerequisite not met."
		return		
	
	# -------------------- PURCHASABLE
	hint_title = room_details.name
	hint_icon = SVGS.TYPE.BUILD
	hint_description = room_details.description		
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
		#onClick.call()
	else:
		onDismiss.call()
# --------------------------------------		
