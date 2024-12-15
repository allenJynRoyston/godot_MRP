@tool
extends PanelContainer

enum SHOP_STEPS {HIDE, START, SHOW, WAIT_FOR_USER, CONFIRM_LOCATION, CONFIRM, FINALIZE}
enum CONTAIN_STEPS {HIDE, START, SHOW, WAIT_FOR_USER, CONFIRM_LOCATION, CONFIRM, FINALIZE}
enum RECRUIT_STEPS {HIDE, START, SHOW, WAIT_FOR_USER, CONFIRM_LOCATION, CONFIRM, FINALIZE}

@onready var Structure3dContainer:Control = $Structure3DContainer
@onready var LocationContainer:MarginContainer = $LocationContainer
@onready var ActionQueueContainer:MarginContainer = $ActionQueueContainer
@onready var ItemStatusContainer:MarginContainer = $ItemStatusContainer
@onready var ActionContainer:MarginContainer = $ActionContainer
@onready var ResourceContainer:MarginContainer = $ResourceContainer
@onready var DialogueContainer:MarginContainer = $DialogueContainer
@onready var StoreContainer:MarginContainer = $StoreContainer
@onready var ItemSelectContainer:MarginContainer = $ItemSelectContainer
@onready var RecruitContainer:MarginContainer = $RecruitContainer

@onready var ConfirmModal:MarginContainer = $ConfirmModal

# ------------------------------------------------------------------------------	EXPORT VARS
#region EXPORT VARS
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
		
@export var show_recruit:bool = false : 
	set(val):
		show_recruit = val
		on_show_recruit_update()		

@export var show_item_select:bool = false : 
	set(val):
		show_item_select = val
		on_show_item_select_update()
		
@export var show_confirm_modal:bool = false : 
	set(val):
		show_confirm_modal = val
		on_show_confirm_modal_update()
		

#endregion
# ------------------------------------------------------------------------------ 

# ------------------------------------------------------------------------------	LOCAL DATA
#region LOCAL DATA
var showing_states:Dictionary = {} 

var current_shop_step:SHOP_STEPS = SHOP_STEPS.HIDE : 
	set(val):
		current_shop_step = val
		on_current_shop_step_update()
		
var current_contain_step:CONTAIN_STEPS = CONTAIN_STEPS.HIDE : 
	set(val):
		current_contain_step = val
		on_current_contain_step_update()
		
var current_recruit_step:RECRUIT_STEPS = RECRUIT_STEPS.HIDE : 
	set(val):
		current_recruit_step = val
		on_current_recruit_step_update()
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	LIFECYCLE
#region LIFECYCLE
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
	setup()

func setup() -> void:
	# first these
	on_show_structures_update()
	on_show_actions_update()
	on_show_resources_update()
	on_show_location_update()
	on_show_action_queue_update()
	on_show_item_status_update()
	on_show_dialogue_update()
	on_show_item_select_update()
	on_show_recruit_update()
	
	# modals
	on_show_confirm_modal_update()
	
	# steps
	on_show_store_update()
	on_current_shop_step_update()
	
	# get default showing state
	capture_default_showing_state()
		
	LocationContainer.onRoomSelected = func(data:Dictionary) -> void:
		# update structure
		print(data)
		
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	START GAME
#region START GAME
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
#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	SHOW/HIDE CONTAINERS
#region show/hide functions
func get_all_container_nodes(exclude:Array = []) -> Array:
	return [
		Structure3dContainer, LocationContainer, ActionQueueContainer, 
		ItemStatusContainer, ActionContainer, ResourceContainer, 
		DialogueContainer, StoreContainer, ItemSelectContainer, 
		ConfirmModal, RecruitContainer
	].filter(func(node): return node not in exclude)
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------
func capture_default_showing_state() -> void:
	for node in get_all_container_nodes():
		showing_states[node] = node.is_showing
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func restore_default_state() -> void:
	for node in get_all_container_nodes():
		node.is_showing = showing_states[node]
	await U.set_timeout(0.3)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func show_only(nodes:Array = []) -> void:
	var show_filter:Array = get_all_container_nodes().filter(func(node): return node in nodes)
	var hide_filter:Array = get_all_container_nodes().filter(func(node): return node not in nodes)
	
	for node in hide_filter:
		if node.is_showing != false:
			node.is_showing = false
	await U.set_timeout(0.3)
	
	for node in show_filter:
		if node.is_showing != true:
			node.is_showing = true
			
	await U.set_timeout(0.3)
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	ON_SHOW_UPDATES
#region on_show_updates
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

func on_show_confirm_modal_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		ConfirmModal.is_showing = show_confirm_modal
		showing_states[ConfirmModal] = show_confirm_modal

func on_show_recruit_update() -> void:
	if is_node_ready() or Engine.is_editor_hint():
		RecruitContainer.is_showing = show_recruit
		showing_states[RecruitContainer] = show_recruit

