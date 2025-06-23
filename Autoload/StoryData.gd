extends SubscribeWrapper

enum {HAVE_AT_LEAST, HAVE_MORE_THAN, HAVE_NO_MORE_THAN, HAVE_LESS_THAN, HAVE_EXACTLY}
enum {CURRENCY, BUILDING}

var chapters:Array = [
	# ----------------------------------------------------------------------------------------------
	{
		"story_message": [
			"Good evening, D-[REDACTED], my name is Researcher Amborosia.",
			"I'm sure you have many questions so lets start with the most obvious:  why?  Why you?  I can't tell you.  And when I explain why you'll understand.  But what I can tell you i this.",
			"You deserve to be here.",
			"Look, I'm... not here to judge you, but you do something... you do something bad.  Many people have been killed or are going to die because of you.",
			"But... I still don't think you should be here.  Many don't.  I know that's a bit cryptic but once you get your memory back I think you'll see.",
			"Let me explain what happens now.  You are going to test something for us.  In front of you is a computer with a game on it.  You're going to log in and play this game.",
			"I need to warn you.  This game is dangerous.  Extremely dangerous. It has already ended thel lives of [xxx] people, most of them children.  We're still unsure on the how or why but one commonality has emerged.",\
			"It will lie to you.  It's always the same lie, but it always seems to work.",
			"You need to be resilient if you want to survive.  Don't let it get inside your head.  Be strong.",
			"I want you to understand that we all want you to succeed because your success means we have a means to contain this thing, so our goals are alignted.",
			"You help us, and I will guarantee your release.  Your freedom.  Your life.",
			"Now before you woke up, I had to expose you to a powerful amnestic - a chemical agent that effects your memory.  It's why you can't remember anything.",
			"And if you're lucky and beat this game, you'll be exposed to the same thing.  And you'll just wake up in a field or soemthing, far from here.",
			"You won't rememeber any of this.",
			"Now, I'll tell you more once you've had a chance to play around with it.",
			"And remember.  Your life depends on you winning this game.  "
			
		],
		"complete_message": [
			"Okay. First phase complete. You’re doing fine."
		],
		"objectives": {
			"title": "Setup the facility.",
			"list":[
				# HAVE A BUNCH OF EASY GOALS THAT TEACH YOU HOW TO PLAY THE GAME, SO YOU DON'T REALLY NEED A TUTORIAL
				# THINGS LIKE:
				# HAVE AT LEAST 100 MONEY, 100 SCIENCE, 
				# A DIRECTORS OFFICE AND AN HQ BUILT,
				# 1 GENERATOR UPGRADE,
				# FLOOR 1 UNLOCKED
				# 1 RESERACHER
				# 1 STAFF, etc etc
				# 1 SCP CONTAINED, etc...
				
				# and the scps are now also 
				# - select a passive ability (like RETURNS MONEY)
				# - and that's what it returns, requires 1 PERSON (any type)
				# - other "symbols" can be researched
				# - that way you can build many containment cells "types" and have them do something unique
				# - scp rooms have a preference (saves a researcher based on their personality/auirks) or kills them.  
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 1,
						"type": BUILDING,
						"ref": ROOM.REF.DIRECTORS_OFFICE
					},
					"hints": [
						{"title": "Step 1", "cost": 1},
						{"title": "Step 2", "cost": 2},
						{"title": "Step 3", "cost": 5},
					]
				},
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 1,
						"type": BUILDING,
						"ref": ROOM.REF.HQ
					},
					"hints": [
						
					]
				},
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 1,
						"type": BUILDING,
						"ref": ROOM.REF.STANDARD_CONTAINMENT_CELL
					},
					"hints": [
						
					]
				},

				#{
					#"criteria": {
						#"action": HAVE_EXACTLY,
						#"amount": 1,
						#"type": BUILDING,
						#"ref": ROOM.REF.HQ
					#},
				#},
			],
			"complete_by_day": 2,
		},
	},
	# ----------------------------------------------------------------------------------------------
	
	# ----------------------------------------------------------------------------------------------
	{
		"story_message": [
			"Every Site Director knows that each SCP they contain is dangerous."
		],
		"complete_message": [
			"Okay. First phase complete. You’re doing fine."
		],
		"objectives": {
			"title": "Objective title 1.",
			"list":[
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 500,
						"type": CURRENCY,
						"ref": RESOURCE.CURRENCY.MONEY
					},
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
			"title": "Objective title 2.",
			"list":[
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 500,
						"type": CURRENCY,
						"ref": RESOURCE.CURRENCY.MONEY
					},
				},
			],
			"complete_by_day": 10,
		},
	},
	# ----------------------------------------------------------------------------------------------		
];


