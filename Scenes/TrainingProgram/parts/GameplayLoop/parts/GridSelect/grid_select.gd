extends PanelContainer

@onready var TabPanel:PanelContainer = $TabControl/PanelContainer
@onready var TabMargin:MarginContainer = $TabControl/PanelContainer/MarginContainer 
@onready var Tabs:HBoxContainer = $TabControl/PanelContainer/MarginContainer/Categories/Tabs

@onready var HeaderPanel:PanelContainer = $HeaderControl/PanelContainer
@onready var HeaderMargin:MarginContainer = $HeaderControl/PanelContainer/MarginContainer
@onready var HeaderLabel:Label = $HeaderControl/PanelContainer/MarginContainer/HBoxContainer/HeaderLabel

@onready var ContentPanel:PanelContainer = $ContentControl/PanelContainer
@onready var ContentMargin:MarginContainer = $ContentControl/PanelContainer/MarginContainer
@onready var LessBtn:BtnBase = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/LessBtn
@onready var MoreBtn:BtnBase = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MoreBtn
@onready var GridContent:GridContainer = $ContentControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/MarginContainer/GridContainer

@onready var BtnControls:Control = $BtnControls

const TabBtnPreload:PackedScene = preload("res://UI/Buttons/TabBtn/TabBtn.tscn")

enum MODE {HIDE, TAB_SELECT, CONTENT_SELECT}

var freeze_inputs:bool = false
var is_animating:bool = false
var control_pos_default:Dictionary = {}
var control_pos:Dictionary = {}

var current_mode:MODE = MODE.HIDE : 
	set(val):
		current_mode = val
		on_current_mode_update()

var tab_index:int = 0 : 
	set(val):
		tab_index = val
		on_tab_index_update()
		
var grid_index:int = 0 : 
	set(val):
		grid_index = val
		on_grid_index_update()

var has_more:bool = false
var grid_list_data:Array
var tabs:Array = [] : 
	set(val):
		tabs = val
		on_tabs_update()

var page_tracker:Dictionary = {}

var grid_as_array:Array = [
	[0, 1, 2],
	[3, 4, 5],
	[6, 7, 8],
]

var onEnd:Callable = func() -> void:pass
var onAction:Callable = func() -> void:pass

var onModeTab:Callable = func() -> void:pass
var onModeContent:Callable = func() -> void:pass

var onTabUpdate:Callable = func(_tab_index:int) -> void:pass

var onUpdateEmptyNode:Callable = func(_node:Control) -> void:pass
var onUpdateNode:Callable = func(_node:Control, _data:Dictionary, _index:int) -> void:pass

var onUpdate:Callable = func(_node:Control, _data:Dictionary, _index:int) -> void:pass

var onValidCheck:Callable = func(_node:Control) -> bool:
	return true
	

signal mode_updated

# --------------------------------------------------------------------------------------------------			
func _ready() -> void:
	clear()
	self.modulate = Color(1, 1, 1, 0)
	BtnControls.onDirectional = on_key_press
	BtnControls.freeze_and_disable(true)
	
	await U.tick()
	control_pos[HeaderPanel]  = {
		"show": 0, 
		"hide": -HeaderMargin.size.y
	}
	control_pos[TabPanel] = {
		"show": 0, 
		"hide": -TabMargin.size.y
	}
	
	control_pos[ContentPanel] = {
		"show": 0, 
		"hide": -ContentMargin.size.y
	}	
	
	await U.tick()
	HeaderPanel.position.y = control_pos[HeaderPanel].hide
	TabPanel.position.y = control_pos[TabPanel].hide
	ContentPanel.position.y = control_pos[ContentPanel].hide


func start(use_node:PackedScene, init_func:Callable) -> void:
	for n in range(0, 9):
		var new_node:Control = use_node.instantiate()
		init_func.call(new_node)
		GridContent.add_child(new_node)
		
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	current_mode = MODE.TAB_SELECT
	
	on_tab_index_update()
	
func end() -> void:
	BtnControls.freeze_and_disable(true)
	reveal_header(false)
	reveal_content(false)
	reveal_tabs(false)
	await BtnControls.reveal(false)
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 0), 0.3)	
	onEnd.call()

