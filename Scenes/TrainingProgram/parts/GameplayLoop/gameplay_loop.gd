@tool
extends PanelContainer

@onready var Structure3dContainer:Control = $Structure3DContainer
@onready var LocationContainer:MarginContainer = $LocationContainer
@onready var ActionQueueContainer:MarginContainer = $ActionQueueContainer
@onready var ItemStatusContainer:MarginContainer = $ItemStatusContainer
@onready var ActionContainer:MarginContainer = $ActionContainer
@onready var ResourceContainer:MarginContainer = $ResourceContainer
@onready var DialogueContainer:MarginContainer = $DialogueContainer
@onready var StoreContainer:MarginContainer = $StoreContainer
@onready var ItemSelectContainer:MarginContainer = $ItemSelectContainer

@export var show_structures:bool = true: 
	set(val):
		show_structures = val
		on_show_structures_update()
		
@export var show_location:bool = true : 
	set(val):
		show_location = val
		on_show_location_update()

@export var show_action_queue:bool = true : 
	set(val):
		show_action_queue = val
		on_show_action_queue_update()
		
@export var show_item_status:bool = true : 
	set(val):
		show_item_status = val
		on_show_item_status_update()

@export var show_actions:bool = true : 
	set(val):
		show_actions = val
		on_show_actions_update()

@export var show_resources:bool = true : 
	set(val):
		show_resources = val
		on_show_resources_update()

@export var show_dialogue:bool = true : 
	set(val):
		show_dialogue = val
		on_show_dialogue_update()
		
@export var show_store:bool = false : 
	set(val):
		show_store = val
		on_show_store_update()		

@export var show_item_select:bool = false : 
	set(val):
		show_item_select = val
		on_show_item_select_update()
		
var store_data:Dictionary = {} : 
	set(val):
		store_data = val
		on_store_data_update()
		
var item_select_data:Dictionary = {} : 
	set(val):
		item_select_data = val
		on_item_select_data_update()

var showing_states:Dictionary = {} 

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.register_node(REFS.GAMEPLAY_LOOP, self)
	GBL.subscribe_to_control_input(self)
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.GAMEPLAY_LOOP)
	GBL.unsubscribe_to_control_input(self)
	
func _ready() -> void:
	if !Engine.is_editor_hint():
		hide()
		set_process(false)
		set_physics_process(false)	
	
	# first these
	on_show_structures_update()
	on_show_actions_update()
	on_show_resources_update()
	on_show_location_update()
	on_show_action_queue_update()
	on_show_item_status_update()
	on_show_dialogue_update()
	on_show_item_select_update()
	
	# then these
	on_show_store_update()
	on_store_data_update()
	
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func start(game_data:Dictionary = {}) -> void:
	show()
	set_process(true)
	set_physics_process(true)	
	_on_container_rect_changed()
	
	# initially all animation speed is set to 0 but after this is all ready, set animation speed
	for node in get_all_container_nodes():
		node.animation_speed = 0.3

	if game_data.is_empty():
		start_new_game()
	else:
		start_load_game()

func start_new_game() -> void:
	pass

func start_load_game() -> void:
	pass
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func get_all_container_nodes(exclude:Array = []) -> Array:
	return [
		Structure3dContainer, LocationContainer, ActionQueueContainer, 
		ItemStatusContainer, ActionContainer, ResourceContainer, 
		DialogueContainer, StoreContainer, ItemSelectContainer
	].filter(func(node): return node not in exclude)
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func capture_current_showing_state() -> void:
	for node in get_all_container_nodes():
		showing_states[node] = node.is_showing
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func add_to_action_queue(item:Dictionary) -> void:
	print("add to queue")
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_store_data_update() -> void:
	if store_data.is_empty():
		for node in get_all_container_nodes():
			if node.is_showing != showing_states[node]:
				node.is_showing = showing_states[node]
		return

	capture_current_showing_state()
	for node in get_all_container_nodes([ResourceContainer, StoreContainer, ActionQueueContainer, ItemStatusContainer]):
		node.is_showing = false
		
	await U.set_timeout(0.1)
	StoreContainer.is_showing = true
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func on_item_select_data_update() -> void:
	if item_select_data.is_empty():
		for node in get_all_container_nodes():
			if node.is_showing != showing_states[node]:
				node.is_showing = showing_states[node]
		return

	capture_current_showing_state()
	for node in get_all_container_nodes([ResourceContainer, ItemSelectContainer, ActionQueueContainer, ItemStatusContainer]):
		node.is_showing = false
		
	await U.set_timeout(0.1)
	ItemSelectContainer.is_showing = true
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func on_show_location_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		LocationContainer.is_showing = show_location
		showing_states[LocationContainer] = show_location
	
func on_show_structures_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		Structure3dContainer.is_showing = show_structures
		showing_states[Structure3dContainer] = show_structures
	
func on_show_actions_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ActionContainer.is_showing = show_actions
		showing_states[ActionContainer] = show_actions
	
func on_show_action_queue_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ActionQueueContainer.is_showing = show_action_queue
		showing_states[ActionQueueContainer] = show_action_queue

func on_show_item_status_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ItemStatusContainer.is_showing = show_item_status
		showing_states[ItemStatusContainer] = show_item_status

func on_show_resources_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ResourceContainer.is_showing = show_resources
		showing_states[ResourceContainer] = show_resources
		
func on_show_dialogue_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		DialogueContainer.is_showing = show_dialogue
		showing_states[DialogueContainer] = show_dialogue

func on_show_store_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		StoreContainer.is_showing = show_store
		showing_states[StoreContainer] = show_store

func on_show_item_select_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ItemSelectContainer.is_showing = show_item_select
		showing_states[ItemSelectContainer] = show_item_select

func _on_container_rect_changed() -> void:	
	if is_node_ready() or Engine.is_editor_hint():
		for sidebar in [ItemStatusContainer, ActionQueueContainer]:
			sidebar.max_height = self.size.y
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	print("key: %s   keycode: %s" % [key, keycode])
	match key:
		"5":
			quicksave()
		"8":
			quickload()
		
	
# ------------------------------------------------------------------------------	

# -----------------------------------
#region SAVE/LOAD
func quicksave() -> void:
	var save_data = {

	}	
	var res = FS.save_file(FS.FILE.QUICK_SAVE, save_data)
	print("saved game!")

func quickload() -> void:
	var res = FS.load_file(FS.FILE.QUICK_SAVE)		
	if res.success:
		parse_restore_data(res.filedata.data)
	print("quickload game!")
		
func parse_restore_data(restore_data:Dictionary = {}) -> void:
	var no_save:bool = restore_data.is_empty()
	

#endregion		
# -----------------------------------
