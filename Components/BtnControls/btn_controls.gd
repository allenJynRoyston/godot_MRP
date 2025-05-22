extends Control

@onready var BtnControlPanel:PanelContainer = $BtnControlPanel
@onready var BtnMarginContainer:MarginContainer = $BtnControlPanel/BtnMarginContainer
@onready var ABtn:BtnBase = $BtnControlPanel/BtnMarginContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/ABtn
@onready var BBtn:BtnBase = $BtnControlPanel/BtnMarginContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList/BBtn
@onready var CBtn:BtnBase = $BtnControlPanel/BtnMarginContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/CBtn

@onready var HintContainer:Control = $BtnControlPanel/BtnMarginContainer/Control/CenterContainer/HintContainer
@onready var HintTitle:Label = $BtnControlPanel/BtnMarginContainer/Control/CenterContainer/HintContainer/MarginContainer/VBoxContainer/HintTitle
@onready var HintDescription:Label = $BtnControlPanel/BtnMarginContainer/Control/CenterContainer/HintContainer/MarginContainer/VBoxContainer/HBoxContainer/HintDescription
@onready var HintIcon:Control = $BtnControlPanel/BtnMarginContainer/Control/CenterContainer/HintContainer/MarginContainer/VBoxContainer/HBoxContainer/HintIcon

@export_category("OPTIONS")
@export var reset_to_last:bool = false
@export var offset:Vector2 = Vector2(2, 5)

@export_category("A BUTTON")
@export var a_btn_title:String = "NEXT" : 
	set(val):
		a_btn_title = val
		on_a_btn_title_update()
@export var a_btn_icon:SVGS.TYPE = SVGS.TYPE.NEXT : 
	set(val):
		a_btn_icon = val
		on_a_btn_icon_update()
@export var hide_a_btn:bool = false : 
	set(val):
		hide_a_btn = val
		on_hide_a_btn_update()
@export var intercept_click_event:bool  = false 
		

@export_category("B BUTTON")
@export var b_btn_title:String = "BACK" : 
	set(val):
		b_btn_title = val
		on_b_btn_title_update()
@export var b_btn_icon:SVGS.TYPE = SVGS.TYPE.BACK : 
	set(val):
		b_btn_icon = val
		on_b_btn_icon_update()		
@export var hide_b_btn:bool = false : 
	set(val): 
		hide_b_btn = val
		on_hide_b_btn_update()
		
		
@export_category("C BUTTON")
@export var c_btn_title:String = "INFO" : 
	set(val):
		c_btn_title = val
		on_c_btn_title_update()
@export var c_btn_icon:SVGS.TYPE = SVGS.TYPE.INFO : 
	set(val):
		c_btn_icon = val
		on_c_btn_icon_update()		
@export var hide_c_btn:bool = true : 
	set(val): 
		hide_c_btn = val
		on_hide_c_btn_update()		

var control_pos:Dictionary
var control_pos_default:Dictionary
var freeze_inputs:bool = false
var directional_pref:String = "LR"

var disabled_state:Dictionary = {}

var item_index:int = -1 : 
	set(val):
		item_index = val
		on_item_index_update()

var itemlist:Array = [] : 
	set(val):
		itemlist = val
		on_itemlist_update()

var is_revealed:bool = false 

var disable_active_btn:bool = false : 
	set(val):
		disable_active_btn = val
		on_disable_active_btn_update()
		
var disable_back_btn:bool = false : 
	set(val):
		disable_back_btn = val
		on_disable_back_btn_update()

var disable_c_btn:bool = false : 
	set(val):
		disable_c_btn = val
		on_disable_c_btn_update()
	
