extends PanelContainer

@onready var BtnControls:Control = $BtnControl

@onready var MainPanel:PanelContainer = $MainControl/PanelContainer
@onready var MainMargin:MarginContainer = $MainControl/PanelContainer/MarginContainer

@onready var SubTitle:Label = $MainControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/SubTitle

@onready var BtnList:VBoxContainer = $MainControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnList
@onready var NewBtn:Control = $MainControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnList/NewBtn
@onready var ContinueBtn:Control = $MainControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnList/ContinueBtn
@onready var QuitBtn:Control = $MainControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnList/QuitBtn

const ActiveMenuPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ActionContainer/parts/ActiveMenu.tscn")
const ScenarioBtnPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/TitleScreen/parts/ScenarioBtn.tscn")

enum MODE {TITLE, SCENARIO}

var is_tutorial:bool = false
var completed_scenarios:Array = []
var	disable_story:bool = false
var disable_scenario:bool = false
var has_quicksave:bool = false
var freeze_inputs:bool = false : 
	set(val):
		freeze_inputs = val
		on_freeze_inputs_update()
		
var control_pos:Dictionary

var after_setup_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.after_setup
var checkpoint_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.restore_checkpoint
var quicksave_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.quicksaves	

var has_after_setup:bool = !after_setup_data.is_empty()
var has_checkpoint_data:bool = !checkpoint_data.is_empty()
var has_quicksave_data:bool = !quicksave_data.is_empty()

signal wait_for_input

# ------------------------------------------
func _init() -> void:
	self.modulate = Color(1, 1, 1, 0)

func _ready() -> void:	
	modulate = Color(1, 1, 1, 0)

	BtnControls.reveal(false)
	BtnControls.directional_pref = "UD"
	BtnControls.onUpdate = func(node:Control) -> void:
		for btn in BtnList.get_children():
			btn.is_selected = btn == node
		
	BtnControls.onBack = func() -> void:
		await BtnControls.reveal(false)
		end("QUIT")		
			
	NewBtn.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("START_NEW_GAME")
	
	ContinueBtn.onClick = func() -> void:
		show_continue_options()

	ContinueBtn.is_disabled = !has_after_setup and !has_checkpoint_data and !has_quicksave_data
					
	QuitBtn.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("QUIT")			
		
# ------------------------------------------

# ------------------------------------------
func activate() -> void:
	await U.tick()
	
	control_pos[MainPanel] = {
		"hide": -MainPanel.size.y,
		"show": 0,
	}
	
	MainPanel.position.y = control_pos[MainPanel].hide	
# ------------------------------------------


# ------------------------------------------
func start(fast_boot:bool = false) -> void:
	modulate = Color(1, 1, 1, 1)
	
	SubTitle.text = "TUTORIAL VERSION" if is_tutorial else "BASE MANAGEMENT SIMULATOR"
	
	await U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].show, 0.7)

	BtnControls.itemlist = BtnList.get_children()
	BtnControls.reveal(true)
	
	if has_quicksave_data or has_checkpoint_data or has_after_setup:
		BtnControls.item_index = 1
	else:
		BtnControls.item_index = 0
# ------------------------------------------

# ------------------------------------------
func end(action:String, props:Dictionary = {}) -> void:
	await U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].hide, 0.7)
	hide()
	wait_for_input.emit({"action": action, "props": props})
# ------------------------------------------

# ------------------------------------------
func on_freeze_inputs_update() -> void:
	BtnControls.freeze_and_disable(freeze_inputs)
# ------------------------------------------

# --------------------------------------------------------------------------------------------------
func show_continue_options() -> void:			
	var ActiveMenuNode:Control = ActiveMenuPreload.instantiate()

	var options:Array = [
		{
			"title": "SAVE POINTS",
			"items": [
				{
					"show": has_after_setup,
					"title": "CONTINUE AFTER SEUP",
					"hint": {
						"icon": SVGS.TYPE.EXE_FILE,
						"title": "FILE DATA",
						"description": "Continue from day %s." % [after_setup_data.progress_data.day] if !after_setup_data.is_empty() else "Unavailable"
					},
					"action": func() -> void:
						ActiveMenuNode.close()
						end("START_FROM_AFTER_SETUP"),
				},				
				{
					"show": has_checkpoint_data,
					"title": "CONTINUE FROM CHECKPOINT",
					"hint": {
						"icon": SVGS.TYPE.EXE_FILE,
						"title": "FILE DATA",
						"description": "Continue from day %s." % [checkpoint_data.progress_data.day] if !checkpoint_data.is_empty() else "Unavailable"
					},
					"action": func() -> void:
						ActiveMenuNode.close()
						end("START_FROM_AFTER_SETUP"),
				},
				{
					"show": has_quicksave_data,
					"title": "CONTINUE FROM QUICKSAVE",
					"hint": {
						"icon": SVGS.TYPE.EXE_FILE,
						"title": "FILE DATA",
						"description": "Continue from day %s." % [quicksave_data.progress_data.day] if !quicksave_data.is_empty() else "Unavailable"
					},
					"action": func() -> void:
						ActiveMenuNode.close()
						end("START_FROM_QUICKSAVE"),
				},
			]
		}
	]
	

	BtnControls.reveal(false)
	ActiveMenuNode.onClose = func() -> void:	
		BtnControls.reveal(true)

	ActiveMenuNode.use_color = Color.WHITE
	ActiveMenuNode.options_list = options
	
	add_child(ActiveMenuNode)
	await ActiveMenuNode.activate()
	ActiveMenuNode.open()	
# --------------------------------------------------------------------------------------------------
