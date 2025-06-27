@tool
extends SubscribeWrapper

# ------------------------------------------------------------------------
var GAME_OVER:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
			
		return [
			# ---------
			func() -> Dictionary:
				return {
					"header": "FAIL STATE",
					"img_src": "res://Media/images/redacted.png",
					"text": [
						"Your facility has fallen into disarray.",
					],
					"options": [
						{
							"show": true,
							"title": "Restart.",
							"val": EVT.GAME_OVER_OPTIONS.RESTART,
							"onSelected": onSelected
						},
						{
							"show": true,
							"title": "Restart with random perk.",
							"val": EVT.GAME_OVER_OPTIONS.RESTART,
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				props.onSelection.call(option_selected.val)
				return {
					"text": [
						"You selected %s" % [option_selected.val],
					]
				}	
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var SCP_ON_CONTAINMENT:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var event_ref:int = EVT.TYPE.SCP_ON_CONTAINMENT
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
		
		var room_details:Dictionary = props.room_details
		var scp_details:Dictionary = props.scp_details
		var scp_entry:Dictionary = props.scp_entry
		var researchers:Array = props.researchers
		
		var event:Dictionary = scp_details.event[event_ref]
		var selected_staff:Dictionary = {} if researchers.size() == 0 else researchers[U.generate_rand(0, researchers.size() - 1)]
		var vibes:Dictionary = GAME_UTIL.get_vibes_summary(scp_entry.location)	

		# add additional props and send to event
		props.selected_staff = selected_staff
		props.vibes = vibes
		
		# build out story
		var story_text:Array = []
		for line in event.story.call(props):
			story_text.push_back(line)
		
		# build out choices
		var choices_data:Dictionary = event.choices.call(props)
		var options:Array = []
		
		# build "standard" choices
		if "standard" in choices_data:
			for choice in choices_data.standard:
				choice.onSelected = onSelected
				options.append(choice)
		
		# build "traits" choices
		if "traits" in choices_data and selected_staff.trait.ref in choices_data.traits:
			var choice:Dictionary = choices_data.traits[selected_staff.trait.ref]
			choice.onSelected = onSelected
			options.append(choice)
			
		# build "mode" choices
		if "mood" in choices_data and selected_staff.mood.ref in choices_data.mood:
			var choice:Dictionary = choices_data.mood[selected_staff.mood.ref]
			choice.onSelected = onSelected
			options.append(choice)			
			
			
		return [
			# ---------
			func() -> Dictionary:
				return {
					"title": scp_details.name,
					"subtitle": scp_details.nickname,
					"img_src": scp_details.img_src,
					"text": story_text,
					"options": options
				},
			# ---------
			func() -> Dictionary:
				var random_int:int = U.generate_rand(0, 100)
				var is_success:bool = (option_selected.val.option.success_rate) > random_int
				
				# run the effect
				var res:Dictionary = {}
				if "effect" in option_selected.val.option:
					res = option_selected.val.option.effect.call(is_success)
					# record event
					if event_ref not in scp_data[scp_details.ref].event_results:
						scp_data[scp_details.ref].event_results[event_ref] = [] 
					scp_data[scp_details.ref].event_results[event_ref].push_back({"results": res, "title": option_selected.val.option.title})
				
				return {
					"set_return_val": func(): return res,
					"text":option_selected.val.option.story.call(is_success)
				}	

					
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var SCP_BREACH_EVENT_1:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var event_ref:int = EVT.TYPE.SCP_BREACH_EVENT_1
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
		
		var room_details:Dictionary = props.room_details
		var scp_details:Dictionary = props.scp_details
		var scp_entry:Dictionary = props.scp_entry
		var researchers:Array = props.researchers
		var breach_count:int = scp_entry.breach_count
				
		var event:Dictionary = scp_details.event[event_ref]
		var selected_staff:Dictionary = {} if researchers.size() == 0 else researchers[U.generate_rand(0, researchers.size() - 1)]
		var vibes:Dictionary = GAME_UTIL.get_vibes_summary(scp_entry.location)	

		# add additional props and send to event
		props.selected_staff = selected_staff
		props.vibes = vibes
		props.breach_count = breach_count
		
		# build out story
		var story_text:Array = []
		for line in event.story.call(props):
			story_text.push_back(line)
		
		# build out choices
		var choices_data:Dictionary = event.choices.call(props)
		var options:Array = []
		
		# build "standard" choices
		if "standard" in choices_data:
			for choice in choices_data.standard:
				choice.onSelected = onSelected
				options.append(choice)
		
		# build "traits" choices
		if "traits" in choices_data and selected_staff.trait.ref in choices_data.traits:
			var choice:Dictionary = choices_data.traits[selected_staff.trait.ref]
			choice.onSelected = onSelected
			options.append(choice)
			
		# build "mode" choices
		if "mood" in choices_data and selected_staff.mood.ref in choices_data.mood:
			var choice:Dictionary = choices_data.mood[selected_staff.mood.ref]
			choice.onSelected = onSelected
			options.append(choice)			
			
			
		return [
			# ---------
			func() -> Dictionary:
				return {
					"title": scp_details.name,
					"subtitle": scp_details.nickname,
					"img_src": scp_details.img_src,
					"text": story_text,
					"options": options
				},
			# ---------
			func() -> Dictionary:
				var random_int:int = U.generate_rand(0, 100)
				var is_success:bool = (option_selected.val.option.success_rate) > random_int
				
				# run the effect
				var res:Dictionary = {}
				if "effect" in option_selected.val.option:
					res = option_selected.val.option.effect.call(is_success)
					# record results
					if event_ref not in scp_data[scp_details.ref].event_results:
						scp_data[scp_details.ref].event_results[event_ref] = [] 
					scp_data[scp_details.ref].event_results[event_ref].push_back({"results": res, "title": option_selected.val.option.title})
					SUBSCRIBE.scp_data = scp_data
				
				return {
					"set_return_val": func(): return res,
					"text":option_selected.val.option.story.call(is_success)
				}	

					
		],
}
# ------------------------------------------------------------------------


# ------------------------------------------------------------------------
var HIRE_RESEARCHER:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"selected": null
		}
		var onSelected = func(selected) -> void:
			option_selected.selected = selected.option.val
		
		var text:Array = []
		var researcher:Dictionary = props.researcher
		
		# -------------  ORIGINAL, NO CLONES 
		text = [
			"You've hired a new researcher!"
		]

		return [
			# ---------
			func() -> Dictionary:
				return {
					"title": "HIRE RESEARCHER",
					"img_src": "res://Media/images/redacted.png",
					"text": text,
					"portrait": {
						"title": props.researcher.name,
						"img_src": props.researcher.img_src
					},
					"options": [
						# ----------------------------------------- NON-RESPONSE
						{
							"include": true,
							"title": "Celebrate!",
							"val": {
								"response": "RESPONSE GOES HERE",
							},
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				if "onSelection" in props:
					props.onSelection.call(option_selected.selected)
					
				return {
					"text": [
						option_selected.selected.response
					]
				}	
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var CLONE_RESEARCHER:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"selected": null
		}
		var onSelected = func(selected) -> void:
			option_selected.selected = selected.option.val
		
		var text:Array = []
		var clone_props:Dictionary = props.researcher.clone
		# -------------  ORIGINAL, NO CLONES 
		text = [
			"The cloning protocol executed without deviation.",
			"Subject [name] is confirmed as the baseline instance.",
			"No replication anomalies or psychological drift detected. Subject retains full cognitive function and baseline identity markers."
		]

		# -------------  IS FIRST CLONE
		if clone_props.clone_iteration == 1:
			text = [
				"The cloning protocol completed successfully.",
				"Subject [name] (Clone-1) exhibits minor cognitive variance from the original baseline, observed primarily under psychological stress.",
				"Deviation deemed within acceptable thresholds for first-generation replication."
			]

		# -------------  IS CLONE OF A CLONE
		if clone_props.clone_iteration > 1:
			text = [
				"Subject [name] is a subsequent-generation clone.",
				"Notable deviations in memory retention and behavioral response were recorded during psychometric assessment.", 
				"Linguistic patterns suggest iterative corruption of identity schema. Clone origin traced to non-original progenitor."
			]			

		# -------------  IS HIGH-GENERATION CLONE (iteration > 3)
		if clone_props.clone_iteration > 3:
			text = [
				"Subject [name] (Clone-[iteration]) demonstrates critical psychological degradation.",
				"Delusional ideation, temporal dislocation, and identity fragmentation were evident within minutes of activation.",
				"Clone has been classified as cognitively unstable and transferred to Isolation Wing-7 pending reassessment."
			]

		# -------------  TOO MANY CLONES TO TRACK
		if clone_props.clone_copies > 2:
			text = [
				"Clone proliferation has exceeded containment projections.",
				"Multiple instances of subject [name] are active simultaneously, rendering individual identification unreliable.", 
				"Visual resemblance and behavioral mimicry are near-identical.", 
				"Incident Log ███-█ recommends immediate moratorium on further replications and initiation of Termination Protocol Alpha-7."
			]


		return [
			# ---------
			func() -> Dictionary:
				return {
					"header": "CLONING EVENT",
					"img_src": "res://Media/images/redacted.png",
					"text": text,
					"portrait": {
						"title": props.researcher.name,
						"img_src": props.researcher.img_src
					},
					"options": [
						# ----------------------------------------- NON-RESPONSE
						{
							"include": true,
							"title": "Okay.",
							"val": {
								"response": "RESPONSE GOES HERE",
							},
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				if "onSelection" in props:
					props.onSelection.call(option_selected.selected)
					
				return {
					"text": [
						option_selected.selected.response
					]
				}	
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var PROMOTE_RESEARCHER:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"selected": null
		}
		var onSelected = func(selected) -> void:
			option_selected.selected = selected.option.val
		
		var trait_arr:Array = []
		for trait_ref in props.researcher.traits:
			var trait_data:Dictionary = RESEARCHER_UTIL.return_trait_data(trait_ref)
			trait_arr.push_back(trait_data)
		
		var use_trait:Dictionary = trait_arr[U.generate_rand(0,trait_arr.size() - 1)]
	
		var text:Array = []
		
		# ----------------------------------------- ONE RESEARCHER
		if hired_lead_researchers_arr.size() == 0:
			text = [
				"Researcher %s.  Congratulations, you're being promoted." % props.researcher.name,
				'"Promoted? Huh." They glance around the empty lab. "Guess I\'m talking to the containment logs now.",
				"A quiet sigh follows — half-pride, half-loneliness — before they get back to work.'
			]
		
		# ----------------------------------------- SMALL TEAM
		elif hired_lead_researchers_arr.size() > 0 and hired_lead_researchers_arr.size() < 4: 
			text = [
				"Attention, all personnel. There\'s an announcement regarding staff changes.",
				"Researcher %s.  Congratulations, you're being promoted." % props.researcher.name,
				'"Well... guess it\'s just us now," one mutters with a half-smile. In a team this small, any change feels seismic. There\'s a pause — pride, tension, maybe even a bit of envy — before work quietly resumes.'
			]

		# ----------------------------------------- LARGER TEAM
		else:
			text = [
				"Attention, all personnel. There\'s an announcement regarding staff changes.",
				"Researcher %s.  Congratulations, you're being promoted." % props.researcher.name,
				"[%s] %s" % [use_trait.name, use_trait.on_promotion.description]
			]
		
			
		return [
			# ---------
			func() -> Dictionary:
				return {
					"title": "PROMOTION EVENT",
					"img_src": "res://Media/images/redacted.png",
					"text": text,
					"portrait": {
						"title": props.researcher.name,
						"img_src": props.researcher.img_src
					},
					"options": [
						# ----------------------------------------- POSITIVE TRAIT RESPONSE
						{
							"include": hired_lead_researchers_arr.size() != 0 and use_trait.type == RESEARCHER.TRAIT_TYPE.POSITIVE,
							"title": "Respond postively.",
							"val": {
								"response": "Promotion’s well-earned. Take a moment to celebrate — then let’s get back to making sure nothing breaches and eats the intern."
							},
							"onSelected": onSelected
						},
						# ----------------------------------------- NEGATIVE TRAIT RESPONSE
						{
							"include": hired_lead_researchers_arr.size() != 0 and use_trait.type == RESEARCHER.TRAIT_TYPE.NEGATIVE,
							"title": "Keep it polite (even if you're unsure)",
							"val": {
								"response": "That’s it. Congratulations again. There’s coffee and exactly one box of donuts in the break room — pace yourselves, it’s still a containment site."								
							},
							"onSelected": onSelected
						},
						# ----------------------------------------- NEUTRAL TRAIT RESPONSE
						{
							"include": hired_lead_researchers_arr.size() != 0 and use_trait.type == RESEARCHER.TRAIT_TYPE.NEUTRAL,
							"title": "Respond professionally.",
							"val": {
								"response": "That concludes the announcement. Let’s give them our support — and keep a close eye on the protocols, just in case."
							},
							"onSelected": onSelected
						},
						# ----------------------------------------- NON-RESPONSE
						{
							"include": true,
							"title": "End the announcement.",
							"val": {
								"response": "That concludes the announcement. Carry on with your duties, and remember — the Foundation depends on each of us.",
							},
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				if "onSelection" in props:
					props.onSelection.call(option_selected.selected)
					
				return {
					"text": [
						option_selected.selected.response
					]
				}	
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var HAPPY_HOUR:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"selected": null
		}
		var onSelected = func(selected) -> void:
			option_selected.selected = selected.option.val
		

		return [
			# ---------
			func() -> Dictionary:
				return {
					"header": "HAPPY HOUR EVENT",
					"img_src": "res://Media/images/redacted.png",
					"text": ["HAPPY HOUR"],
					#"portrait": {
						#"title": props.researcher.name,
						#"img_src": props.researcher.img_src
					#},
					"options": [
						# ----------------------------------------- NON-RESPONSE
						{
							"include": true,
							"title": "OPTION A.",
							"val": {
								"response": "RESPONSE A HERE",
							},
							"onSelected": onSelected
						},
						{
							"include": true,
							"title": "OPTION B.",
							"val": {
								"response": "RESPONSE B HERE",
							},
							"onSelected": onSelected
						},
						{
							"include": true,
							"title": "OPTION C.",
							"val": {
								"response": "RESPONSE C HERE",
							},
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				if "onSelection" in props:
					props.onSelection.call(option_selected.selected)
					
				return {
					"text": [
						option_selected.selected.response
					]
				}	
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var UNHAPPY_HOUR:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"selected": null
		}
		var onSelected = func(selected) -> void:
			option_selected.selected = selected.option.val
		

		return [
			# ---------
			func() -> Dictionary:
				return {
					"title": "UNHAPPY HOUR",
					"img_src": "res://Media/images/redacted.png",
					"text": ["HAPPY HOUR"],
					"options": [
						# ----------------------------------------- NON-RESPONSE
						{
							"include": true,
							"title": "OPTION A.",
							"val": {
								"response": "RESPONSE A HERE",
							},
							"onSelected": onSelected
						},
						{
							"include": true,
							"title": "OPTION B.",
							"val": {
								"response": "RESPONSE B HERE",
							},
							"onSelected": onSelected
						},
						{
							"include": true,
							"title": "OPTION C.",
							"val": {
								"response": "RESPONSE C HERE",
							},
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				if "onSelection" in props:
					props.onSelection.call(option_selected.selected)
					
				return {
					"text": [
						option_selected.selected.response
					]
				}	
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var OBJECTIVE_REWARD:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"selected": null
		}
		var onSelected = func(selected) -> void:
			option_selected.selected = selected.option.val
		
		var text:Array = []
		
		# -------------  ORIGINAL, NO CLONES 
		text = [
			"Well done.  Please select a reward."
		]

		return [
			# ---------
			func() -> Dictionary:
				return {
					"title": "OBJECTIVE_REWARD EVENT",
					"img_src": "res://Media/images/redacted.png",
					"text": text,
					"options": [
						# ----------------------------------------- NON-RESPONSE
						{
							"include": true,
							"title": "GAIN MONEY!",
							"val": {
								"response": "RESPONSE GOES HERE",
							},
							"onSelected": onSelected
						},
						{
							"include": true,
							"title": "GAIN SCIENCE!",
							"val": {
								"response": "RESPONSE GOES HERE",
							},
							"onSelected": onSelected
						},
						{
							"include": true,
							"title": "GAIN MATERIAL!",
							"val": {
								"response": "RESPONSE GOES HERE",
							},
							"onSelected": onSelected
						}
					]
				},
			# ---------
			func() -> Dictionary:
				if "onSelection" in props:
					props.onSelection.call(option_selected.selected)
					
				return {
					"text": [
						option_selected.selected.response
					]
				}	
		],
}
# ------------------------------------------------------------------------


var reference_data:Dictionary = {
	# ------------------
	EVT.TYPE.GAME_OVER: GAME_OVER,
	# ------------------
	
	# ------------------ 
	EVT.TYPE.SCP_ON_CONTAINMENT: SCP_ON_CONTAINMENT,
	EVT.TYPE.SCP_BREACH_EVENT_1: SCP_BREACH_EVENT_1,
	
	# ------------------
	EVT.TYPE.HIRE_RESEARCHER: HIRE_RESEARCHER,
	EVT.TYPE.CLONE_RESEARCHER: CLONE_RESEARCHER,
	EVT.TYPE.PROMOTE_RESEARCHER: PROMOTE_RESEARCHER,
	#EVT.TYPE.DISMISS_RESEARCHER: DISMISS_RESEARCHER,	
	# ------------------
	
	# ------------------
	EVT.TYPE.OBJECTIVE_REWARD: OBJECTIVE_REWARD,
	# ------------------
	
	# ------------------
	EVT.TYPE.HAPPY_HOUR: HAPPY_HOUR,
	EVT.TYPE.UNHAPPY_HOUR: UNHAPPY_HOUR
	# ------------------
}

# ------------------------------------------------------------------------
func return_data(val:EVT.TYPE) -> Dictionary:
	return reference_data[val]
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
func run_event(val:EVT.TYPE, props:Dictionary = {}) -> Dictionary:
	var data:Dictionary = return_data(val)
	
	return {
		"event_id": EVT.TYPE,
		"event_instructions": data.event_instructions.call(props)
	}
# ------------------------------------------------------------------------