func clear() -> void:
	for node in [Tabs, GridContent]:
		for child in node.get_children():
			child.free()
			
	page_tracker = {}
	HeaderLabel.text = ""
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------
func on_tabs_update() -> void:
	if !is_node_ready():return
	for index in tabs.size():
		var tab:Dictionary = tabs[index]
		var tab_node:Control = TabBtnPreload.instantiate()
		tab_node.title = tab.title
		Tabs.add_child(tab_node)
		page_tracker[index] = 0
				
func on_tab_index_update() -> void:
	if !is_node_ready():return
	onTabUpdate.call(tab_index)
	
	for n in GridContent.get_child_count():
		var node:Control = GridContent.get_child(n)
		if "is_hoverable" in node:
			node.is_hoverable = false
		if "reset" in node:
			node.reset()					
	
	await U.tick()
	
	for index in Tabs.get_child_count():
		var tab:Control = Tabs.get_child(index)
		# ---------------------------------------
		tab.onFocus = func(node:Control) -> void:
			if current_mode != MODE.TAB_SELECT:return
			tab.is_selected = true
			tab_index = index
			update_grid_content(index)
		# ---------------------------------------
		tab.onBlur = func(node:Control) -> void:
			if current_mode != MODE.TAB_SELECT:return
			tab.is_selected = false
		# ---------------------------------------
		tab.onClick = func() -> void:
			if current_mode != MODE.TAB_SELECT:return
			HeaderLabel.text = tab.title
			current_mode = MODE.CONTENT_SELECT			
			await U.tick()
			grid_index = 0
			

# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func on_grid_index_update() -> void:
	if !is_node_ready() or grid_index == -1 or grid_list_data.is_empty():return
	BtnControls.item_index = grid_index

	if current_mode == MODE.CONTENT_SELECT:
		for index in GridContent.get_child_count():
			var node:Control = GridContent.get_child(index)
			if "is_highlighted" in node:
				node.is_highlighted = index == grid_index
				
	onUpdate.call(GridContent.get_child(grid_index), grid_list_data[grid_index], grid_index)
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------				
func reveal_header(show:bool = true, duration:float = 0.3) -> void:
	await U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].show if show else control_pos[HeaderPanel].hide, duration)

func reveal_content(show:bool, duration:float = 0.3) -> void:
	await U.tween_node_property(ContentPanel, "position:y", control_pos[ContentPanel].show if show else control_pos[ContentPanel].hide, duration)	
	
func reveal_tabs(show:bool, duration:float = 0.3) -> void:
	await U.tween_node_property(TabPanel, "position:y", control_pos[TabPanel].show if show else control_pos[TabPanel].hide, duration)	
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------				
func freeze_and_disable(state:bool, animate:bool = false) -> void:
	if animate:
		await BtnControls.reveal(!state)

	for n in GridContent.get_child_count():
		var card_node:Control = GridContent.get_child(n)
		if "freeze_inputs" in card_node:
			card_node.freeze_inputs = state
			
	BtnControls.freeze_and_disable(state)	
	freeze_inputs = state
# --------------------------------------------------------------------------------------------------				

# --------------------------------------------------------------------------------------------------		
func update_grid_content(index:int = tab_index) -> void:
	var grid_size:int = GridContent.get_child_count() 
	var start_at:int = page_tracker[index] * grid_size
	var end_at:int = start_at + grid_size
	var query:Dictionary = tabs[index].onSelect.call(index, start_at, end_at)

	if query.is_empty():
		BtnControls.disable_active_btn = true
		return
	
	BtnControls.disable_active_btn = query.list.size() == 0
	# reset show/hide more buttons	
	has_more = query.has_more
	MoreBtn.modulate = Color(1, 1, 1, 1 if has_more else 0) 
	MoreBtn.is_hoverable = has_more
	
	MoreBtn.onClick = func() -> void:
		page_tracker[index] = page_tracker[index] + 1
		update_grid_content()
	
	LessBtn.onClick = func() -> void:
		if page_tracker[index] > 0:
			page_tracker[index] = page_tracker[index] - 1
			update_grid_content()	
			
	LessBtn.modulate = Color(1, 1, 1, 0 if page_tracker[index] == 0 else 1) 
	LessBtn.is_hoverable = page_tracker[index] > 0

	grid_list_data = query.list
	for n in GridContent.get_child_count():
		var card_node:Control = GridContent.get_child(n)
		if grid_list_data.size() - 1 < n:
			onUpdateEmptyNode.call(card_node)
		else:	
			onUpdateNode.call(card_node, grid_list_data[n], n)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------			