var onBack:Callable = func() -> void:pass
var onAction:Callable = func() -> void:pass
var onCBtn:Callable = func() -> void:pass
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
	on_disable_active_btn_update()
	
	on_a_btn_title_update()
	on_b_btn_title_update()
	on_c_btn_title_update()
	
	on_a_btn_icon_update()
	on_b_btn_icon_update()
	on_c_btn_icon_update()
	
	on_hide_a_btn_update()
	on_hide_b_btn_update()
	on_hide_c_btn_update()
	
	HintContainer.hide()
	
	ABtn.onClick = func() -> void:
		if !is_node_ready():return
		
		if !itemlist.is_empty():
			var node:Control = itemlist[item_index]
			
			if "is_disabled" in node and node.is_disabled:
				return
			
			if "onClick" in node:
				node.onClick.call()
					
		onAction.call()	
					
	
	CBtn.onClick = func() -> void:
		if !is_node_ready():return
		onCBtn.call()
	
	BBtn.onClick = func() -> void:
		if !is_node_ready():return
		onBack.call()

	disabled_state = {
		ABtn: false,
		BBtn: false,
		CBtn: false
	}
	
	update_control_pos()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_a_btn_title_update() -> void:
	if !is_node_ready():return
	ABtn.title = str(a_btn_title)
	
func on_b_btn_title_update() -> void:
	if !is_node_ready():return
	BBtn.title = str(b_btn_title)	

func on_c_btn_title_update() -> void:
	if !is_node_ready():return
	CBtn.title = str(c_btn_title)	
	
func on_a_btn_icon_update() -> void:
	if !is_node_ready():return
	ABtn.icon = a_btn_icon
	
func on_b_btn_icon_update() -> void:
	if !is_node_ready():return
	BBtn.icon = b_btn_icon	

func on_c_btn_icon_update() -> void:
	if !is_node_ready():return
	CBtn.icon = c_btn_icon		

func on_disable_active_btn_update() -> void:
	disabled_state[ABtn] = disable_active_btn
	if is_revealed:
		ABtn.is_disabled = disable_active_btn

func on_disable_back_btn_update() -> void:
	disabled_state[BBtn] = disable_back_btn
	if is_revealed:
		BBtn.is_disabled = disable_back_btn
		
func on_disable_c_btn_update() -> void:
	disabled_state[CBtn] = disable_c_btn
	if is_revealed:
		CBtn.is_disabled = disable_c_btn		

func on_hide_a_btn_update() -> void:
	if !is_node_ready():return
	ABtn.hide() if hide_a_btn else ABtn.show()

func on_hide_b_btn_update() -> void:
	if !is_node_ready():return
	BBtn.hide() if hide_b_btn else BBtn.show()	

func on_hide_c_btn_update() -> void:
	if !is_node_ready():return
	CBtn.hide() if hide_c_btn else CBtn.show()		
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
	var duration:float = 0 if skip_animation else 0.3
	is_revealed = state
	
	if !state:
		freeze_and_disable(true)
			
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show if state else control_pos[BtnControlPanel].hide, duration)
	
	if state:
		freeze_and_disable(false)
	
	if !state:
		HintContainer.hide()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func freeze_and_disable(state:bool) -> void:
	freeze_inputs = state
	for btn in [ABtn, BBtn, CBtn]:
		btn.is_disabled = disabled_state[btn] if !state else state
	if !state:
		restore_last_index()
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
	HintContainer.hide()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func restore_last_index() -> void:
	on_item_index_update()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_item_index_update() -> void:	
	# prevents it from warping all over the place
	if !is_node_ready() or itemlist.is_empty() or !is_visible_in_tree() or !is_revealed:return
	var node:Control = itemlist[item_index]
	if "get_hint" in node and !node.get_hint().is_empty():
		var hint:Dictionary = node.get_hint()
		if hint.title == "" and hint.description == "":
			HintContainer.hide()
		else:
			HintIcon.icon = hint.icon
			HintTitle.text = hint.title
			HintDescription.text = hint.description
			await U.tick()
			HintContainer.show()			
	else:
		HintContainer.hide()

	Input.warp_mouse(node.global_position + offset)
# --------------------------------------------------------------------------------------------------
	
# ------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs: 
		return

	var key:String = input_data.key
	
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
