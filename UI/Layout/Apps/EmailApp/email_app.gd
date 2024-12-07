extends AppWrapper

@onready var EmailComponent = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/EmailComponent

var email_data:Array[Dictionary] = [
	{
		"section": "Important",
		"opened": true,
		"items": [
			{
				"get_details": func():
					return {
						"title": "URGENT!",
						"from": "@unknown",
						"date": "unknown",
						"content": "This is urgent.  You are in danger, and the danger is real.  But I need you to stay calm and do not panic.  You've trained for this and you will be fine.  First things first, download and install the program attached.  It will help you with your cuerent situation.  VERY IMPORTANT:  DO NOT venture out into the darkness.  It will kill you.  It will [REMOVE ALL YOUR PROGRESS - ESSENTIALLY A HARD RESET].",
						"get_attachment_details": func():
							return {
								"title": "Site_Director_Training_Program.exe",
								"onClick": func(data:Dictionary) -> void:
									app_events.onOpenAttachment.call({
										"type": "download", 
										"installer_data": {
											"filename": data.title,
											"duration": 3,
											"ref": Layout.APPS.SDT
										}
									}),
							}
						
					},
				"render_if": func():
					return true,
			},
			{
				"get_details": func():
					return {
						"title": "Test voicenote",
						"from": "@unknown",
						"date": "unknown",
						"content": "Lorem ipsum odor amet, consectetuer adipiscing elit. Cursus sollicitudin pellentesque fermentum interdum quisque auctor quisque. Elit in faucibus porta; bibendum donec nunc maximus. Magna efficitur porttitor fringilla non facilisi dis leo ullamcorper. Tempus maecenas ultricies sagittis nam eleifend odio. Facilisis suscipit ut suscipit, vivamus sollicitudin ligula. Pulvinar vivamus est id cras nibh mus. At semper pretium habitasse lacinia sagittis luctus mollis.",
						"get_attachment_details": func():
							return {
								"title": "Voicenote",
								"onClick": func(data:Dictionary) -> void:
									app_events.onOpenAttachment.call({
										"type": "media_player", 
										"track_list": [
											{
												"metadata": {
													"name": "voicenote_001.wav",
													"author": "unknown"
												},
												"file": preload("res://Media/mp3/ghost_trick_test_track.mp3")
											}
										]
									}),
							}
					},
				"render_if": func():
					return true,
			}			
		]
	},
	{
		"section": "Junk",
		"opened": false,
		"items": [
			{
				"get_details": func():
					return {
						"title": "Email 1",
						"from": "@unknown",
						"date": "unknown",
						"content": "Lorem ipsum odor amet, consectetuer adipiscing elit. Cursus sollicitudin pellentesque fermentum interdum quisque auctor quisque. Elit in faucibus porta; bibendum donec nunc maximus. Magna efficitur porttitor fringilla non facilisi dis leo ullamcorper. Tempus maecenas ultricies sagittis nam eleifend odio. Facilisis suscipit ut suscipit, vivamus sollicitudin ligula. Pulvinar vivamus est id cras nibh mus. At semper pretium habitasse lacinia sagittis luctus mollis."
					},
				"render_if": func():
					return true,
			},
			{
				"get_details": func():
					return {
						"title": "Email 2",
						"from": "@unknown",
						"date": "unknown",
						"content": "Lorem ipsum odor amet, consectetuer adipiscing elit. Cursus sollicitudin pellentesque fermentum interdum quisque auctor quisque. Elit in faucibus porta; bibendum donec nunc maximus. Magna efficitur porttitor fringilla non facilisi dis leo ullamcorper. Tempus maecenas ultricies sagittis nam eleifend odio. Facilisis suscipit ut suscipit, vivamus sollicitudin ligula. Pulvinar vivamus est id cras nibh mus. At semper pretium habitasse lacinia sagittis luctus mollis."
					},
				"render_if": func():
					return true,
			}			
		]
	}	
]

# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	super._ready()	
	
	# make sure has_read first so email_data can reference it
	EmailComponent.has_read = app_props.get_has_read.call()	
	# assign email_data
	EmailComponent.email_data = email_data
	
	EmailComponent.onHasReadUpdate = func(arr:Array) -> void:
		app_events.onHasReadUpdate.call(arr)
		
# ------------------------------------------------------------------------------
