extends Control

@onready var BtnControlPanel:PanelContainer = $BtnControlPanel
@onready var BtnMarginContainer:MarginContainer = $BtnControlPanel/BtnMarginContainer
@onready var ABtn:BtnBase = $BtnControlPanel/BtnMarginContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/ABtn
@onready var BBtn:BtnBase = $BtnControlPanel/BtnMarginContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BBtn

@export var reset_to_last:bool = false
@export var offset:Vector2 = Vector2(2, 5)

var control_pos:Dictionary
var control_pos_default:Dictionary
var freeze_inputs:bool = false
var directional_pref:String = "LR"

var item_index:int = -1 : 
	set(val):
		item_index = val
		on_item_index_update()

var itemlist:Array = [] : 
	set(val):
		itemlist = val
		on_itemlist_update()

var is_revealed:bool = false : 
	set(val):
		is_revealed = val
		reveal(val)
		
var onBack:Callable = func() -> void:pass
var onAction:Callable = func() -> void:pass
var onDirectional:Callable = func(key:String) -> void:pass

# --------------------------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)
	GBL.subscribe_to_fullscreen(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)
	GBL.unsubscribe_to_fullscreen(self)

func _ready() -> void:
	on_fullscreen_update()
	
	ABtn.onClick = func() -> void:
		if !is_node_ready() or itemlist.is_empty():return
		var node:Control = itemlist[item_index]
		if "is_disabled" in node and node.is_disabled:
			return
		
		if "onClick" in node:
			node.onClick.call()
			
		onAction.call()	
	
	BBtn.onClick = func() -> void:
		onBack.call()
				
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
func on_fullscreen_update(_is_fullscreen:bool = GBL.is_fullscreen) -> void:
	await U.tick()
	control_pos_default[BtnControlPanel] = BtnControlPanel.position	
	update_control_pos()
	
func update_control_pos() -> void:	
	await U.tick()

	control_pos[BtnControlPanel] = {
		"show": control_pos_default[BtnControlPanel].y, 
		"hide": control_pos_default[BtnControlPanel].y + BtnMarginContainer.size.y
	}
	
	BtnControlPanel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	reveal(is_revealed, true)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal(state:bool = is_revealed, skip_animation:bool = false) -> void:
	if control_pos.is_empty():return
	
	if !state:
		freeze_and_disable(true)
			
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show if state else control_pos[BtnControlPanel].hide, 0 if skip_animation else 0.2)
	
	if state:
		freeze_and_disable(false)
		
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func freeze_and_disable(state:bool) -> void:
	freeze_inputs = state
	for btn in [ABtn, BBtn]:
		btn.is_disabled = state	
	if !state:
		on_item_index_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_itemlist_update() -> void:
	if !is_node_ready() or itemlist.is_empty():return
	await U.tick()
	item_index = itemlist.size() - 1 if reset_to_last else 0

func add_to_itemlist(list:Array) -> void:
	for node in list:
		if node not in itemlist:
			itemlist.push_back(node)
	
func remove_from_itemlist(list:Array) -> void:
	for node in list:
		if node in itemlist:
			itemlist.erase(node)
	item_index = 0
	
func clear_itemlist() -> void: 
	itemlist = []
	item_index = -1
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_item_index_update() -> void:	
	if !is_node_ready() or itemlist.is_empty():return
	var node:Control = itemlist[item_index]
	Input.warp_mouse(node.global_position + offset)
# --------------------------------------------------------------------------------------------------
	
# ------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs: 
		return

	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	onDirectional.call(key)
	
	if directional_pref == "LR":
		match key:
			"A":
				item_index = U.min_max(item_index - 1, 0, itemlist.size() - 1)
			"D":
				item_index = U.min_max(item_index + 1, 0, itemlist.size() - 1)
			
	if directional_pref == "UD":
		match key:
			"W":
				item_index = U.min_max(item_index - 1, 0, itemlist.size() - 1)
			"S":
				item_index = U.min_max(item_index + 1, 0, itemlist.size() - 1)		
# ------------------------------------------	
