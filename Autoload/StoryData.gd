extends SubscribeWrapper

enum {HAVE_AT_LEAST, HAVE_MORE_THAN, HAVE_NO_MORE_THAN, HAVE_LESS_THAN, HAVE_EXACTLY}
enum TYPE {CURRENCY, BUILDING, PERSONNEL, SCP}

var chapters:Array = [
	# ----------------------------------------------------------------------------------------------
	{
		"story_message": [
			"D-Class 313202, you're finally awake. I'm Researcher Ambrose. I'm overseeing the study of... whatever that is in front of you.",
			"Good news first — your job's pretty simple. That computer right there has a piece of software on it.",
			"Specifically, it’s called the Site Director Training Program.",
			"All you have to do is learn it. That’s it.",
			"You complete the program, we let you walk free. Simple.",
			"Now, the bad news.",
			"If you refuse, or take too long? The bomb around your neck goes off.",
			"Well... that's all you need to know for now. Get to work."
		],
		"objectives": {
			"title": "SETUP",
			"complete_by_day": 2,
			"required":[
				{
					"custom": {
						"title": "Supply power to AT LEAST 1 floor.",
						"count_str": func(amount:int) -> String:
							return "Required 1 FLOOR to be activated.",
						"you_have": func() -> int: 
							return GAME_UTIL.get_activated_floor_count(),
						"is_completed": func() -> bool:
							return GAME_UTIL.get_activated_floor_count() > 0,
						},
					"hints": [
						{"title": "Custom step A", "cost": 1},
					]
				},
			],
		},
		"tutorial": {
			"title": "TUTORIAL 1",
			"text": [
				'Welcome Site Director.'
			]			
		}
	},
		
	# ----------------------------------------------------------------------------------------------
	{
		"story_message": [
			"You've probably already figured this out, but I'm not actually here.  These messages are just recordings.",
			"Yeah, I know, it's a bit impersonal but it's not like you'd have much to say anyway.",
			"You see we wiped your memory before we started.  I can't really explain why, you're just going to have to go with it.",
			"But hey, if you beat this game you'll get your memory back guaranteed.",
			"For most that's a good enough motivation to finish.",
			"But you... you're special."
		],			
		"objectives": {
			"title": "SETUP",
			"complete_by_day": 4,
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
						{"title": "Step 2", "cost": 2},
						{"title": "Step 3", "cost": 5},
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
			],
			"optional": [

			],
		},
		"rewarded": func() -> Array:
			return [
				{
					"room_ref": ROOM.REF.HR_DEPARTMENT, 
					"title":  ROOM_UTIL.return_data(ROOM.REF.HR_DEPARTMENT).name,
					"val": {
						"func": GAME_UTIL.rewarded_room.bind(ROOM.REF.HR_DEPARTMENT),
					},
					"hint_description": ROOM_UTIL.return_data(ROOM.REF.HR_DEPARTMENT).description
				},
				{
					"room_ref": ROOM.REF.OPERATIONS_SUPPORT, 
					"title":  ROOM_UTIL.return_data(ROOM.REF.OPERATIONS_SUPPORT).name,
					"val": {
						"func": GAME_UTIL.rewarded_room.bind(ROOM.REF.OPERATIONS_SUPPORT),
					},
					"hint_description": ROOM_UTIL.return_data(ROOM.REF.OPERATIONS_SUPPORT).description
				}							
		],
		"tutorial": {
			"title": "TUTORIAL 2",
			"text": [
				'Tutorial 2.'
			]			
		}		
	},
	# ----------------------------------------------------------------------------------------------
	
	# ----------------------------------------------------------------------------------------------
	{
		"objectives": {
			"title": "STAFF UP",
			"story_message": [
				"Congratulations D-Class 313202, seems like you're getting the hang of it.",
				"Now... you've probably noticed that this computer will... lie to you.",
				"You cannot trust what it says.  Like at all.  It lies a lot.  That's its one defining trait.",
				"Just focus on beating that game for now.",
				"It will not make that goal easy."
			],			
			"complete_by_day": 10,
			"required":[
				# --------------------- CRITERIA BASED OBJECTIVES
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 5,
						"type": TYPE.PERSONNEL,
						"ref": RESEARCHER.SPECIALIZATION.ADMIN
					},
					"hints": [
						{"title": "Step 1", "cost": 1},
					]
				},
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 5,
						"type": TYPE.PERSONNEL,
						"ref": RESEARCHER.SPECIALIZATION.RESEARCHER
					},
					"hints": [
						{"title": "Step 1", "cost": 1},
					]
				},
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 5,
						"type": TYPE.PERSONNEL,
						"ref": RESEARCHER.SPECIALIZATION.SECURITY
					},
					"hints": [
						{"title": "Step 1", "cost": 1},
					]
				},

			],
			"optional": [
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 5,
						"type": TYPE.PERSONNEL,
						"ref": RESEARCHER.SPECIALIZATION.DCLASS
					},
					"hints": [
						{"title": "Step 1", "cost": 1},
					]
				},				
			],
		},
		"rewarded": func() -> Array:
			return [
				{
					"title":  ROOM_UTIL.return_data(ROOM.REF.GEOTHERMAL_POWER).name,
					"val": {
						"func": GAME_UTIL.rewarded_room.bind(ROOM.REF.GEOTHERMAL_POWER),
					},
					"hint_description": ROOM_UTIL.return_data(ROOM.REF.GEOTHERMAL_POWER).description
				},
				{
					"title":  ROOM_UTIL.return_data(ROOM.REF.MINIERAL_MINING).name,
					"val": {
						"func": GAME_UTIL.rewarded_room.bind(ROOM.REF.MINIERAL_MINING),
					},
					"hint_description": ROOM_UTIL.return_data(ROOM.REF.MINIERAL_MINING).description
				}				
		],
	},
	# ----------------------------------------------------------------------------------------------	

	# ----------------------------------------------------------------------------------------------
	{
		"objectives": {
			"title": "CONTAIN AN SCP",
			"complete_by_day": 15,
			"required":[
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 3,
						"type": TYPE.BUILDING,
						"ref": ROOM.REF.STANDARD_CONTAINMENT_CELL
					},
				},
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 3,
						"type": TYPE.SCP,
					},
				},
				{
					"custom": {
						"title": "Survive for at least 28 days.",
						"count_str": func(amount:int) -> String:
							return "(Survive for %s more days." % [progress_data.day - amount],
						"you_have": func() -> int: 
							return progress_data.day,
						"is_completed": func() -> bool:
							return progress_data.day >= 28,
						},
					"hints": [
						{"title": "Custom step A", "cost": 1},
					]
				},
			],
			
		},
	},
	# ----------------------------------------------------------------------------------------------		
	
	
	
	# ----------------------------------------------------------------------------------------------
	{
		"objectives": {
			"title": "GATHER RESOURCES",
			"complete_by_day": 25,
			"required":[
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 1000,
						"type": TYPE.CURRENCY,
						"ref": RESOURCE.CURRENCY.MONEY
					},
				},
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 500,
						"type": TYPE.CURRENCY,
						"ref": RESOURCE.CURRENCY.SCIENCE
					},
				},
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 250,
						"type": TYPE.CURRENCY,
						"ref": RESOURCE.CURRENCY.MATERIAL
					},
				},
				{
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 20,
						"type": TYPE.CURRENCY,
						"ref": RESOURCE.CURRENCY.CORE
					},
				},				
			],
			
		},
	},
	# ----------------------------------------------------------------------------------------------		
			
];


	#{
		#"criteria": {
			#"action": HAVE_AT_LEAST,
			#"amount": 1,
			#"type": TYPE.BUILDING,
			#"ref": ROOM.REF.HQ
		#},
		#"hints": [
			#{"title": "Step 1", "cost": 1},
		#]
	#},
