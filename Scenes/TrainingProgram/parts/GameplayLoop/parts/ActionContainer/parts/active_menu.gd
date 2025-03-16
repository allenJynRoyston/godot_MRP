extends Control

@onready var List:VBoxContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/List
@onready var HeaderLabel:Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/HeaderLabel

@onready var ApContainer:PanelContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/ApContainer
@onready var ApLabel:Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/ApContainer/MarginContainer/VBoxContainer/HBoxContainer/ApLabel

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

var ap_val:int = 0 : 
	set(val):
		ap_val = val
		on_ap_val_update()

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

var onPrev:Callable = func():pass
var onNext:Callable = func():pass
var onClose:Callable = func():pass
var onBookmark:Callable = func(_index:int, _target:int):pass

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
	on_ap_val_update()
	on_show_ap_update()
	on_level_update()
	
func open() -> void:
	freeze_inputs = false
	set_fade(true)

func close() -> void:	
	freeze_inputs = true
	await set_fade(false)
	onClose.call()	
	show_ap = false
	ap_val = 0
	selected_index = 0	
	level = -1
	options_list = []
	clear_list()
	
func set_fade(state:bool) -> void:
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1 if state else 0), 0.2)	
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
		
func on_options_list_update() -> void:
	if !is_node_ready():return	
	clear_list()
	

	
	# ---- IF EMPTY
	if options_list.is_empty():
		var btn_node:Control = MenuBtnPreload.instantiate()
		btn_node.title = "NO ACTIONS AVAILABLE"
		btn_node.icon = SVGS.TYPE.CLEAR
		btn_node.btn_color = use_color
		List.add_child(btn_node)		
		return
	
	if selected_index > options_list.size():
		selected_index = options_list.size() - 1
		
	for index in options_list.size():
		var item:Dictionary = options_list[index]		
		var btn_node:Control = MenuBtnPreload.instantiate()
		
		btn_node.title = item.title
		btn_node.icon = item.icon if "icon" in item else SVGS.TYPE.NONE
		btn_node.btn_color = use_color
		btn_node.is_togglable = item.is_togglable if "is_togglable" in item else false
		btn_node.is_checked = item.is_checked if "is_checked" in item else false
		btn_node.is_selected = index == selected_index
		btn_node.cooldown_duration = item.cooldown_duration if "cooldown_duration" in item else -1
		btn_node.is_disabled = item.is_disabled if "is_disabled" in item else false
		
		btn_node.onClick = func() -> void:
			if !btn_node.is_disabled:
				item.onSelect.call(selected_index)
		btn_node.onFocus = func(_node:Control) -> void:
			selected_index = index
		
		List.add_child(btn_node)
	
	self.size.y = 1	
	



func on_ap_val_update() -> void:
	if !is_node_ready():return
	ApLabel.text = str(ap_val)


	
func on_level_update() -> void:
	if !is_node_ready():return	
	#LevelLabel.text = "%s" % ["%s" % [level] if level != -1  else ""]
	
func on_show_ap_update() -> void:
	if !is_node_ready():return
	ApContainer.show() if show_ap else ApContainer.hide()


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

func on_action() -> void:
	if freeze_inputs:return
	if selected_index != -1:
		var btn_node:Control = List.get_child(selected_index)
		
		if btn_node == null:return
		if !btn_node.is_disabled:
			options_list[selected_index].onSelect.call(selected_index)
			
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_visible_in_tree() or freeze_inputs or selected_index == -1:return
	var key:String = input_data.key

	match key:
		"1":
			onBookmark.call(selected_index, 0)
		"2":
			onBookmark.call(selected_index, 1)
		"3":
			onBookmark.call(selected_index, 2)
		"4":
			onBookmark.call(selected_index, 3)			
		"E":
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
