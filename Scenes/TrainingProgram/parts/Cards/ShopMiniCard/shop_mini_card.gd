@tool
extends MouseInteractions

@onready var RootPanel:Control = $"."
@onready var CardTextureRect:TextureRect = $CardTextureRect
@onready var NameLabel:Label = $SubViewport/InfoContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/NameLabel
@onready var ProfileImage:TextureRect = $SubViewport/ProfileImage
@onready var Checkbox:BtnBase = $SubViewport/InfoContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/CheckBox
@onready var PurchaseList:HBoxContainer = $SubViewport/InfoContainer/VBoxContainer/MarginContainer/PurchaseList
@onready var IconBtn:BtnBase = $Control/PanelContainer/IconBtn
@onready var LockPanel:PanelContainer = $SubViewport/LockPanel
@onready var AtMaxPanel:PanelContainer = $SubViewport/AtMaxPanel


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
var resources_data:Dictionary = {} 
var shop_unlock_purchase:Array = []
var room_config:Dictionary

var can_afford:bool = false : 
	set(val):
		can_afford = val
		on_can_afford_update()

var max_capacity:bool = false

var onClick:Callable = func():pass
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

	for child in PurchaseList.get_children():
		child.queue_free()	

	on_focus()
	on_is_selected_update()
	on_is_deselected_update()
	on_ref_update()
	
# --------------------------------------

# --------------------------------------
func on_is_selected_update() -> void:
	if !is_node_ready():return
	Checkbox.is_checked = is_selected
# --------------------------------------	

# --------------------------------------	
func on_is_highlighted_update() -> void:
	if !is_node_ready():return
	IconBtn.show() if is_highlighted else IconBtn.hide()
	
	var dupe_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
	dupe_stylebox.border_color = Color.WHITE if is_highlighted else Color.BLACK
	RootPanel.add_theme_stylebox_override('panel', dupe_stylebox)	
# --------------------------------------		

# --------------------------------------
func on_is_deselected_update() -> void:
	if !is_node_ready():return
	CardTextureRect.material = BlackAndWhiteShader if is_deselected else null
# --------------------------------------	

# --------------------------------------	
# --------------------------------------		
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	room_config = new_val
	if !is_node_ready() or room_config.is_empty() or ref == -1:return
	max_capacity = ROOM_UTIL.at_own_limit(ref)
	AtMaxPanel.show() if max_capacity else AtMaxPanel.hide()

func on_shop_unlock_purchases_update(new_val:Array) -> void:
	shop_unlock_purchase = new_val
	update_content()
	
func on_resources_data_update(new_val:Dictionary) -> void:
	resources_data = new_val
	update_content()

func on_ref_update() -> void:
	update_content()
	
# --------------------------------------		

# --------------------------------------		
func update_content() -> void:	
	if !is_node_ready() or resources_data.is_empty() or ref == -1:return
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)

	ProfileImage.texture = CACHE.fetch_image(room_details.img_src)
	NameLabel.text = room_details.name

	if room_details.requires_unlock:
		LockPanel.hide() if room_details.ref in shop_unlock_purchase else LockPanel.show()		
		if room_details.ref not in shop_unlock_purchase:
			build_cost( ROOM_UTIL.return_unlock_costs(ref) )
		else:
			build_cost( ROOM_UTIL.return_purchase_cost(ref), true )
	else:
		LockPanel.hide()
		build_cost( ROOM_UTIL.return_purchase_cost(ref), true)
	
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
func build_cost(cost_arr:Array, show_free:bool = false) -> void:
	for child in PurchaseList.get_children():
		child.queue_free()	
	
	can_afford = can_afford_check(cost_arr)	

	for item in cost_arr:
		var new_btn:Control = TextBtnPreload.instantiate()
		new_btn.title = "%s" % [absi(item.amount)]
		new_btn.icon = item.resource.icon
		new_btn.is_disabled = !can_afford
		new_btn.panel_color = Color.BLACK
		PurchaseList.add_child(new_btn)

	if cost_arr.size() == 0 and show_free:
		var new_btn:Control = TextBtnPreload.instantiate()
		new_btn.title = "FREE"
		new_btn.icon = SVGS.TYPE.MONEY
		PurchaseList.add_child(new_btn)		
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
