@tool
extends MouseInteractions

@onready var RootPanel:Control = $SubViewport/PanelContainer
@onready var CardTextureRect:TextureRect = $CardTextureRect
@onready var BackNameLabel:Label = $SubViewport/PanelContainer/Back/MarginContainer2/LockPanel/VBoxContainer/PanelContainer/VBoxContainer/BackNameLabel
@onready var NameLabel:Label = $SubViewport/PanelContainer/Front/Header/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/NameLabel
@onready var ProfileImage:TextureRect = $SubViewport/PanelContainer/SubViewport/ProfileImage
@onready var PurchaseList:HBoxContainer = $SubViewport/PanelContainer/Front/Header/VBoxContainer/MarginContainer/PurchaseList
@onready var UnlockList:HBoxContainer = $SubViewport/PanelContainer/Back/MarginContainer2/LockPanel/VBoxContainer/UnlockList
@onready var CursorContainer:Control = $CursorContainer
@onready var UnlockBtn:Control = $SubViewport/PanelContainer/Back/MarginContainer2/LockPanel/VBoxContainer/UnlockBtn
@onready var LockPanel:PanelContainer = $SubViewport/PanelContainer/Back/MarginContainer2/LockPanel
@onready var AtMaxPanel:PanelContainer = $SubViewport/PanelContainer/AtMaxPanel

@onready var Front:Control = $SubViewport/PanelContainer/Front
@onready var Back:Control = $SubViewport/PanelContainer/Back

@export var flip:bool = false : 
	set(val):
		flip = val
		on_flip_update()

@export var is_selected:bool = false : 
	set(val):
		is_selected = val
		on_is_selected_update()
		
@export var is_highlighted:bool = false : 
	set(val):
		is_highlighted = val
		on_is_highlighted_update()

@export var is_deselected:bool = false : 
	set(val):
		is_deselected = val
		on_is_deselected_update()		
		
@export var ref:int = -1: 
	set(val):
		ref = val
		on_ref_update()
		
const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")
const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var index:int
var previous_flip:bool 
var resources_data:Dictionary = {} 
var shop_unlock_purchase:Array = []
var room_config:Dictionary
var no_animation:bool = false

var can_afford:bool = false : 
	set(val):
		can_afford = val
		on_can_afford_update()

var max_capacity:bool = false

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
	
	
	Front.show()
	Back.hide()
	
	CardTextureRect.scale.x = 0
	for child in PurchaseList.get_children():
		child.queue_free()	

	on_focus()
	on_is_selected_update()
	on_is_deselected_update()
	on_ref_update()
# --------------------------------------

# --------------------------------------
func reset() -> void:
	is_highlighted = false
	is_selected = false
# --------------------------------------

# --------------------------------------
func on_is_selected_update() -> void:
	if !is_node_ready():return

# --------------------------------------	

# --------------------------------------	
func on_is_highlighted_update() -> void:
	if !is_node_ready():return
	CursorContainer.show() if is_highlighted else CursorContainer.hide()
	
	var dupe_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
	dupe_stylebox.border_color = Color.WHITE if is_highlighted else Color.BLACK
	RootPanel.add_theme_stylebox_override('panel', dupe_stylebox)	
# --------------------------------------		

# --------------------------------------
func on_is_deselected_update() -> void:
	if !is_node_ready():return
	if !flip:
		CardTextureRect.material = BlackAndWhiteShader if is_deselected else null
# --------------------------------------	

