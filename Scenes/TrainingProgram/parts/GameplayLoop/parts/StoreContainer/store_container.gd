@tool
extends GameContainer

@onready var CloseBtn:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/CloseBtn
@onready var GridItemContainer:GridContainer = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ScrollContainer/MarginContainer/GridContainer
@onready var FocusDetails:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/FocusDetails
@onready var CategoryContainer:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer/CategoryContainer

@onready var PaginationBack:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer2/PaginationBackBtn
@onready var PaginationMore:Control = $SubViewport/PanelContainer/MarginContainer/PanelContainer/HBoxContainer/PanelContainer2/MarginContainer/VBoxContainer/HBoxContainer2/PaginationMoreBtn

const StoreItemPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/StoreContainer/parts/StoreItem/StoreItem.tscn")
const TextBtnPreload:PackedScene = preload("res://UI/Buttons/TextBtn/TextBtn.tscn")

var focus_data:Dictionary = {} : 
	set(val):
		focus_data = val
		on_focus_data_update()

var filters:Dictionary = {} : 
	set(val):
		filters = val
		on_filters_update()

var active_filters:Array = [] : 
	set(val):
		active_filters = val
		
var is_busy:bool = false
var pagination:int = 0 : 
	set(val):
		pagination = val
		on_pagination_update()
		
var limit:int = 6

signal user_response

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	
	TextureRectNode = $TextureRect
	Subviewport = $SubViewport

	CloseBtn.onClick = func() -> void:
		user_response.emit({"action": ACTION.BACK})
		
	PaginationBack.onClick = func() -> void:
		pagination = pagination - 1
	PaginationMore.onClick = func() -> void:
		pagination = pagination + 1
		

	var category_data:Dictionary = ROOM_UTIL.get_categories()
	for item in category_data.list:
		var new_node:Control = TextBtnPreload.instantiate()
		new_node.title = item.details.name
		new_node.icon = SVGS.TYPE.MINUS
		new_node.onClick = func() -> void:
			if !is_busy:
				filters[item.id].active = !filters[item.id].active
				filters = filters
				build_list()
			
		CategoryContainer.add_child(new_node)
		
		filters[item.id] = {
			"active": false, 
			"node_ref": new_node
		}
	filters = filters

	on_focus_data_update()
	on_filters_update()
	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func start() -> void:	
	build_list()
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func on_pagination_update() -> void:
	build_list()
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------			
func build_list() -> void:
	var start_at:int = pagination * limit
	var list_data:Dictionary = ROOM_UTIL.get_rooms(active_filters, start_at, limit)

	PaginationBack.hide() if pagination == 0 else PaginationBack.show()
	PaginationMore.show() if list_data.has_more else PaginationMore.hide()
	
	for child in GridItemContainer.get_children():
		child.queue_free()

	for item in list_data.list:
		var new_node:Control = StoreItemPreload.instantiate()
		new_node.resources_data = resources_data
		new_node.data = item
		
		new_node.onClick = func() -> void:
			user_response.emit({
				"action": ACTION.NEXT, 
				"selected": {
					"uid": U.generate_uid(),
					"id": item.id
				}
			})
		
		new_node.onFocus = func(node:Control) -> void:			
			update_focus_data.call_deferred(item)
		
		new_node.onBlur = func(node:Control) -> void:
			update_focus_data.call({})
			
		GridItemContainer.add_child(new_node)	
		
	await U.set_timeout(0.2)
	is_busy = false		
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func end() -> void:
	for child in GridItemContainer.get_children():
		child.queue_free()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_filters_update() -> void:
	var _active_filters = []
	for key in filters:
		var item:Dictionary = filters[key]
		item.node_ref.icon = SVGS.TYPE.PLUS if item.active else SVGS.TYPE.MINUS
		if item.active:
			_active_filters.push_back(key)
			
	active_filters = _active_filters
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------		
func update_focus_data(new_state:Dictionary):
	focus_data = new_state
# --------------------------------------------------------------------------------------------------		
		
# --------------------------------------------------------------------------------------------------		
func on_focus_data_update() -> void:
	if is_node_ready():
		FocusDetails.hide_details = !focus_data.is_empty()
		FocusDetails.data = focus_data
# --------------------------------------------------------------------------------------------------			
