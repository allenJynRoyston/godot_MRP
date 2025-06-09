extends GameContainer

@onready var ObjectivesControlPanel:MarginContainer = $ObjectivesControl/MarginContainer
@onready var ObjectivesList:VBoxContainer = $ObjectivesControl/MarginContainer/PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ObjectivesList
@onready var BtnControls:Control = $BtnControls

enum MODE {HIDE, ACTIVE}

const CheckBoxButtonPreload:PackedScene = preload("res://UI/Buttons/Checkbox/Checkbox.tscn")

signal mode_updated

var current_mode:MODE = MODE.HIDE : 
	set(val):
		current_mode = val
		on_current_mode_update()
		
var objectives:Array = [] : 
	set(val):
		objectives = val
		on_objectives_update()
		
# --------------------------------------------------------------------------------------------------
func _ready() -> void:
	super._ready()
	modulate = Color(1, 1, 1, 0)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func start() -> void:
	current_mode = MODE.ACTIVE
	modulate = Color(1, 1, 1, 1)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end() -> void:						
	BtnControls.reveal(false)
	await U.tween_node_property(ObjectivesControlPanel, "position:y", control_pos[ObjectivesControlPanel].hide)
	user_response.emit()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func activate(_objectives:Array = []) -> void:
	objectives = _objectives
	await U.tick()

	control_pos_default[ObjectivesControlPanel] = ObjectivesControlPanel.position
	
	await U.tick()
	control_pos[ObjectivesControlPanel] = {
		"show": 0, 
		"hide": -ObjectivesControlPanel.size.y
	}	
	
	await U.tick()
	ObjectivesControlPanel.position.y = control_pos[ObjectivesControlPanel].hide
	on_room_config_update()	
	
	await U.tick()	
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return	
	var duration:float = 0 if skip_animation else 0.3
	match current_mode:
		MODE.ACTIVE:
			await U.tween_node_property(ObjectivesControlPanel, "position:y", control_pos[ObjectivesControlPanel].show, duration)	
			await BtnControls.reveal(true)
			BtnControls.onBack = func() -> void:
				end()			
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_room_config_update(new_val:Dictionary = room_config) -> void:
	super.on_room_config_update(new_val)
	if !is_node_ready():return
	for index in objectives.size():
		var objective:Dictionary = objectives[index]
		var btn_node:Control = ObjectivesList.get_child(index)
		btn_node.is_checked = objective.is_completed.call()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_objectives_update() -> void:
	if !is_node_ready():return
	for child in ObjectivesList.get_children():
		child.queue_free()

	for objective in objectives:
		var new_btn:Control = CheckBoxButtonPreload.instantiate()
		new_btn.title = str(objective.title).to_upper()
		new_btn.is_checked = objective.is_completed.call()
		ObjectivesList.add_child(new_btn)
# --------------------------------------------------------------------------------------------------		
