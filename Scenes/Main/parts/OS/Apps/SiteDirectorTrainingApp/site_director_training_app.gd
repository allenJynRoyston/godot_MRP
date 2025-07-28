extends AppWrapper

@onready var LoadingComponent:PanelContainer = $LoadingComponent
@onready var TrainingProgram:PanelContainer = $TrainingProgram
@onready var PauseContainer:PanelContainer = $PauseContainer
@onready var TransitionScreen:Control = $TransitionScreen

# ------------------------------------------------------------------------------
func _ready() -> void:
	for node in [PauseContainer, TrainingProgram]:
		node.hide()	

func start(fast_load:bool) -> void:	
	LoadingComponent.loading_text = str(details.title).to_upper()
	await LoadingComponent.start(fast_load)
	await TransitionScreen.start(0.7, true)

	# start app
	TrainingProgram.show()	
	TrainingProgram.options = options
	TrainingProgram.fast_start = fast_load
	TrainingProgram.onQuit = quit
	TrainingProgram.start()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func quit() -> void:
	events.close.call()
	queue_free()
	
func on_taskbar_is_open_update(state:bool) -> void:
	await pause() if state else await unpause()
	
func pause() -> void:
	if !is_paused:
		is_paused = true
		await TrainingProgram.pause()
		if is_visible_in_tree():
			PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.MAIN_ACTIVE_VIEWPORT))	
		PauseContainer.show()
		TrainingProgram.hide()
	
func unpause() -> void:
	if is_paused:
		is_paused = false
		PauseContainer.hide()
		TrainingProgram.show()
		await U.set_timeout(0.3)
		TrainingProgram.unpause()
	
func force_save_and_quit() -> void:
	await GBL.find_node(REFS.AUDIO).fade_out(0.5)
	await TrainingProgram.force_save_and_quit()
# ------------------------------------------------------------------------------