#
	#{
		#"custom": {
			#"title": "Activate all rooms.",
			#"count_str": func(amount:int) -> String:
				#var activated_count:int = ROOM_UTIL.get_activated_count()
				#return "(Rooms activated: %s out of %s)" % [activated_count, amount],
			#"you_have": func() -> int: 
				#return purchased_facility_arr.size(),
			#"is_completed": func() -> bool:
				#var total_count:int = purchased_facility_arr.size()
				#var activated_count:int = ROOM_UTIL.get_activated_count()
				#return total_count > 0 and total_count == activated_count,
			#},
		#"hints": [
			#{"title": "Custom step A", "cost": 1},
		#]
	#},
	# ---------------------

			#"optional": [
				## --------------------- OPTIONAL
				#{ 
					#"criteria": {
						#"action": HAVE_AT_LEAST,
						#"amount": 1,
						#"type": TYPE.BUILDING,
						#"ref": ROOM.REF.UI_ASSIST
					#},
					#"hints": [
						#{"title": "Step 1", "cost": 1},
						#{"title": "Step 2", "cost": 2},
						#{"title": "Step 3", "cost": 5},
					#]
				#},				
				#{
					#"custom": {
						#"is_optional": true,
						#"title": "%s is enabled" % [ABL_P.get_ability(ABL_P.REF.OBJECTIVE_ASSIST).name],
						#"count_str": func(amount:int) -> String:
							## purposely don't want to render this
							#return "",
						#"you_have": func() -> int: 
							#return 1 if ROOM_UTIL.check_if_passive_is_active(ABL_P.REF.OBJECTIVE_ASSIST) else 0,
						#"is_completed": func() -> bool:
							#return ROOM_UTIL.check_if_passive_is_active(ABL_P.REF.OBJECTIVE_ASSIST),
						#},
					#"hints": [
						#{"title": "Step custom 1", "cost": 1},
					#]
				#},
				#{
					#"custom": {
						#"is_optional": true,
						#"title": "%s is enabled." % [ABL_P.get_ability(ABL_P.REF.PREDICTIVE_TIMELINE).name],
						#"count_str": func(amount:int) -> String:
							## purposely don't want to render this
							#return "",
						#"you_have": func() -> int: 
							#return 1 if ROOM_UTIL.check_if_passive_is_active(ABL_P.REF.PREDICTIVE_TIMELINE) else 0,
						#"is_completed": func() -> bool:
							#return ROOM_UTIL.check_if_passive_is_active(ABL_P.REF.PREDICTIVE_TIMELINE),
						#},
					#"hints": [
						#{"title": "Step custom 1", "cost": 1},
					#]
				#},				
				## ---------------------
			#],

