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
#var DISMISS_RESEARCHER:Dictionary = {
	#"event_instructions": func(props:Dictionary) -> Array:
		#var option_selected:Dictionary = {
			#"val": null
		#}
		#var onSelected = func(val) -> void:
			#option_selected.val = val
			#
		#return [
			## ---------
			#func() -> Dictionary:
				#return {
					#"header": "Event header",
					#"img_src": "res://Media/images/redacted.png",
					#"text": [
						#"You've decided that %s should be dismissed." % [props.name],
						#"Should you take any other precautions?"
					#],
					#"options": [
						#{
							#"show": true,
							#"title": "Thank them for their service.",
							#"val": EVT.DISMISS_TYPE.THANK_AND_DISMISS,
							#"onSelected": onSelected
						#},
						#{
							#"show": true,
							#"title": "Administer Class-B amnestics.",
							#"val": EVT.DISMISS_TYPE.ADMINISTER_AMNESTICS,
							#"onSelected": onSelected
						#},
						#{
							#"show": true,
							#"title": "Terminate them and destroy their research.",
							#"val": EVT.DISMISS_TYPE.TERMINATE,
							#"onSelected": onSelected
						#}						
					#]
				#},
			## ---------
			#func() -> Dictionary:
				#props.onSelection.call(option_selected.val)
				#return {
					#"text": [
						#"You selected %s" % [option_selected.val],
					#]
				#}	
		#],
#}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
#var SITEWIDE_BROWNOUT:Dictionary = {
	#"event_instructions": func(props:Dictionary) -> Array:
		#var option_selected:Dictionary = {
			#"val": null
		#}
		#var onSelected = func(val) -> void:
			#option_selected.val = val
			#
		#return [
			## ---------
			#func() -> Dictionary:
				#return {
					#"header": "Event header",
					#"img_src": "res://Media/images/redacted.png",
					#"text": [
						#"The lights begin to flicker as the power in the facility fluctuates.  Your batteries are almost out of juice.",
					#],
					#"options": [
						#{
							#"show": true,
							#"title": "Utilize the emergency backup generators.",
							#"val": EVT.BROWNOUT_OPTIONS.EMERGENCY_GENERATORS,
							#"onSelected": onSelected
						#},
						#{
							#"show": true,
							#"title": "Do nothing",
							#"val": EVT.BROWNOUT_OPTIONS.DO_NOTHING,
							#"onSelected": onSelected
						#}
					#]
				#},
			## ---------
			#func() -> Dictionary:
				#props.onSelection.call(option_selected.val)
				#return {
					#"text": [
						#"You selected %s" % [option_selected.val],
					#]
				#}	
		#],
#}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
#var IN_DEBT_WARNING:Dictionary = {
	#"event_instructions": func(props:Dictionary) -> Array:
		#var option_selected:Dictionary = {
			#"val": null
		#}
		#var onSelected = func(val) -> void:
			#option_selected.val = val
			#
		#return [
			## ---------
			#func() -> Dictionary:
				#return {
					#"header": "Event header",
					#"img_src": "res://Media/images/redacted.png",
					#"text": [
						#"IN DEBT WARNING",
					#],
					#"options": [
						#{
							#"show": true,
							#"title": "Utilize the emergency funds.",
							#"val": EVT.BROWNOUT_OPTIONS.EMERGENCY_GENERATORS,
							#"onSelected": onSelected
						#},
						#{
							#"show": true,
							#"title": "Do nothing",
							#"val": EVT.BROWNOUT_OPTIONS.DO_NOTHING,
							#"onSelected": onSelected
						#}
					#]
				#},
			## ---------
			#func() -> Dictionary:
				#props.onSelection.call(option_selected.val)
				#return {
					#"text": [
						#"You selected %s" % [option_selected.val],
					#]
				#}	
		#],
#}
# ------------------------------------------------------------------------

## ------------------------------------------------------------------------
#var MORALE:Dictionary = {
	#"event_instructions": func(props:Dictionary) -> Array:
		#var option_selected:Dictionary = {
			#"selected": null
		#}
		#var onSelected = func(option:Dictionary) -> void:
			#option_selected.selected = option
			##option_selected.val = val
			#
		#return [
			## ---------
			#func() -> Dictionary:
				#return {
					#"header": "Morale 1 event",
					#"img_src": "res://Media/images/redacted.png",
					#"portrait": {
						#"title": "DR SMITHERS",
						#"img_src": 	"res://Media/images/example_doctor.jpg",
					#},					
					#"text": [
						#"MORALE EVENT 1",
					#],
					#"options": [
						#{
							#"show": true,
							#"title": "Option a",
							#"description": "Description goes here.",
							#"success_rate": func() -> int:
								#return 60,
							#"val": 0,
							#"onSelected": onSelected
						#},
						#{
							#"show": true,
							#"title": "Option b",
							#"description": "Description goes here.",
							#"success_rate": func() -> int:
								#return 80,
							#"val": 1,
							#"onSelected": onSelected
						#},
						#{
							#"show": true,
							#"title": "Option c",
							#"description": "Description goes here.",
							#"success_rate": func() -> int:
								#return 90,
							#"val": 2,
							#"onSelected": onSelected
						#},
						#{
							#"show": true,
							#"title": "Do nothing",
							#"success_rate": func() -> int:
								#return 100,
							#"val": -1,
							#"onSelected": onSelected
						#}
					#]
				#},
			## ---------
			#func() -> Dictionary:
				#props.onSelection.call(option_selected)
				#return {
					#"text": [
						#"You selected %s" % [option_selected.selected.option.title],
					#]
				#},
			## ---------
			#func() -> Dictionary:
				#return {
					#"text": [
						#"And yet they soldiered on.",
					#]
				#}					
				#
		#],
