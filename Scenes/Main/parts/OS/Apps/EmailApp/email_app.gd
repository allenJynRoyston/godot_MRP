extends AppWrapper

@onready var LoadingComponent:PanelContainer = $LoadingComponent
@onready var EmailComponent:PanelContainer = $EmailComponent
@onready var PauseContainer:PanelContainer = $PauseContainer
@onready var TransitionScreen:Control = $TransitionScreen


# ------------------------------------------------------------------------------
func _ready() -> void:
	EmailComponent.markAsRead = func(index:int) -> void:
		events.mark.call(index)
		EmailComponent.read_emails = events.fetch_read_emails.call()
		
	EmailComponent.onBackToDesktop = func() -> void:
		await pause()
		GBL.find_node(REFS.OS_LAYOUT).return_to_desktop()
		
	await U.tick()
	EmailComponent.read_emails = events.fetch_read_emails.call()


func start(fast_load:bool) -> void:
	LoadingComponent.loading_text = str(details.title).to_upper()
	await LoadingComponent.start(fast_load)
	await TransitionScreen.start(0.7, true)
	
	#SUBSCRIBE.music_data = {
		#"selected": OS_AUDIO.TRACK.OS_TRACK_TWO
	#}
		

	# start app
	EmailComponent.start()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func quit(skip_close:bool = false) -> void:
	events.close.call()
	queue_free()
	
func on_taskbar_is_open_update(state:bool) -> void:
	await pause() if state else await unpause()

func pause() -> void:
	if !is_paused:
		is_paused = true
		await EmailComponent.pause()
		if is_visible_in_tree():
			PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.MAIN_ACTIVE_VIEWPORT))	
		PauseContainer.show()
		EmailComponent.hide()
	#
func unpause() -> void:
	if is_paused:
		is_paused = false
		PauseContainer.hide()
		EmailComponent.show()
		await U.set_timeout(0.3)
		EmailComponent.unpause()
# ------------------------------------------------------------------------------
