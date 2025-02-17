extends Control

@onready var HeaderLabel:Label = $MarginContainer/VBoxContainer/HBoxContainer/HeaderLabel
@onready var List:VBoxContainer = $MarginContainer/VBoxContainer/List

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var selected_index:int = 0 : 
	set(val):
		selected_index = val
		on_selected_index_update()
			
var options_list:Array = [] : 
	set(val):
		options_list = val
		on_options_list_update()

var freeze_inputs:bool = true : 
	set(val):
		freeze_inputs = val
		on_freeze_inputs_update()

var onClose:Callable = func():pass

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)
	
func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	on_options_list_update()
	
func open() -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))	

func close() -> void:	
	freeze_inputs = true
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 0))	
	onClose.call()	
	selected_index = 0	
	options_list = []
	clear_list()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func clear_list() -> void:
	for child in List.get_children():
		child.queue_free()	
	
func on_selected_index_update() -> void:
	if !is_node_ready() or List.get_child_count() == 0:return
		
	for index in List.get_child_count():
		var btn_node:Control = List.get_child(index) 
		btn_node.icon = SVGS.TYPE.MEDIA_PLAY if index == selected_index else SVGS.TYPE.NONE
		

func on_options_list_update() -> void:
	if !is_node_ready() or options_list.is_empty():return	
	clear_list()
	
	if selected_index > options_list.size():
		selected_index = options_list.size() - 1
		
	for index in options_list.size():
		var item:Dictionary = options_list[index]		
		var btn_node:Control = TextBtnPreload.instantiate()
		btn_node.title = item.title
		btn_node.is_disabled = item.is_disabled if "is_disabled" in item else false
		btn_node.onClick = func() -> void:
			if !btn_node.is_disabled:
				item.onSelect
		btn_node.icon = SVGS.TYPE.MEDIA_PLAY if index == selected_index else SVGS.TYPE.NONE
		btn_node.onFocus = func(_node:Control) -> void:
			selected_index = index
		
		List.add_child(btn_node)
	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_freeze_inputs_update() -> void:
	U.tween_node_property(self, "scale:x", 0 if freeze_inputs else 1)

func on_action() -> void:
	if freeze_inputs:return
	if selected_index != -1:
		var btn_node:Control = List.get_child(selected_index)
		if !btn_node.is_disabled:
			options_list[selected_index].onSelect.call()		
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_visible_in_tree() or freeze_inputs or selected_index == -1:return
	var key:String = input_data.key

	match key:
		"E":
			on_action()
		"ENTER":
			on_action()
		"BACKSPACE":
			close()
		"B":
			close()
		"W":
			selected_index = U.min_max(selected_index - 1, 0, options_list.size() - 1)
		"S":
			selected_index = U.min_max(selected_index + 1, 0, options_list.size() - 1)
# ------------------------------------------------------------------------------
