extends SubscribeWrapper

enum {HAVE_AT_LEAST, HAVE_MORE_THAN, HAVE_NO_MORE_THAN, HAVE_LESS_THAN, HAVE_EXACTLY}
enum TYPE {CURRENCY, BUILDING, PERSONNEL, SCP}

var chapters:Array = [
	# ----------------------------------------------------------------------------------------------
	{
		"story_message": [
			"Good morning, D-Class 2477.",
			"My name is Doctor Ambrose, and you have been selected to test SCP-[REDACTED], which has taken on the form of a computer.",
			"It's the one on your left.",
			"We need you to interact with it.  There's an application on it called Site Director Training Program.",
			"Your task is straightforward: learn the rules, complete the objectives, and provide input when prompted.",
			"There is no penalty for failure. However, progression will be noted and rewarded.",
			"Do not attempt to leave your station, tamper with the equipment, or damage anything in the room. Any such actions will be treated as a breach of protocol and you will be terminated.",
			"That will be all, D-2477. Begin when ready."
		],
		"complete_by_day": 7,
		"objectives": {
			"required":[
				{ 
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 50,
						"type": TYPE.CURRENCY,
						"ref": RESOURCE.CURRENCY.MONEY
					},
				},
			],
		}
	},
	# ----------------------------------------------------------------------------------------------
	{
		"complete_by_day": 14,
		"objectives": {
			"required":[
				{ 
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 50,
						"type": TYPE.CURRENCY,
						"ref": RESOURCE.CURRENCY.SCIENCE
					},
				},
			],
		}
	},
	# ----------------------------------------------------------------------------------------------
	
	# ----------------------------------------------------------------------------------------------
	{
		"complete_by_day": 21,
		"objectives": {
			"required":[
				{ 
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 50,
						"type": TYPE.CURRENCY,
						"ref": RESOURCE.CURRENCY.MATERIAL
					},
				},
			],
		}
	},
	# ----------------------------------------------------------------------------------------------	
	
	# ----------------------------------------------------------------------------------------------
	{
		"complete_by_day": 28,
		"objectives": {
			"required":[
				{ 
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 100,
						"type": TYPE.CURRENCY,
						"ref": RESOURCE.CURRENCY.MONEY
					},
				},
				{ 
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 100,
						"type": TYPE.CURRENCY,
						"ref": RESOURCE.CURRENCY.MATERIAL
					},
				},
				{ 
					"criteria": {
						"action": HAVE_AT_LEAST,
						"amount": 100,
						"type": TYPE.CURRENCY,
						"ref": RESOURCE.CURRENCY.SCIENCE
					},
				},
			],
		}
	},
	# ----------------------------------------------------------------------------------------------		

	## ----------------------------------------------------------------------------------------------
	#{
		#"complete_by_day": 15,
		#"objectives": {
			#"title": "CONTAIN AN SCP",
			#
			#"required":[
				#{
					#"criteria": {
						#"action": HAVE_AT_LEAST,
						#"amount": 3,
						#"type": TYPE.BUILDING,
						#"ref": ROOM.REF.STANDARD_CONTAINMENT_CELL
					#},
				#},
				#{
					#"criteria": {
						#"action": HAVE_AT_LEAST,
						#"amount": 3,
						#"type": TYPE.SCP,
					#},
				#},
				#{
					#"custom": {
						#"title": "Survive for at least 28 days.",
						#"count_str": func(amount:int) -> String:
							#return "(Survive for %s more days." % [progress_data.day - amount],
						#"you_have": func() -> int: 
							#return progress_data.day,
						#"is_completed": func() -> bool:
							#return progress_data.day >= 28,
						#},
					#"hints": [
						#{"title": "Custom step A", "cost": 1},
					#]
				#},
			#],
			#
		#},
	#},
	## ----------------------------------------------------------------------------------------------		
	#
	#
	#
	## ----------------------------------------------------------------------------------------------
	#{
		#"objectives": {
			#"title": "GATHER RESOURCES",
			#"complete_by_day": 25,
			#"required":[
				#{
					#"criteria": {
						#"action": HAVE_AT_LEAST,
						#"amount": 1000,
						#"type": TYPE.CURRENCY,
						#"ref": RESOURCE.CURRENCY.MONEY
					#},
				#},
				#{
					#"criteria": {
						#"action": HAVE_AT_LEAST,
						#"amount": 500,
						#"type": TYPE.CURRENCY,
						#"ref": RESOURCE.CURRENCY.SCIENCE
					#},
				#},
				#{
					#"criteria": {
						#"action": HAVE_AT_LEAST,
						#"amount": 250,
						#"type": TYPE.CURRENCY,
						#"ref": RESOURCE.CURRENCY.MATERIAL
					#},
				#},
				#{
					#"criteria": {
						#"action": HAVE_AT_LEAST,
						#"amount": 20,
						#"type": TYPE.CURRENCY,
						#"ref": RESOURCE.CURRENCY.CORE
					#},
				#},				
			#],
			#
		#},
	#},
	## ----------------------------------------------------------------------------------------------		
			
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
func get_previous_objective() -> Dictionary:
	var objectives:Array = get_objectives()
	return objectives[get_current_objective_index() - 1]
	
func get_current_objective() -> Dictionary:
	var on_chapter:int = 0
	
	for index in chapters.size():
		var chapter:Dictionary = chapters[index]
		if progress_data.day <= chapter.complete_by_day:
			on_chapter = index
			break

	var objectives:Array = get_objectives()
	return objectives[on_chapter]
	
func get_current_objective_index() -> int:
	var on_chapter:int = 0
	
	for index in chapters.size():
		var chapter:Dictionary = chapters[index]
		if progress_data.day <= chapter.complete_by_day:
			on_chapter = index
			break
			
	return on_chapter

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
			"title": chapter.objectives.title if chapter.objectives.has("title") else "REDACTED",
			"list": list,
			"complete_by_day": chapter.complete_by_day,
			"reward_event": chapter.objectives.reward_event if chapter.objectives.has("reward_event") else -1
		})	
	
	return objective_list
# ----------------------------------------------------------------------------------------------


# ----------------------------------------------------------------------------------------------
func get_chapter(chapter:int) -> Dictionary:
	return chapters[chapter]
# ----------------------------------------------------------------------------------------------
