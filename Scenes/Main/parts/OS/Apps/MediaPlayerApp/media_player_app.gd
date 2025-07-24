extends AppWrapper

@onready var MediaPlayerMain:PanelContainer = $MediaPlayerMain
@onready var LoadingComponent:PanelContainer = $LoadingComponent
@onready var PauseContainer:PanelContainer = $PauseContainer
@onready var TransitionScreen:Control = $TransitionScreen

# ------------------------------------------------------------------------------
func _ready() -> void:	
	MediaPlayerMain.onBackToDesktop = func() -> void:
		await pause()
		GBL.find_node(REFS.OS_LAYOUT).return_to_desktop()


func start(fast_load:bool) -> void:
	LoadingComponent.loading_text = str(details.title).to_upper()
	await LoadingComponent.start(fast_load)
	await TransitionScreen.start(0.7, true)
	
	GBL.find_node(REFS.TASKBAR).show_media_player = true

	# start app
	MediaPlayerMain.start()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func quit(skip_close:bool = false) -> void:
	GBL.find_node(REFS.TASKBAR).show_media_player = false
	
	events.close.call()
	queue_free()
	
func on_taskbar_is_open_update(state:bool) -> void:
	await pause() if state else await unpause()

func pause() -> void:
	if !is_paused:
		is_paused = true
		await MediaPlayerMain.pause()
		if is_visible_in_tree():
			PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))	
		PauseContainer.show()
		MediaPlayerMain.hide()
	#
func unpause() -> void:
	if is_paused:
		is_paused = false
		PauseContainer.hide()
		MediaPlayerMain.show()
		await U.set_timeout(0.3)
		MediaPlayerMain.unpause()
# ------------------------------------------------------------------------------
