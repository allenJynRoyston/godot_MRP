extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var GridSelect:Control = $GridSelect
@onready var TransitionScreen:Control = $TransistionScreen

# summary
@onready var SummaryPanel:Control = $SummaryControl/PanelContainer
@onready var SummaryMargin:MarginContainer = $SummaryControl/PanelContainer/MarginContainer
@onready var SummaryCard:Control = $SummaryControl/PanelContainer/MarginContainer/SummaryCard

# cost
@onready var CostPanel:Control = $ResearcherPanel/MarginContainer/VBoxContainer/CostPanel
@onready var ResearchPanel:Control = $ResearcherPanel/MarginContainer/VBoxContainer/ResearchPanel

# minicards
const ShopMiniCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ShopMiniCard/ShopMiniCard.tscn")

var made_changes:bool = false
var current_category:int
var selected_ref:int = -1
var selected_node:Control

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
	on_resources_data_update()	

func activate() -> void:
	await U.tick()

	control_pos[SummaryPanel] = {
		"show": 0, 
		"hide": -SummaryMargin.size.x
	}	
	await U.tick()

	SummaryPanel.position.x = control_pos[SummaryPanel].hide
	SummaryCard.use_location = current_location
	await U.tick()
	
func setup_gridselect() -> void:
	# ---------------- GRID_SELECT CONFIG
	GridSelect.tabs = [
		{
			"title": "DEPARTMENTS",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				current_category = ROOM.CATEGORY.DEPARTMENT
				return ROOM_UTIL.get_category(ROOM.CATEGORY.DEPARTMENT, start_at, end_at),
		},
		{
			"title": "NODES",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				current_category = ROOM.CATEGORY.UTILITY
				return ROOM_UTIL.get_category(ROOM.CATEGORY.UTILITY, start_at, end_at),
		},
	]
	
	GridSelect.onModeTab = func() -> void:
		ResearchPanel.modulate.a = 1 
		CostPanel.modulate.a = 1 
		reveal_node(SummaryPanel, false)
		GridSelect.deselect_all()
	
	GridSelect.onModeContent = func() -> void:
		await U.set_timeout(0.2)
		reveal_node(SummaryPanel, true)
	
	GridSelect.onUpdate = func(node:Control, data:Dictionary, index:int) -> void:
		if GridSelect.current_mode != GridSelect.MODE.CONTENT_SELECT:return
		selected_ref = data.ref
		selected_node = node
		U.debounce( str(self, "_update_node"), update_node )

	GridSelect.onUpdateEmptyNode = func(node:Control) -> void:
		node.ref = -1
	
	GridSelect.onUpdateNode = func(node:Control, data:Dictionary, index:int) -> void:		
		node.index = index
		node.ref = data.ref
	
	GridSelect.onValidCheck = func(node:Control) -> bool:
		return node.ref != -1
	
	GridSelect.onAction = func():
		if GridSelect.current_mode != GridSelect.MODE.CONTENT_SELECT or selected_ref == -1:return
		if selected_node.requires_unlock:
			unlock_room(selected_ref)
		else:
			purchase_room(selected_ref)
		

	GridSelect.onEnd = func():
		end()	

func start() -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	await TransitionScreen.start()	
	setup_gridselect()		
	
	var init_func:Callable = func(node:Control) -> void:
		node.ref = -1
		
	GridSelect.start(ShopMiniCardPreload, 0, init_func)
	on_resources_data_update()
	
	
func end() -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 0), 0.3)	
	await TransitionScreen.end()
	user_response.emit(made_changes)
	queue_free()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal_node(node:Control, state:bool, duration:float = 0.3) -> void:
	await U.tween_node_property(node, "position:x", control_pos[node].show if state else control_pos[node].hide, duration)	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func purchase_room(ref:int) -> void:
	match current_category:
		ROOM.CATEGORY.UTILITY:
			if ref not in base_states.utility_cards:
				base_states.utility_cards[ref] = 0
			base_states.utility_cards[ref] += 1
		ROOM.CATEGORY.DEPARTMENT:
			if ref not in base_states.department_cards:
				base_states.department_cards[ref] = 0
			base_states.department_cards[ref] += 1
	

	GridSelect.BtnControls.disable_active_btn = true
	resources_data[RESOURCE.CURRENCY.MATERIAL].amount -= ROOM_UTIL.return_purchase_cost(ref)
	
	SUBSCRIBE.resources_data = resources_data
	SUBSCRIBE.base_states = base_states	
		
	await selected_node.play_purchase_animation()
	GridSelect.BtnControls.disable_active_btn = false		
	made_changes = true
	
	U.debounce( str(self, "_update_node"), update_node )
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func unlock_room(ref:int) -> void:
	await GridSelect.freeze_and_disable(true, true)
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)
	
	var activation_requirements:Array = [{
		"amount": -ROOM_UTIL.return_unlock_costs(ref), 
		"resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.SCIENCE)
	}]
	
	made_changes = await GAME_UTIL.create_modal("Unlock %s?" % room_details.name, room_details.description, room_details.img_src, activation_requirements, false)
	if made_changes:
		await GAME_UTIL.open_tally( {RESOURCE.CURRENCY.SCIENCE: -ROOM_UTIL.return_unlock_costs(ref)} )
		ROOM_UTIL.add_to_unlocked_list(room_details.ref)
		GameplayNode.ToastContainer.add("Unlocked %s!" % [room_details.name])
		await U.tick()

	GridSelect.refresh()
	GridSelect.freeze_and_disable(false, true)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
	U.debounce( str(self, "_update_node"), update_node )
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------			
func can_afford_check(cost:int, requires_unlock:bool) -> bool:
	return resources_data[RESOURCE.CURRENCY.SCIENCE if requires_unlock else RESOURCE.CURRENCY.MATERIAL].amount >= abs(cost)
# --------------------------------------------------------------------------------------------------			

# --------------------------------------------------------------------------------------------------			
func update_node() -> void:	
	if !is_node_ready() or resources_data.is_empty():
		return
		
	CostPanel.amount = str(resources_data[RESOURCE.CURRENCY.MATERIAL].amount)
	ResearchPanel.amount = str(resources_data[RESOURCE.CURRENCY.SCIENCE].amount)
		
	if selected_node == null or selected_ref == -1:
		return
	
	var requires_unlock:bool = selected_node.requires_unlock
	var can_afford:bool = can_afford_check( ROOM_UTIL.return_unlock_costs(selected_ref) if requires_unlock else ROOM_UTIL.return_purchase_cost(selected_ref), requires_unlock )
	
	SummaryCard.preview_mode_ref = selected_ref
	GridSelect.BtnControls.disable_active_btn = !can_afford
	GridSelect.BtnControls.a_btn_title = "RESEARCH" if requires_unlock else 'FABRICATE'	

	ResearchPanel.modulate.a = 1 if requires_unlock else 0.75
	CostPanel.modulate.a = 1 if !requires_unlock else 0.75

	if requires_unlock:
		ResearchPanel.is_negative = !can_afford	
	else:
		CostPanel.is_negative = !can_afford		
	

# --------------------------------------------------------------------------------------------------			
