extends Control

@onready var MenuPanel:PanelContainer = $MenuControl/PanelContainer
@onready var MenuMargin:MarginContainer = $MenuControl/PanelContainer/MarginContainer

@onready var BtnPanel:PanelContainer = $BtnControl/BtnControlPanel
@onready var BtnMargin:MarginContainer = $BtnControl/BtnControlPanel/BtnMarginContainer

@onready var List:VBoxContainer = $MenuControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/List
@onready var HeaderLabel:Label = $MenuControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/HBoxContainer/HeaderLabel

@onready var HintControl:Control = $BtnControl/BtnControlPanel/BtnMarginContainer/Control
@onready var HintTitle:Label = $BtnControl/BtnControlPanel/BtnMarginContainer/Control/CenterContainer/HintContainer/MarginContainer/VBoxContainer/HintTitle
@onready var HintIcon:BtnBase = $BtnControl/BtnControlPanel/BtnMarginContainer/Control/CenterContainer/HintContainer/MarginContainer/VBoxContainer/HBoxContainer/HintIcon
@onready var HintDesription:Label = $BtnControl/BtnControlPanel/BtnMarginContainer/Control/CenterContainer/HintContainer/MarginContainer/VBoxContainer/HBoxContainer/HintDescription

@onready var ABtn:BtnBase = $BtnControl/BtnControlPanel/BtnMarginContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/ABtn
@onready var BBtn:BtnBase = $BtnControl/BtnControlPanel/BtnMarginContainer/PanelContainer/MarginContainer/HBoxContainer/LeftSideBtnList/BBtn

const MenuBtnPreload:PackedScene = preload("res://UI/Buttons/MenuBtn/MenuBtn.tscn")

var header:String = "" : 
	set(val):
		header = val
		on_header_update()

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
		

var control_pos_default:Dictionary
var control_pos:Dictionary

var wait_for_release:bool = false
var allow_shortcut:bool = false
var stored_pos:Vector2 

var onBeforeAction:Callable = func(_item:Dictionary):pass
var onAfterAction:Callable = func(_item:Dictionary):pass
var onClose:Callable = func():pass
var onUpdate:Callable = func(_item:Dictionary):pass


# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)
	
func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	activate()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func activate() -> void:
	await U.tick()
	var duration:float = 0
	
	control_pos_default[MenuPanel] = MenuPanel.position
	control_pos_default[BtnPanel] = BtnPanel.position

	control_pos[MenuPanel] = {
		"show": control_pos_default[MenuPanel].x, 
		"hide": control_pos_default[MenuPanel].x - MenuMargin.size.x
	}
	
	control_pos[BtnPanel] = {
		"show": control_pos_default[BtnPanel].y, 
		"hide": control_pos_default[BtnPanel].y + BtnMargin.size.y
	}	
	
	MenuPanel.position.x = control_pos[MenuPanel].hide
	BtnPanel.position.y = control_pos[BtnPanel].hide
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func open() -> void:
	modulate = Color(1, 1, 1, 1)
	on_tab_index_update	()
	await animate_in(true)
	selected_index = 0
	freeze_inputs = false
	

func close() -> void:	
	print("close...")
	freeze_inputs = true
	await animate_in(false)
	onClose.call()	
	queue_free()
	
func lock() -> void:
	for btn in [ABtn, BBtn]:
		btn.is_disabled = true
	await U.tween_node_property(BtnPanel, "position:y", control_pos[BtnPanel].hide, 0.3)	
	await U.set_timeout(0.2)

func unlock() -> void:
	await U.tween_node_property(BtnPanel, "position:y", control_pos[BtnPanel].show, 0.3)
	for btn in [ABtn, BBtn]:
		btn.is_disabled = false
	await U.set_timeout(0.2)

	
# ------------------------------------------------------------------------------
func animate_in(state:bool, skip_animation:bool = false) -> void:
	var duration:float = 0.3
	await U.tween_node_property(MenuPanel, "position:x", control_pos[MenuPanel].show if state else control_pos[MenuPanel].hide, duration)
	await U.tween_node_property(BtnPanel, "position:y", control_pos[BtnPanel].show if state else control_pos[BtnPanel].hide, duration)	
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func clear_list() -> void:
	for child in List.get_children():
		child.queue_free()

func update_checkbox_option(index:int, is_checked:bool) -> void:
	var btn_node:Control = List.get_child(index) 
	btn_node.is_checked = is_checked
	
func on_selected_index_update() -> void:
	if !is_node_ready() or List.get_child_count() == 0:return
	for index in List.get_child_count():
		var btn_node:Control = List.get_child(index) 
		btn_node.is_selected = index == selected_index
		if index == selected_index:
			Input.warp_mouse(btn_node.global_position)
			onUpdate.call(options_list[tab_index].items[index])	
			update_hint(options_list[tab_index].items[index])

func update_hint(item:Dictionary) -> void:
	if "hint" in item:
		HintControl.show()
		HintTitle.text = item.title
		HintIcon.icon = item.hint.icon
		HintDesription.text = item.hint.description
	else:
		HintControl.hide()

func on_tab_index_update() -> void:
	on_options_list_update()

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
		
		List.add_child(btn_node)		
		return
	
	for index in options_list[tab_index].items.size():
		var item:Dictionary = options_list[tab_index].items[index]
		var btn_node:Control = MenuBtnPreload.instantiate()
		header = options_list[tab_index].title
		btn_node.title = item.title
		btn_node.btn_color = use_color

		btn_node.is_togglable = item.is_togglable if "is_togglable" in item else false
		btn_node.is_checked = item.is_checked if "is_checked" in item else false
		btn_node.is_disabled = item.is_disabled if "is_disabled" in item else false

		btn_node.onClick = func() -> void:
			on_action()

		btn_node.onFocus = func(_node:Control) -> void:
			selected_index = index
		
		List.add_child(btn_node)
		


func on_header_update() -> void:
	if !is_node_ready():return
	HeaderLabel.text = header

func on_use_color_update() -> void:
	if !is_node_ready():return
	var label_settings:LabelSettings = HeaderLabel.label_settings.duplicate()
	label_settings.font_color = use_color.lightened(0.4)
	HeaderLabel.label_settings = label_settings
	for child in List.get_children():
		child.btn_color = use_color
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_action() -> void:
	var btn_node:Control = List.get_child(selected_index)
	if !btn_node.is_disabled:
		var item:Dictionary = options_list[tab_index].items[selected_index]
		await onBeforeAction.call(item)
		await item.action.call()
		onAfterAction.call(item)
# ------------------------------------------------------------------------------

				
# ------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:	
	if !is_node_ready() or !is_visible_in_tree() or freeze_inputs:return
	var key:String = input_data.key

	match key:
		"E":
			if wait_for_release:return
			on_action()
		"B":
			print("close?")
			close()
		"A":
			tab_index = U.min_max(tab_index - 1, 0, options_list.size() - 1)
			await U.tick()
			selected_index = 0
		"D":
			tab_index = U.min_max(tab_index + 1, 0, options_list.size() - 1)
			await U.tick()
			selected_index = 0
		"W":
			selected_index = U.min_max(selected_index - 1, 0, options_list[tab_index].items.size() - 1)
		"S":
			selected_index = U.min_max(selected_index + 1, 0, options_list[tab_index].items.size() - 1)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_control_input_release_update() -> void:
	if !is_node_ready():return
	wait_for_release = false
# ------------------------------------------------------------------------------	
