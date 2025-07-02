extends SubscribeWrapper

enum {HAVE_AT_LEAST, HAVE_MORE_THAN, HAVE_NO_MORE_THAN, HAVE_LESS_THAN, HAVE_EXACTLY}
enum TYPE {CURRENCY, BUILDING, SCP}

var chapters:Array = [
	# ----------------------------------------------------------------------------------------------
	{
		"story_message": [
			"Alright, listen up D-9973, uh... okay, you know what.  If I have to use your full name each time this is going to take forever.  You're just D from now on.",
			"I know it's not very professional, but I've been doing this all day and we just need to get through it.",
			"Now, lets go over your situation.  As far as you're conerned, you just hit the lottery.  Out of all the horrors we could of had you test on, this one is relatively harmless.",
			"Nothing going to come out of the screen.  There's no monsters hidden around the corner.  We literally just need you to test some software.",
			"In front of you is a computer.  There's a game on there called \"Site Director Training Program\".",
			"You're gonna play until you beat it.  If you're able to do that we let you go. If you don't, then I'm afraid we have to terminate you.",
			"For now, just get past day 10.",
		],
		"objectives": {
			"title": "Setup up facility.",
			"complete_by_day": 2,
			"required":[
				# --------------------- CRITERIA BASED OBJECTIVES
				{ 
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 1,
						"type": TYPE.BUILDING,
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
						"type": TYPE.BUILDING,
						"ref": ROOM.REF.HQ
					},
					"hints": [
						{"title": "Step 1", "cost": 1},
					]
				},
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 1,
						"type": TYPE.BUILDING,
						"ref": ROOM.REF.HR_DEPARTMENT
					},
					"hints": [
						{"title": "Step 1", "cost": 1},
					]
				},
				{
					"custom": {
						"title": "Activate all rooms.",
						"count_str": func(amount:int) -> String:
							var activated_count:int = ROOM_UTIL.get_activated_count()
							return "(Rooms activated: %s out of %s)" % [activated_count, amount],
						"you_have": func() -> int: 
							return purchased_facility_arr.size(),
						"is_completed": func() -> bool:
							var total_count:int = purchased_facility_arr.size()
							var activated_count:int = ROOM_UTIL.get_activated_count()
							return total_count > 0 and total_count == activated_count,
						},
					"hints": [
						{"title": "Custom step A", "cost": 1},
					]
				},
				# ---------------------
			],
			"optional": [
				# --------------------- OPTIONAL
				{
					"custom": {
						"is_optional": true,
						"title": "%s is enabled" % [ABL_P.get_ability(ABL_P.REF.OBJECTIVE_ASSIST).name],
						"count_str": func(amount:int) -> String:
							# purposely don't want to render this
							return "",
						"you_have": func() -> int: 
							return 1 if ROOM_UTIL.check_if_passive_is_active(ABL_P.REF.OBJECTIVE_ASSIST) else 0,
						"is_completed": func() -> bool:
							return ROOM_UTIL.check_if_passive_is_active(ABL_P.REF.OBJECTIVE_ASSIST),
						},
					"hints": [
						{"title": "Step custom 1", "cost": 1},
					]
				},
				{
					"custom": {
						"is_optional": true,
						"title": "%s is enabled." % [ABL_P.get_ability(ABL_P.REF.PREDICTIVE_TIMELINE).name],
						"count_str": func(amount:int) -> String:
							# purposely don't want to render this
							return "",
						"you_have": func() -> int: 
							return 1 if ROOM_UTIL.check_if_passive_is_active(ABL_P.REF.PREDICTIVE_TIMELINE) else 0,
						"is_completed": func() -> bool:
							return ROOM_UTIL.check_if_passive_is_active(ABL_P.REF.PREDICTIVE_TIMELINE),
						},
					"hints": [
						{"title": "Step custom 1", "cost": 1},
					]
				},				
				# ---------------------
			],
			
		},
	},
	# ----------------------------------------------------------------------------------------------
	
	# ----------------------------------------------------------------------------------------------
	{
		"objectives": {
			"title": "Contain an SCP.",
			"complete_by_day": 5,
			"required":[
				# --------------------- CRITERIA BASED OBJECTIVES
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 1,
						"type": TYPE.BUILDING,
						"ref": ROOM.REF.STANDARD_CONTAINMENT_CELL
					},
					"hints": [
						{"title": "Step 1", "cost": 1},
					]
				},
				{
					"custom": {
						"title": "Contain an SCP.",
						"count_str": func(amount:int) -> String:
							# purposely don't want to render this
							return "(Currently contained: %s)" % amount,
						"you_have": func() -> int: 
							return scp_data.size(),
						"is_completed": func() -> bool:
							return scp_data.size() > 0,
						},
					"hints": [
						{"title": "Step custom 1", "cost": 1},
					]
				},
			],
			"optional": [
				# --------------------- OPTIONAL
				{
					"custom": {
						"title": "Contain SCP-T-001",
						"count_str": func(amount:int) -> String:
							# purposely don't want to render this
							return "",
						"you_have": func() -> int: 
							return 0,
						"is_completed": func() -> bool:
							for ref in scp_data:
								var scp_details:Dictionary = SCP_UTIL.return_data(ref)
								if scp_details.name == "SCP-T-001":
									return true
							return false,
						},
					"hints": [
						{"title": "Step custom 1", "cost": 1},
					]
				},
			],
		},
	},
	# ----------------------------------------------------------------------------------------------	
	
	
	# ----------------------------------------------------------------------------------------------
	{
		"objectives": {
			"title": "Collect resources.",
			"complete_by_day": 10,
			"required":[
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 500,
						"type": TYPE.CURRENCY,
						"ref": RESOURCE.CURRENCY.MONEY
					},
				},
			],
			
		},
	},
	# ----------------------------------------------------------------------------------------------		
];


