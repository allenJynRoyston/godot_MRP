extends GameContainer

@onready var ColorRectBG:ColorRect = $ColorRectBG

@onready var GridSelect:Control = $GridSelect
@onready var DetailPanel:Control = $DetailPanel
@onready var TransitionScreen:Control = $TransistionScreen

@onready var SummaryPanel:Control = $SummaryControl/PanelContainer
@onready var SummaryMargin:MarginContainer = $SummaryControl/PanelContainer/MarginContainer
@onready var SummaryImage:TextureRect = $SummaryControl/PanelContainer/MarginContainer/SummaryImage

const ResearcherMiniCard:PackedScene = preload("res://Scenes/TrainingProgram/parts/Cards/ResearcherMiniCard/ResearcherMiniCard.tscn")

var use_location:Dictionary = {}
var assigned_uids:Array = []
var filter_for_type:RESEARCHER.SPECIALIZATION = RESEARCHER.SPECIALIZATION.ANY
var check_for_compatability:bool = false
var check_for_promotions:bool = false

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	self.modulate = Color(1, 1, 1, 0)
	DetailPanel.cycle_to_reseacher(true)
		

func setup_gridselect() -> void:
	# ---------------- GRID_SELECT CONFIG
	var tabs:Array = [
		{
			"title": "ALL",
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return RESEARCHER_UTIL.get_paginated_list(-1, start_at, end_at),
		}
	]
	
	var available_specs:Array = RESEARCHER_UTIL.get_list_of_specializations()
	for item in available_specs:
		tabs.push_back({
			"title": item.name,
			"onSelect": func(category:int, start_at:int, end_at:int) -> Dictionary:
				return RESEARCHER_UTIL.get_paginated_list(item.ref, start_at, end_at),
		})	
	
	GridSelect.tabs = tabs
	
	GridSelect.onModeTab = func() -> void:
		reveal_node(SummaryPanel, false)
		DetailPanel.reveal(false)
	
	GridSelect.onModeContent = func() -> void:
		reveal_node(SummaryPanel, true)
		DetailPanel.reveal(true)
	
	GridSelect.onUpdate = func(node:Control, data:Dictionary, index:int) -> void:
		var is_compatable:bool = true
		GridSelect.BtnControls.disable_active_btn = !is_compatable
		
		if GridSelect.current_mode != GridSelect.MODE.CONTENT_SELECT:return
		#GridSelect.grid_index = index
		DetailPanel.researcher_uid = data.uid
		SummaryImage.texture = CACHE.fetch_image(data.img_src)

			
	GridSelect.onUpdateEmptyNode = func(node:Control) -> void:
		node.uid = ""
		node.onHover = func() -> void: pass
		node.onClick = func() -> void: pass		
	
	GridSelect.onUpdateNode = func(node:Control, data:Dictionary, index:int) -> void:		
		node.index = index
		node.uid = data.uid
		node.is_hoverable = true
		node.check_for_promotions = check_for_promotions
		
		if check_for_compatability:
			var extract_data:Dictionary = GAME_UTIL.extract_room_details(use_location)
			node.is_incompatable = false if filter_for_type == RESEARCHER.SPECIALIZATION.ANY else data.specialization.ref != filter_for_type 
			node.assigned_elsewhere_data = {} if data.props.assigned_to_room.is_empty() else GAME_UTIL.extract_room_details(data.props.assigned_to_room)
			node.is_assigned_elsewhere = !data.props.assigned_to_room.is_empty() and data.uid not in assigned_uids
			node.is_already_assigned = data.uid in assigned_uids
		else:
			node.is_incompatable = false
			node.is_assigned_elsewhere = false
			node.is_already_assigned = false
			node.can_be_promoted = RESEARCHER_UTIL.can_be_promoted(data.uid)
			
		

				
		#node.onHover = func() -> void:
			#if GridSelect.current_mode != GridSelect.MODE.CONTENT_SELECT:return
			#GridSelect.grid_index = index
			#DetailPanel.researcher_uid = data.uid
			#SummaryImage.texture = CACHE.fetch_image(data.img_src)
			
		node.onClick = func() -> void:
			if GridSelect.current_mode != GridSelect.MODE.CONTENT_SELECT or !node.is_clickable():return
			
			if data.status == RESEARCHER.STATUS.KIA:
				return
			
			GridSelect.freeze_and_disable(true)
			GridSelect.grid_index = index
			
			
			
			if node.is_assigned_elsewhere:
				await GridSelect.freeze_and_disable(true, true)
				var confirm:bool = await GAME_UTIL.create_modal(str("Reassign %s to this facility?" % [data.name]), "Will be removed from %s." % node.assigned_elsewhere_data.room.details.name , data.img_src, [], false, Color(0, 0, 0, 0.7))
				if !confirm:
					GridSelect.freeze_and_disable(false, true)
					return

			end(data.uid)
	
	GridSelect.onValidCheck = func(node:Control) -> bool:
		return node.uid != ""
	
	GridSelect.onAction = func():
		pass
		
	GridSelect.onEnd = func():
		end()	

func activate() -> void:
	await U.tick()

	control_pos[SummaryPanel] = {
		"show": 0, 
		"hide": -SummaryMargin.size.x
	}	

	SummaryPanel.position.x = control_pos[SummaryPanel].hide

func start(_assigned_uids:Array = [], _filter_for_type:int = RESEARCHER.SPECIALIZATION.ANY, _use_location:Dictionary = {}) -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	await TransitionScreen.start()	
	setup_gridselect()	
		
	filter_for_type = _filter_for_type
	use_location = _use_location
	assigned_uids = _assigned_uids
	check_for_compatability = !use_location.is_empty()
	
	var init_func:Callable = func(node:Control) -> void:
		node.uid = ""
	GridSelect.start(ResearcherMiniCard, filter_for_type, init_func)

func view_only() -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	await TransitionScreen.start()	
	setup_gridselect()	
	
	check_for_promotions = false
	check_for_compatability = false
	
	var init_func:Callable = func(node:Control) -> void:
		node.uid = ""
		
	GridSelect.start(ResearcherMiniCard, 0, init_func, true)

func promote() -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	await TransitionScreen.start()	
	setup_gridselect()	
	
	check_for_promotions = true
	check_for_compatability = false
	
	var init_func:Callable = func(node:Control) -> void:
		node.uid = ""
	GridSelect.start(ResearcherMiniCard, 0, init_func)
	
	
func end(uid:String = "") -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 0), 0.3)	
	await TransitionScreen.end()
	user_response.emit(uid)
	queue_free()
# --------------------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------------------
func reveal_node(node:Control, state:bool, duration:float = 0.3) -> void:
	await U.tween_node_property(node, "position:x", control_pos[node].show if state else control_pos[node].hide, duration)	
# --------------------------------------------------------------------------------------------------
