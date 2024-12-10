extends AppWrapper

@onready var LoadingComponent:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/LoadingComponent
@onready var TrainingProgram:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/TrainingProgram

# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	super._ready()
	
	LoadingComponent.delay = 0.3 if previously_loaded else 3.0
	TrainingProgram.hide()
	LoadingComponent.start(previously_loaded)
	await LoadingComponent.on_complete	
	TrainingProgram.show()	
# ------------------------------------------------------------------------------
