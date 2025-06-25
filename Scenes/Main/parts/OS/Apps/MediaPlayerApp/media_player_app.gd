extends AppWrapper

@onready var MediaPlayerMain:PanelContainer = $MediaPlayerMain
@onready var LoadingComponent:PanelContainer = $LoadingComponent
@onready var PauseContainer:PanelContainer = $PauseContainer
@onready var TransitionScreen:Control = $TransitionScreen

var music_track_list:Array = [
	{
		"details": {
			"name": "ghost trick finale",
			"author": "CAPCOM",
			"ref": 0,
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Media/mp3/ghost_trick_test_track.mp3")
	},
	{
		"details": {
			"name": "phoenix wright",
			"author": "CAPCOM",
			"ref": 1,
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Media/mp3/phoenix wright.mp3")
	},
	{
		"details": {
			"name": "The Weeknd - Popular",
			"author": "Vidojean X Oliver Loenn Amapiano Remix",
			"ref": 2
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Media/mp3/The Weeknd - Popular (Vidojean X Oliver Loenn Amapiano Remix).mp3")
	}							
]

# ------------------------------------------------------------------------------
func _ready() -> void:
	MediaPlayerMain.music_track_list = music_track_list
	
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
		#await EmailComponent.pause()
		if is_visible_in_tree():
			PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))	
		PauseContainer.show()
		#EmailComponent.hide()
	#
func unpause() -> void:
	if is_paused:
		is_paused = false
		PauseContainer.hide()
		#EmailComponent.show()
		await U.set_timeout(0.3)
		#EmailComponent.unpause()
# ------------------------------------------------------------------------------
