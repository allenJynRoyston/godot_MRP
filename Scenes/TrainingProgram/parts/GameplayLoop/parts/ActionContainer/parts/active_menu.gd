extends Control

@onready var BtnControls:Control = $BtnControls

@onready var CardBody:Control = $MenuControl/PanelContainer/MarginContainer/CardBody
@onready var CardControlBody:PanelContainer = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody
@onready var CardBodySubviewport:SubViewport = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport
@onready var EmptyList:PanelContainer = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/EmptyList

@onready var MenuPanel:PanelContainer = $MenuControl/PanelContainer
@onready var MenuMargin:MarginContainer = $MenuControl/PanelContainer/MarginContainer

@onready var PaginationContainer:HBoxContainer = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/PaginationContainer
@onready var CategoryLabel:Label = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/PaginationContainer/CategoryLabel
@onready var PrevIcon:Control = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/PaginationContainer/PrevIcon
@onready var NextIcon:Control = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/PaginationContainer/NextIcon
@onready var Footerlabel:Label = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/FooterLabel
@onready var List:VBoxContainer = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/List

const MenuBtnPreload:PackedScene = preload("res://UI/Buttons/ItemBtn/ItemBtn.tscn")

var list_size:int = 5

var tab_index:int = 0 : 
	set(val):
		tab_index = val
		on_tab_index_update()

var selected_index:int = 0 : 
	set(val):
		selected_index = val
		on_selected_index_update()

var use_color:Color = Color.GREEN : 
	set(val):
		use_color = val
		on_use_color_update()
			
var options_list:Array = [] : 
	set(val):
		options_list = val
		on_options_list_update()

var freeze_inputs:bool = true : 
	set(val):
		freeze_inputs = val
		
var disable_active_btn:bool = false : 
	set(val):
		disable_active_btn = val
		on_disable_active_btn_update()

var retain_height:bool = true
var render_table:Dictionary
var lookup_index:int = 0
var render_on_right:bool = false

var control_pos_default:Dictionary
var control_pos:Dictionary

var wait_for_release:bool = false
var allow_shortcut:bool = false
var stored_size:Vector2 

var onBeforeAction:Callable = func(_item:Dictionary):pass
var onAfterAction:Callable = func(_item:Dictionary):pass
var onUpdate:Callable = func(_item:Dictionary):pass

var onBeforeClose:Callable = func():pass
var onClose:Callable = func():pass
var onAction:Callable = func():pass

var SelectedNode:Control

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.register_node(REFS.ACTIVE_MENU, self)
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unregister_node(REFS.ACTIVE_MENU)	
	GBL.unsubscribe_to_control_input(self)
	GBL.direct_ref.erase("ActiveMenu")
	
func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	BtnControls.reveal(false, true)
	#CardBody.reveal = false
	GBL.direct_ref["ActiveMenu"] = CardBody

	BtnControls.onDirectional = on_key_press
	
	BtnControls.onAction = func() -> void:		
		if !SelectedNode.is_disabled and !freeze_inputs:
			freeze_inputs = true
			await on_action()
			# delay stops user from hitting same button and calling the action multiple times, like
			# opening a modal multiple times
			# BUG: DONT CHANGE 0.4 VALUE - prevents a huge bug I can't seem to figure out...
			await U.set_timeout(0.4)
			freeze_inputs = false
		
	BtnControls.onBack = func() -> void:
		close()		
	
	BtnControls.onUpdate = func(node:Control) -> void:
		BtnControls.offset = CardBody.global_position + Vector2(10, 15)
		selected_index = node.index
		for index in List.get_child_count():
			var btn:Control = List.get_child(index)
			btn.is_selected = btn == node
			if btn == node:
				SelectedNode = node
				onUpdate.call(options_list[tab_index].items[index])	
				
				
	
	BtnControls.directional_pref = "UD"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func activate(new_list_size:int = 4) -> void:
	await U.tick()
	var duration:float = 0
	
	control_pos_default[MenuPanel] = MenuPanel.position
	list_size = new_list_size
	
	List.custom_minimum_size.y = list_size * 50

	await U.tick()
	if render_on_right:
		control_pos[MenuPanel] = {
			"show": GBL.game_resolution.x - MenuMargin.size.x, 
			"hide": GBL.game_resolution.x + (MenuMargin.size.x * 2)
		}
	else:
		control_pos[MenuPanel] = {
			"show": 0, 
			"hide": -MenuMargin.size.x
		}

	MenuPanel.position.x = control_pos[MenuPanel].hide
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func open(has_cost_panel:bool = false) -> void:
	modulate = Color(1, 1, 1, 1)
	on_tab_index_update()
	animate_in(true)
	selected_index = 0
	freeze_inputs = false
	
func close() -> void:
	freeze_inputs = true
	BtnControls.reveal(false)
	onBeforeClose.call()
	await animate_in(false)
	onClose.call()	
	queue_free()

func lock() -> void:
	await BtnControls.reveal(false)

func unlock() -> void:
	await BtnControls.reveal(true)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func animate_in(state:bool, duration:float = 0.3) -> void:
	#CardBody.reveal = state
	U.tween_node_property(MenuPanel, "position:x", control_pos[MenuPanel].show if state else control_pos[MenuPanel].hide, duration)
	await BtnControls.reveal(state)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func clear_list() -> void:
	for node in [List]:
		for child in node.get_children():
			child.queue_free()

func on_disable_active_btn_update() -> void:
	if !is_node_ready():return
	BtnControls.disable_active_btn = disable_active_btn

