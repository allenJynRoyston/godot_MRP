extends GameContainer

@onready var ObjectivesControlPanel:MarginContainer = $ObjectivesControl/MarginContainer
@onready var ObjectivesList:VBoxContainer = $ObjectivesControl/PanelContainer/MarginContainer/OverlayContainer/MarginContainer/VBoxContainer/ObjectivesList

@onready var BtnControlPanel:MarginContainer = $BtnControl/MarginContainer
@onready var RightSideBtnList:HBoxContainer = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList
@onready var BackBtn:Control = $BtnControl/MarginContainer/HBoxContainer/PanelContainer/MarginContainer/HBoxContainer/RightSideBtnList/BackBtn

enum MODE {HIDE, ACTIVE}

var current_mode:MODE = MODE.HIDE : 
	set(val):
		current_mode = val
		on_current_mode_update()
		
# --------------------------------------------------------------------------------------------------
func _init() -> void:
	super._init()

func _exit_tree() -> void:
	super._exit_tree()

func _ready() -> void:
	super._ready()
	
	BackBtn.onClick = func() -> void:
		await U.tick()
		end()
	
	await U.set_timeout(1.0)
	control_pos[ObjectivesControlPanel] = {"show": ObjectivesControlPanel.position.y, "hide": ObjectivesControlPanel.position.y - ObjectivesControlPanel.size.y - 20}
	control_pos[BtnControlPanel] = {"show": BtnControlPanel.position.y, "hide": BtnControlPanel.position.y + BtnControlPanel.size.y}
	on_current_mode_update(true)
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func start() -> void:
	current_mode = MODE.ACTIVE
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func end() -> void:		
	current_mode = MODE.HIDE
	user_response.emit()
# --------------------------------------------------------------------------------------------------		

# --------------------------------------------------------------------------------------------------		
func on_current_mode_update(skip_animation:bool = false) -> void:
	if !is_node_ready() or control_pos.is_empty():return	
	match current_mode:
		MODE.HIDE:
			BackBtn.is_disabled = true
			U.tween_node_property(ObjectivesControlPanel, "position:y", control_pos[ObjectivesControlPanel].hide, 0 if skip_animation else 0.3)
			await U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].hide, 0 if skip_animation else 0.3)			
			hide()
		MODE.ACTIVE:
			show()
			U.tween_node_property(BtnControlPanel, "position:y", control_pos[BtnControlPanel].show)
			await U.tween_node_property(ObjectivesControlPanel, "position:y", control_pos[ObjectivesControlPanel].show)	
			BackBtn.is_disabled = false
# --------------------------------------------------------------------------------------------------		
