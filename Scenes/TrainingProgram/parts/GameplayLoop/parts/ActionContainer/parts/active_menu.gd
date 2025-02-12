extends Control

@onready var HeaderLabel:Label = $ControlMenuContainer/MarginContainer/VBoxContainer/HBoxContainer/HeaderLabel
@onready var List:VBoxContainer = $ControlMenuContainer/MarginContainer/VBoxContainer/List

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var selected_index:int = -1 : 
	set(val):
		selected_index = val
		if selected_index != -1:
			on_selected_index_update()
			
var options_list:Array = [] : 
	set(val):
		options_list = val
		on_options_list_update()

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)
	
func _ready() -> void:
	on_options_list_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func clear_list() -> void:
	for child in List.get_children():
		child.queue_free()	

func on_selected_index_update() -> void:
	if !is_node_ready():return

func on_options_list_update() -> void:
	if !is_node_ready():return	
	clear_list()
	#self.modulate = Color(1, 1, 1, 0)
	
	if options_list.size() == 0:
		selected_index = -1
		return
	
	for index in options_list.size():
		var item:Dictionary = options_list[index]
		var new_node:Control = TextBtnPreload.instantiate()
		List.add_child(new_node)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or !is_visible_in_tree() or selected_index == -1:return
	var key:String = input_data.key

	match key:
		"W":
			selected_index = U.min_max(selected_index - 1, 0, options_list.size() - 1)
		"S":
			selected_index = U.min_max(selected_index + 1, 0, options_list.size() - 1)
# ------------------------------------------------------------------------------
