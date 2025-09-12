extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG
@onready var BtnControls:Control = $GridSelect/BtnControls

@onready var GridSelect:Control = $GridSelect
@onready var TransitionScreen:Control = $TransistionScreen

@onready var CardPanel:Control = $CardControl/CardPanel
@onready var CardMargin:MarginContainer = $CardControl/CardPanel/MarginContainer
@onready var ScpCard:Control = $CardControl/CardPanel/MarginContainer/SCPCard

const ScpMiniCardPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ScpMiniCard/ScpMiniCard.tscn")

var selected_data:Dictionary
var is_valid:bool : 
	set(val):
		is_valid = val
		on_is_valid_update()

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate.a = 0

func activate() -> void:
	await U.tick()
	control_pos[CardPanel] = {
		"show": 0, 
		"hide": -CardMargin.size.x
	}	
	await U.tick()

	CardPanel.position.x = control_pos[CardPanel].hide
	await U.tick()
		

func start() -> void:
	setup()
	
func setup_gridselect() -> void:
	# ---------------- GRID_SELECT CONFIG
	var tabs:Array = [
		{
			"title": "ALL",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return SCP_UTIL.get_paginated_list(start_at, end_at),
		}
	]
	
	GridSelect.tabs = tabs
	
	GridSelect.onModeTab = func() -> void:		
		reveal_card(false)
		GridSelect.deselect_all()
	
	GridSelect.onModeContent = func() -> void:
		await U.set_timeout(0.2)
		reveal_card(true)
		
	GridSelect.onUpdate = func(node:Control, data:Dictionary, index:int) -> void:
		ScpCard.ref = data.ref
		ScpCard.use_location = current_location
		selected_data = data
		BtnControls.disable_active_btn = node.is_contained 
		
	GridSelect.onUpdateEmptyNode = func(node:Control) -> void:
		node.scp_ref = -1
	
	GridSelect.onUpdateNode = func(node:Control, data:Dictionary, index:int) -> void:		
		node.index = index
		node.scp_ref = data.ref
			
	GridSelect.onValidCheck = func(node:Control) -> bool:
		return node.scp_ref != -1
	
	GridSelect.onAction = func() -> void:
		end(selected_data.ref)
		
	GridSelect.onEnd = func() -> void:
		end()	

func reveal_card(state:bool) -> void:
	await U.tween_node_property(CardPanel, "position:x", control_pos[CardPanel].show if state else control_pos[CardPanel].hide)

func setup() -> void:
	U.tween_node_property(self, "modulate:a", 1, 0.3)	
	TransitionScreen.start()	
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
