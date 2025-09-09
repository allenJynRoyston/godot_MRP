extends Control

@onready var CardTextureRect:TextureRect = $CardTextureRect
@onready var HighlightControl:Control = $HighlightControl
@onready var NamePanel:PanelContainer = $MarginContainer/FrontDrawerContainer/NamePanel
@onready var CostPanel:PanelContainer = $MarginContainer/FrontDrawerContainer/CostPanel
@onready var HighlightIcon3:Control = $HighlightControl/HighlightIcon3
@onready var NameTagLabel:Label = $MarginContainer/FrontDrawerContainer/NamePanel/MarginContainer/HBoxContainer/NameTag
@onready var CostLabel:Label = $MarginContainer/FrontDrawerContainer/CostPanel/MarginContainer/HBoxContainer/HBoxContainer/CostLabel
@onready var CostIcon:Control = $MarginContainer/FrontDrawerContainer/CostPanel/MarginContainer/HBoxContainer/HBoxContainer/CostIcon
@onready var EmptyPanel:PanelContainer = $EmptyPanel
@onready var PurchaseLabel:Label = $Control/PurchaseLabel

@onready var OwnCountLabel:Label = $MarginContainer/FrontDrawerContainer/CostPanel/MarginContainer/HBoxContainer/HBoxContainer2/OwnCountLabel
@onready var OwnCapacityLabel:Label = $MarginContainer/FrontDrawerContainer/CostPanel/MarginContainer/HBoxContainer/HBoxContainer2/OwnCapacityLabel
@onready var LevelRequired:PanelContainer = $CardTextureRect/LevelRequired

@onready var name_panel_stylebox:StyleBoxFlat = NamePanel.get("theme_override_styles/panel").duplicate()
@onready var cost_panel_stylebox:StyleBoxFlat = CostPanel.get("theme_override_styles/panel").duplicate()

@onready var nametag_label_label_setting:LabelSettings = NameTagLabel.get("label_settings").duplicate()
@onready var own_count_label_setting:LabelSettings = OwnCountLabel.get("label_settings").duplicate()

@export var is_highlighted:bool = false : 
	set(val):
		is_highlighted = val
		on_is_highlighted_update()
		
@export var ref:int = -1: 
	set(val):
		ref = val
		on_ref_update()
		
var index:int
var requires_unlock:bool
var base_states:Dictionary = {}
var resources_data:Dictionary = {} 
var shop_unlock_purchase:Array = []
var room_config:Dictionary = {}

# --------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_base_states(self)
	SUBSCRIBE.subscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.subscribe_to_resources_data(self)
	SUBSCRIBE.subscribe_to_shop_unlock_purchases(self)
	SUBSCRIBE.subscribe_to_room_config(self)

func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_base_states(self)
	SUBSCRIBE.unsubscribe_to_purchased_facility_arr(self)
	SUBSCRIBE.unsubscribe_to_resources_data(self)
	SUBSCRIBE.unsubscribe_to_shop_unlock_purchases(self)	
	SUBSCRIBE.unsubscribe_to_room_config(self)

func _ready() -> void:
	NameTagLabel.set("label_settings", nametag_label_label_setting)
	CostLabel.set("label_settings", nametag_label_label_setting)	
	OwnCountLabel.set("label_settings", own_count_label_setting)
	OwnCapacityLabel.set("label_settings", nametag_label_label_setting)
	NamePanel.set("theme_override_styles/panel", name_panel_stylebox)
	CostPanel.set("theme_override_styles/panel", cost_panel_stylebox)
	
	on_ref_update()
	on_is_highlighted_update()
	PurchaseLabel.modulate.a = 0	
	
func reset() -> void:
	is_highlighted = false
	update_content()	
# --------------------------------------

# --------------------------------------	
func on_is_highlighted_update() -> void:
	if !is_node_ready():return
	for stylebox in [cost_panel_stylebox, name_panel_stylebox]:
		stylebox.bg_color = Color(1.0, 0.749, 0.2, 1) if is_highlighted else Color(1.0, 0.749, 0.2, 1).darkened(0.5)
	nametag_label_label_setting.font_color = Color.WHITE if !is_highlighted else Color.BLACK
	own_count_label_setting.font_color = Color.WHITE if !is_highlighted else Color.BLACK
	
	CostIcon.icon_color = nametag_label_label_setting.font_color
	HighlightControl.show() if is_highlighted else HighlightControl.hide()
	modulate.a = 1
# --------------------------------------		

# --------------------------------------	
func on_base_states_update(new_val:Dictionary) -> void:
	base_states = new_val
	U.debounce( str(self.name, "_update_content"), update_content )
	
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
	update_content()

func play_purchase_animation() -> void:
	PurchaseLabel.modulate.a = 1
	U.tween_node_property(PurchaseLabel, "modulate:a", 0, 0.3)
	await U.tween_node_property(PurchaseLabel, "position:y", -10, 0.3, 0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	PurchaseLabel.position.y = 0
# --------------------------------------		

# --------------------------------------		
func update_content() -> void:	
	if !is_node_ready() or resources_data.is_empty() or room_config.is_empty():return
	
	if ref == -1:
		EmptyPanel.show()
		return
	
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)	
	var room_unlock_val:int = room_config.base.room_unlock_val
	var own_count:int = 0
	
	EmptyPanel.hide()
	
	NameTagLabel.text = room_details.name
	CardTextureRect.texture = CACHE.fetch_image(room_details.img_src) 
	CostLabel.text = str(room_details.costs.purchase) # str(room_details.costs.unlock) if room_details.costs.unlock > 0 else "FREE"
	
	if ref in base_states.department_cards:
		own_count = base_states.department_cards[ref]
	if ref in base_states.utility_cards:
		own_count = base_states.utility_cards[ref]
		

	HighlightIcon3.hide() if own_count == 0 else HighlightIcon3.show()
	

	# -------------------- LEVEL REQUIRED
	if room_details.requires_unlock and (room_details.ref not in shop_unlock_purchase): #and and room_details.unlock_level > room_unlock_val:
		LevelRequired.show()
		NameTagLabel.text = '?'
		CardTextureRect.texture = null
		LevelRequired.title = "RESEARCH TO UNLOCK"
		OwnCountLabel.text = "-"
		CostIcon.icon = SVGS.TYPE.RESEARCH
		requires_unlock = true
	else:
		LevelRequired.hide()
		OwnCountLabel.text = str(own_count)
		OwnCapacityLabel.text = str("/", room_details.own_limit)
		CostIcon.icon = SVGS.TYPE.RING
		requires_unlock = false
