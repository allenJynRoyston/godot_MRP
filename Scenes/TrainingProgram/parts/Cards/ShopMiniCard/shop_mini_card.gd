extends Control

@onready var CardTextureRect:TextureRect = $CardTextureRect
@onready var HighlightControl:Control = $HighlightControl
@onready var NamePanel:PanelContainer = $MarginContainer/FrontDrawerContainer/NamePanel
@onready var CostPanel:PanelContainer = $MarginContainer/FrontDrawerContainer/CostPanel

@onready var HighlightIcon1:Control = $HighlightControl/HighlightIcon1
@onready var HighlightIcon2:Control = $HighlightControl/HighlightIcon2
@onready var HighlightIcon3:Control = $HighlightControl/HighlightIcon3
@onready var HighlightIcon4:Control = $HighlightControl/HighlightIcon4

@onready var NameTagLabel:Label = $MarginContainer/FrontDrawerContainer/NamePanel/MarginContainer/HBoxContainer/NameTag
@onready var CostLabel:Label = $MarginContainer/FrontDrawerContainer/CostPanel/MarginContainer/HBoxContainer/HBoxContainer/CostLabel
@onready var CostIcon:Control = $MarginContainer/FrontDrawerContainer/CostPanel/MarginContainer/HBoxContainer/HBoxContainer/CostIcon
@onready var EmptyPanel:PanelContainer = $EmptyPanel
@onready var PurchaseLabel:Label = $Control/PurchaseLabel

@onready var OwnHBox:HBoxContainer = $MarginContainer/FrontDrawerContainer/CostPanel/MarginContainer/HBoxContainer/OwnHBox
@onready var OwnCountLabel:Label = $MarginContainer/FrontDrawerContainer/CostPanel/MarginContainer/HBoxContainer/OwnHBox/OwnCountLabel
@onready var OwnCapacityLabel:Label = $MarginContainer/FrontDrawerContainer/CostPanel/MarginContainer/HBoxContainer/OwnHBox/OwnCapacityLabel
@onready var LevelRequired:PanelContainer = $CardTextureRect/LevelRequired

@onready var name_panel_stylebox:StyleBoxFlat = NamePanel.get("theme_override_styles/panel").duplicate()
@onready var cost_panel_stylebox:StyleBoxFlat = CostPanel.get("theme_override_styles/panel").duplicate()

@onready var nametag_label_label_setting:LabelSettings = NameTagLabel.get("label_settings").duplicate()
@onready var own_count_label_setting:LabelSettings = OwnCountLabel.get("label_settings").duplicate()
@onready var cost_label_setting:LabelSettings = CostLabel.get("label_settings").duplicate()

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
	CostLabel.set("label_settings", cost_label_setting)	
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
	if !is_node_ready() or ref == -1:return
	var cost:int = ROOM_UTIL.return_unlock_costs(ref) if requires_unlock else ROOM_UTIL.return_purchase_cost(ref)	
	var can_afford:bool = resources_data[RESOURCE.CURRENCY.SCIENCE if requires_unlock else RESOURCE.CURRENCY.MATERIAL].amount >= abs(cost)
		
	for stylebox in [cost_panel_stylebox, name_panel_stylebox]:
		stylebox.bg_color = Color(1.0, 0.8, 0.2, 1) if !requires_unlock else Color.DARK_GRAY
		stylebox.bg_color.a = 0.8 if !is_highlighted else 1
	nametag_label_label_setting.font_color = Color.DARK_SLATE_GRAY if !is_highlighted else Color.BLACK if can_afford else Color.DARK_RED
	own_count_label_setting.font_color = Color.DARK_SLATE_GRAY if !is_highlighted else Color.BLACK if can_afford else Color.DARK_RED
	cost_label_setting.font_color = own_count_label_setting.font_color if can_afford else Color.DARK_RED

	CostIcon.icon_color = cost_label_setting.font_color	
	LevelRequired.use_color = Color.WHITE if can_afford else Color.DARK_RED
		
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
	var cost:int = ROOM_UTIL.return_unlock_costs(room_details.ref) if requires_unlock else ROOM_UTIL.return_purchase_cost(room_details.ref)	
	var room_unlock_val:int = room_config.base.room_unlock_val
	var own_count:int = 0
	
	EmptyPanel.hide()
	
	CardTextureRect.texture = CACHE.fetch_image(room_details.img_src) 
	CostLabel.text = str(cost) 
	
	if ref in base_states.department_cards:
		own_count = base_states.department_cards[ref]
	if ref in base_states.utility_cards:
		own_count = base_states.utility_cards[ref]
		
	LevelRequired.icon = SVGS.TYPE.NONE

	# -------------------- LEVEL REQUIRED
	if room_details.requires_unlock and (room_details.ref not in shop_unlock_purchase): #and and room_details.unlock_level > room_unlock_val:
		LevelRequired.show()
		OwnHBox.hide()
		HighlightIcon3.hide()
		for node in [HighlightIcon1, HighlightIcon2, HighlightIcon3, HighlightIcon4]:
			node.icon_color = Color.BLACK
		
		NameTagLabel.text = room_details.shortname
		CardTextureRect.texture = null
		LevelRequired.title = ""
		LevelRequired.icon = SVGS.TYPE.LOCK
		OwnCountLabel.text = "-"
		CostIcon.icon = SVGS.TYPE.RESEARCH
		requires_unlock = true
	else:
		NameTagLabel.text = room_details.shortname
		LevelRequired.hide()
		OwnHBox.show()
		HighlightIcon3.show()
		for node in [HighlightIcon1, HighlightIcon2, HighlightIcon3, HighlightIcon4]:
			node.icon_color = Color.BLACK
					
		OwnCountLabel.text = str(own_count)
		OwnCapacityLabel.text = str("/", room_details.own_limit)
		CostIcon.icon = SVGS.TYPE.RING
		requires_unlock = false
