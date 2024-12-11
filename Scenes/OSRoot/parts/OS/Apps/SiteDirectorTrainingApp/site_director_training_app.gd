extends AppWrapper

@onready var LoadingComponent:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/LoadingComponent
@onready var TrainingProgram:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/TrainingProgram

# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	super._ready()
	TrainingProgram.fast_start = fast_load
	LoadingComponent.delay = 0.3 if fast_load else 3.0

	LoadingComponent.start(fast_load)
	await LoadingComponent.on_complete	
	TrainingProgram.start()
	await TrainingProgram.on_quit
	TrainingProgram.hide()
	app_events.onQuit.call()
# ------------------------------------------------------------------------------
