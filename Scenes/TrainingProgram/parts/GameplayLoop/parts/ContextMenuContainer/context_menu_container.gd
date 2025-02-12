@tool
extends GameContainer

@onready var ListContainer:Control = $ListContainer

var menu_item:Dictionary = {} : 
	set(val):
		menu_item = val
		on_menu_list_update()
		

const ContextMenuItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ContextMenuContainer/parts/ContextMenuItem.tscn")

func _init() -> void:
	super._init()
	SUBSCRIBE.subscribe_to_menu_context(self)
	
func _exit_tree() -> void:
	super._exit_tree()
	SUBSCRIBE.unsubscribe_to_menu_context(self)	

# -----------------------------------------------
func _ready() -> void:
	super._ready()	
	on_reset()
	on_menu_list_update()
# -----------------------------------------------

# -----------------------------------------------
func on_reset() -> void:
	for child in ListContainer.get_children():
		child.queue_free()
# -----------------------------------------------		

# -----------------------------------------------		
func update_active_node() -> void:
	await U.tick()
	for index in ListContainer.get_child_count():		
		var child:Control = ListContainer.get_child(index)
		child.freeze_input = index != ListContainer.get_child_count() - 1
# -----------------------------------------------		

# -----------------------------------------------
func on_menu_context_update(new_val:Dictionary) -> void:
	menu_item = new_val
# -----------------------------------------------

# -----------------------------------------------		
func on_menu_list_update() -> void:
	if !is_node_ready() or menu_item.is_empty():return
	var previous_node_data:Dictionary = {}
	if ListContainer.get_child_count() > 0:
		var previous_node:Control = ListContainer.get_child(ListContainer.get_child_count() - 1)
		previous_node_data = previous_node.get_menu_content()
	
	var new_node:Control = ContextMenuItemPreload.instantiate()
	#new_node.position.y = -self.size.y	
	new_node.data = {"menu": menu_item, "previous_node_data": previous_node_data}
	new_node.onRemoved = func() -> void:
		update_active_node()
	ListContainer.add_child(new_node)
	await U.tick()
	#await new_node.animate_in()
	
	update_active_node()
# -----------------------------------------------		
#
## ------------------------------------------------------------------------------
#func on_control_input_update(input_data:Dictionary) -> void:
	#var key:String = input_data.key
	#match key:
		#"1":
			#SUBSCRIBE.menu_context = {"placement": GBL.PLACEMENT.LEFT}
		#"2":
			#SUBSCRIBE.menu_context = {"placement": GBL.PLACEMENT.TOP}
		#"3":
			#SUBSCRIBE.menu_context = {"placement": GBL.PLACEMENT.RIGHT}
		#"4":
			#SUBSCRIBE.menu_context = {"placement": GBL.PLACEMENT.BOTTOM}	
## ------------------------------------------------------------------------------
