extends SubscribeWrapper

var chapters:Array = [
	# ----------------------------------------------------------------------------------------------
	{
		"story_message": [
			"Hello, Site Director. My name is Researcher Cowan, and if you’re hearing this message, then something’s gone horribly, horribly wrong.",
			"Or maybe it hasn't and everything is going great? Honestly, even when we recorded this we weren’t entirely sure how this was really supposed to work.",
			"But that probably doesn't really matter right now since you have no idea who I am, or who you are, or have any idea at what's going on.",
			"The thing is, you've been exposed a chemical agent designed to inhibit memory.  An amnestic.  A powerful one one.",
			"And uh... I agree that sounds not great - but believe it or not, you did this to yourself.  On purpose.  Several times already, in fact, and each time you've recovered your memory without fail.",
			"So.  Don't panic.  This is fixable.  Trust me.",
			"For now, I just need you to log in to your computer and complete the program that's been preinstalled for you.",
			"And I know you can do this, because like I said before: you've done this before.",
			"Do that and I'll tell you more about what is happening."
		],
		"complete_message": [
			"Okay. First phase complete. You’re doing fine."
		],
		"objetive": "COMPLETE THE TUTORIAL",
		"objectives": [
			{
				"title": "Establish the facility", 
				"complete_by_day": 3,
				"is_completed": func() -> bool:
					return false,
			},
			{
				"title": "Build a Director's Office", 
				"complete_by_day": 3,
				"is_completed": func() -> bool:
					return false,
			},
			{
				"title": "Build an HQ", 
				"complete_by_day": 3,
				"is_completed": func() -> bool:
					return false,
			},						
		]
	},
	# ----------------------------------------------------------------------------------------------
];


func get_objectives(story_progress_val:int) -> Array:
	var objectives:Array = []
	for index in chapters.size():
		if index <= story_progress_val: 
			for objective in chapters[index].objectives:
				objectives.push_back(objective)

	return objectives