# ----------------------------------------------------------------------------------------------		
func get_action_str(val:int) -> String:
	match val:
		STORY.HAVE_AT_LEAST:
			return "HAVE AT LEAST"	
		STORY.HAVE_MORE_THAN:
			return "HAVE MORE THAN"	
		STORY.HAVE_NO_MORE_THAN:
			return "HAVE NO MORE THAN"
		STORY.HAVE_LESS_THAN:
			return "HAVE LESS THAN"
		STORY.HAVE_EXACTLY:
			return "HAVE EXACTLY"
	return ""

func get_type_str(val:int, ref:int) -> String:
	match val:
		# -------
		STORY.CURRENCY:
			return RESOURCE_UTIL.return_currency(ref).name
		STORY.BUILDING:
			return ROOM_UTIL.return_data(ref).name
		# -------
	return "UNDEFINED"

func check_for_criteria(criteria:Dictionary) -> bool:
	var current_amount = check_for_current(criteria)

	match criteria.action:
		STORY.HAVE_AT_LEAST:
			return current_amount >= criteria.amount
		STORY.HAVE_MORE_THAN:
			return current_amount > criteria.amount
		STORY.HAVE_NO_MORE_THAN:
			return current_amount <= criteria.amount
		STORY.HAVE_LESS_THAN:
			return current_amount < criteria.amount
		STORY.HAVE_EXACTLY:
			return current_amount == criteria.amount
			
	return false
	
func check_for_current(criteria:Dictionary) -> int:
	match criteria.type:
		# --------
		STORY.CURRENCY:
			return resources_data[criteria.ref].amount 
		STORY.BUILDING:
			return ROOM_UTIL.build_count(criteria.ref)
			
	return -1
# ----------------------------------------------------------------------------------------------		

# ----------------------------------------------------------------------------------------------
func get_objectives() -> Array:
	var objective_list:Array = []
	for c_index in chapters.size():
		var chapter:Dictionary = chapters[c_index]
		var list:Array = []	
		for o_index in chapter.objectives.list.size():
			var objective:Dictionary = chapter.objectives.list[o_index]
			var hints:Array = []
			
			if "hints" in objective:
				for h_index in objective.hints.size():
					var hint:Dictionary = objective.hints[h_index]
					var uid:String = str(c_index, o_index, h_index)
					
					hints.push_back({
						"title": hint.title,
						"cost": hint.cost,
						"uid": uid, 
						"is_purchased": func() -> bool:
							return uid in SUBSCRIBE.hints_unlocked
					})
			
			if "criteria" in objective:
				var title:String = ""
				var ref:int = objective.criteria.ref
				
				for key in objective.criteria:
					var val = objective.criteria[key]
					match key:
						'action':
							title += str(get_action_str(val), " ")
						'amount':
							title += "%s" % str(val, " ")
						'type':
							title += str(get_type_str(val, ref), ".")
								
				list.push_back({
					"uid": str(c_index, o_index),
					"title": title,
					"hints": hints,
					"you_have": func() -> int: 
						return check_for_current(objective.criteria),
					"is_completed": func() -> bool:
						return check_for_criteria(objective.criteria),
				})
		
		objective_list.push_back({
			"title": chapter.objectives.title,
			"list": list,
			"complete_by_day": chapter.objectives.complete_by_day
		})	
				
	
	return objective_list
# ----------------------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------------------
func get_chapter(chapter:int) -> Dictionary:
	return chapters[chapter]
# ----------------------------------------------------------------------------------------------
