extends GameContainer

@onready var BtnControls:Control = $BtnControls
@onready var TransitionScreen:Control = $TransitionScreen

@onready var CurrentObjective:Label = $HintControl/PanelContainer/MarginContainer/VBoxContainer/CurrentObjective
@onready var ObjectivePanel:PanelContainer = $ObjectivesControl/PanelContainer
@onready var ObjectiveMargin:MarginContainer = $ObjectivesControl/PanelContainer/MarginContainer
@onready var ObjectiveCard:Control = $ObjectivesControl/PanelContainer/MarginContainer/ObjectiveCard

@onready var HintPanel:PanelContainer = $HintControl/PanelContainer
@onready var HintMargin:MarginContainer = $HintControl/PanelContainer/MarginContainer
@onready var HintList:VBoxContainer = $HintControl/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer

@onready var ResourcePanel:PanelContainer = $ResourceControl/PanelContainer
@onready var ResourceMargin:MarginContainer = $ResourceControl/PanelContainer/MarginContainer

@onready var Days:Control = $ResourceControl/PanelContainer/MarginContainer/VBoxContainer/Days
@onready var Cores:Control = $ResourceControl/PanelContainer/MarginContainer/VBoxContainer/Cores

signal mode_updated

const ObjectiveHintPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ObjectivesContainer/parts/ObjectiveHint.tscn")

var story_progress:Dictionary	
var objectives:Array = []
var objective_index:int : 
	set(val):
		objective_index = val
		on_objective_index_update()
		
var selected_index:int = 0
var hint_index:int
var current_objective:Dictionary
var current_hints:Array = []
var purchase_hint:Dictionary

# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	clear_hints()
	
	modulate = Color(1, 1, 1, 0)
	
	BtnControls.directional_pref = "UD"
	
	BtnControls.onBack = func() -> void:
		end()
		
	BtnControls.onAction = func() -> void:
		if purchase_hint.is_empty():return
		await BtnControls.reveal(false)
		
		var activation_requirements = [{"amount": -(purchase_hint.cost), "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.CORE)}]
		var confirm:bool = await GAME_UTIL.create_modal("Purchase hint #%s" % (hint_index + 1), "", "res://Media/images/Defaults/hint.png", activation_requirements)
		
		if confirm:
			if purchase_hint.uid not in SUBSCRIBE.hints_unlocked:
				hints_unlocked.push_back(purchase_hint.uid)
			resources_data[RESOURCE.CURRENCY.CORE].amount -= 1
			
			SUBSCRIBE.resources_data = resources_data
			SUBSCRIBE.hints_unlocked = hints_unlocked
			
			build_hints()
		
		BtnControls.reveal(true)

	BtnControls.onUpdate = func(node:Control) -> void:
		current_objective = objectives[objective_index].list[node.index]
		current_hints = objectives[objective_index].list[node.index].hints
		build_hints(current_hints, current_objective)
		ObjectiveCard.set_selected_node(node)
		

	BtnControls.onDirectional = func(key:String):
		var story_progress:Dictionary = GBL.active_user_profile.story_progress
		
		var total_objectives:int = objectives.size() - 1
		var max_val:int = U.min_max(story_progress.on_chapter + 1, 0, total_objectives)

		match key:
			"A":
				objective_index = U.min_max(objective_index - 1, 0, max_val )
			"D":
				objective_index = U.min_max(objective_index + 1, 0, max_val )
		
# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------
func activate() -> void:		
	# assign objectives and assign to current index
	story_progress = GBL.active_user_profile.story_progress
	objectives = STORY.get_objectives()
	objective_index = story_progress.on_chapter
	
	await U.tick()
	control_pos[ObjectivePanel] = {
		"show": 0, 
		"hide": -ObjectiveMargin.size.x - 20
	}
	
	control_pos[ResourcePanel] = {
		"show": 0,
		"hide": ResourceMargin.size.x
	}
	
	control_pos[HintPanel] = {
		"show": 0,
		"hide": -HintMargin.size.y
	}
	
	BtnControls.offset = ObjectiveCard.global_position

	ObjectivePanel.position.x = control_pos[ObjectivePanel].hide
	ResourcePanel.position.x = control_pos[ResourcePanel].hide
	HintPanel.position.y = control_pos[HintPanel].hide
	
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------		
func start() -> void:
	on_resources_data_update()

	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))
	await TransitionScreen.start()
	
	U.tween_node_property(ObjectivePanel, "position:x", control_pos[ObjectivePanel].show)	
	U.tween_node_property(ResourcePanel, "position:x", control_pos[ResourcePanel].show)
	U.tween_node_property(HintPanel, "position:y", control_pos[HintPanel].show)
	
	await BtnControls.reveal(true)
		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end() -> void:						
	BtnControls.reveal(false)
	U.tween_node_property(ObjectivePanel, "position:x", control_pos[ObjectivePanel].hide)	
	U.tween_node_property(ResourcePanel, "position:x", control_pos[ResourcePanel].hide)
	await U.tween_node_property(HintPanel, "position:y", control_pos[HintPanel].hide)
	
	TransitionScreen.end()	
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 0))
	
	user_response.emit()
	queue_free()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_resources_data_update(new_val:Dictionary = resources_data) -> void:
	super.on_resources_data_update(new_val)
	if !is_node_ready():return
	Cores.amount = str(resources_data[RESOURCE.CURRENCY.CORE].amount)	
