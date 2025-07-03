extends PanelContainer

@onready var BtnControls:Control = $BtnControls
@onready var Splash:Control = $ContainmentBreachSplash

@onready var FailStateBtnContainer:VBoxContainer = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/FailStateBtnContainer
@onready var RestartBeginningBtn:BtnBase = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/FailStateBtnContainer/RestartBeginningBtn
@onready var RestartAfterSetupBtn:BtnBase = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/FailStateBtnContainer/RestartAfterSetupBtn
@onready var RestartFromCheckpointBtn:BtnBase = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/FailStateBtnContainer/RestartFromCheckpoint
@onready var RestartFromQuicksaveBtn:BtnBase = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/FailStateBtnContainer/RestartFromQuicksaveBtn
@onready var QuitBtn:BtnBase = $Control/PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/FailStateBtnContainer/QuitBtn

@export var is_win_state:bool = false


signal wait_for_response

func _ready() -> void:
	modulate = Color(1, 1, 1, 0)
	
	BtnControls.reveal(false)
	BtnControls.directional_pref = "UD"
	BtnControls.onUpdate = func(node:Control) -> void:
		for btn in FailStateBtnContainer.get_children():
			btn.is_selected = btn == node
			btn.panel_color = Color(0.337, 0.275, 1.0) if btn == node else Color.BLACK
	
	BtnControls.onBack = func() -> void:
		await BtnControls.reveal(false)
		end("BACK_TO_TITLE")		
	
	RestartBeginningBtn.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("START_NEW_GAME")

	RestartAfterSetupBtn.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("START_FROM_AFTER_SETUP")
		
	RestartFromCheckpointBtn.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("START_FROM_AFTER_SETUP")
	
	RestartFromQuicksaveBtn.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("START_FROM_QUICKSAVE")
	
	QuitBtn.onClick = func() -> void:
		await BtnControls.reveal(false)
		end("QUIT")		
	


func start() -> void:
	modulate = Color(1, 1, 1, 1)
	
	var after_setup_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.after_setup
	var checkpoint_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.restore_checkpoint
	var 	quicksave_data:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].snapshots.quicksaves
	
	RestartFromCheckpointBtn.is_disabled = checkpoint_data.is_empty()
	RestartAfterSetupBtn.is_disabled = after_setup_data.is_empty()
	RestartFromQuicksaveBtn.is_disabled = quicksave_data.is_empty()
	
	BtnControls.itemlist = FailStateBtnContainer.get_children()
	BtnControls.item_index = 0
	BtnControls.reveal(true)
	
	await Splash.activate()
	Splash.start(true)
	
	
func end(action:String) -> void:
	await BtnControls.reveal(false)
	wait_for_response.emit(action)
