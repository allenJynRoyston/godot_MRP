extends SubscribeWrapper

enum {HAVE_AT_LEAST, HAVE_MORE_THAN, HAVE_NO_MORE_THAN, HAVE_LESS_THAN, HAVE_EXACTLY}
enum {CURRENCY, BUILDING}

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
			"title": "Setup the facility.",
			"list":[
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 1,
						"type": BUILDING,
						"ref": ROOM.REF.STANDARD_CONTAINMENT_CELL
					},
				},
				{
					"criteria": {
						"action": HAVE_EXACTLY,
						"amount": 1,
						"type": BUILDING,
						"ref": ROOM.REF.HQ
					},
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
				{
					"criteria": {
						"action": HAVE_MORE_THAN,
						"amount": 50,
						"type": CURRENCY,
						"ref": RESOURCE.CURRENCY.SCIENCE
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
	for chapter in chapters:
		var list:Array = []	
		for objective in chapter.objectives.list:
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
					"title": title,
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
