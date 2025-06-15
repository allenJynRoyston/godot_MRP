extends GameContainer

@onready var BtnControls:Control = $BtnControls
@onready var TransitionScreen:Control = $TransitionScreen

@onready var ObjectivePanel:PanelContainer = $ObjectivesControl/PanelContainer
@onready var ObjectiveMargin:MarginContainer = $ObjectivesControl/PanelContainer/MarginContainer
@onready var ObjectiveItemList:VBoxContainer = $ObjectivesControl/PanelContainer/MarginContainer/CardBody/SubViewport/Control/CardBody/Front/PanelContainer/MarginContainer/FrontDrawerContainer/ObjectiveItemList

@onready var ObjectiveHeader:Label = $TitleControl/PanelContainer/MarginContainer/VBoxContainer/ObjectiveHeader
@onready var ObjectiveTitle:Label =  $TitleControl/PanelContainer/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/ObjectiveTitle
@onready var ObjectiveDeadline:Label = $TitleControl/PanelContainer/MarginContainer/VBoxContainer/ObjectiveDeadline

@onready var ObjectiveCard:Control = $ObjectivesControl/PanelContainer/MarginContainer/ObjectiveCard

signal mode_updated

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
		
# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	modulate = Color(1, 1, 1, 0)
	
	BtnControls.directional_pref = "UD"
	
	BtnControls.onBack = func() -> void:
		end()
		
	BtnControls.onUpdate = func(node:Control) -> void:
		if !is_visible_in_tree() or !is_node_ready():return
		pass
	
	BtnControls.onDirectional = func(key:String):
		if !is_visible_in_tree() or !is_node_ready():return
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
	
	if is_upcoming:
		ObjectiveHeader.text = "Upcoming Objective"	
		ObjectiveCard.title = "OBJECTIVES"
		ObjectiveTitle.text = "???"
		ObjectiveDeadline.text = ""
		bookmark_data = {}
		
	if is_expired:
		ObjectiveHeader.text = "Previous Objective"
		ObjectiveCard.title = "COMPLETED"
		ObjectiveTitle.text = current_objectives.title
		ObjectiveDeadline.text = ""
		bookmark_data = {}
		
	if objective_index == story_progress.current_story_val:
		ObjectiveHeader.text = "Current Objective"
		ObjectiveCard.title = "OBJECTIVES" 
		ObjectiveTitle.text = current_objectives.title
		ObjectiveDeadline.text = "Must be completed by day %s.\r(You have %s days remaining)." % [current_objectives.complete_by_day, current_objectives.complete_by_day - progress_data.day]		
		bookmark_data = current_objectives
		
		
	await U.tick()
	BtnControls.itemlist = ObjectiveCard.get_buttons()
	BtnControls.item_index = 0
# --------------------------------------------------------------------------------------------------	
	
