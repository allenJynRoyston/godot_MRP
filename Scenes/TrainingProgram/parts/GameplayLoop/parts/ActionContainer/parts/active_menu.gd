extends Control

@onready var CardBody:Control = $MenuControl/PanelContainer/MarginContainer/CardBody
@onready var CardControlBody:PanelContainer = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody
@onready var CardBodySubviewport:SubViewport = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport

@onready var PaginationContainer:HBoxContainer = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardMenuHeader/PaginationContainer
@onready var PrevIcon:BtnBase = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardMenuHeader/PaginationContainer/PrevIcon
@onready var NextIcon:BtnBase = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardMenuHeader/PaginationContainer/NextIcon
@onready var PaginationList:HBoxContainer = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardMenuHeader/PaginationContainer/PaginationList
@onready var Footerlabel:Label = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/FooterLabel
@onready var MenuPanel:PanelContainer = $MenuControl/PanelContainer
@onready var MenuMargin:MarginContainer = $MenuControl/PanelContainer/MarginContainer
@onready var List:VBoxContainer = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/List
@onready var CardMenuHeader:Control = $MenuControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/CardMenuHeader

@onready var BtnControls:Control = $BtnControls

const MenuBtnPreload:PackedScene = preload("res://UI/Buttons/ItemBtn/ItemBtn.tscn")
const LabelSettingPreload:LabelSettings = preload("res://Fonts/game/label_small_thick.tres")

const LIST_SIZE:int = 4

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


var hint_border_color:Color = Color(0.337, 0.275, 1.0) : 
	set(val):
		hint_border_color = val
		on_hint_border_color_update()

var control_pos_default:Dictionary
var control_pos:Dictionary

var tutorial_is_open:bool = false
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
	on_hint_border_color_update()
	BtnControls.reveal(false, true)
	#CardBody.reveal = false
	GBL.direct_ref["ActiveMenu"] = CardBody

	BtnControls.onDirectional = on_key_press
	
	BtnControls.onAction = func() -> void:
		on_action()
		
	BtnControls.onBack = func() -> void:
		close()		
	
	BtnControls.onUpdate = func(node:Control) -> void:
		BtnControls.offset = CardBody.global_position + Vector2(10, 15)
		for index in List.get_child_count():
			var btn:Control = List.get_child(index)
			btn.is_selected = btn == node
			if btn == node:
				SelectedNode = node
				onUpdate.call(options_list[tab_index].items[index])	
				
	
	BtnControls.directional_pref = "UD"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func activate() -> void:
	await U.tick()
	var duration:float = 0
	
	control_pos_default[MenuPanel] = MenuPanel.position

	await U.tick()
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
	BtnControls.reveal(false)
	onBeforeClose.call()
	freeze_inputs = true
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
	for node in [PaginationList, List]:
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
	#for index in List.get_child_count():
		#if index == selected_index:
			##Input.warp_mouse(btn_node.global_position + CardBody.global_position)
			#onUpdate.call(options_list[tab_index].items[index])	
			#update_hint(options_list[tab_index].items[index])

func update_hint(item:Dictionary) -> void:
	pass
	#if "hint" in item:
		#HintTitle.text = item.title
		#HintIcon.icon = item.hint.icon
		#HintDesription.text = item.hint.description
		#await U.tick()
		#HintControl.show()
	#else:
		#HintControl.hide()


func on_hint_border_color_update() -> void:
	if !is_node_ready():return
	#var new_stylebox:StyleBoxFlat = HintContainer.get_theme_stylebox('panel').duplicate()
	#new_stylebox.border_color = hint_border_color		
	#HintContainer.add_theme_stylebox_override('panel', new_stylebox)	

func on_tab_index_update() -> void:
	on_options_list_update()
	await U.tick()
	for index in PaginationList.get_child_count():		
		var LabelNode:Label = PaginationList.get_child(index) 
		LabelNode.modulate = Color(1, 1, 1, 1 if index == tab_index else 0.5)
		
	# create a render table
	await U.tick()
	render_table = {}
	var count:int = 0
	for index in range(ceili(options_list[tab_index].items.size() / LIST_SIZE) + 1):
		render_table[index] = []
		for n in range(count, count + LIST_SIZE):
			render_table[index].append(n)
			count += 1
	check_list_limit()	


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
		btn_node.is_hollow = true
		
		List.add_child(btn_node)		
		return
	
	PaginationContainer.show() if options_list.size() > 1 else PaginationContainer.hide()
	if options_list.size() > 1:
		PrevIcon.static_color = Color(1, 1, 1, 0.5 if tab_index == 0 else 1)
		NextIcon.static_color = Color(1, 1, 1, 0.5 if tab_index == options_list.size() - 1 else 1)
	
	# render list
	for index in options_list[tab_index].items.size():
		var item:Dictionary = options_list[tab_index].items[index]
		var btn_node:Control = MenuBtnPreload.instantiate()
		var show:bool = item.show if item.has("show") else true
		
		CardMenuHeader.content = str(options_list[tab_index].title) if "title" in options_list[tab_index] else ""
		
		if show:
			btn_node.title = item.title
			#btn_node.btn_color = use_color
			btn_node.COLOR_A = Color.WHITE
			btn_node.COLOR_A_DISABLED = Color(0.337, 0.275, 1.0).lightened(0.4)
			#btn_node.COLOR_B = Color.WHITE
			btn_node.display_checkmark = item.is_togglable if "is_togglable" in item else false
			btn_node.is_checked = item.is_checked if "is_checked" in item else false
			btn_node.is_disabled = item.is_disabled if "is_disabled" in item else false
			btn_node.is_hollow = true
			btn_node.index = index
			
			btn_node.hint_description = item.hint.description if item.has("hint") else ""
			btn_node.hint_icon = item.hint.icon if item.has("hint") and item.hint.has("icon") else ""
			btn_node.hint_title = item.hint.title if item.has("hint") and item.hint.has("title") else ""

			if index >= LIST_SIZE:
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
		if selected_index in  render_table[table_index]:
			lookup_index = table_index
			break

	for i in List.get_child_count():
		var item_node:Control = List.get_child(i)
		item_node.show() if i in render_table[lookup_index] else item_node.hide()
		
	Footerlabel.text = str(lookup_index + 1, "/", render_table.size()) 

		

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
	if !SelectedNode.is_disabled:
		var item:Dictionary = options_list[tab_index].items[SelectedNode.index]
		await onBeforeAction.call(item)
		await item.action.call()
		onAfterAction.call(item)
		onAction.call()
# ------------------------------------------------------------------------------

				
# ------------------------------------------------------------------------------
func on_key_press(key:String) -> void:
	if !is_node_ready() or !is_visible_in_tree() or freeze_inputs or tutorial_is_open:return
	
	if options_list.size() > 1:
		match key:
			"A":
				tab_index = U.min_max(tab_index - 1, 0, options_list.size() - 1)
				await U.tick()
				selected_index = 0
				
			"D":
				tab_index = U.min_max(tab_index + 1, 0, options_list.size() - 1)
				await U.tick()
				selected_index = 0
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_control_input_release_update() -> void:
	if !is_node_ready():return
	wait_for_release = false
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if !is_node_ready():return
	CardBodySubviewport.size = CardControlBody.size
# ------------------------------------------------------------------------------
	#