# --------------------------------------------------------------------------------------------------		


# --------------------------------------------------------------------------------------------------		
func clear_hints() -> void:
	for node in HintList.get_children():
		node.queue_free()	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func build_hints(hints:Array = current_hints, current_objective:Dictionary = {}) -> void:
	clear_hints()
	var is_upcoming:bool = objective_index > story_progress.on_chapter 
	var is_expired:bool = objective_index < story_progress.on_chapter 	
	var already_completed:bool = current_objective.is_completed.call()	
	var filter_arr:Array = hints.filter(func(x): return x.is_purchased.call() )

	# all hints
	var all_complete:bool = true
	var last_index:int
	
	# has none and is expired
	if hints.is_empty():
		var new_hint:Control = ObjectiveHintPreload.instantiate()
		new_hint.is_expired = true
		new_hint.is_locked = false
		new_hint.has_more = false
		new_hint.title = "None"
		HintList.add_child(new_hint)
			
			
	# build hint list
	for index in hints.size():
		var hint:Dictionary = hints[index]
		if !hint.is_purchased.call() and !is_expired:
			all_complete = false
			last_index = index
			break
		var new_hint:Control = ObjectiveHintPreload.instantiate()
		new_hint.index = index
		new_hint.title = hint.title
		new_hint.cost = hint.cost
		new_hint.is_complete = already_completed or is_expired
		new_hint.is_locked = false
		new_hint.has_more = (index < filter_arr.size() - 1) if (already_completed or is_expired) else (index < hints.size() - 1)
		HintList.add_child(new_hint)
		
	# THIS ONE IS label ??? if there is another hint
	if !all_complete and !already_completed and !is_expired:
		var hint:Dictionary = hints[last_index]		
		var new_hint:Control = ObjectiveHintPreload.instantiate()
		new_hint.is_locked = true
		new_hint.has_more = false
		new_hint.cost = hint.cost
		HintList.add_child(new_hint)
	
	BtnControls.hide_a_btn = is_upcoming or is_expired or already_completed
	
	if current_objective.is_empty():
		CurrentObjective.text = "UPCOMING..."
	else:
		CurrentObjective.text = current_objective.title
		

	if !already_completed:
		check_for_next_hint(current_hints)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func check_for_next_hint(hints:Array = current_hints) -> void:
	for index in hints.size():
		var hint:Dictionary = hints[index]
		if !hint.is_purchased.call():
			purchase_hint = hint
			hint_index = index
			return
	
	purchase_hint = {}
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_objective_index_update() -> void:
	if !is_node_ready():return
	var current_objectives:Dictionary = objectives[objective_index]	
	var is_upcoming:bool = objective_index > story_progress.on_chapter 
	var is_expired:bool = objective_index < story_progress.on_chapter 
	
	Days.amount = str( U.min_max( current_objectives.complete_by_day - progress_data.day, 0, 999 ) )	
	Days.is_negative = is_expired
	
	ObjectiveCard.at_start = objective_index == 0
	ObjectiveCard.at_end = objective_index == objectives.size() - 1
	ObjectiveCard.is_upcoming = is_upcoming
	ObjectiveCard.is_expired = is_expired
	ObjectiveCard.objectives = current_objectives
	ObjectiveCard.complete_by_day = current_objectives.complete_by_day
	
	if is_upcoming:
		ObjectiveCard.title = "UPCOMING"
		HintPanel.hide()

	elif is_expired:
		ObjectiveCard.title = "PREVIOUS"
		HintPanel.show()
	
	else:
		ObjectiveCard.title = "CURRENT"
		HintPanel.show()
		
	#await U.tick()
	await ObjectiveCard.objectives_updated

	
	BtnControls.itemlist = ObjectiveCard.get_buttons()
	BtnControls.item_index = 0	
# --------------------------------------------------------------------------------------------------	
	
