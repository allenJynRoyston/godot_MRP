extends AppWrapper

@onready var EmailComponent:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/EmailComponent
@onready var LoadingComponent:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/LoadingComponent
@onready var PauseContainer:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/PauseContainer

var email_data:Array[Dictionary] = [
	{
		"title": "INSTALL THIS",
		"from": "@unknown",
		"date": "unknown",
		"content": "This is urgent.  You are in danger, and the danger is real.  But I need you to stay calm and do not panic.  You've trained for this and you will be fine.  First things first, download and install the program attached.  It will help you with your cuerent situation.  VERY IMPORTANT:  DO NOT venture out into the darkness.  It will kill you.  It will [REMOVE ALL YOUR PROGRESS - ESSENTIALLY A HARD RESET].",
		"attachment": {
			"title": "Site_Director_Training_Program.exe",
			"onClick": func(attachment:Dictionary) -> void:
				events.install.call({
					"type": "download", 
					"installer_data": {
						"filename": attachment.title,
						"duration": 3,
						"ref": Layout.APPS.SDT
					}
				}),
		}

	},	
	{
		"title": "INSTALL THIS (OPTIONAL)",
		"from": "@unknown",
		"date": "unknown",
		"content": "SOMETHING ABOUT THIS SHOULD RESTORE YOUR MEMORY.",
		"attachment": {
			"title": "Music_Player.exe",
			"onClick": func(attachment:Dictionary) -> void:
				events.install.call({
					"type": "download", 
					"installer_data": {
						"filename": attachment.title,
						"duration": 3,
						"ref": Layout.APPS.MUSIC_PLAYER
					}
				}),
		}

	}
]

# signals
signal on_quit

# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	PauseContainer.hide()	
	LoadingComponent.hide()
	EmailComponent.hide()
	
	EmailComponent.markAsRead = func(index:int) -> void:
		events.mark.call(index)
		EmailComponent.read_emails = events.fetch_read_emails.call()
		
	EmailComponent.onQuit = func() -> void:quit()

	EmailComponent.email_data = email_data			
	EmailComponent.read_emails = events.fetch_read_emails.call()

	super._ready()	

func start() -> void:
	if !is_ready_and_activated:
		is_ready_and_activated = true	
		LoadingComponent.start(fast_load)
		await LoadingComponent.on_complete	
		
		EmailComponent.start()
		is_ready.emit()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func quit() -> void:
	EmailComponent.hide()
	PauseContainer.hide()
	LoadingComponent.hide()
	events.close.call()

	
func pause() -> void:
	if !is_paused:
		is_paused = true
		PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))	
		PauseContainer.show()
		EmailComponent.hide()
	
func unpause() -> void:
	is_paused = false
	PauseContainer.hide()
	EmailComponent.show()
# ------------------------------------------------------------------------------
