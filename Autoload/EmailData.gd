extends SubscribeWrapper

enum {HAVE_AT_LEAST, HAVE_MORE_THAN, HAVE_NO_MORE_THAN, HAVE_LESS_THAN, HAVE_EXACTLY}
enum {CURRENCY, BUILDING}

var chapters:Array = [
	# ---------------------------------------------------------------------------------------------- TUTORIAL
	{
		"story_message": [
			"My name is Site Director Ambrosia, and if you're receiving this message, then it means that I'm dead and this failsafe has been triggered.",
			"In front of you is a computer.  It has been prepared for you well in advance and has been specifically designed to restore your memory.",
			"Complete the tutorial and I'll tell you more."
		],
		"objectives": {
			"title": "Setup the facility.",
			"list":[
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
			"complete_by_day": chapter.complete_by_day
		})	
				
	
	return objective_list
# ----------------------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------------------
func get_chapter(chapter:int) -> Dictionary:
	return chapters[chapter]
# ----------------------------------------------------------------------------------------------