#}
## ------------------------------------------------------------------------
#
## ------------------------------------------------------------------------
#var SAFETY:Dictionary = {
	#"event_instructions": func(props:Dictionary) -> Array:
		#var option_selected:Dictionary = {
			#"val": null
		#}
		#var onSelected = func(val) -> void:
			#option_selected.val = val
			#
		#return [
			## ---------
			#func() -> Dictionary:
				#return {
					#"header": "SAFETY 1 event",
					#"img_src": "res://Media/images/redacted.png",
					#"text": [
						#"SAFETY EVENT 1",
					#],
					#"options": [
						#{
							#"show": true,
							#"title": "Option a",
							#"val": 0,
							#"onSelected": onSelected
						#},
						#{
							#"show": true,
							#"title": "Do nothing",
							#"val": -1,
							#"onSelected": onSelected
						#}
					#]
				#},
			## ---------
			#func() -> Dictionary:
				#props.onSelection.call(option_selected.val)
				#return {
					#"text": [
						#"You selected %s" % [option_selected.val],
					#]
				#}	
		#],
#}
## ------------------------------------------------------------------------
#
# ------------------------------------------------------------------------
var SCP_ON_CONTAIN:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
		
		var scp_details:Dictionary = props.scp_details
		var scp_data:Dictionary = props.scp_data
		var researchers:Array = props.researchers
		
		var event:Dictionary = scp_details.on_contain
		var selected_consequence:int = event.default_consequence 
		var consequences:Dictionary = event.consequence
		var responses:Dictionary = event.responses
		var specializations:Dictionary = scp_details.on_contain.specialization
		var selected_researcher:Dictionary = {} if researchers.size() == 0 else researchers[U.generate_rand(0, researchers.size() - 1)]
		
		var story_text:Array = []
		for line in scp_details.on_contain.text:
			story_text.push_back(line)

		# IF NO RESEARCHERS ASSIGNED, PICK THIS CONSEQUENCE	
		if researchers.size() == 0:
			selected_consequence = EVT.CONSEQUNCE.UNSUPERVISED
		else:
			# ELSE, check for a trait, grab it and add it to the story, then prime set the consequence
			if selected_researcher.specialization.ref in specializations:
				selected_consequence = specializations[selected_researcher.specialization.ref].consequence_result
				for line in specializations[selected_researcher.specialization.ref].text:
					story_text.push_back(line)
					
		# add consequnce to to story text
		var consequence_data:Dictionary = event.consequence[selected_consequence]			
		for line in consequence_data.text:
			story_text.push_back(line)

		# then build responses
		var options:Array = []
		var allowed_responses:Array = [EVT.RESPONSE.ALWAYS] + consequence_data.allowed_responses
		for ref in allowed_responses:
			var response:Dictionary = responses[ref]
			var success_rate:int = 100
			var title:String = response.title
			
			match ref:
				EVT.RESPONSE.ALWAYS:
					success_rate = 100
				EVT.RESPONSE.MORALE:
					success_rate = 25 + (GAME_UTIL.get_metric_val(current_location, RESOURCE.METRICS.MORALE) * 20)
					title = str('[MORALE]: ', response.title)
				EVT.RESPONSE.SAFETY:
					success_rate = 25 + (GAME_UTIL.get_metric_val(current_location, RESOURCE.METRICS.SAFETY) * 20)
					title = str('[SAFETY]: ', response.title)
				EVT.RESPONSE.READINESS:
					success_rate = 25 + (GAME_UTIL.get_metric_val(current_location, RESOURCE.METRICS.READINESS) * 20)
					title = str('[READINESS]: ', response.title)
			
			options.push_back({
				"show": true,
				"title": title,
				"val": ref,
				"description": "Chances of success.",
				"success_rate": success_rate,
				"onSelected": onSelected
			})
		
			
		return [
			# ---------
			func() -> Dictionary:
				return {
					"header": "SCP_ON_CONTAIN",
					"img_src": scp_details.img_src,
					"text": story_text,
					"options": options
				},
			# ---------
			func() -> Dictionary:
				var random_int:int = U.generate_rand(0, 100)
				var is_success:bool = (option_selected.val.option.success_rate) > random_int			
				var response_selected:Dictionary = responses[option_selected.val.option.val]
				var res_story:Array = response_selected.story.call(is_success)
				consequences[selected_consequence].effect.call(is_success)
				
				return {
					"text": consequences[selected_consequence].text + res_story
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
					"header": "HIRE RESEARCHER EVENT",
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
					"header": "PROMOTION EVENT",
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
					"header": "UNHAPPY HOUR",
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


var reference_data:Dictionary = {
	# ------------------
	EVT.TYPE.GAME_OVER: GAME_OVER,
	# ------------------
	
	# ------------------ 
	EVT.TYPE.SCP_ON_CONTAIN: SCP_ON_CONTAIN,
	#EVT.TYPE.SCP_BREACH: SCP_BREACH,
	
	# ------------------
	EVT.TYPE.HIRE_RESEARCHER: HIRE_RESEARCHER,
	EVT.TYPE.CLONE_RESEARCHER: CLONE_RESEARCHER,
	EVT.TYPE.PROMOTE_RESEARCHER: PROMOTE_RESEARCHER,
	#EVT.TYPE.DISMISS_RESEARCHER: DISMISS_RESEARCHER,	
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
