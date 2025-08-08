extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $GridSelect/BtnControls

@onready var GridSelect:Control = $GridSelect
@onready var TransitionScreen:Control = $TransistionScreen

@onready var CardPanel:Control = $CardControl/CardPanel
@onready var CardMargin:MarginContainer = $CardControl/CardPanel/MarginContainer
@onready var ScpCard:Control = $CardControl/CardPanel/MarginContainer/SCPCard

const ScpMiniCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ScpMiniCard/ScpMiniCard.tscn")

enum TYPE { SELECT, CONTAIN, RESEARCH }

var selected_data:Dictionary
var is_valid:bool : 
	set(val):
		is_valid = val
		on_is_valid_update()

var type:TYPE

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)

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
		reveal_card(false)
	
	GridSelect.onModeContent = func() -> void:
		reveal_card(true)
		
	GridSelect.onUpdate = func(node:Control, data:Dictionary, index:int) -> void:
		var research_cost:int = 1
		var research_level:int = 0 if data.ref not in scp_data else scp_data[data.ref].level
		ScpCard.ref = data.ref
		ScpCard.use_location = current_location
		if type == TYPE.CONTAIN:
			is_valid = SCP_UTIL.is_scp_in_containment(data)
		selected_data = data
		
	GridSelect.onUpdateEmptyNode = func(node:Control) -> void:
		node.scp_ref = -1
	
	GridSelect.onUpdateNode = func(node:Control, data:Dictionary, index:int) -> void:		
		node.index = index
		node.scp_ref = data.ref
		
		if type == TYPE.CONTAIN:		
			node.in_containment = SCP_UTIL.is_scp_in_containment(data)
			return
		
		node.in_containment = false
			
	GridSelect.onValidCheck = func(node:Control) -> bool:
		return node.scp_ref != -1
	
	GridSelect.onAction = func() -> void:
		end(selected_data.ref)
		
	GridSelect.onEnd = func() -> void:
		end()	

func activate() -> void:
	control_pos[CardPanel] = {
		"show": 0,
		"hide": -CardMargin.size.x
	}
	CardPanel.position.x = control_pos[CardPanel].hide

func start() -> void:
	type = TYPE.SELECT
	setup()

func contain() -> void:
	type = TYPE.CONTAIN
	setup()

func research() -> void:
	type = TYPE.RESEARCH
	setup()

func reveal_card(state:bool) -> void:
	await U.tween_node_property(CardPanel, "position:x", control_pos[CardPanel].show if state else control_pos[CardPanel].hide)

func setup() -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	await TransitionScreen.start()	
	setup_gridselect()		

	var init_func:Callable = func(node:Control) -> void:
		node.scp_ref = -1
		
	GridSelect.start(ScpMiniCardPreload, -1, init_func)	

func end(scp_ref:int = -1) -> void:
	if scp_ref != -1:
		GridSelect.end()

	reveal_card(false)
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 0), 0.3)	
	await TransitionScreen.end()
	user_response.emit(scp_ref)
	queue_free()
	
func on_is_valid_update() -> void:
	if !is_node_ready():return
	BtnControls.disable_active_btn = is_valid
# --------------------------------------------------------------------------------------------------
