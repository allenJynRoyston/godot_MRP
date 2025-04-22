@tool
extends MouseInteractions

@onready var RootPanel:Control = $SubViewport/PanelContainer
@onready var CardTextureRect:TextureRect = $CardTextureRect
@onready var Front:Control = $SubViewport/PanelContainer/Front
@onready var Back:Control = $SubViewport/PanelContainer/Back

@onready var ProfileImage:TextureRect = $SubViewport/PanelContainer/MarginContainer/TextureRect
@onready var FrontNameLabel:Label = $SubViewport/PanelContainer/Front/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/FrontNameLabel
@onready var BackNameLabel:Label = $SubViewport/PanelContainer/Back/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/BackNameLabel
@onready var CostBtn:BtnBase = $SubViewport/PanelContainer/Front/MarginContainer/VBoxContainer/MarginContainer/CostBtn

@onready var CursorContainer:Control = $CursorContainer
@onready var LockedPanel:Control = $SubViewport/PanelContainer/LockedPanel
@onready var AtMaxPanel:PanelContainer = $SubViewport/PanelContainer/AtMaxPanel
@onready var AlreadyOwned:PanelContainer = $SubViewport/PanelContainer/AlreadyOwned

enum CARD_TYPE {SHOP, SELECTION}

@export var card_type:CARD_TYPE = CARD_TYPE.SELECTION

@export var flipped:bool = false : 
	set(val):
		flipped = val
		on_flipped_update()

@export var is_highlighted:bool = false : 
	set(val):
		is_highlighted = val
		on_is_highlighted_update()

#@export var is_deselected:bool = false : 
	#set(val):
		#is_deselected = val
		#on_is_deselected_update()		

#@export var show_already_unlocked:bool = false : 
	#set(val):
		#show_already_unlocked = val
		#on_show_already_unlocked()
		
@export var ref:int = -1: 
	set(val):
		ref = val
		on_ref_update()
		
const BlackAndWhiteShader:ShaderMaterial = preload("res://Shader/BlackAndWhite/template.tres")

var index:int
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
	CardTextureRect.pivot_offset = self.size/2

	on_focus()
	on_ref_update()
	on_is_highlighted_update()
# --------------------------------------

# --------------------------------------	
func on_is_highlighted_update() -> void:
	if !is_node_ready():return
	CursorContainer.show() if is_highlighted else CursorContainer.hide()
# --------------------------------------		

# --------------------------------------	
func on_flipped_update() -> void:
	if !is_node_ready():return
	if no_animation:
		CardTextureRect.scale.x = 0
	else:
		await U.tween_node_property(CardTextureRect, "scale:x", 0, 0.1)		
		await U.set_timeout(0.2)
		
	Front.hide() if flipped else Front.show()
	Back.show() if flipped else Back.hide()

	#CardTextureRect.material = BlackAndWhiteShader if is_locked else null		
	if no_animation:
		CardTextureRect.scale.x = 1
	else:
		U.tween_node_property(CardTextureRect, "scale:x", 1, 0.1)


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
	FrontNameLabel.text = room_details.shortname
	BackNameLabel.text = room_details.shortname
	
	match card_type:
		CARD_TYPE.SELECTION:
			ROOM_UTIL.at_own_limit(ref)
			AtMaxPanel.show() if max_capacity else AtMaxPanel.hide()
			AlreadyOwned.hide()
			LockedPanel.hide()
			CostBtn.show()
			var cost:int = ROOM_UTIL.return_purchase_cost(ref)
			CostBtn.title = str(cost)
			can_afford = can_afford_check(cost)
		
		CARD_TYPE.SHOP:
			CostBtn.show()
			if !room_details.requires_unlock or room_details.ref in shop_unlock_purchase:
				AlreadyOwned.show()
				LockedPanel.hide()
				CostBtn.hide()
			else:
				AlreadyOwned.hide()
				LockedPanel.show()
				CostBtn.show()
				var cost:int = ROOM_UTIL.return_unlock_costs(ref)
				CostBtn.title = str(cost)
				can_afford = can_afford_check(cost)	
# --------------------------------------		

# --------------------------------------		
func can_afford_check(amount:int) -> bool:
	return resources_data[RESOURCE.CURRENCY.MONEY].amount >= amount
# --------------------------------------			

# --------------------------------------		
func on_can_afford_update() -> void:
	if !is_node_ready():return
	var dupe_stylebox:StyleBoxFlat = RootPanel.get_theme_stylebox('panel').duplicate()
	dupe_stylebox.bg_color = Color.BLACK if can_afford else Color.RED
	RootPanel.add_theme_stylebox_override('panel', dupe_stylebox)	
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
		if can_afford and !max_capacity:
			onClick.call()
	else:
		onDismiss.call()
# --------------------------------------		