# ----------------------------------------------------------------------------------------------		
func check_for_criteria(criteria:Dictionary) -> bool:
	var current_amount = check_for_current(criteria)
	match criteria.action:
		HAVE_AT_LEAST:
			return current_amount >= criteria.amount
		HAVE_MORE_THAN:
			return current_amount > criteria.amount
		HAVE_NO_MORE_THAN:
			return current_amount <= criteria.amount
		HAVE_LESS_THAN:
			return current_amount < criteria.amount
		HAVE_EXACTLY:
			return current_amount == criteria.amount
	return false
	

func get_action_str(val:int) -> String:
	match val:
		HAVE_AT_LEAST:
			return "Have at least"	
		HAVE_MORE_THAN:
			return "have more than"	
		HAVE_NO_MORE_THAN:
			return "Have no more than"
		HAVE_LESS_THAN:
			return "Have less than"
		HAVE_EXACTLY:
			return "Have exactly"
	return ""

func get_type_str(val:int, ref:int) -> String:
	match val:
		# -------
		TYPE.CURRENCY:
			return RESOURCE_UTIL.return_currency(ref).name
		TYPE.BUILDING:
			return ROOM_UTIL.return_data(ref).name
		TYPE.PERSONNEL:
			return RESEARCHER_UTIL.return_specialization_data(ref).name
		TYPE.SCP:
			return ""
			
		# -------
	return "UNDEFINED"


func check_for_current(criteria:Dictionary) -> int:
	match criteria.type:
		# --------
		TYPE.CURRENCY:
			return resources_data[criteria.ref].amount 
		TYPE.BUILDING:
			return ROOM_UTIL.build_count(criteria.ref)
		TYPE.PERSONNEL:
			return RESEARCHER_UTIL.get_spec_count(criteria.ref)
		TYPE.SCP:
			return -1
			
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
				var ref:int = objective.criteria.ref if objective.criteria.has("ref") else -1
				
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
