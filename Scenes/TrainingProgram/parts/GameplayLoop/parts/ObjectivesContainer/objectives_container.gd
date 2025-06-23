extends GameContainer

@onready var BtnControls:Control = $BtnControls
@onready var TransitionScreen:Control = $TransitionScreen

@onready var ObjectivePanel:PanelContainer = $ObjectivesControl/PanelContainer
@onready var ObjectiveMargin:MarginContainer = $ObjectivesControl/PanelContainer/MarginContainer
@onready var ObjectiveItemList:VBoxContainer = $ObjectivesControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ObjectiveItemList

@onready var HintPanel:PanelContainer = $HintControl/PanelContainer
@onready var HintMargin:MarginContainer = $HintControl/PanelContainer/MarginContainer
@onready var HintList:VBoxContainer = $HintControl/PanelContainer/MarginContainer/VBoxContainer

@onready var ObjectiveCard:Control = $ObjectivesControl/PanelContainer/MarginContainer/ObjectiveCard

signal mode_updated

const ObjectiveHintPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ObjectivesContainer/parts/ObjectiveHint.tscn")

var story_progress:Dictionary	
var objectives:Array = []
var objective_index:int : 
	set(val):
		objective_index = val
		on_objective_index_update()
		
var selected_index:int = 0
var bookmark_data:Dictionary = {} : 
	set(val):
		bookmark_data = val
		if !is_node_ready():return
		BtnControls.disable_active_btn = bookmark_data.is_empty()

var hint_index:int
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
		
		var activation_requirements = [{"amount": purchase_hint.cost, "resource": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.CORE)}]
		var confirm:bool = await GAME_UTIL.create_modal("Purchase hint #%s" % (hint_index + 1), "", "", activation_requirements)
		
		if confirm:
			if purchase_hint.uid not in SUBSCRIBE.hints_unlocked:
				hints_unlocked.push_back(purchase_hint.uid)
			resources_data[RESOURCE.CURRENCY.CORE].amount -= 1
			
			SUBSCRIBE.resources_data = resources_data
			SUBSCRIBE.hints_unlocked = hints_unlocked
			
			check_for_next_hint()
			build_hints()
		
		BtnControls.reveal(true)


	BtnControls.onUpdate = func(node:Control) -> void:
		current_hints = objectives[objective_index].list[node.index].hints
		build_hints(current_hints)
		check_for_next_hint(current_hints)
	
	BtnControls.onDirectional = func(key:String):
		var story_progress:Dictionary = GBL.active_user_profile.story_progress
		
		var total_objectives:int = objectives.size() - 1
		var max_val:int = U.min_max(story_progress.current_story_val + 1, 0, total_objectives)

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
	objective_index = story_progress.current_story_val
	
	await U.tick()
	control_pos[ObjectivePanel] = {
		"show": 0, 
		"hide": -ObjectiveMargin.size.x - 20
	}
	
	BtnControls.offset = ObjectiveCard.global_position

	ObjectivePanel.position.x = control_pos[ObjectivePanel].hide
# --------------------------------------------------------------------------------------------------	


# --------------------------------------------------------------------------------------------------		
func start() -> void:
	U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))
	await TransitionScreen.start()
	U.tween_node_property(ObjectivePanel, "position:x", control_pos[ObjectivePanel].show)	
	await BtnControls.reveal(true)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end() -> void:						
	BtnControls.reveal(false)
	await U.tween_node_property(ObjectivePanel, "position:x", control_pos[ObjectivePanel].hide)
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 0))
	
	user_response.emit()
	queue_free()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func clear_hints() -> void:
	for node in HintList.get_children():
		node.queue_free()	
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func build_hints(hints:Array = current_hints) -> void:
	clear_hints()
	
	# THIS ONE IS FOR THE OBJECTIVE
	var new_hint:Control = ObjectiveHintPreload.instantiate()
	HintList.add_child(new_hint)	
	
	# THESE are for the HINTS
	var all_complete:bool = true
	for hint in hints:
		if !hint.is_purchased.call():
			all_complete = false
			break
		new_hint = ObjectiveHintPreload.instantiate()
		HintList.add_child(new_hint)
		
	# THIS ONE IS label ??? if there is another hint
	if !all_complete:
		new_hint = ObjectiveHintPreload.instantiate()
		HintList.add_child(new_hint)			
# --------------------------------------------------------------------------------------------------		

func check_for_next_hint(hints:Array = current_hints) -> void:
	for index in hints.size():
		var hint:Dictionary = hints[index]
		if !hint.is_purchased.call():
			purchase_hint = hint
			BtnControls.disable_active_btn = false
			hint_index = index
			return
	
	purchase_hint = {}
	BtnControls.disable_active_btn = true
# --------------------------------------------------------------------------------------------------	
func on_objective_index_update() -> void:
	if !is_node_ready():return

	var current_objectives:Dictionary = objectives[objective_index]	
	var is_upcoming:bool = objective_index > story_progress.current_story_val 
	var is_expired:bool = objective_index < story_progress.current_story_val 
	
	ObjectiveCard.at_start = objective_index == 0
	ObjectiveCard.at_end = objective_index == objectives.size() - 1
	ObjectiveCard.is_upcoming = is_upcoming
	ObjectiveCard.is_expired = is_expired
	ObjectiveCard.objectives = current_objectives
	
	
	#if is_upcoming:
		#ObjectiveHeader.text = "Upcoming Objective"	
		#ObjectiveCard.title = "OBJECTIVES"
		#ObjectiveTitle.text = "???"
		#ObjectiveDeadline.text = ""
		#bookmark_data = {}
		#
	#if is_expired:
		#ObjectiveHeader.text = "Previous Objective"
		#ObjectiveCard.title = "COMPLETED"
		#ObjectiveTitle.text = current_objectives.title
		#ObjectiveDeadline.text = ""
		#bookmark_data = {}
		#
	#if objective_index == story_progress.current_story_val:
		#ObjectiveHeader.text = "Current Objective"
		#ObjectiveCard.title = "OBJECTIVES" 
		#ObjectiveTitle.text = current_objectives.title
		#ObjectiveDeadline.text = "Must be completed by day %s.\r(You have %s days remaining)." % [current_objectives.complete_by_day, current_objectives.complete_by_day - progress_data.day]		
		#bookmark_data = current_objectives
		#
		
	await U.tick()
	BtnControls.itemlist = ObjectiveCard.get_buttons()
	BtnControls.item_index = 0
# --------------------------------------------------------------------------------------------------	
	
