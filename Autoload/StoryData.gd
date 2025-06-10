extends SubscribeWrapper

var chapters:Array = [
	{
		"text": [
			"Listen carefully.  My name is Researcher [   ] and I was tasked with recording these messages for Procedure-[   ]: the Memeory Recovery Protocol, the procedure that you are now currently undergoing.",
			"The first thing I need to tell you is you are not safe, and your life is in danger.",
			"Thats the bad news.  The good news, is, that you can change that.  You have control here.  But.  I still need you to be a little bit afraid.",
			"Now this is hard to understand at first, but... you've done this before.  You've undergone this exact procedure, safetly, multiple times.  You've saved your life each time.",
			"You just don't remember.",
			"But it's more accurate to say that you just CAN'T remember.",
			"The reason is you exposed yourself to an incredibly potent amnestic, a synthetic chemical agent used to suppress memory and [    ].",
			"Your inability to remember who you are, who you REALLY are, is intentional.  What we don't understand is how the mind that, the mind of somebody not you... fills in that absense.  Whoever that is, you are target we are trying to reach.",
			"And we believe that's who we're speaking to now.",
			"Anyways, there's a computer in front of you. I just need you to complete the tutorial.  Once you do I'll tell you more."
		 ],
		"objectives": [
			{
				"title": "TEST 1", 
				"complete_by_day": 2,
				"is_completed": func() -> bool:
					return true,
			},
		],
		"completed_by_day": 10
	},
	{
		"text": [
			"So like I said, we've done this a few times now.  Our success rate is actually [ ]%, which, you know... isn't that bad.  Considering.",
			"But... what's really improves our odds is when you trust me.",
			"And, unfortunately, that's going to be really difficult after I disclose the last message you sent me.",
			"It simply said, and I quote: ",
			"'You can't trust it.  It lies.'",
			"End quote.",
			"The thing is, you've sent me this exact message the last time you triggered the self destruct, but you couldn't remember what it meant, even after a successful recall.",
			"That is... very uncomforable, to say the least.  And it leads me to only two conlusions: ",
			"That some entity keeps forcing you to initiate the site self-destruct sequence unknowingly or worse.",  
			"You WANT to do it, but that something keeps stopping you.",
			"Eitherway, we need to know so we can help you.", 
			"You've been emailed a program for the computer.  Install it and fufill the objectives and we'll talk more."
		],
		"objectives": [
			{
				"title": "TEST 2", 
				"complete_by_day": 8,
				"is_completed": func() -> bool:
					return false,
			},
		],
		"completed_by_day": 20	
	}	
];


func get_objectives(story_progress_val:int) -> Array:
	var objectives:Array = []
	for index in chapters.size():
		if index <= story_progress_val: 
			for objective in chapters[index].objectives:
				objectives.push_back(objective)
	
	print("objectives: ", objectives)
	return objectives
