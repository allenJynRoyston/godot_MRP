extends Control

@onready var List:VBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/List
@onready var HeaderLabel:Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/HBoxContainer/HeaderLabel
@onready var LvlContainer:HBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/LvlContainer

@onready var PrevIcon:Control = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/HBoxContainer/PrevIcon
@onready var NextIcon:Control = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/HBoxContainer/NextIcon

const MenuBtnPreload:PackedScene = preload("res://UI/Buttons/MenuBtn/MenuBtn.tscn")

var header:String = "" : 
	set(val):
		header = val
		on_header_update()

var show_ap:bool = false : 
	set(val):
		show_ap = val
		on_show_ap_update()

var level:int = -1 : 
	set(val):
		level = val
		on_level_update()

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
		on_freeze_inputs_update()
		
var max_level:int = -1 : 
	set(val):
		max_level = val
		on_max_level_update()

var wait_for_release:bool = false
var allow_shortcut:bool = false

var onPrev:Callable = func():pass
var onNext:Callable = func():pass
var onClose:Callable = func():pass
var onBookmark:Callable = func(_shortcut_data:Dictionary, _btn_node:Control):pass

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)
	
func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	on_options_list_update()
	on_header_update()
	on_use_color_update()	
	on_show_ap_update()
	on_level_update()
	on_max_level_update()
	
func open() -> void:
	freeze_inputs = false
	set_fade(true)

func close() -> void:	
	freeze_inputs = true
	await set_fade(false)
	onClose.call()	
	show_ap = false
	selected_index = 0	
	level = -1
	options_list = []
	clear_list()
	
func set_fade(state:bool) -> void:
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1 if state else 0), 0.2)	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func clear_list() -> void:
	selected_index = 0
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
		
func on_options_list_update() -> void:
	if !is_node_ready():return	
	wait_for_release = true
	clear_list()

	# ---- IF EMPTY
	if options_list.is_empty():
		var btn_node:Control = MenuBtnPreload.instantiate()
		btn_node.title = "NO LVL %s ACTIONS AVAILABLE" % [level + 1]
		btn_node.btn_color = use_color
		btn_node.is_empty = true
		
		List.add_child(btn_node)		
		return
	
	if selected_index > options_list.size():
		selected_index = options_list.size() - 1
		
	for index in options_list.size():
		var item:Dictionary = options_list[index]		
		var btn_node:Control = MenuBtnPreload.instantiate()
		
		btn_node.title = item.title
		btn_node.btn_color = use_color
		btn_node.is_togglable = item.is_togglable if "is_togglable" in item else false
		btn_node.is_checked = item.is_checked if "is_checked" in item else false
		btn_node.is_selected = index == selected_index
		btn_node.cooldown_duration = item.cooldown_duration if "cooldown_duration" in item else -1
		btn_node.is_disabled = item.is_disabled if "is_disabled" in item else false
		btn_node.energy_cost = item.energy_cost if "energy_cost" in item else -1

		btn_node.onClick = func() -> void:
			if !btn_node.is_disabled:
				on_action.call(index)
				
		btn_node.onFocus = func(_node:Control) -> void:
			selected_index = index
		
		List.add_child(btn_node)
	
	self.size.y = 1	


func on_max_level_update() -> void:
	if !is_node_ready():return	
	U.debounce("update_lvl_nodes", update_lvl_nodes)
		
		
func on_level_update() -> void:
	if !is_node_ready():return	
	U.debounce("update_lvl_nodes", update_lvl_nodes)

func update_lvl_nodes() -> void:
	for index in LvlContainer.get_child_count():
		var node:Control = LvlContainer.get_child(index)
		var alpha:float = 1.0 if index == level else 0.5		
		node.modulate = Color(1, 0, 0, alpha) if index > max_level else Color(1, 1, 1, alpha)
	
	for node in [PrevIcon, NextIcon]:
		if max_level == 0:
			node.hide()  
		else:
			node.show()
	
	PrevIcon.static_color = Color(1, 1, 1, 0.2 if level == 0 else 1)
	NextIcon.static_color = Color(1, 1, 1, 0.2 if level == max_level else 1)		


func on_show_ap_update() -> void:
	if !is_node_ready():return
	LvlContainer.show() if show_ap else LvlContainer.hide()


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
func on_freeze_inputs_update() -> void:
	pass
	#U.tween_node_property(self, "modulate", Color(1, 1, 1, 0 if freeze_inputs else 1)  )

func on_action(btn_index:int = selected_index) -> void:
	if freeze_inputs or options_list.is_empty():return
	if btn_index != -1:
		var btn_node:Control = List.get_child(selected_index)
		if btn_node == null:return
		if !btn_node.is_disabled:
			await options_list[btn_index].onSelect.call(btn_index)
			
			if "get_checked_state" in options_list[btn_index]:
				btn_node.is_checked = await options_list[btn_index].get_checked_state.call()
			if "get_disabled_state" in options_list[btn_index]:
				btn_node.is_disabled = await options_list[btn_index].get_disabled_state.call()
			if "get_cooldown_duration" in options_list[btn_index]:
				btn_node.cooldown_duration = await options_list[btn_index].get_cooldown_duration.call()
			if "get_checked_state" in options_list[btn_index]:
				btn_node.is_checked = await options_list[btn_index].get_checked_state.call()
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:	
	if !is_node_ready() or !is_visible_in_tree() or freeze_inputs or selected_index == -1:return
	var key:String = input_data.key

	match key:
		"G":
			if !options_list.is_empty() and "shortcut_data" in options_list[selected_index]:
				onBookmark.call(options_list[selected_index].shortcut_data, List.get_child(selected_index))
		"E":
			if wait_for_release:return
			on_action()
		"B":
			close()
		"A":
			onPrev.call()
		"D":
			onNext.call()
		"W":
			selected_index = U.min_max(selected_index - 1, 0, options_list.size() - 1)
		"S":
			selected_index = U.min_max(selected_index + 1, 0, options_list.size() - 1)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_control_input_release_update() -> void:
	if !is_node_ready():return
	wait_for_release = false
# ------------------------------------------------------------------------------	
