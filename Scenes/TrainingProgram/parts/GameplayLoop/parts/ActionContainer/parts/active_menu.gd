extends Control

@onready var List:VBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/List
@onready var HeaderLabel:Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/HBoxContainer/HeaderLabel
@onready var LvlContainer:HBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/LvlContainer

@onready var HintPanel:PanelContainer = $Control/HintPanel
@onready var HintLabel:Label = $Control/HintPanel/MarginContainer/VBoxContainer/HintLabel

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
		
var max_level:int = -1 : 
	set(val):
		max_level = val
		on_max_level_update()

var show_hotkey:bool =  false : 
	set(val):
		show_hotkey = val
		on_show_hotkey_update()

var wait_for_release:bool = false
var allow_shortcut:bool = false
var stored_pos:Vector2 

var onPrev:Callable = func():pass
var onNext:Callable = func():pass
var onClose:Callable = func():pass
var onBookmark:Callable = func(_shortcut_data:Dictionary, _btn_node:Control):pass
var onDrawUpdate:Callable = func(_index:int, _item:Dictionary):pass

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
	on_show_hotkey_update()
	
func open() -> void:
	stored_pos = self.position
	freeze_inputs = false
	set_fade(true)

func close() -> void:	
	freeze_inputs = true
	await set_fade(false)
	onClose.call()	
	show_ap = false
	selected_index = -1
	level = -1
	options_list = []
	clear_list()
	
	
func set_fade(state:bool) -> void:
	U.tween_node_property(self, "position:y", stored_pos.y + (-10 if state else 0), 0.3)	
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1 if state else 0), 0.3)	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func clear_list() -> void:
	for child in List.get_children():
		child.queue_free()

func on_show_hotkey_update() -> void:
	if !is_node_ready():return
	HintPanel.modulate = Color(1, 1, 1, 0 if show_hotkey else 1)

func update_checkbox_option(index:int, is_checked:bool) -> void:
	var btn_node:Control = List.get_child(index) 
	btn_node.is_checked = is_checked
	
func on_selected_index_update() -> void:
	if !is_node_ready() or List.get_child_count() == 0:return
	await U.tick()
	for index in List.get_child_count():
		var btn_node:Control = List.get_child(index) 
		btn_node.is_selected = index == selected_index
		if index == selected_index:
			var item:Dictionary = options_list[index]					
			var has_hint:bool = "hint" in item and item.hint.length() > 0
			if has_hint:
				HintLabel.text = str(item.hint)
				HintPanel.size = Vector2(1, 1)				
				var new_pos:Vector2 = btn_node.global_position + Vector2(self.size.x, btn_node.size.y/2 - HintPanel.size.y/2)
				var is_offscreen:bool = new_pos.x + btn_node.size.x > GBL.game_resolution.x
				await U.tick()
				if !is_offscreen:
					HintPanel.global_position = self.global_position + Vector2(self.size.x, 5)
				else:
					HintPanel.global_position = self.global_position + Vector2(-self.size.x + 50, 5)
				HintPanel.show()
			else:
				HintPanel.hide()
	if !freeze_inputs:
		add_draw_lines()
		

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
		
	for index in options_list.size():
		var item:Dictionary = options_list[index]		
		var btn_node:Control = MenuBtnPreload.instantiate()
		
		btn_node.title = item.title
		btn_node.btn_color = use_color

		btn_node.is_togglable = item.is_togglable if "is_togglable" in item else false
		btn_node.is_checked = item.is_checked if "is_checked" in item else false
		btn_node.is_disabled = item.is_disabled if "is_disabled" in item else false
		
		btn_node.cooldown_duration = item.cooldown_duration if "cooldown_duration" in item else -1
		btn_node.energy_cost = item.energy_cost if "energy_cost" in item else -1
		btn_node.science_cost = item.science_cost if "science_cost" in item else -1

		btn_node.onClick = func() -> void:
			if !btn_node.is_disabled:
				on_action.call(index)
				
		btn_node.onFocus = func(_node:Control) -> void:
			selected_index = index
		
		List.add_child(btn_node)
		
	self.size.y = 1	
	await U.tick()
	selected_index = 0


func add_draw_lines() -> void:
	if options_list.is_empty():return	
	if "shortcut_data" in options_list[selected_index] and  "use_location" in options_list[selected_index].shortcut_data:
		onDrawUpdate.call(selected_index, {} if options_list.is_empty() else options_list[selected_index] )

		
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
func on_action(btn_index:int = selected_index) -> void:
	if freeze_inputs or options_list.is_empty():return
	if btn_index != -1:
		var btn_node:Control = List.get_child(selected_index)
		if btn_node == null:return
		if !btn_node.is_disabled:
			await options_list[btn_index].onSelect.call(btn_index)
			
	await U.tick()
	check_all_button_states()
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func check_all_button_states() -> void:
	for btn_index in List.get_child_count():
		var btn_node:Control = List.get_child(btn_index)
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
func get_node_btn(index:int) -> Control:
	return List.get_child(selected_index)
# ------------------------------------------------------------------------------			

# ------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:	
	if !is_node_ready() or !is_visible_in_tree() or freeze_inputs:return
	var key:String = input_data.key

	match key:
		"H":
			if !options_list.is_empty() and "shortcut_data" in options_list[selected_index]:
				onBookmark.call(options_list[selected_index].shortcut_data, List.get_child(selected_index))
		"E":
			if wait_for_release:return
			on_action()
		"B":
			close()
		"A":
			selected_index = 0
			onPrev.call()
		"D":
			selected_index = 0
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
