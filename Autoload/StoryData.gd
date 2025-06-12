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
		"objectives": {
			"title": "Establish the base.",
			"list":[
				{
					"title": "Build a Director's Office", 
					"is_completed": func() -> bool:
						return true,
				},
				{
					"title": "Build an HQ", 
					"is_completed": func() -> bool:
						return true,
				},						
			],
			"complete_by_day": 2,
		},
	},
	# ----------------------------------------------------------------------------------------------
	
	# ----------------------------------------------------------------------------------------------
	{
		"story_message": [
			"Story 1",
		],
		"complete_message": [
			"Okay. First phase complete. You’re doing fine."
		],
		"objectives": {
			"title": "Establish the base.",
			"list":[
				{
					"title": "Objective 1", 
					"is_completed": func() -> bool:
						return true,
				},
			],
			"complete_by_day": 7,
		},
	},
	# ----------------------------------------------------------------------------------------------	
	
	
	# ----------------------------------------------------------------------------------------------
	{
		"story_message": [
			"Story 2",
		],
		"complete_message": [
			"Okay. First phase complete. You’re doing fine."
		],
		"objectives": {
			"title": "Establish the base.",
			"list":[
				{
					"title": "Objectives 2", 
					"is_completed": func() -> bool:
						return false,
				},
			],
			"complete_by_day": 10,
		},
	},
	# ----------------------------------------------------------------------------------------------		
];

# ----------------------------------------------------------------------------------------------
func get_objectives() -> Array:
	return chapters.map(func(x): return x.objectives).duplicate(true)
# ----------------------------------------------------------------------------------------------
