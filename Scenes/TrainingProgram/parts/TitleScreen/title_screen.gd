extends PanelContainer

@onready var BtnControls:Control = $BtnControl

@onready var SubTitle:Label = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/SubTitle

@onready var BtnList:VBoxContainer = $CenterContainer/VBoxContainer/BtnList
@onready var NewBtn:Control = $CenterContainer/VBoxContainer/BtnList/NewBtn
@onready var ContinueAfterSetup:BtnBase = $CenterContainer/VBoxContainer/BtnList/ContinueAfterSetup
@onready var ContinueFromCheckpoint:BtnBase = $CenterContainer/VBoxContainer/BtnList/ContinueFromCheckpoint
@onready var ContinueFromQuisksave:BtnBase = $CenterContainer/VBoxContainer/BtnList/ContinueQuicksave
@onready var QuitBtn:Control = $CenterContainer/VBoxContainer/BtnList/QuitBtn

@onready var ContinueDetails:PanelContainer = $ContinueControl/ContinueDetails
@onready var DetailName:Label = $ContinueControl/ContinueDetails/MarginContainer/VBoxContainer/VBoxContainer/DetailName
@onready var DetailDay:Label = $ContinueControl/ContinueDetails/MarginContainer/VBoxContainer/VBoxContainer/DetailDay
@onready var DetailDate:Label = $ContinueControl/ContinueDetails/MarginContainer/VBoxContainer/VBoxContainer/DetailDate

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

var after_setup_data:Dictionary 
var checkpoint_data:Dictionary 
var 	quicksave_data:Dictionary

signal wait_for_input

# ------------------------------------------
func _init() -> void:
	self.modulate = Color(1, 1, 1, 0)

func _ready() -> void:	
	modulate = Color(1, 1, 1, 0)

	after_setup_data = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.after_setup
	checkpoint_data = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.restore_checkpoint
	quicksave_data = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.quicksaves	
	
	ContinueAfterSetup.hint_description = "Continue from day %s." % [after_setup_data.progress_data.day] if !after_setup_data.is_empty() else "Unavailable"
	ContinueFromCheckpoint.hint_description = "Continue from day %s." % [checkpoint_data.progress_data.day] if !checkpoint_data.is_empty() else "Unavailable"
	ContinueFromQuisksave.hint_description = "Continue from day %s." % [quicksave_data.progress_data.day] if !quicksave_data.is_empty() else "Unavailable"

	BtnControls.reveal(false)
	BtnControls.directional_pref = "UD"
	BtnControls.onUpdate = func(node:Control) -> void:
		for btn in BtnList.get_children():
			btn.is_selected = btn == node
			btn.panel_color = Color(0.337, 0.275, 1.0) if btn == node else Color.BLACK
		
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
		
	ContinueFromQuisksave.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("START_FROM_QUICKSAVE")		
					
	QuitBtn.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("QUIT")			
# ------------------------------------------

# ------------------------------------------
func start(fast_boot:bool = false) -> void:
	modulate = Color(1, 1, 1, 1)
	
	SubTitle.text = "TUTORIAL VERSION" if is_tutorial else "BASE MANAGEMENT SIMULATOR"
		
	ContinueAfterSetup.is_disabled = after_setup_data.is_empty()
	ContinueFromCheckpoint.is_disabled = checkpoint_data.is_empty()
	ContinueFromQuisksave.is_disabled = quicksave_data.is_empty()
			
	await U.tick()
	BtnControls.itemlist = BtnList.get_children()
	BtnControls.item_index = 0
	BtnControls.reveal(true)
# ------------------------------------------

# ------------------------------------------
func end(action:String, props:Dictionary = {}) -> void:
	ContinueDetails.hide()
	# add animation here
	await U.set_timeout(0.5)
	hide()
	wait_for_input.emit({"action": action, "props": props})
# ------------------------------------------

# ------------------------------------------
func on_freeze_inputs_update() -> void:
	BtnControls.freeze_and_disable(freeze_inputs)
# ------------------------------------------
