extends Control

@onready var BtnControlPanel:PanelContainer = $BtnControlPanel
@onready var BtnMarginContainer:MarginContainer = $BtnControlPanel/BtnMarginContainer
@onready var ABtn:BtnBase = $BtnControlPanel/BtnMarginContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/ABtn
@onready var BBtn:BtnBase = $BtnControlPanel/BtnMarginContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BBtn

var control_pos:Dictionary
var control_pos_default:Dictionary
var freeze_inputs:bool = false

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
		


# --------------------------------------------------------------------------------------------------
func _init() -> void:
	GBL.register_node(REFS.BTN_CONTROLS, self)
	GBL.subscribe_to_control_input(self)
	GBL.subscribe_to_fullscreen(self)

func _exit_tree() -> void:
	GBL.unregister_node(REFS.BTN_CONTROLS)
	GBL.unsubscribe_to_control_input(self)
	GBL.unsubscribe_to_fullscreen(self)

func _ready() -> void:
	on_fullscreen_update()
	
	ABtn.onClick = func() -> void:
		if !is_node_ready() or itemlist.is_empty():return
		var node:Control = itemlist[item_index]
		if "onClick" in node:
			node.onClick.call()
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
	U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show if state else control_pos[BtnControlPanel].hide, 0 if skip_animation else 0.3)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_itemlist_update() -> void:
	if !is_node_ready() or itemlist.is_empty():return
	item_index = 0
	for index in itemlist.size():
		var node:Control = itemlist[index]
		if "onFocus" in node:
			node.onFocus = func(_node:Control) -> void:
				if _node == node:
					item_index = index

func add_to_itemlist(list:Array) -> void:
	for node in list:
		itemlist.push_back(node)
	
func remove_from_itemlist(list:Array) -> void:
	for node in list:
		itemlist.erase(node)
# --------------------------------------------------------------------------------------------------



# --------------------------------------------------------------------------------------------------
func on_item_index_update() -> void:	
	if !is_node_ready() or itemlist.is_empty():return
	var node:Control = itemlist[item_index]
		
	Input.warp_mouse(node.global_position + Vector2(node.size.x/2, 10))
# --------------------------------------------------------------------------------------------------
	

# ------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs: 
		return

	var key:String = input_data.key
	var keycode:int = input_data.keycode
	
	match key:
		"A":
			item_index = U.min_max(item_index - 1, 0, itemlist.size() - 1)
		"D":
			item_index = U.min_max(item_index + 1, 0, itemlist.size() - 1)
# ------------------------------------------	
