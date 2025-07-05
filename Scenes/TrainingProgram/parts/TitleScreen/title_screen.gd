extends PanelContainer

@onready var BtnControls:Control = $BtnControl

@onready var MainPanel:PanelContainer = $MainControl/PanelContainer
@onready var MainMargin:MarginContainer = $MainControl/PanelContainer/MarginContainer

@onready var SubTitle:Label = $MainControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/SubTitle
@onready var BtnList:VBoxContainer = $MainControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnList
@onready var NewBtn:Control = $MainControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnList/NewBtn
@onready var ContinueAfterSetup:BtnBase = $MainControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnList/ContinueAfterSetup
@onready var ContinueFromCheckpoint:BtnBase = $MainControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnList/ContinueFromCheckpoint
@onready var ContinueFromQuicksave:BtnBase = $MainControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnList/ContinueQuicksave
@onready var QuitBtn:Control = $MainControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BtnList/QuitBtn

@onready var ContinueDetails:PanelContainer = $ContinueControl/ContinueDetails
@onready var DetailName:Label = $ContinueControl/ContinueDetails/MarginContainer/VBoxContainer/DetailName
@onready var DetailDay:Label = $ContinueControl/ContinueDetails/MarginContainer/VBoxContainer/DetailDay
@onready var DetailDate:Label = $ContinueControl/ContinueDetails/MarginContainer/VBoxContainer/DetailDate

enum MODE {TITLE, SCENARIO}

const ScenarioBtnPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/TitleScreen/parts/ScenarioBtn.tscn")

var is_tutorial:bool = false
var completed_scenarios:Array = []
var	disable_story:bool = false
var disable_scenario:bool = false
var has_quicksave:bool = false
var freeze_inputs:bool = false : 
	set(val):
		freeze_inputs = val
		on_freeze_inputs_update()
		
var btn_arr:Array[Control] = []
var slist:Array = []
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
	
	ContinueAfterSetup.hint_description = "Continue from day %s." % [after_setup_data.progress_data.day] if !after_setup_data.is_empty() else "Unavailable"
	ContinueFromCheckpoint.hint_description = "Continue from day %s." % [checkpoint_data.progress_data.day] if !checkpoint_data.is_empty() else "Unavailable"
	ContinueFromQuicksave.hint_description = "Continue from day %s." % [quicksave_data.progress_data.day] if !quicksave_data.is_empty() else "Unavailable"

	BtnControls.reveal(false)
	BtnControls.directional_pref = "UD"
	BtnControls.onUpdate = func(node:Control) -> void:
		for btn in BtnList.get_children():
			btn.is_selected = btn == node
			btn.panel_color = Color(0.337, 0.275, 1.0) if btn == node else Color.BLACK
			if btn == node:
				match node:
					ContinueAfterSetup:
						update_continue_panel(after_setup_data, node)
					ContinueFromCheckpoint:
						update_continue_panel(checkpoint_data, node)
					ContinueFromQuicksave:
						update_continue_panel(quicksave_data, node)
					_:
						ContinueDetails.hide()
		
		
	BtnControls.onBack = func() -> void:
		await BtnControls.reveal(false)
		end("QUIT")		
			
	NewBtn.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("START_NEW_GAME")
		
	ContinueAfterSetup.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("START_FROM_AFTER_SETUP")

	ContinueFromCheckpoint.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("START_FROM_CHECKPOINT")		
		
	ContinueFromQuicksave.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("START_FROM_QUICKSAVE")		
					
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
	
	await U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].show)
	
	ContinueAfterSetup.is_disabled = !has_after_setup
	ContinueFromCheckpoint.is_disabled = !has_checkpoint_data
	ContinueFromQuicksave.is_disabled = !has_quicksave_data
			
	await U.tick()
	BtnControls.itemlist = BtnList.get_children()
	BtnControls.reveal(true)
	
	if has_quicksave_data:
		BtnControls.item_index = 3
		return
		
	if has_checkpoint_data:
		BtnControls.item_index = 2
		return

	if has_after_setup:
		BtnControls.item_index = 1
		return

	BtnControls.item_index = 0
# ------------------------------------------

# ------------------------------------------
func end(action:String, props:Dictionary = {}) -> void:
	ContinueDetails.hide()	
	await U.tween_node_property(MainPanel, "position:y", control_pos[MainPanel].hide)
	hide()
	wait_for_input.emit({"action": action, "props": props})
# ------------------------------------------

# ------------------------------------------
func on_freeze_inputs_update() -> void:
	BtnControls.freeze_and_disable(freeze_inputs)
# ------------------------------------------

# ------------------------------------------
func update_continue_panel(save_data:Dictionary, node:Control) -> void:
	if save_data.is_empty():
		ContinueDetails.hide()
		return

	var modification_date:Dictionary = save_data.metadata.modification_date
	
	DetailDay.text = "DAY %s" % save_data.progress_data.day
	DetailDate.text = "%s/%s/%s" % [modification_date.month, modification_date.day, modification_date.year]
	ContinueDetails.position = node.global_position + node.size - Vector2(0, ContinueDetails.size.y) + Vector2(20, 0)
	ContinueDetails.show()	
	
# ------------------------------------------