func update_checkbox_option(index:int, is_checked:bool) -> void:
	var btn_node:Control = List.get_child(index) 
	btn_node.is_checked = is_checked
	
func on_selected_index_update() -> void:
	if !is_node_ready() or List.get_child_count() == 0:return
	check_list_limit()	

func on_tab_index_update() -> void:
	if !is_node_ready():return
	on_options_list_update()

	render_table = {}
	var count:int = 0
	for index in range(ceili(options_list[tab_index].items.size() / list_size) + 1):
		render_table[index] = []
		for n in range(count, count + list_size):
			render_table[index].append(n)
			count += 1

	await U.tick()
	check_list_limit()	
	CardControlBody.size = Vector2(1, 1)
	CardBodySubviewport.size = CardControlBody.size
		


func on_options_list_update() -> void:
	if !is_node_ready():return	
	wait_for_release = true
	clear_list()
	
	# ---- IF EMPTY
	if options_list.is_empty():
		var btn_node:Control = MenuBtnPreload.instantiate()
		#btn_node.title = "NO LVL %s ACTIONS AVAILABLE" % [level + 1]
		btn_node.btn_color = use_color
		btn_node.is_empty = true
		#btn_node.is_hollow = true
		
		List.add_child(btn_node)		
		return
	
	PaginationContainer.show()# if options_list.size() > 1 else PaginationContainer.hide()
	for icon in [PrevIcon, NextIcon]:
		if options_list.size() > 1:
			icon.show() 
		else:
			icon.hide()
	
	if options_list.size() > 1:
		PrevIcon.icon_color.a = 0.2 if tab_index == 0 else 1
		NextIcon.icon_color.a = 0.2 if tab_index == options_list.size() - 1 else 1
	
	CategoryLabel.text = str(options_list[tab_index].title) if "title" in options_list[tab_index] else ""

	# if empty...
	EmptyList.show() if options_list[tab_index].items.is_empty() else EmptyList.hide()

	# render list
	for index in options_list[tab_index].items.size():
		var item:Dictionary = options_list[tab_index].items[index]
		var btn_node:Control = MenuBtnPreload.instantiate()
		var show:bool = item.show if item.has("show") else true
		
		if show:
			btn_node.title = item.title
			#btn_node.btn_color = use_color
			btn_node.COLOR_A = COLORS.primary_color
			btn_node.COLOR_A_DISABLED = COLORS.disabled_color
			#btn_node.COLOR_B = Color.WHITE
			btn_node.display_checkmark = item.is_togglable if "is_togglable" in item else false
			btn_node.is_checked = item.is_checked if "is_checked" in item else false
			btn_node.is_disabled = item.is_disabled if "is_disabled" in item else false
			#btn_node.is_hollow = true
			btn_node.index = index
			
			btn_node.hint_description = item.hint.description if item.has("hint") else ""
			btn_node.hint_icon = item.hint.icon if item.has("hint") and item.hint.has("icon") else ""
			btn_node.hint_title = item.hint.title if item.has("hint") and item.hint.has("title") else ""

			if index >= list_size:
				btn_node.hide()
			
			List.add_child(btn_node)
		

	await U.tick()
	if stored_size.y < CardControlBody.size.y:
		stored_size = CardControlBody.size
	
	if retain_height:	
		CardControlBody.size.y = stored_size.y
		CardControlBody.custom_minimum_size.y = stored_size.y
	
	BtnControls.itemlist = List.get_children()
	BtnControls.item_index = 0
		
func check_list_limit() -> void:
	for table_index in render_table:
		if selected_index in render_table[table_index]:
			lookup_index = table_index
			break
	
	for i in List.get_child_count():
		var item_node:Control = List.get_child(i)
		item_node.show() if i in render_table[lookup_index] else item_node.hide()
	
	Footerlabel.text = str(lookup_index + 1, "/", ceili(options_list[tab_index].items.size() * 1.0 / list_size * 1.0) ) 

		

func on_use_color_update() -> void:
	if !is_node_ready():return
	#var label_settings:LabelSettings = HeaderLabel.label_settings.duplicate()
	#label_settings.font_color = use_color.lightened(0.4)
	#HeaderLabel.label_settings = label_settings
	#for child in List.get_children():
		#child.btn_color = use_color
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_action() -> void:
	var item:Dictionary = options_list[tab_index].items[SelectedNode.index]
	await onBeforeAction.call(item)
	await item.action.call()		
	onAfterAction.call(item)
	onAction.call()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func remap_data(new_data:Array) -> void:
	for index in List.get_child_count():
		var btn_node:Control = List.get_child(index)
		var properties:Dictionary = new_data[index]
		if properties.has("title"):
			btn_node.title = properties.title
		if properties.has("is_disabled"):
			btn_node.is_disabled = properties.is_disabled
		if properties.has("hint"):	
			btn_node.hint_title =  properties.hint.title
			btn_node.hint_icon =  properties.hint.icon
			btn_node.hint_description =  properties.hint.description		
# ------------------------------------------------------------------------------
				
# ------------------------------------------------------------------------------
func on_key_press(key:String) -> void:
	if !is_node_ready() or !is_visible_in_tree() or freeze_inputs:return
	
	if options_list.size() > 1:
		match key:
			"A":
				tab_index = U.min_max(tab_index - 1, 0, options_list.size() - 1)
				selected_index = 0
				
			"D":
				tab_index = U.min_max(tab_index + 1, 0, options_list.size() - 1)
				selected_index = 0
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_control_input_release_update() -> void:
	if !is_node_ready():return
	wait_for_release = false
# ------------------------------------------------------------------------------	
