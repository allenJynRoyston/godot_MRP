extends PanelContainer

@onready var Structure3dContainer:Control = $Structure3DContainer
@onready var LocationContainer:Control = $LocationContainer
@onready var ActionQueueContainer:Control = $ActionQueueContainer
@onready var ItemStatusContainer:Control = $ItemStatusContainer
@onready var ActionContainer:Control = $ActionContainer
@onready var ResourceContainer:Control = $ResourceContainer
@onready var DialogueContainer:Control = $DialogueContainer

@onready var show_structures:bool = true: 
	set(val):
		show_structures = val
		on_show_structures_update()
		
@onready var show_location:bool = true : 
	set(val):
		show_location = val
		on_show_location_update()

@onready var show_action_queue:bool = true : 
	set(val):
		show_action_queue = val
		on_show_action_queue_update()
		
@onready var show_item_status:bool = true : 
	set(val):
		show_item_status = val
		on_show_item_status_update()

@onready var show_actions:bool = true : 
	set(val):
		show_actions = val
		on_show_actions_update()

@onready var show_resources:bool = true : 
	set(val):
		show_resources = val
		on_show_resources_update()

@onready var show_dialogue:bool = true : 
	set(val):
		show_dialogue = val
		on_show_dialogue_update()

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.register_node(REFS.GAMEPLAY_LOOP, self)
	
func _exit_tree() -> void:
	GBL.unregister_node(REFS.GAMEPLAY_LOOP)
	
func _ready() -> void:
	hide()
	set_process(false)
	set_physics_process(false)	
	
	on_show_structures_update()
	on_show_actions_update()
	on_show_resources_update()
	on_show_location_update()
	on_show_action_queue_update()
	on_show_item_status_update()
	on_show_dialogue_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func start(game_data:Dictionary = {}) -> void:
	show()
	set_process(true)
	set_physics_process(true)	
	_on_container_rect_changed()
	
	if game_data.is_empty():
		start_new_game()
	else:
		restore_game()

func start_new_game() -> void:
	print('new')

func restore_game() -> void:
	print('restore')
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_show_location_update() -> void:
	LocationContainer.is_showing = show_location
	
func on_show_structures_update() -> void:
	Structure3dContainer.is_showing = show_structures
	
func on_show_actions_update() -> void:
	ActionContainer.is_showing = show_actions
	
func on_show_action_queue_update() -> void:
	ActionQueueContainer.is_showing = show_action_queue

func on_show_item_status_update() -> void:
	ItemStatusContainer.is_showing = show_item_status

func on_show_resources_update() -> void:
	ResourceContainer.is_showing = show_resources
	
func on_show_dialogue_update() -> void:
	DialogueContainer.is_showing = show_dialogue

func _on_container_rect_changed() -> void:	
	if is_node_ready():
		for sidebar in [ItemStatusContainer, ActionQueueContainer]:
			sidebar.max_height = self.size.y
# ------------------------------------------------------------------------------	
