extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $BtnControls
@onready var DetailsPanel:Control = $DetailPanel

@onready var GridSelect:Control = $GridSelect
@onready var DetailPanel:Control = $DetailPanel
@onready var TransitionScreen:Control = $TransistionScreen

@onready var SummaryPanel:Control = $SummaryControl/PanelContainer
@onready var SummaryMargin:MarginContainer = $SummaryControl/PanelContainer/MarginContainer
@onready var CostResourceItem:Control = $SummaryControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CostResourceItem
@onready var CostResourceDiff:Control = $SummaryControl/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CostResourceItemDiff

const ScpMiniCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ScpMiniCard/ScpMiniCard.tscn")

enum TYPE { SELECT, RESEARCH }

var type:TYPE

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
	DetailsPanel.cycle_to_scp(true)
	on_resources_data_update()

func setup_gridselect() -> void:
	# ---------------- GRID_SELECT CONFIG
	var tabs:Array = [
		{
			"title": "ALL",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return SCP_UTIL.get_paginated_list(start_at, end_at),
		},
		{
			"title": "RESEARCHED",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return SCP_UTIL.get_paginated_list(start_at, end_at),
		},
		{
			"title": "UNKNOWN",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return SCP_UTIL.get_paginated_list(start_at, end_at),
		}	
	]
	
	GridSelect.tabs = tabs
	
	GridSelect.onModeTab = func() -> void:
		reveal_node(SummaryPanel, false)
		DetailsPanel.reveal(false)
	
	GridSelect.onModeContent = func() -> void:
		reveal_node(SummaryPanel, true)
		DetailsPanel.reveal(true)
		
	GridSelect.onUpdate = func(node:Control, data:Dictionary, index:int) -> void:
		var research_cost:int = 1
		var can_afford:bool = can_afford_check( research_cost )
		var already_researched:bool = data.ref in scp_data.researched
		CostResourceDiff.title = str(U.min_max(resources_data[RESOURCE.CURRENCY.CORE].amount - research_cost, 0, resources_data[RESOURCE.CURRENCY.CORE].capacity))
		CostResourceDiff.is_negative = !can_afford
		
		match type:
			TYPE.SELECT:
				GridSelect.BtnControls.disable_active_btn = false
			TYPE.RESEARCH:
				GridSelect.BtnControls.disable_active_btn = !can_afford or already_researched
			
	GridSelect.onUpdateEmptyNode = func(node:Control) -> void:
		node.scp_ref = -1
		node.onHover = func() -> void: pass
		node.onClick = func() -> void: pass		
	
	GridSelect.onUpdateNode = func(node:Control, data:Dictionary, index:int) -> void:		
		node.index = index
		node.scp_ref = data.ref

		node.onHover = func() -> void:
			if GridSelect.current_mode != GridSelect.MODE.CONTENT_SELECT:return
			GridSelect.grid_index = index
			DetailPanel.scp_ref = data.ref
			
		node.onClick = func() -> void:
			if GridSelect.current_mode != GridSelect.MODE.CONTENT_SELECT or !node.is_clickable():return
			GridSelect.freeze_and_disable(true)
			GridSelect.grid_index = index
			end(data.ref)
	
	GridSelect.onValidCheck = func(node:Control) -> bool:
		return node.scp_ref != -1
	
	GridSelect.onAction = func() -> void:
		pass
		
	GridSelect.onEnd = func() -> void:
		end()	

func activate() -> void:
	await U.tick()

	control_pos[SummaryPanel] = {
		"show": 0, 
		"hide": -SummaryMargin.size.x
	}	
	
	await DetailsPanel.reveal(false)

	SummaryPanel.position.x = control_pos[SummaryPanel].hide
	
	await U.tick()

func start() -> void:
	type = TYPE.SELECT
	setup()

func research() -> void:
	type = TYPE.RESEARCH
	setup()
	
func setup() -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	await TransitionScreen.start()	
	setup_gridselect()		

	var init_func:Callable = func(node:Control) -> void:
		node.scp_ref = -1
		
	GridSelect.start(ScpMiniCardPreload, init_func)	

func end(scp_ref:int = -1) -> void:
	if scp_ref != -1:
		GridSelect.end()
		DetailsPanel.reveal(false)
		await reveal_node(SummaryPanel, false)
		
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 0), 0.3)	
	await TransitionScreen.end()
	user_response.emit(scp_ref)
	queue_free()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal_node(node:Control, state:bool, duration:float = 0.3) -> void:
	await U.tween_node_property(node, "position:x", control_pos[node].show if state else control_pos[node].hide, duration)	
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	resources_data = new_val
	if !is_node_ready():return
	CostResourceItem.title = str(resources_data[RESOURCE.CURRENCY.CORE].amount)
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------			
func can_afford_check(cost:int) -> bool:
	return resources_data[RESOURCE.CURRENCY.CORE].amount >= abs(cost)
# --------------------------------------------------------------------------------------------------			
