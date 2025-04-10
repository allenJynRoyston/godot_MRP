extends GameContainer

@onready var ObjectivesControlPanel:MarginContainer = $ObjectivesControl/MarginContainer
@onready var ObjectivesList:VBoxContainer = $ObjectivesControl/MarginContainer/PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ObjectivesList

@onready var BtnControlPanel:MarginContainer = $BtnControl/MarginContainer
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var BackBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn

enum MODE {HIDE, ACTIVE}

const CheckBoxButtonPreload:PackedScene = preload("res://UI/Buttons/Checkbox/Checkbox.tscn")

var current_mode:MODE = MODE.HIDE : 
	set(val):
		current_mode = val
		on_current_mode_update()
		
var objectives:Array = [] : 
	set(val):
		objectives = val
		on_objectives_update()
		
# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()

func _exit_tree() -> void:
	super._exit_tree()

func _ready() -> void:
	super._ready()
	
	BackBtn.onClick = func() -> void:
		end()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func start() -> void:
	current_mode = MODE.ACTIVE
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end() -> void:		
	U.tween_node_property(ObjectivesControlPanel, "position:y", control_pos[ObjectivesControlPanel].hide)
	await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide)			
				
	current_mode = MODE.HIDE
	user_response.emit()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------
func activate() -> void:
	show()
	await U.tick()

	control_pos_default[ObjectivesControlPanel] = ObjectivesControlPanel.position
	control_pos_default[BtnControlPanel] = BtnControlPanel.position

	update_control_pos()
	on_is_showing_update()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------	
func on_fullscreen_update(state:bool) -> void:
	update_control_pos()
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func update_control_pos() -> void:	
	await U.tick()
	var h_diff:int = (1080 - 720) # difference between 1080 and 720 resolution - gives you 360
	var y_diff =  (0 if !GBL.is_fullscreen else h_diff) if !initalized_at_fullscreen else (0 if GBL.is_fullscreen else -h_diff)
	
	# for elements in the bottom left corner
	control_pos[BtnControlPanel] = {
		"show": control_pos_default[BtnControlPanel].y + y_diff, 
		"hide": control_pos_default[BtnControlPanel].y + y_diff + BtnControlPanel.size.y
	}
	
	# for eelements in the top right
	control_pos[ObjectivesControlPanel] = {
		"show": control_pos_default[ObjectivesControlPanel].y, 
		"hide": control_pos_default[ObjectivesControlPanel].y - ObjectivesControlPanel.size.y
	}	
	
	on_current_mode_update(true)
# --------------------------------------------------------------------------------------------------	

# --------------------------------------------------------------------------------------------------		
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return	
	match current_mode:
		MODE.HIDE:
			BackBtn.is_disabled = true
			U.tween_node_property(ObjectivesControlPanel, "position:y", control_pos[ObjectivesControlPanel].hide, 0)
			await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide, 0)			
			hide()
		MODE.ACTIVE:
			show()
			U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show, 0 if skip_animation else 0.3)
			await U.tween_node_property(ObjectivesControlPanel, "position:y", control_pos[ObjectivesControlPanel].show, 0 if skip_animation else 0.3)	
			BackBtn.is_disabled = false
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_room_config_update(new_val:Dictionary) -> void:
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