func is_valid_selection(index:int) -> bool:
	if index > GridContent.get_child_count() - 1 or index < 0:
		return false
	return onValidCheck.call(GridContent.get_child(index))

func find_nearest_valid(start_at:int, reverse:bool = false) -> void:
	var nearest_val:int = GridContent.columns - 1
	
	for n in range(start_at + nearest_val, 0, -1) if reverse else [start_at - nearest_val, 8, 4, 0]:
		if is_valid_selection(n):
			grid_index = n
			return
	
	grid_index = 0 
# --------------------------------------------------------------------------------------------------				



# --------------------------------------------------------------------------------------------------				
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return
	var duration:float = 0 if skip_animation else 0.3
	is_animating = true
	
	match current_mode:
		# -------------------
		MODE.HIDE:
			BtnControls.freeze_and_disable(true)
			reveal_header(false, duration)
			await reveal_content(false, duration)
			await BtnControls.reveal(false)
		# -------------------
		MODE.TAB_SELECT:
			BtnControls.freeze_and_disable(true)
			reveal_header(false, duration)
			reveal_tabs(true)
			await reveal_content(true)			
			
			BtnControls.itemlist = Tabs.get_children()
			BtnControls.directional_pref = "LR"
			BtnControls.disable_active_btn = false
			
			BtnControls.onBack = func() -> void:
				end()
			BtnControls.onAction = func() -> void:
				pass
				
			await BtnControls.reveal(true)
			BtnControls.item_index = tab_index

			for n in GridContent.get_child_count():
				var node:Control = GridContent.get_child(n)
				if "is_hoverable" in node:
					node.is_hoverable = false
				if "reset" in node:
					node.reset()
			
			BtnControls.freeze_and_disable(false)
			onModeTab.call()
		# -------------------
		MODE.CONTENT_SELECT:
			BtnControls.freeze_and_disable(true)
			await reveal_tabs(false)
			await reveal_header(true)
						
			BtnControls.directional_pref = "NONE"
			BtnControls.itemlist = GridContent.get_children()
			
			BtnControls.onBack = func() -> void:
				BtnControls.freeze_and_disable(true)
				await reveal_header(false, duration)
				current_mode = MODE.TAB_SELECT
			BtnControls.onAction = func() -> void:
				pass
				
			await U.tick()
			BtnControls.item_index = 0
			
			for n in GridContent.get_child_count():
				var node:Control = GridContent.get_child(n)
				if "is_hoverable" in node:
					node.is_hoverable = true
					
			BtnControls.freeze_and_disable(false)
			onModeContent.call()
		# -------------------
	
	is_animating = false
	mode_updated.emit()
# --------------------------------------------------------------------------------------------------				


# --------------------------------------------------------------------------------------------------
func on_key_press(key:String) -> void:
	if !is_visible_in_tree() or !is_node_ready() or freeze_inputs or is_animating: 
		return
	
	var columns:int = GridContent.columns
		
	match key:
		"W":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in grid_as_array[0] and is_valid_selection(grid_index - columns):
						grid_index = grid_index - columns
					#
		"S":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in grid_as_array[2] and is_valid_selection(grid_index + columns):
						grid_index = grid_index + columns
#
		"A":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in [0, 3, 6]:
						if is_valid_selection(grid_index - 1):
							grid_index = grid_index - 1
					elif page_tracker[tab_index] > 0:
						page_tracker[tab_index] = page_tracker[tab_index] - 1
						update_grid_content()
						find_nearest_valid(grid_index, true)

		"D":
			match current_mode:
				MODE.CONTENT_SELECT:
					if grid_index not in [2, 5, 8]:
						if is_valid_selection(grid_index + 1):
							grid_index = grid_index + 1
					elif has_more:
						page_tracker[tab_index] = page_tracker[tab_index] + 1
						update_grid_content()
						find_nearest_valid(grid_index, false)
		
# --------------------------------------------------------------------------------------------------
