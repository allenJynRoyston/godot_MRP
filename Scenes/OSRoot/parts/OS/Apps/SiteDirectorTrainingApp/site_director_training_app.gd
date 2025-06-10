extends AppWrapper

@onready var LoadingComponent:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/LoadingComponent
@onready var TrainingProgram:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/TrainingProgram
@onready var PauseContainer:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/PauseContainer

# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	TrainingProgram.hide()
	PauseContainer.hide()
	LoadingComponent.hide()
	super._ready()

func start() -> void:
	if !is_ready_and_activated:
		is_ready_and_activated = true
		LoadingComponent.start(fast_load)
		await LoadingComponent.on_complete	

		TrainingProgram.options = options
		TrainingProgram.fast_start = fast_load
		TrainingProgram.start()
		is_ready.emit()
		
		await TrainingProgram.on_quit
		TrainingProgram.hide()
		PauseContainer.hide()
		LoadingComponent.hide()
		events.close.call()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func quit() -> void:
	await U.set_timeout(0.3)
	quit_complete.emit()
	self.queue_free()
	
func on_taskbar_is_open_update(state:bool) -> void:
	if state:
		pause()
	else:
		unpause()	
	
func pause() -> void:
	if !is_paused:
		is_paused = true
		await TrainingProgram.pause()
		if is_visible_in_tree():
			PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))	
		PauseContainer.show()
		TrainingProgram.hide()
	
func unpause() -> void:
	is_paused = false
	PauseContainer.hide()
	TrainingProgram.show()
	TrainingProgram.unpause()
	await U.set_timeout(0.3)
	TrainingProgram.unpause()
	
func force_save_and_quit() -> void:
	await TrainingProgram.force_save_and_quit()
# ------------------------------------------------------------------------------