# ----------------------------------------------------------------------------------------------		
func get_action_str(val:int) -> String:
	match val:
		STORY.HAVE_AT_LEAST:
			return "Have at least"	
		STORY.HAVE_MORE_THAN:
			return "have more than"	
		STORY.HAVE_NO_MORE_THAN:
			return "Have no more than"
		STORY.HAVE_LESS_THAN:
			return "Have less than"
		STORY.HAVE_EXACTLY:
			return "Have exactly"
	return ""

func get_type_str(val:int, ref:int) -> String:
	match val:
		# -------
		STORY.TYPE.CURRENCY:
			return RESOURCE_UTIL.return_currency(ref).name
		STORY.TYPE.BUILDING:
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
		STORY.TYPE.CURRENCY:
			return resources_data[criteria.ref].amount 
		STORY.TYPE.BUILDING:
			return ROOM_UTIL.build_count(criteria.ref)
			
	return -1
# ----------------------------------------------------------------------------------------------		

# ----------------------------------------------------------------------------------------------
func get_objectives() -> Array:
	var objective_list:Array = []
	for c_index in chapters.size():
		var chapter:Dictionary = chapters[c_index]
		var list:Array = []
		
		var all_objectives:Array = []
		if chapter.objectives.has("required"):
			for item in chapter.objectives.required:
				item.is_optional = false
				all_objectives.push_back(item)
					
		if chapter.objectives.has("optional"):
			for item in chapter.objectives.optional:
				item.is_optional = true
				all_objectives.push_back(item)
										
		
		for o_index in all_objectives.size():
			var objective:Dictionary = all_objectives[o_index]
			var hints:Array = []
			var uid:String = str(c_index, o_index)
			var is_optional:bool = objective.is_optional
			
			# ------------------------------------------------------------------
			if objective.has("hints"):
				for h_index in objective.hints.size():
					var hint:Dictionary = objective.hints[h_index]
					var hint_uid:String = str(c_index, o_index, h_index)
					
					hints.push_back({
						"title": hint.title,
						"cost": hint.cost,
						"uid": hint_uid, 
						"is_purchased": func() -> bool:
							return hint_uid in SUBSCRIBE.hints_unlocked
					})
			
			# ------------------------------------------------------------------
			if objective.has("custom"):
				var new_objective:Dictionary = {
					"uid": uid,
					"title": objective.custom.title,
					"hints": hints,
					"is_optional": is_optional,
					"count_str": objective.custom.count_str,
					"you_have": objective.custom.you_have,
					"is_completed": objective.custom.is_completed
				}
				
				# sort into optional or regular list
				list.push_back(new_objective)
					
			# ------------------------------------------------------------------
			if objective.has("criteria"):
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
				
				var new_objective:Dictionary = {
					"uid": uid,
					"title": title,
					"hints": hints,
					"is_optional": is_optional,
					"count_str": func(amount:int) -> String:
						return "(You currently have %s)" % amount,
					"you_have": func() -> int: 
						return check_for_current(objective.criteria),
					"is_completed": func() -> bool:
						return check_for_criteria(objective.criteria),
				}
				
				# sort into optional or regular list
				list.push_back(new_objective)
				
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
