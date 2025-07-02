extends AppWrapper

@onready var LoadingComponent:PanelContainer = $LoadingComponent
@onready var EmailComponent:PanelContainer = $EmailComponent
@onready var PauseContainer:PanelContainer = $PauseContainer
@onready var TransitionScreen:Control = $TransitionScreen

var email_data:Array[Dictionary] = [
	{
		"title": "INSTALL THIS",
		"from": "@unknown",
		"date": "unknown",
		"content": "This is urgent.  You are in danger, and the danger is real.  But I need you to stay calm and do not panic.  You've trained for this and you will be fine.  First things first, download and install the program attached.  It will help you with your cuerent situation.  VERY IMPORTANT:  DO NOT venture out into the darkness.  It will kill you.  It will [REMOVE ALL YOUR PROGRESS - ESSENTIALLY A HARD RESET].",
		"attachment": {
			"title": "Site_Director_Training_Program.exe",
			"is_installed": func() -> bool:
				return Layout.APPS.SITE_DIRECTOR_TRAINING_PROGRAM in GBL.find_node(REFS.OS_LAYOUT).apps_installed,
			"onClick": func(attachment:Dictionary) -> void:
				events.install.call({
					"type": "download", 
					"installer_data": {
						"filename": attachment.title,
						"duration": 3,
						"ref": Layout.APPS.SITE_DIRECTOR_TRAINING_PROGRAM
					}
				}),
		}

	},	
	{
		"title": "TEST 2",
		"from": "@unknown",
		"date": "unknown",
		"content": "SOMETHING ABOUT THIS SHOULD RESTORE YOUR MEMORY."
	},
	{
		"title": "TEST 3",
		"from": "@unknown",
		"date": "unknown",
		"content": "Somethig something something."
	}	
]

# ------------------------------------------------------------------------------
func _ready() -> void:
	EmailComponent.markAsRead = func(index:int) -> void:
		events.mark.call(index)
		EmailComponent.read_emails = events.fetch_read_emails.call()
		
	EmailComponent.onBackToDesktop = func() -> void:
		await pause()
		GBL.find_node(REFS.OS_LAYOUT).return_to_desktop()
		
	EmailComponent.email_data = email_data
	await U.tick()
	EmailComponent.read_emails = events.fetch_read_emails.call()


func start(fast_load:bool) -> void:
	LoadingComponent.loading_text = str(details.title).to_upper()
	await LoadingComponent.start(fast_load)
	await TransitionScreen.start(0.7, true)

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
			PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))	
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
