extends GameContainer

@onready var BtnControls:Control = $BtnControls

@onready var ObjectivePanel:PanelContainer = $ObjectivesControl/PanelContainer
@onready var ObjectiveMargin:MarginContainer = $ObjectivesControl/PanelContainer/MarginContainer
@onready var ObjectivesList:VBoxContainer = $ObjectivesControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ObjectivesList

const CheckBoxButtonPreload:PackedScene = preload("res://UI/Buttons/Checkbox/Checkbox.tscn")

signal mode_updated

var story_progress:Dictionary	
var objectives:Array = []
var objective_index:int : 
	set(val):
		objective_index = val
		on_objective_index_update()
		
# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	modulate = Color(1, 1, 1, 0)
	
	BtnControls.onBack = func() -> void:
		end()
	
	BtnControls.onDirectional = func(key:String):
		if !is_visible_in_tree() or !is_node_ready():return
		var story_progress:Dictionary = GBL.active_user_profile.story_progress

		match key:
			"A":
				objective_index = U.min_max(objective_index - 1, 0, objectives.size() - 1)
			"D":
				objective_index = U.min_max(objective_index + 1, 0, objectives.size() - 1)
		
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func start() -> void:
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1))
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
		"hide": -ObjectiveMargin.size.x
	}
	
	print(control_pos[ObjectivePanel])
	
	ObjectivePanel.position.x = control_pos[ObjectivePanel].hide
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_objective_index_update() -> void:
	if !is_node_ready():return
	for node in ObjectivesList.get_children():
		node.queue_free()
	
	var current_objectives:Dictionary = objectives[objective_index]	
	var is_upcoming:bool = objective_index > story_progress.current_story_val 
	var is_expired:bool = objective_index < story_progress.current_story_val 
	
	for items in [current_objectives]:
		for objective in items.list:
			var new_btn:Control = CheckBoxButtonPreload.instantiate()
			new_btn.title = "???" if is_upcoming else str(objective.title).to_upper()
			new_btn.is_checked = true if is_expired else objective.is_completed.call() 
			if (!is_upcoming and !is_expired):
				new_btn.checkbox_color = Color.WHITE
			if is_upcoming:
				new_btn.checkbox_color = Color.SKY_BLUE
			if is_expired:
				new_btn.checkbox_color = Color.YELLOW
			ObjectivesList.add_child(new_btn)	
# --------------------------------------------------------------------------------------------------	
	

## --------------------------------------------------------------------------------------------------		
#func on_current_mode_update(skip_animation:bool = false) -> void:
	#if !is_node_ready() or control_pos.is_empty():return	
	#var duration:float = 0 if skip_animation else 0.3
	#match current_mode:
		#MODE.ACTIVE:
			#await U.tween_node_property(ObjectivePanel, "position:x", control_pos[ObjectivePanel].show, duration)	
			#await BtnControls.reveal(true)
			#BtnControls.onBack = func() -> void:
				#end()			
## --------------------------------------------------------------------------------------------------		

## --------------------------------------------------------------------------------------------------		
#func on_room_config_update(new_val:Dictionary = room_config) -> void:
	#super.on_room_config_update(new_val)
	#if !is_node_ready():return
#
	#for item in objectives:
		#for index in item.list.size():
			#var objective:Dictionary = item.list[index]
			#var btn_node:Control = ObjectivesList.get_child(index)
			#print(objective.is_completed.call())
			#btn_node.is_checked = objective.is_completed.call()
## --------------------------------------------------------------------------------------------------		
