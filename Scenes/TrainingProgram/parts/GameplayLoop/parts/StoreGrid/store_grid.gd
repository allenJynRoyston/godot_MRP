extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG

@onready var GridSelect:Control = $GridSelect
@onready var DetailPanel:Control = $DetailPanel
@onready var TransitionScreen:Control = $TransistionScreen

@onready var SummaryPanel:Control = $SummaryControl/PanelContainer
@onready var SummaryMargin:MarginContainer = $SummaryControl/PanelContainer/MarginContainer
@onready var SummaryCard:Control = $SummaryControl/PanelContainer/MarginContainer/VBoxContainer/SummaryCard
@onready var SummaryImage:TextureRect = $SummaryControl/PanelContainer/MarginContainer/SummaryImage

@onready var CostPanel:Control = $SummaryControl/PanelContainer/MarginContainer/VBoxContainer/MarginContainer2/CostPanel

const ShopMiniCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ShopMiniCard/ShopMiniCard.tscn")

var made_changes:bool = false

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
	await U.tick()
	
func setup_gridselect() -> void:
	#var room_unlock_level:int = 9 #room_config.base.room_unlock_val
	# ---------------- GRID_SELECT CONFIG
	GridSelect.tabs = [
		{
			"title": "RESOURCE",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return ROOM_UTIL.get_category(ROOM.CATEGORY.RESOURCES, start_at, end_at),
		},
		{
			"title": "RECRUITMENT",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return ROOM_UTIL.get_category(ROOM.CATEGORY.RECRUITMENT, start_at, end_at),
		},
		{
			"title": "ENERGY",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return ROOM_UTIL.get_category(ROOM.CATEGORY.ENERGY, start_at, end_at),
		},
		{
			"title": "CONTAINMENT",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return ROOM_UTIL.get_category(ROOM.CATEGORY.CONTAINMENT, start_at, end_at),
		},
		{
			"title": "UTILITY",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return ROOM_UTIL.get_category(ROOM.CATEGORY.UTILITY, start_at, end_at),
		},		
	]
	
	GridSelect.onModeTab = func() -> void:
		reveal_node(SummaryPanel, false)
		DetailPanel.reveal(false)
	
	GridSelect.onModeContent = func() -> void:
		reveal_node(SummaryPanel, true)
		DetailPanel.reveal(true)
	
	GridSelect.onUpdate = func(node:Control, data:Dictionary, index:int) -> void:
		var can_afford:bool = can_afford_check( ROOM_UTIL.return_unlock_costs(data.ref) )
		var show_card:bool = node.show_card
		
		DetailPanel.reveal(show_card)
		DetailPanel.room_ref = data.ref if show_card else -1
		CostPanel.amount =resources_data[RESOURCE.CURRENCY.SCIENCE].amount
		CostPanel.is_negative = !can_afford
		SummaryImage.texture = CACHE.fetch_image(data.details.img_src)
		
		GridSelect.BtnControls.disable_active_btn = !can_afford or !node.is_clickable
		
		if data.details.requires_unlock:
			if data.ref in shop_unlock_purchases:
				GridSelect.BtnControls.disable_active_btn = true
		else:
			GridSelect.BtnControls.disable_active_btn = true
			
	
	GridSelect.onUpdateEmptyNode = func(node:Control) -> void:
		node.ref = -1
		node.onHover = func() -> void: pass
		node.onClick = func() -> void: pass		
	
	GridSelect.onUpdateNode = func(node:Control, data:Dictionary, index:int) -> void:		
		node.index = index
		node.ref = data.ref
		node.is_hoverable = true
				
		node.onHover = func() -> void:
			if GridSelect.current_mode != GridSelect.MODE.CONTENT_SELECT:return
			GridSelect.grid_index = index
			SummaryCard.room_ref = data.ref
			
		node.onClick = func() -> void:
			if GridSelect.current_mode != GridSelect.MODE.CONTENT_SELECT:return
			GridSelect.grid_index = index
			await U.tick()
			if data.ref not in shop_unlock_purchases:
				unlock_room(data.ref)
	
	GridSelect.onValidCheck = func(node:Control) -> bool:
		return node.ref != -1
	
	GridSelect.onAction = func():
		pass
		
	GridSelect.onEnd = func():
		end()	

func start() -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	await TransitionScreen.start()	
	setup_gridselect()		
	
	var init_func:Callable = func(node:Control) -> void:
		node.ref = -1
		
	GridSelect.start(ShopMiniCardPreload, 0, init_func)
	
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
func unlock_room(ref:int) -> void:
	await GridSelect.freeze_and_disable(true, true)
	var room_details:Dictionary = ROOM_UTIL.return_data(ref)
	
	var activation_requirements:Array = [{
		"amount": -room_details.costs.unlock, 
		"resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.SCIENCE)
	}]
	
	var confirm:bool = await GAME_UTIL.create_modal("Unlock %s?" % room_details.name, room_details.description, room_details.img_src, activation_requirements, false)
	if confirm:
		ROOM_UTIL.add_to_unlocked_list(room_details.ref)
		ROOM_UTIL.calculate_unlock_cost(room_details.ref)
		
		GameplayNode.ToastContainer.add("Unlocked %s!" % [room_details.name])
		
		made_changes = true
		await U.set_timeout(0.5)
		end()		
		
	
	GridSelect.freeze_and_disable(false, true)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
	if !is_node_ready():return
	#CostPanel.title = str(resources_data[RESOURCE.CURRENCY.SCIENCE].amount)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------			
func can_afford_check(cost:int) -> bool:
	return resources_data[RESOURCE.CURRENCY.SCIENCE].amount >= abs(cost)
# --------------------------------------------------------------------------------------------------			