# --------------------------------------	
func on_flip_update() -> void:
	if !is_node_ready():return
	previous_flip = flip
	CardTextureRect.pivot_offset = self.size/2
	if no_animation:
		CardTextureRect.scale.x = 0
	else:
		await U.tween_node_property(CardTextureRect, "scale:x", 0, 0.1)		
		await U.set_timeout(0.2)
		
	Front.hide() if flip else Front.show()
	Back.show() if flip else Back.hide()
	
	if flip:
		AtMaxPanel.hide()
		PurchaseList.hide()		

	CardTextureRect.material = BlackAndWhiteShader if flip else null		
	if no_animation:
		CardTextureRect.scale.x = 1
	else:
		U.tween_node_property(CardTextureRect, "scale:x", 1, 0.1)
	
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty() or ref == -1:return
	await U.tick()
	

	max_capacity = ROOM_UTIL.at_own_limit(ref)

		
	AtMaxPanel.show() if max_capacity else AtMaxPanel.hide()
	PurchaseList.hide() if max_capacity else PurchaseList.show()	

func on_shop_unlock_purchases_update(new_val:Array) -> void:
	shop_unlock_purchase = new_val
	update_content()
	
func on_resources_data_update(new_val:Dictionary) -> void:
	resources_data = new_val
	update_content()

func on_ref_update() -> void:
	modulate = Color(1, 1, 1, 0 if ref == -1 else 1)
	update_content()
# --------------------------------------		

# --------------------------------------		
func update_content() -> void:	
	if !is_node_ready() or resources_data.is_empty() or ref == -1:return
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)

	ProfileImage.texture = CACHE.fetch_image(room_details.img_src)
	NameLabel.text = room_details.shortname
	BackNameLabel.text = room_details.shortname

	if room_details.requires_unlock:
		LockPanel.hide() if room_details.ref in shop_unlock_purchase else LockPanel.show()		
		if room_details.ref not in shop_unlock_purchase:
			build_cost( ROOM_UTIL.return_unlock_costs(ref), false, UnlockList )
		else:
			build_cost( ROOM_UTIL.return_purchase_cost(ref), true, PurchaseList)
	else:
		build_cost( ROOM_UTIL.return_purchase_cost(ref), true, PurchaseList)

	on_room_config_update()
# --------------------------------------		

# --------------------------------------		
func can_afford_check(cost_arr:Array) -> bool:
	for item in cost_arr:				
		if abs(item.amount) > resources_data[item.resource.ref].amount:
			return false
	return true
# --------------------------------------			

# --------------------------------------		
func build_cost(cost_arr:Array, show_free:bool, parent_node:Control) -> void:
	for child in parent_node.get_children():
		child.queue_free()	
	
	can_afford = can_afford_check(cost_arr)	

	for item in cost_arr:
		var new_btn:Control = TextBtnPreload.instantiate()
		new_btn.title = "%s" % [absi(item.amount)]
		new_btn.icon = item.resource.icon
		new_btn.is_disabled = !can_afford
		new_btn.panel_color = Color.BLACK
		parent_node.add_child(new_btn)

	if cost_arr.size() == 0 and show_free:
		var new_btn:Control = TextBtnPreload.instantiate()
		new_btn.title = "FREE"
		new_btn.icon = SVGS.TYPE.MONEY
		parent_node.add_child(new_btn)		
# --------------------------------------		

# --------------------------------------		
func on_can_afford_update() -> void:
	if !is_node_ready():return
	var dupe_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
	dupe_stylebox.bg_color = dupe_stylebox.bg_color if can_afford else Color.RED
	dupe_stylebox.border_color = dupe_stylebox.border_color if can_afford else Color.RED
	RootPanel.add_theme_stylebox_override('panel', dupe_stylebox)	
# --------------------------------------			
	
# --------------------------------------	
func on_focus(state:bool = false) -> void:
	if !is_node_ready():return
	
	if !is_selected:
		var dupe_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
		dupe_stylebox.border_color = Color.BLACK if !state else Color.WHITE
		RootPanel.add_theme_stylebox_override('panel', dupe_stylebox)
		
	if state:
		GBL.change_mouse_icon.call_deferred(GBL.MOUSE_ICON.POINTER)
		onHover.call()
	else:
		GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
# --------------------------------------	

# --------------------------------------	
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if on_hover:
		if can_afford and !max_capacity:
			onClick.call()
	else:
		onDismiss.call()
# --------------------------------------		
