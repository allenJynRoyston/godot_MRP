extends AppWrapper

@onready var EmailComponent:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/EmailComponent
@onready var LoadingComponent:PanelContainer = $WindowUI/MarginContainer/VBoxContainer/Body/MarginContainer/LoadingComponent

var email_data:Array[Dictionary] = [
	{
		"section": "Important",
		"opened": true,
		"selected": [],
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
				"render_if": func(_details:Dictionary) -> bool:
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
												"details": {
													"name": "voicenote_001.wav",
													"author": "unknown"
												},
												"file": preload("res://Media/mp3/ghost_trick_test_track.mp3")
											}
										]
									}),
							}
					},
				"render_if": func(_details:Dictionary) -> bool:
					return true,
			}			
		]
	},
	{
		"section": "Junk",
		"opened": false,
		"selected": [],
		"items": [
			{
				"get_details": func():
					return {
						"title": "Email 1",
						"from": "@unknown",
						"date": "unknown",
						"content": "Lorem ipsum odor amet, consectetuer adipiscing elit. Cursus sollicitudin pellentesque fermentum interdum quisque auctor quisque. Elit in faucibus porta; bibendum donec nunc maximus. Magna efficitur porttitor fringilla non facilisi dis leo ullamcorper. Tempus maecenas ultricies sagittis nam eleifend odio. Facilisis suscipit ut suscipit, vivamus sollicitudin ligula. Pulvinar vivamus est id cras nibh mus. At semper pretium habitasse lacinia sagittis luctus mollis."
					},
				"render_if": func(_details:Dictionary) -> bool:
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
				"render_if": func(_details:Dictionary) -> bool:
					return true,
			}			
		]
	}	
]

# ------------------------------------------------------------------------------
func _ready() -> void:
	WindowUI = $WindowUI
	super._ready()	
	
	LoadingComponent.delay = 0.3 if previously_loaded else 2.0
	EmailComponent.hide()
	LoadingComponent.start(previously_loaded)
	await LoadingComponent.on_complete	
	EmailComponent.show()
	
	# make sure has_read first so email_data can reference it
	EmailComponent.not_new = app_props.get_not_new.call()	
	# assign email_data
	EmailComponent.email_data = email_data

	
	# assign event to update has read
	EmailComponent.on_marked = app_events.on_marked	
	# assign event to updat eif state has changed
	EmailComponent.on_data_changed = func(new_state:Array) -> void:
		# not used, but can be used to capture the state of opened 
		pass
	
	EmailComponent.on_click = func(data:Dictionary) -> void:
		for index in email_data.size():			
			email_data[index].selected = [data.index] if index == data.parent_index else []
		EmailComponent.email_data = email_data
# ------------------------------------------------------------------------------