func _on_container_rect_changed() -> void:	
	if is_node_ready() or Engine.is_editor_hint():
		for sidebar in [ItemStatusContainer, ActionQueueContainer]:
			sidebar.max_height = self.size.y

#endregion
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	SHOP STEPS
#region SHOP STATES
func on_current_shop_step_update() -> void:
	if !is_node_ready() and !Engine.is_editor_hint():return
	match current_shop_step:
		# ---------------
		SHOP_STEPS.HIDE:
			await restore_default_state()
		# ---------------
		SHOP_STEPS.START:
			await show_only([ResourceContainer, StoreContainer, ActionQueueContainer, ItemStatusContainer])
			current_shop_step = SHOP_STEPS.WAIT_FOR_USER
		# ---------------
		SHOP_STEPS.WAIT_FOR_USER:
			var response:Dictionary = await StoreContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.BACK:
					current_shop_step = SHOP_STEPS.HIDE
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.CONFIRM_LOCATION
		# ---------------
		SHOP_STEPS.CONFIRM_LOCATION:
			await show_only([LocationContainer, ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_shop_step = SHOP_STEPS.START
				ACTION.NEXT:
					current_shop_step = SHOP_STEPS.FINALIZE
		# ---------------
		SHOP_STEPS.FINALIZE:
			# do something with data
			current_shop_step = SHOP_STEPS.HIDE
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	CONTAIN STEPS
#region CONTAIN STEPS
func on_current_contain_step_update() -> void:
	if !is_node_ready() and !Engine.is_editor_hint():return
	match current_contain_step:
		# ---------------
		CONTAIN_STEPS.HIDE:
			await restore_default_state()
		# ---------------
		CONTAIN_STEPS.START:
			await show_only([ResourceContainer, ItemSelectContainer, ActionQueueContainer, ItemStatusContainer])
			current_contain_step = CONTAIN_STEPS.WAIT_FOR_USER
		# ---------------
		CONTAIN_STEPS.WAIT_FOR_USER:
			var response:Dictionary = await ItemSelectContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			match response.action:
				ACTION.BACK:
					current_contain_step = CONTAIN_STEPS.HIDE
				ACTION.NEXT:
					current_contain_step = CONTAIN_STEPS.CONFIRM_LOCATION
		# ---------------
		CONTAIN_STEPS.CONFIRM_LOCATION:
			await show_only([LocationContainer, ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_contain_step = CONTAIN_STEPS.START
				ACTION.NEXT:
					current_contain_step = CONTAIN_STEPS.FINALIZE
		# ---------------
		CONTAIN_STEPS.FINALIZE:
			# do something with data
			current_contain_step = CONTAIN_STEPS.HIDE	
#endregion
# ------------------------------------------------------------------------------		

# ------------------------------------------------------------------------------	RECRUIT STEPS
#region RECRUIT STEPS
func on_current_recruit_step_update() -> void:
	if !is_node_ready() and !Engine.is_editor_hint():return

	match current_recruit_step:
		# ---------------
		RECRUIT_STEPS.HIDE:
			await restore_default_state()
		# ---------------
		CONTAIN_STEPS.START:
			await show_only([ResourceContainer, RecruitContainer, ActionQueueContainer, ItemStatusContainer])
			current_recruit_step = RECRUIT_STEPS.WAIT_FOR_USER
		# ---------------
		CONTAIN_STEPS.WAIT_FOR_USER:
			var response:Dictionary = await RecruitContainer.user_response
			GBL.change_mouse_icon(GBL.MOUSE_ICON.CURSOR)
			print(response)
			match response.action:
				ACTION.BACK:
					current_recruit_step = RECRUIT_STEPS.HIDE
				ACTION.NEXT:
					current_recruit_step = RECRUIT_STEPS.CONFIRM_LOCATION
		# ---------------
		RECRUIT_STEPS.CONFIRM_LOCATION:
			await show_only([LocationContainer, ConfirmModal])
			var response:Dictionary = await ConfirmModal.user_response
			match response.action:
				ACTION.BACK:
					current_recruit_step = RECRUIT_STEPS.START
				ACTION.NEXT:
					current_recruit_step = RECRUIT_STEPS.FINALIZE
		# ---------------
		RECRUIT_STEPS.FINALIZE:
			# do something with data
			current_recruit_step = RECRUIT_STEPS.HIDE	
#endregion
# ------------------------------------------------------------------------------		


# ------------------------------------------------------------------------------	CONTROLS
#region CONTROL UPDATE
func on_control_input_update(input_data:Dictionary) -> void:
	var key:String = input_data.key
	var keycode:int = input_data.keycode
	print("key: %s   keycode: %s" % [key, keycode])
	match key:
		"5":
			quicksave()
		"8":
			quickload()
		
#endregion
# ------------------------------------------------------------------------------	

# ------------------------------------------------------------------------------	SAVE/LOAD
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
# ------------------------------------------------------------------------------
