@tool
extends SubscribeWrapper

# ------------------------------------------------------------------------ support func and vars
var option_selected:Dictionary = {
	"selected": null
}

func onSelected(choice:Dictionary) -> void:
	# assign to option selected
	option_selected.selected = {
		# return selected index
		"choice": choice,
		"type": choice.option.type if choice.option.has("type") else 0,
		"outcome_index": choice.outcome_index,
		"outcome": choice.option.outcomes.list[choice.outcome_index]
	}
		
func build_event_content(props:Dictionary, content:Dictionary) -> Array:
		return [
			# ---------
			func() -> Dictionary:
				return content,
			# ---------
			func() -> Dictionary:
				return {
					"text": option_selected.selected.outcome.response
				},
			# ---------
			func() -> Dictionary:
				# send result to prop
				if props.has("onSelection"):
					props.onSelection.call(option_selected.selected)
				
				# call effect function (optional, used to do something other than calculate currency, metrics, buffs, debuffs, etc)
				# that steps happens in the EventContainer
				if option_selected.selected.outcome.has("effect"):
					await option_selected.selected.outcome.effect.call()
				
				# checks if there's an impact
				var has_choice_impact:bool = option_selected.selected.choice.option.has("impact")
				var has_local_impact:bool = option_selected.selected.outcome.has("impact")
				
				# if impact, initiate tally
				if has_choice_impact or has_local_impact:
					return {
						"tally": true,
					}
				
				return {
					
				},
		]
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var TEST_EVENT_A:Dictionary = {
	"is_repeatable": true,
	"event_instructions": func(props:Dictionary) -> Array:
		return build_event_content(props, {
			"header": "TEST EVENT A",
			"subheader": "Subheader goes here",
			"img_src": "res://Media/images/redacted.png",
			"text": ["Test event A text goes here."],
			"options": [
				# ----------------------------------------- NEUTRAL
				{
					"header": "CURRENCY",
					"title": "EFFECT CURRENCY",
					"description": "Description of option.",
					"type": EVT.OUTCOME.NEUTRAL,
					"outcomes": {
						"list": [
							{
								"chance": 50,  
								"response": [
									"Lost money."	
								],
								"impact": {
									"currency": {
										RESOURCE.CURRENCY.MONEY: -5,
									}
								},
							},
							{
								"chance": 50,  
								"response": [
									"Gain money."	
								],
								"impact": {
									"currency": {
										RESOURCE.CURRENCY.MONEY: 10,
									}
								},
							}
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------
				
				# ----------------------------------------- NEUTRAL
				{
					"header": "METRICS",
					"title": "EFFECT METRICS",
					"description": "Description of option.",
					"type": EVT.OUTCOME.NEUTRAL,
					"outcomes": {
						"list": [
							{
								"chance": 50,  
								"response": [
									"Lost MORALE."	
								],
								"impact": {
									"metrics": {
										RESOURCE.METRICS.MORALE: -5,
									}
								},
							},
							{
								"chance": 50,  
								"response": [
									"Gain MORALE."	
								],
								"impact": {
									"metrics": {
										RESOURCE.METRICS.MORALE: 3,
									}
								},
							}
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------				
				
				# ----------------------------------------- NEUTRAL
				{
					"header": "BUFFS",
					"title": "EFFECT BUFFS/DEBUFF",
					"description": "Description of option.",
					"type": EVT.OUTCOME.NEUTRAL,
					"outcomes": {
						"list": [
							{
								"chance": 50,  
								"impact": {
									"buff": [
										BASE.BUFF.MORALE_BOOST
									]
								},
								"response": [
									"Response for outcome 1 goes here."	
								],
							},
							{
								"chance": 50,  
								"impact": {
									"debuff": [
										BASE.DEBUFF.MORALE_DRAIN
									]
								},								
								"response": [
									"Response for outcome 2 goes here."	
								],
							}							
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------				
								
				# ----------------------------------------- NEUTRAL
				{
					"header": "DO NOTHING",
					"title": "NO IMPACT",
					"description": "Description of option.",
					"type": EVT.OUTCOME.NEUTRAL,
					"outcomes": {
						"list": [
							{
								"response": [
									"No changes to anything."	
								],
							},
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------								

			]
		})
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var TEST_EVENT_B:Dictionary = {
	"is_repeatable": true,
	"event_instructions": func(props:Dictionary) -> Array:
		return build_event_content(props, {
			"header": "TEST EVENT B",
			"subheader": "Subheader goes here",
			"img_src": "res://Media/images/redacted.png",
			"text": ["Test event B text goes here."],
			"options": [
				# ----------------------------------------- NEUTRAL
				{
					"header": "HEADER",
					"title": "TITLE OF OPTION 1",
					"description": "Description of option.",
					"type": EVT.OUTCOME.NEUTRAL,
					"impact": {
						"metrics": {
							RESOURCE.METRICS.MORALE: -5,
						},
					},
					"outcomes": {
						"list": [
							{
								"chance": 1,  
								"response": [
									"Response for outcome 1 goes here."	
								],
							},
							{
								"chance": 1,  
								"response": [
									"Response for outcome 2 goes here."	
								],
							}
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------

				# ----------------------------------------- NEUTRAL
				{
					"header": "HEADER",
					"title": "TITLE OF OPTION 2",
					"description": "Description of option.",
					"type": EVT.OUTCOME.NEUTRAL,
					"impact": {
						"currency": {
							RESOURCE.CURRENCY.MONEY: -50
						},
					},
					"outcomes": {
						"list": [
							{
								"chance": 1,  
								"response": [
									"Response for outcome 1 goes here."	
								],
							},
							{
								"chance": 1,  
								"response": [
									"Response for outcome 2 goes here."	
								],
							}
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------				
				
				# ----------------------------------------- NEUTRAL
				{
					"header": "HEADER",
					"title": "TITLE OF OPTION 3",
					"description": "Description of option.",
					"type": EVT.OUTCOME.NEUTRAL,
					"impact": {
						"buff": [
							BASE.BUFF.MORALE_BOOST
						],
					},					
					"outcomes": {
						"list": [
							{
								"chance": 1,  
								"response": [
									"Response for outcome 1 goes here."	
								],
							},
							{
								"chance": 1,  
								"response": [
									"Response for outcome 2 goes here."	
								],
							}							
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------				

			]
		})
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var TEST_EVENT_C:Dictionary = {
	"is_repeatable": true,
	"event_instructions": func(props:Dictionary) -> Array:
		return build_event_content(props, {
			"header": "TEST EVENT C",
			"subheader": "Subheader goes here",
			"img_src": "res://Media/images/redacted.png",
			"text": ["Test event C text goes here."],
			"options": [
				# ----------------------------------------- NEUTRAL
				{
					"header": "HEADER",
					"title": "TITLE OF OPTION 1",
					"description": "Description of option.",
					"type": EVT.OUTCOME.NEUTRAL,
					"requires":{
						"title": "Add a conditional here.  This one is true.",
						"check": func() -> bool:
							return true,
					},
					"outcomes": {
						"list": [
							{
								"chance": 1,  
								"response": [
									"Response for outcome 1 goes here."	
								],
							},
							{
								"chance": 1,  
								"response": [
									"Response for outcome 2 goes here."	
								],
							}
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------

				# ----------------------------------------- NEUTRAL
				{
					"header": "HEADER",
					"title": "TITLE OF OPTION 2",
					"description": "Description of option.",
					"type": EVT.OUTCOME.NEUTRAL,
					"requires":{
						"title": "Add a conditional here.  This one is false.",
						"check": func() -> bool:
							return false,
					},
					"outcomes": {
						"list": [
							{
								"chance": 1,  
								"response": [
									"Response for outcome 1 goes here."	
								],
							},
							{
								"chance": 1,  
								"response": [
									"Response for outcome 2 goes here."	
								],
							}
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------				
				
				# ----------------------------------------- NEUTRAL
				{
					"header": "HEADER",
					"title": "TITLE OF OPTION 3",
					"description": "Description of option.",
					"type": EVT.OUTCOME.NEUTRAL,
					"outcomes": {
						"list": [
							{
								"chance": 1,  
								"response": [
									"Response for outcome 1 goes here."	
								],
							},
							{
								"chance": 1,  
								"response": [
									"Response for outcome 2 goes here."	
								],
							}							
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------				

			]
		})
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var ADMIN_SETUP:Dictionary = {
	"is_repeatable": true,
	"btn": {
		"title": "ADMIN DEPARTMENT SETUP"
	},
	"event_instructions": func(props:Dictionary) -> Array:
		# admin department always installed
		
		var instructions_1:Array = build_event_content(props, {
			"header": "FACILITY SETUP",
			"subheader": "A NEW DAY BEGINS",
			"img_src": "res://Media/images/redacted.png",
			"text": ["The beating heart of any bureaucracy: the Administration Department. Select its priority"],
			"options": [
				{
					"header": "FINANCIAL",
					"title": "Fiscal Oversight",
					"description": "Gain additional income each turn through optimized budgets and front-company revenue.",
					"type": EVT.OUTCOME.NEUTRAL,
					"room_ref": ROOM.REF.ADMIN_DEPARTMENT,
					"impact": {
						"conditional": CONDITIONALS.TYPE.ADMIN_PERK_1,
					},					
					"outcomes": {
						"list": [
							{"response": [CONDITIONALS.return_data(CONDITIONALS.TYPE.ADMIN_PERK_1).description] }
						]
					},
					"onSelected": func(choice:Dictionary) -> void:
						GAME_UTIL.set_conditional(CONDITIONALS.TYPE.ADMIN_PERK_1, true)
						ROOM_UTIL.add_room(choice.option.room_ref, false, {"floor": current_location.floor, "ring":current_location.ring, "room": 4})
						onSelected(choice),
				},
				{
					"header": "DEDICATION",
					"title": "Unwavering Support",
					"description": "Your facility recruits only the most committed personnel driven by conviction and unwavering faith in the mission.",
					"type": EVT.OUTCOME.NEUTRAL,
					"room_ref": ROOM.REF.ADMIN_DEPARTMENT,
					"impact": {
						"conditional": CONDITIONALS.TYPE.ADMIN_PERK_2,
					},					
					"outcomes": {
						"list": [
							{"response": [CONDITIONALS.return_data(CONDITIONALS.TYPE.ADMIN_PERK_2).description] }
						]
					},
					"onSelected": func(choice:Dictionary) -> void:
						GAME_UTIL.set_conditional(CONDITIONALS.TYPE.ADMIN_PERK_2, true)
						ROOM_UTIL.add_room(choice.option.room_ref, false, {"floor": current_location.floor, "ring":current_location.ring, "room": 4})
						onSelected(choice),
				},
				{
					"header": "LOGISTICS",
					"title": "Streamlined Logistics",
					"description": "Gain additional materials each turn through tighter supply chains and requisitioning.",
					"type": EVT.OUTCOME.NEUTRAL,
					"room_ref": ROOM.REF.ADMIN_DEPARTMENT,
					"impact": {
						"conditional": CONDITIONALS.TYPE.ADMIN_PERK_3,
					},					
					"outcomes": {
						"list": [
							{"response": [CONDITIONALS.return_data(CONDITIONALS.TYPE.ADMIN_PERK_3).description] }
						]
					},
					"onSelected": func(choice:Dictionary) -> void:
						GAME_UTIL.set_conditional(CONDITIONALS.TYPE.ADMIN_PERK_3, true)
						ROOM_UTIL.add_room(choice.option.room_ref, false, {"floor": current_location.floor, "ring":current_location.ring, "room": 4})
						onSelected(choice),
				}					
			]
		})

		return instructions_1
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var SCIENCE_SETUP:Dictionary = {
	"is_repeatable": true,
	"btn": {
		"title": "SCIENCE DEPARTMENT SETUP",
		"is_disabled_check": func() -> bool:
			var rooms_in_wing_count:int = purchased_facility_arr.filter(func(x): 
				return x.location.floor == current_location.floor and x.location.ring == current_location.ring and x.location.room == 4
			).size()
			return rooms_in_wing_count != 0,
	},
	"event_instructions": func(props:Dictionary) -> Array:
		# admin department always installed
		
		var instructions_1:Array = build_event_content(props, {
			"header": "FACILITY SETUP",
			"subheader": "A NEW DAY BEGINS",
			"img_src": "res://Media/images/redacted.png",
			"text": ["A Science Department is required to oversee research operations. Select its priority."],
			"options": [
				{
					"header": "EXPERIMENTATION",
					"title": "The Scientific Method in Action",
					"description": "True science requires careful observation, controlled testing, and a willingness to confront the unknown.",
					"type": EVT.OUTCOME.NEUTRAL,
					"room_ref": ROOM.REF.SCIENCE_DEPARTMENT,
					"impact": {
						"conditional": CONDITIONALS.TYPE.SCIENCE_PERK_1,
					},					
					"outcomes": {
						"list": [
							{"response": [CONDITIONALS.return_data(CONDITIONALS.TYPE.SCIENCE_PERK_1).description] }
						]
					},
					"onSelected": func(choice:Dictionary) -> void:
						GAME_UTIL.set_conditional(CONDITIONALS.TYPE.SCIENCE_PERK_1, true)
						ROOM_UTIL.add_room(choice.option.room_ref, false, {"floor": current_location.floor, "ring":current_location.ring, "room": 4})
						onSelected(choice),
				},
				{
					"header": "KNOWLEDGE",
					"title": "Pure Knowledge",
					"description": "Focus on research and documentation, cataloging anomalies and expanding the Foundation's understanding.",
					"type": EVT.OUTCOME.NEUTRAL,
					"room_ref": ROOM.REF.SCIENCE_DEPARTMENT,
					"impact": {
						"conditional": CONDITIONALS.TYPE.ADMIN_PERK_2,
					},					
					"outcomes": {
						"list": [
							{"response": [CONDITIONALS.return_data(CONDITIONALS.TYPE.ADMIN_PERK_2).description] }
						]
					},
					"onSelected": func(choice:Dictionary) -> void:
						GAME_UTIL.set_conditional(CONDITIONALS.TYPE.ADMIN_PERK_2, true)
						ROOM_UTIL.add_room(choice.option.room_ref, false, {"floor": current_location.floor, "ring":current_location.ring, "room": 4})
						onSelected(choice),
				},
				{
					"header": "DISCOVERY",
					"title": "Frontier Research",
					"description": "Prioritize uncovering new anomalies and pushing the boundaries of containment and understanding.",
					"type": EVT.OUTCOME.NEUTRAL,
					"room_ref": ROOM.REF.SCIENCE_DEPARTMENT,
					"impact": {
						"conditional": CONDITIONALS.TYPE.ADMIN_PERK_3,
					},					
					"outcomes": {
						"list": [
							{"response": [CONDITIONALS.return_data(CONDITIONALS.TYPE.ADMIN_PERK_3).description] }
						]
					},
					"onSelected": func(choice:Dictionary) -> void:
						GAME_UTIL.set_conditional(CONDITIONALS.TYPE.ADMIN_PERK_3, true)
						ROOM_UTIL.add_room(choice.option.room_ref, false, {"floor": current_location.floor, "ring":current_location.ring, "room": 4})
						onSelected(choice),
				}					
			]
		})
		
		return instructions_1
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var SELECT_STARTING_DEPARTMENTS_B:Dictionary = {
	"is_repeatable": true,
	"btn": {
		"title": "REWARD",
		"is_disabled_check": func() -> bool:
			var rooms_in_wing_count:int = purchased_facility_arr.filter(func(x): 
				return x.location.floor == current_location.floor and x.location.ring == current_location.ring and x.location.room == 4
			).size()
			return rooms_in_wing_count != 0,
	},
	"event_instructions": func(props:Dictionary) -> Array:
		
		var instructions_1:Array = build_event_content(props, {
			"header": "SELECT STARTING DEPARTMENTS",
			"subheader": "THE MIND",
			"img_src": "res://Media/images/redacted.png",
			"text": ["Two departments determine the pulse of the Foundation:"],
			"options": [
				# ----------------------------------------- SCIENCE
				{
					"header": "SCIENCE",
					"title": "Research & Anomalous Sciences",
					"description": "Studies, catalogs, and exploits anomalies. Curiosity kills, but ignorance kills faster.",
					"type": EVT.OUTCOME.NEUTRAL,
					"room_ref": ROOM.REF.SCIENCE_DEPARTMENT,
					"impact": {
						"currency": { RESOURCE.CURRENCY.SCIENCE: 5 }
					},
					"outcomes": {
						"list": [
							{ "response": ["Every anomaly documented is another weapon — or warning."] },
							{ "response": ["Research protocols expand Foundation archives."] }
						]
					},
					"onSelected": func(choice:Dictionary) -> void:
						ROOM_UTIL.add_room(choice.option.room_ref, false, {"floor": current_location.floor, "ring":current_location.ring, "room": 4})
						onSelected(choice),
				},
				# ----------------------------------------- SECURITY
				{
					"header": "MEDICAL",
					"title": "Medical & Psychological Services",
					"description": "Stabilizes the body and the mind. Clearance is irrelevant; recovery is compulsory.",
					"type": EVT.OUTCOME.NEUTRAL,
					"room_ref": ROOM.REF.MEDICAL_DEPARTMENT,
					"impact": {
						"metrics": { RESOURCE.METRICS.SAFETY: 5 }
					},
					"outcomes": {
						"list": [
							{ "response": ["Pain is inevitable. Collapse is unacceptable."] },
							{ "response": ["Preventative measures reduce incident severity."] }
						]
					},
					"onSelected": func(choice:Dictionary) -> void:
						ROOM_UTIL.add_room(choice.option.room_ref, false, {"floor": current_location.floor, "ring":current_location.ring, "room": 4})
						onSelected(choice),
				},
			]
		})
		#
		#var instruction_3:Array = build_event_content(props, {
			#"header": "SELECT STARTING DEPARTMENTS",
			#"subheader": "THE SOUL",
			#"img_src": "res://Media/images/redacted.png",
			#"text": ["Two departments shape thought and compliance:"],
			#"options": [
				## ----------------------------------------- ADMIN
				#{
					#"header": "ETHICS",
					#"title": "Ethics Committee",
					#"description": "Oversees Foundation conduct, ensuring containment efforts balance necessity with humanity. Their scrutiny can steady staff morale, though at times it slows operations.",
					#"type": EVT.OUTCOME.NEUTRAL,
					#"room_ref": ROOM.REF.ETHICS_DEPARTMENT,
					#"impact": {
						#"metrics": { RESOURCE.METRICS.MORALE: 5 }
					#},
					#"outcomes": {
						#"list": [
							#{ "response": ["Staff find reassurance knowing oversight exists beyond cold efficiency."] },
							#{ "response": ["Committee reviews delay certain projects, but morale improves under a watchful eye."] },
							#{ "response": ["Ethical scrutiny curbs excesses, reinforcing discipline and confidence among staff."] }
						#]
					#},
					#"onSelected": func(choice:Dictionary) -> void:
						#ROOM_UTIL.add_room(choice.option.room_ref, false, {"floor": current_location.floor, "ring": 3, "room": 4})
						#onSelected(choice),
				#},
#
				## ----------------------------------------- MEDICAL
				#{
					#"header": "SECURITY",
					#"title": "Security & Tactical Response",
					#"description": "Trains, surveils, and neutralizes. Internal or external, threats are resolved quickly.",
					#"room_ref": ROOM.REF.SECURITY_DEPARTMENT,
					#"impact": {
						#"metrics": { RESOURCE.METRICS.READINESS: 5 }
					#},
					#"outcomes": {
						#"list": [
							#{ "response": ["Order exists because someone enforces it."] },
							#{ "response": ["Personnel drill and mobilize with renewed precision."] }
						#]
					#},
					#"onSelected": func(choice:Dictionary) -> void:
						#ROOM_UTIL.add_room(choice.option.room_ref, false, {"floor": current_location.floor, "ring": 2, "room": 4})
						#onSelected(choice),
				#},
			#]
		#})		

		return instructions_1 
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var SELECT_STARTING_DEPARTMENTS_C:Dictionary = {
	"is_repeatable": true,
	"btn": {
		"title": "REWARD",
		"is_disabled_check": func() -> bool:
			var rooms_in_wing_count:int = purchased_facility_arr.filter(func(x): 
				return x.location.floor == current_location.floor and x.location.ring == current_location.ring and x.location.room == 4
			).size()
			return rooms_in_wing_count != 0,
	},
	"event_instructions": func(props:Dictionary) -> Array:	
		var instruction_1:Array = build_event_content(props, {
			"header": "SELECT STARTING DEPARTMENTS",
			"subheader": "THE SOUL",
			"img_src": "res://Media/images/redacted.png",
			"text": ["Two departments shape thought and compliance:"],
			"options": [
				# ----------------------------------------- ADMIN
				{
					"header": "ETHICS",
					"title": "Ethics Committee",
					"description": "Oversees Foundation conduct, ensuring containment efforts balance necessity with humanity. Their scrutiny can steady staff morale, though at times it slows operations.",
					"type": EVT.OUTCOME.NEUTRAL,
					"room_ref": ROOM.REF.ETHICS_DEPARTMENT,
					"impact": {
						"metrics": { RESOURCE.METRICS.MORALE: 5 }
					},
					"outcomes": {
						"list": [
							{ "response": ["Staff find reassurance knowing oversight exists beyond cold efficiency."] },
							{ "response": ["Committee reviews delay certain projects, but morale improves under a watchful eye."] },
							{ "response": ["Ethical scrutiny curbs excesses, reinforcing discipline and confidence among staff."] }
						]
					},
					"onSelected": func(choice:Dictionary) -> void:
						ROOM_UTIL.add_room(choice.option.room_ref, false, {"floor": current_location.floor, "ring":current_location.ring, "room": 4})
						onSelected(choice),
				},

				# ----------------------------------------- MEDICAL
				{
					"header": "SECURITY",
					"title": "Security & Tactical Response",
					"description": "Trains, surveils, and neutralizes. Internal or external, threats are resolved quickly.",
					"room_ref": ROOM.REF.SECURITY_DEPARTMENT,
					"impact": {
						"metrics": { RESOURCE.METRICS.READINESS: 5 }
					},
					"outcomes": {
						"list": [
							{ "response": ["Order exists because someone enforces it."] },
							{ "response": ["Personnel drill and mobilize with renewed precision."] }
						]
					},
					"onSelected": func(choice:Dictionary) -> void:
						ROOM_UTIL.add_room(choice.option.room_ref, false, {"floor": current_location.floor, "ring":current_location.ring, "room": 4})
						onSelected(choice),
				},
			]
		})		

		return instruction_1 
}
# ------------------------------------------------------------------------



# ------------------------------------------------------------------------
var MYSTERY_MEAT_1:Dictionary = {
	"is_repeatable": false,
	"event_instructions": func(props:Dictionary) -> Array:
		return build_event_content(props, {
			"header": "MYSTERY MEAT 1",
			"subheader": "Who doesn't like a little mystery?",
			"img_src": "res://Media/images/redacted.png",
			"text": [
				"Analytics has noticed an uptick in meat consumption in this particular facility. Quantities ordered exceed projected dietary needs by 23%. It's not immediately clear that there is an issue, but maybe it's worth investigating. How do we proceed?"
			],
			"options": [
				# ----------------------------------------- NEUTRAL
				{
					"header": "INTERVENE",
					"title": "Investigate the Mystery Meat",
					"description": "Something feels off. Investigate the meat and its sources...",
					"type": EVT.OUTCOME.NEUTRAL,
					"outcomes": {
						"list": [
							{
								"chance": 1,
								"response": [
									"Minor irregularities surface in the supply chain. Correcting them strains resources, and some staff seem unsettled, though they cannot explain why."
								]
							},
							{
								"chance": 1,
								"response": [
									"You track the orders carefully but find no concrete anomaly. Still, there is an indefinable unease among staff that resists explanation."
								],
							}
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------
				# ----------------------------------------- GOOD
				{
					"header": "REPLACE",
					"title": "Switch to Plant-Based",
					"description": "Remove the meat from the menu and replace it with vegetables.",
					"type": EVT.OUTCOME.GOOD,
					"outcomes": {
						"list": [
							{
								"chance": 1,
								"response": [
									"Initial resistance fades as staff adapt to the vegetable menu. The unexplained enthusiasm around the meat vanishes, but so does a certain energy in the facility."
								]
							},
							{
								"chance": 1,
								"response": [
									"Some staff complain of cravings and unease following the switch. While no overt anomaly manifests, the sense of absence is difficult to ignore."
								]
							},
						]
					},
					"onSelected": onSelected
				},				
				# -----------------------------------------
				# ----------------------------------------- BAD
				{
					"header": "DO NOTHING",
					"title": "Just don’t think about it",
					"description": "Turn a blind eye. The staff deserve a little comfort food.",
					"type": EVT.OUTCOME.BAD,
					"outcomes": {
						"list": [
							{
								"chance": 1,
								"response": [
									"Staff morale improves after the meals, though their enthusiasm feels oddly intense. You make a note to keep watch."
								]
							},
							{
								"chance": 1,
								"response": [
									"Meat consumption rates spike, driving up operational costs. Several requisition logs contain inconsistencies that can’t be fully explained."
								]
							},
						],
					},
					"onSelected": onSelected
				},
				# -----------------------------------------
			]
		})
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var MYSTERY_MEAT_2:Dictionary = {
	"is_repeatable": false,	
	"event_instructions": func(props:Dictionary) -> Array:
		return build_event_content(props, {
			"header": "MYSTERY MEAT 2",
			"subheader": "Something doesn’t add Up (except the meat).",
			"img_src": "res://Media/images/redacted.png",
			"text": [
				"Despite earlier concerns, meat continues to be delivered and consumed at an unusual rate. Staff enthusiasm remains high, though some behavioral shifts have been noted: longer meal breaks, increased requests for night shifts near the cafeteria, and several requisition forms with signatures that do not match official records."
			],
			"options": [
				# ----------------------------------------- NEUTRAL
				{
					"header": "AUDIT",
					"title": "Launch a full investigation",
					"description": "Trace the supply chain, interview staff, and cross-check signatures.",
					"type": EVT.OUTCOME.NEUTRAL,
					"outcomes": {
						"list": [
							{
								"chance": 1,
								"response": [
									"The audit uncovers no registered supplier matching the meat’s origin. Several interviewed staff recall events you did not record authorizing. Their accounts differ in subtle but consistent ways."
								],
							},
							{
								"chance": 1,
								"response": [
									"Cross-checking logistics burns time and resources. The findings are inconclusive, but multiple employees display unusual reluctance to discuss their dining habits."
								],
							}
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------
				# ----------------------------------------- GOOD
				{
					"header": "RESEARCH",
					"title": "Restrict meat to limited groups",
					"description": "Continue service, but under controlled and monitored conditions.",
					"type": EVT.OUTCOME.GOOD,
					"outcomes": {
						"list": [
							{
								"chance": 1,
								"response": [
									"With meat service restricted, affected staff show mild agitation but eventually comply. Surveillance notes subtle differences in behavior between those who continue eating the meat and those who abstain."
								],
							},
							{
								"chance": 1,
								"response": [
									"Attempts to isolate distribution generate pushback. Some staff insist they were authorized to receive extra servings, though no such orders exist in your system."
								],
							},
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------
				# ----------------------------------------- BAD
				{
					"header": "INDULGE",
					"title": "Encourage the meals",
					"description": "If the staff are happy, let them have what they want.",
					"type": EVT.OUTCOME.BAD,
					"outcomes": {
						"list": [
							{
								"chance": 1,
								"response": [
									"Morale rises significantly, with staff displaying heightened cooperation and energy. Still, several personnel reports contain inconsistencies regarding memory of events during mealtimes."
								],
							},
							{
								"chance": 1,
								"response": [
									"Operational costs escalate as meat shipments triple. A review of invoices reveals faintly distorted seals from suppliers—unlike any registered vendor."
								],
							},
						],
					},
					"onSelected": onSelected
				},
				# -----------------------------------------
			]
		})
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var MYSTERY_MEAT_3:Dictionary = {
	"is_repeatable": false,	
	"event_instructions": func(props:Dictionary) -> Array:
		return build_event_content(props, {
			"header": "MYSTERY MEAT 3",
			"subheader": "Appetite for catastrophe.",
			"img_src": "res://Media/images/redacted.png",
			"text": [
				"Consumption has spiked beyond all projections. Staff display erratic behavior, including aggression, fixation on meal schedules, and disturbing reports of 'hearing the meat call to them.' Several individuals have attempted to hoard rations. This is no longer a statistical oddity: it’s a crisis."
			],
			"options": [
				# ----------------------------------------- NEUTRAL
				{
					"header": "INTERVENE",
					"title": "Contain the Outbreak",
					"description": "Quarantine affected staff and restrict meat distribution.",
					"type": EVT.OUTCOME.NEUTRAL,
					"outcomes": {
						"list": [
							{
								"chance": 1,
								"response": [
									"Quarantine succeeds, but not before multiple staff members are lost to violent outbursts. Remaining personnel are shaken by the containment measures, but the spread of the anomaly slows."
								],
							}
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------

				# ----------------------------------------- GOOD
				{
					"header": "REPLACE",
					"title": "Purge the Meat Supply",
					"description": "Destroy all contaminated stock and transition to emergency rations.",
					"type": EVT.OUTCOME.GOOD,
					"outcomes": {
						"list": [
							{
								"chance": 1,
								"response": [
									"All meat is incinerated under strict supervision. Withdrawal symptoms ripple through the facility: tremors, hallucinations, and mass unrest. Several staff must be sedated, but eventually the anomaly recedes."
								],
							}
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------
				
				# ----------------------------------------- BAD
				{
					"header": "DO NOTHING",
					"title": "Maintain Operations",
					"description": "Ignore the warning signs. Staff insist they're fine.",
					"type": EVT.OUTCOME.BAD,
					"outcomes": {
						"list": [
							{
								"chance": 1,
								"response": [
									"Staff behavior spirals into chaos. Work grinds to a halt as fights break out over rations. Security is forced to intervene, but several personnel are injured before order is restored."
								],
							}
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------


			]
		})
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var FACILITY_RAID_1:Dictionary = {
	"is_repeatable": true,		
	"event_instructions": func(props:Dictionary) -> Array:
		return build_event_content(props, {
			"header": "Facility Breach",
			"subheader": "Unidentified Hostile Raid",
			"img_src": "res://Media/images/Events/raid.png",
			"text": [
				"Security reports multiple armed intruders breaching the facility perimeter.  Initial reports indicate that they're a scouting party for the Chaos Insurgency.  What could they be after?", 
				"Your security forces prepare to engage.",
			],
			"options": [
				# ----------------------------------------- DEFEND WITH FUNDS
				{
					"header": "FIGHT",
					"title": "Engage with hostile forces.",
					"description": "Send your security forces to confront the intruders head-on. Risk lives and resources to try to repel the attackers before they breach sensitive areas.",
					"type": EVT.OUTCOME.NEUTRAL,
					"requires":{
						"title": "Have at least 10 security officers stationed.",
						"check": func() -> bool:
							return true,
					},					
					"outcomes": {
						"list": [
							{
								"chance": 60,
								"response": [
									"After a brief but brutal firefight, your security forces manage to repel the invading force.",
									"Minor structural damage occurs, but no critical systems are lost."
								],
								"impact": {
									"metrics": {
										RESOURCE.METRICS.MORALE: 3
									},
									"currency": {
										RESOURCE.CURRENCY.MONEY: -3
									},
								},
							},
							{
								"chance": 40,
								"response": [
									"The intruders initially overwhelm your security teams, breaching several perimeter defenses.",
									"Backup forces arrive just in time to prevent total disaster, but not before some equipment is destroyed and minor injuries occur.",
									"Staff morale suffers from the sudden shock, and the facility sustains operational setbacks that will need attention."
								],
								"impact": {
									"metrics": {
										RESOURCE.METRICS.MORALE: -5
									},
									"currency": {
										RESOURCE.CURRENCY.MONEY: -3
									},
								},
							}
						]
					},
					"onSelected": onSelected
				},
				# ----------------------------------------- RESEARCH RAIDED
				{
					"header": "COMMUNICATE",
					"title": "Identify and negotiate",
					"description": "Try to identify the intruders and understand their intentions. Success could prevent bloodshed; failure may escalate the situation.",
					"type": EVT.OUTCOME.GOOD,
					"outcomes": {
						"list": [
							{
								"chance": 50,
								"response": [
									"The intruders step forward and identify themselves as members of the Chaos Insurgency.",
									"They claim they’re here to destroy SCP-X, insisting the anomaly is far more dangerous than the Foundation admits.",
									"After tense negotiation, they agree to withdraw for now. Yet their words leave an unease — were they sincere, or was it just misdirection for a later strike?",
									"Your staff breathe a sigh of relief, morale stabilizes, and readiness improves slightly."
								],
								"impact": {
									"metrics": {
										RESOURCE.METRICS.READINESS: 3
									},
								},
							},
							{
								"chance": 50,
								"response": [
									"The intruders step forward and identify themselves as members of the Chaos Insurgency.",
									"They claim they’re here to destroy SCP-X, insisting the anomaly is far more dangerous than the Foundation admits.",
									"Negotiations break down quickly. Before retreating, they warn that they’ll return with greater numbers — but it’s unclear if they mean to neutralize SCP-X or seize it for themselves.",
									"The facility is left tense, security forces shaken, and operational readiness takes a hit."
								],
								"impact": {
									"metrics": {
										RESOURCE.METRICS.READINESS: -3
									},
								},
							}
						]
					},
					"onSelected": onSelected
				},
				# ----------------------------------------- BUFF/DEBUFF
				{
					"header": "LOCKDOWN",
					"title": "Lockdown Protocols",
					"description": "Initiate a full-site lockdown. Secure doors, disable lifts, and reroute power to containment systems.",
					"type": EVT.OUTCOME.BAD,
					"outcomes": {
						"list": [
							{
								"chance": 60,
								"impact": {
									"metrics": {
										RESOURCE.METRICS.MORALE: 3
									}
								},
								"response": [
									"Heavy blast doors slam into place and reinforced corridors seal tight.",
									"Cut off from their objective, the raiders pound futilely against steel and security barriers.",
									"After several tense minutes, their assault collapses, and they retreat into the shadows outside the facility."
								],
							},
							{
								"chance": 40,
								"impact": {
									"metrics": {
										RESOURCE.METRICS.READINESS: -3
									},
									"currency": {
										RESOURCE.CURRENCY.MONEY: -10
									}
								},
								"response": [
									"The lockdown holds, sealing off the raiders completely.",
									"However, the sudden power rerouting fries several systems, damaging equipment and disrupting ongoing projects.",
									"Though the site is secure, the financial and operational costs leave staff shaken."
								],
							}
						]
					},
					"onSelected": onSelected
				},
			]
		})
}

var FACILITY_RAID_2:Dictionary = {
	"is_repeatable": false,		
	"event_instructions": func(props:Dictionary) -> Array:
		return build_event_content(props, {
			"header": "Facility Breach: Assault",
			"subheader": "Chaos Insurgency Returns",
			"img_src": "res://Media/images/Events/raid.png",
			"text": [
				"It’s the middle of the night when alarms suddenly blare across the facility.",
				"The Chaos Insurgency has returned — this time with greater numbers and heavier weapons.",
				"They’ve studied your defenses and are determined to reach SCP-X. Security forces prepare to engage.",
			],
			"options": [
				# ----------------------------------------- DEFEND WITH FORCE
				{
					"header": "FIGHT",
					"title": "Mount a Counter-Offensive",
					"description": "Deploy all available security units. This will test both your officers and your facility’s defensive infrastructure.",
					"type": EVT.OUTCOME.GOOD,
					"requires":{
						"title": "Have at least 15 security officers stationed.",
						"check": func() -> bool:
							return true,
					},					
					"outcomes": {
						"list": [
							{
								"chance": 50,
								"response": [
									"Your officers, hardened by the first raid, coordinate a disciplined counter-offensive.",
									"After intense fighting, the Chaos Insurgency is pushed back with heavy casualties.",
									"Though the site sustains minor damage, Foundation morale rises as staff see resistance succeed."
								],
								"impact": {
									"metrics": {
										RESOURCE.METRICS.MORALE: 5
									},
									"currency": {
										RESOURCE.CURRENCY.MONEY: -5
									},
								},
							},
							{
								"chance": 50,
								"response": [
									"The raiders advance with new breaching charges, overwhelming outer defenses.",
									"Though eventually contained by reinforcements, several wings suffer significant damage and casualties mount.",
									"The Chaos Insurgency retreats — but at great cost to both morale and resources."
								],
								"impact": {
									"metrics": {
										RESOURCE.METRICS.MORALE: -5
									},
									"currency": {
										RESOURCE.CURRENCY.MONEY: -10
									},
								},
							}
						]
					},
					"onSelected": onSelected
				},
				# ----------------------------------------- NEGOTIATE (RISK)
				{
					"header": "DEFEND",
					"title": "Deploy Defensive Countermeasures",
					"description": "Activate facility traps, turrets, and environmental systems to impede the Chaos Insurgency. This can reduce casualties, but may also damage infrastructure.",
					"type": EVT.OUTCOME.NEUTRAL,
					"outcomes": {
						"list": [
							{
								"chance": 50,
								"response": [
									"Automated turrets and reinforced security doors force the enemy into predefined corridors of engagement giving your security forces a tactical advantage",
									"After a tense and brutal engagement, your teams manage to repel the attackers, who retreat in disarray."
								],
								"impact": {
									"metrics": {
										RESOURCE.METRICS.READINESS: 2,
										RESOURCE.METRICS.MORALE: 1
									},
									"currency": {
										RESOURCE.CURRENCY.MONEY: -2
									}
								}
							},
							{
								"chance": 50,
								"response": [
									"Automated turrets and reinforced security doors activate, but the intruders exploit weak points and force multiple skirmishes in unexpected corridors.",
									"The battle is chaotic and costly. Security teams manage to push the attackers back, but several systems are damaged and personnel are injured.",
									"The raiders retreat, but the facility is left reeling from the intensity of the assault."
								],
								"impact": {
									"metrics": {
										RESOURCE.METRICS.READINESS: -3,
										RESOURCE.METRICS.MORALE: 1
									},
									"currency": {
										RESOURCE.CURRENCY.MONEY: -8
									}
								}
							}
						]
					},
					"onSelected": onSelected
				},

				# ----------------------------------------- LOCKDOWN (ESCALATION)
				{
					"header": "LOCKDOWN",
					"title": "Full Lockdown Protocols",
					"description": "Initiate a full-site lockdown. The Chaos Insurgency is prepared this time and the strain on infrastructure could have severe consequences.",
					"type": EVT.OUTCOME.NEUTRAL,
					"outcomes": {
						"list": [
							{
								"chance": 60,
								"impact": {
									"metrics": {
										RESOURCE.METRICS.SAFETY: 3
									}
								},
								"response": [
									"Blast doors and reinforced bulkheads slam into place, channeling intruders into dead-end corridors.",
									"Security forces exploit the tactical advantage, and the Chaos Insurgency is forced to retreat.",
									"Staff remain tense, but no containment breaches occur, and morale stabilizes slightly under the success."
								]
							},
							{
								"chance": 40,
								"impact": {
									"metrics": {
										RESOURCE.METRICS.MORALE: -5,
									},
									"currency": {
										RESOURCE.CURRENCY.MONEY: -15
									}
								},
								"response": [
									"The lockdown succeeds in stopping the intruders, but the effort strains the facility to its limits.",
									"Power surges disable backup systems, and containment teams race to stabilize anomalies before disaster strikes.",
									"Though the site remains secure, the financial, operational, and human toll is significant, leaving staff weary and resources depleted."
								]
							}
						]
					},
					"onSelected": onSelected
				}
				# ----------------------------------------- DO NOTHING
			]
		})
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var HAPPY_HOUR:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		return build_event_content(props, {
			"header": "Happy Hour",
			"subheader": "It's 5 o'clock somewhere",
			"img_src": "res://Media/images/redacted.png",
			"text": ["HAPPY HOUR"],
			"options": [
				# ----------------------------------------- NEUTRAL
				{
					"header": "INTERVENE",
					"title": "Contain the Outbreak",
					"description": "Quarantine affected staff and restrict meat distribution.",
					"type": EVT.OUTCOME.NEUTRAL,
					"outcomes": {
						"list": [
							{
								"chance": 1,
								"response": [
									"Quarantine succeeds, but not before multiple staff members are lost to violent outbursts. Remaining personnel are shaken by the containment measures, but the spread of the anomaly slows."
								]
							}
						]
					},
					"onSelected": onSelected
				},
				# -----------------------------------------

			]
		})
}
# ------------------------------------------------------------------------

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
var DIRECTORS_OFFICE_EVENT:Dictionary = {
	"timeline": {
		"title": "THE RAID",
		"icon": SVGS.TYPE.DANGER,
		"description": "The facility will be raided by an unknown paramilitary force.",
		"emergency_mode": ROOM.EMERGENCY_MODES.DANGER,
	},
	"event_instructions": func(props:Dictionary) -> Array:
		var option_selected:Dictionary = {
			"selected": null
		}
		var onSelected = func(selected) -> void:
			option_selected.selected = selected.option.val
		
		# reference self
		var timeline:Dictionary = props.timeline
	
	
		return [
			# ---------
			func() -> Dictionary:
				return {
					"header": "THE RAID",
					"img_src": "res://Media/images/Events/raid.png",
					"text": [
						"THE RAID EVENT"
					],
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
var SCP_ON_CONTAINMENT:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var event_ref:int = EVT.TYPE.SCP_ON_CONTAINMENT
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
		
		# var room_details:Dictionary = props.room_details
		var scp_details:Dictionary = props.scp_details
		var scp_entry:Dictionary = props.scp_entry
		# var researchers:Array = props.researchers
		
		var event_data:Array = scp_details.event[event_ref]
		# var selected_staff:Dictionary = {} if researchers.size() == 0 else researchers[U.generate_rand(0, researchers.size() - 1)]
		var vibes:Dictionary = GAME_UTIL.get_vibes_summary(scp_entry.location)	

		# add additional props and send to event
		# props.selected_staff = selected_staff
		props.vibes = vibes

		# build seequence		
		var sequence:Array = []
		for item in event_data:
						
			# build out story
			var story_text:Array = []
			for line in item.story.call(props):
				story_text.push_back(line)
			
			# build out choices
			var options:Array = []
			if "choices" in item:
				var choices:Array = item.choices.call(props)
				for choice in choices:
					choice.onSelected = onSelected
					options.append(choice)
			
			sequence.push_back(
				# ---------
				func() -> Dictionary:
					return {
						"title": scp_details.name,
						"subtitle": scp_details.nickname,
						"img_src": scp_details.img_src,
						# "selected_staff": selected_staff,
						"scp_ref": scp_details.ref,
						"text": story_text,
						"options": options
					}
			)
			
			if !options.is_empty():
				sequence.push_back( 
					func() -> Dictionary:return create_sequence(option_selected) 
				)

		return sequence
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
		
		# var room_details:Dictionary = props.room_details
		var scp_details:Dictionary = props.scp_details
		var scp_entry:Dictionary = props.scp_entry
		var researchers:Array = props.researchers
		var breach_count:int = scp_entry.breach_count
				
		var event_data:Array = scp_details.event[event_ref]
		# var selected_staff:Dictionary = {} if researchers.size() == 0 else researchers[U.generate_rand(0, researchers.size() - 1)]
		var vibes:Dictionary = GAME_UTIL.get_vibes_summary(scp_entry.location)	

		# add additional props and send to event
		# props.selected_staff = selected_staff
		props.vibes = vibes
		props.breach_count = breach_count
		
		# build seequence		
		var sequence:Array = []
		for item in event_data:
						
			# build out story
			var story_text:Array = []
			for line in item.story.call(props):
				story_text.push_back(line)
			
			# build out choices
			var options:Array = []
			if "choices" in item:
				var choices:Array = item.choices.call(props)
				for choice in choices:
					choice.onSelected = onSelected
					options.append(choice)
			
			sequence.push_back(
				# ---------
				func() -> Dictionary:
					return {
						"title": scp_details.name,
						"subtitle": scp_details.nickname,
						"img_src": scp_details.img_src,
						# "selected_staff": selected_staff,
						"text": story_text,
						"options": options
					}
			)
			
			if !options.is_empty():
				sequence.push_back( func() -> Dictionary: return create_sequence(option_selected) )

		return sequence
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var SCP_CONTAINED_EVENT:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var event_ref:int = EVT.TYPE.SCP_CONTAINED_EVENT
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
		
		# var room_details:Dictionary = props.room_details
		var scp_details:Dictionary = props.scp_details
		var scp_entry:Dictionary = props.scp_entry
		var researchers:Array = props.researchers
		var breach_count:int = scp_entry.breach_count
				
		var event_data:Array = scp_details.event[event_ref]
		# var selected_staff:Dictionary = {} if researchers.size() == 0 else researchers[U.generate_rand(0, researchers.size() - 1)]
		var vibes:Dictionary = GAME_UTIL.get_vibes_summary(scp_entry.location)	

		# add additional props and send to event
		# props.selected_staff = selected_staff
		props.vibes = vibes
		props.breach_count = breach_count
		
		# build seequence		
		var sequence:Array = []
		for item in event_data:
						
			# build out story
			var story_text:Array = []
			for line in item.story.call(props):
				story_text.push_back(line)
			
			# build out choices
			var options:Array = []
			if "choices" in item:
				var choices:Array = item.choices.call(props)
				for choice in choices:
					choice.onSelected = onSelected
					options.append(choice)
			
			sequence.push_back(
				# ---------
				func() -> Dictionary:
					return {
						"title": scp_details.name,
						"subtitle": scp_details.nickname,
						"img_src": scp_details.img_src,
						# "selected_staff": selected_staff,
						"text": story_text,
						"options": options
					}
			)
			
			if !options.is_empty():
				sequence.push_back( func() -> Dictionary: return create_sequence(option_selected) )

		return sequence
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var SCP_NO_STAFF_EVENT:Dictionary = {
	"event_instructions": func(props:Dictionary) -> Array:
		var event_ref:int = EVT.TYPE.SCP_NO_STAFF_EVENT
		var option_selected:Dictionary = {
			"val": null
		}
		var onSelected = func(val) -> void:
			option_selected.val = val
		
		# var room_details:Dictionary = props.room_details
		var scp_details:Dictionary = props.scp_details
		var scp_entry:Dictionary = props.scp_entry
		
		var event_data:Array = scp_details.event[event_ref]
		var vibes:Dictionary = GAME_UTIL.get_vibes_summary(scp_entry.location)	

		# add additional props and send to event
		props.vibes = vibes
		
		# build seequence		
		var sequence:Array = []
		for item in event_data:
						
			# build out story
			var story_text:Array = []
			for line in item.story.call(props):
				story_text.push_back(line)
			
			# build out choices
			var options:Array = []
			if "choices" in item:
				var choices:Array = item.choices.call(props)
				for choice in choices:
					choice.onSelected = onSelected
					options.append(choice)
			
			sequence.push_back(
				# ---------
				func() -> Dictionary:
					return {
						"title": scp_details.name,
						"subtitle": scp_details.nickname,
						"img_src": scp_details.img_src,
						"text": story_text,
						"options": options
					}
			)
			
			if !options.is_empty():
				sequence.push_back( 
					func() -> Dictionary:return create_sequence(option_selected) 
				)

		return sequence
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
		
		const awarded_money:int = 100
		const awarded_science:int = 50
		const awarded_material:int = 25
		
		# ----------------------------------------- DEFAULT REWARDS
		#  if objective has rewards, overwrite and add it here
		var options:Array = [
			{
				"title": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY).name,
				"val": {
					"func": func() -> void:
						await GAME_UTIL.open_tally( {RESOURCE.CURRENCY.MONEY: awarded_money} ),
				},
				"hint_description": "Instantly gain %s %s." % [awarded_money, RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY).name],
			},
			{
				"title":  RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.SCIENCE).name,
				"val": {
					"func": func() -> void:
						await GAME_UTIL.open_tally( {RESOURCE.CURRENCY.SCIENCE: awarded_science} ),
				},
				"hint_description": "Instantly gain %s %s." % [awarded_science, RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.SCIENCE).name],
			},
			{
				"title":  RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MATERIAL).name,
				"val": {
					"func": func() -> void:
						await GAME_UTIL.open_tally( {RESOURCE.CURRENCY.MATERIAL: awarded_material} ),
				},
				"hint_description": "Instantly gain %s %s." % [awarded_material, RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MATERIAL).name],
			}
		] if props.rewarded.is_empty() else props.rewarded
		
		# map onSelected func to options
		options = options.map(func(x): 
			x.onSelected = onSelected
			return x
		)		

		return [
			# ---------
			func() -> Dictionary:
				
				return {
					"title": "OBJECTIVE_REWARD EVENT",
					"img_src": "res://Media/images/Defaults/05-council.png",
					"text": text,
					"options": options
				},
			# ---------
			func() -> Dictionary:
				if "onSelection" in props:
					props.onSelection.call(option_selected.selected)
				
				if option_selected.selected.has("response"):
					return {
						"text": [
							option_selected.selected.response
						]
					}
					
				return {
					"end": true
				}
		],
}
# ------------------------------------------------------------------------

# ------------------------------------------------------------------------
var SCP_CONTAINMENT_AWARD_EVENT:Dictionary = {
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
		
		const awarded_money:int = 100
		const awarded_science:int = 50
		const awarded_material:int = 25
		

		# ----------------------------------------- DEFAULT REWARDS
		#  if objective has rewards, overwrite and add it here
		var options:Array = [
			{
				"title": RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY).name,
				"val": {
					"func": func() -> void:
						await GAME_UTIL.open_tally( {RESOURCE.CURRENCY.MONEY: awarded_money} ),
				},
				"hint_description": "Instantly gain %s %s." % [awarded_money, RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MONEY).name],
			},
			{
				"title":  RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.SCIENCE).name,
				"val": {
					"func": func() -> void:
						await GAME_UTIL.open_tally( {RESOURCE.CURRENCY.SCIENCE: awarded_science} ),
				},
				"hint_description": "Instantly gain %s %s." % [awarded_science, RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.SCIENCE).name],
			},
			{
				"title":  RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MATERIAL).name,
				"val": {
					"func": func() -> void:
						await GAME_UTIL.open_tally( {RESOURCE.CURRENCY.MATERIAL: awarded_material} ),
				},
				"hint_description": "Instantly gain %s %s." % [awarded_material, RESOURCE_UTIL.return_currency(RESOURCE.CURRENCY.MATERIAL).name],
			}
		]  if props.rewarded.is_empty() else props.rewarded
		
		# map onSelected func to options
		options = options.map(func(x): 
			x.onSelected = onSelected
			return x
		)		

		return [
			# ---------
			func() -> Dictionary:
				
				return {
					"title": "SCP_CONTAINMENT_AWARD_EVENT EVENT",
					"img_src": "res://Media/images/Defaults/05-council.png",
					"text": text,
					"options": options
				},
			# ---------
			func() -> Dictionary:
				if "onSelection" in props:
					props.onSelection.call(option_selected.selected)
				
				if option_selected.selected.has("response"):
					return {
						"text": [
							option_selected.selected.response
						]
					}
					
				return {
					"end": true
				}
		],
}
# ------------------------------------------------------------------------


var reference_data:Dictionary = {
	EVT.TYPE.TEST_EVENT_A: TEST_EVENT_A,
	EVT.TYPE.TEST_EVENT_B: TEST_EVENT_B,
	EVT.TYPE.TEST_EVENT_C: TEST_EVENT_C,
	
	EVT.TYPE.ADMIN_SETUP: ADMIN_SETUP,
	EVT.TYPE.SCIENCE_SETUP: SCIENCE_SETUP,
	EVT.TYPE.SELECT_STARTING_DEPARTMENTS_B: SELECT_STARTING_DEPARTMENTS_B,
	EVT.TYPE.SELECT_STARTING_DEPARTMENTS_C: SELECT_STARTING_DEPARTMENTS_C,
	
	
	EVT.TYPE.FACILITY_RAID_1: FACILITY_RAID_1,
	EVT.TYPE.FACILITY_RAID_2: FACILITY_RAID_2,
	# ------------------
	EVT.TYPE.GAME_OVER: GAME_OVER,
	# ------------------
	
	# ------------------ 	
	EVT.TYPE.DIRECTORS_OFFICE: DIRECTORS_OFFICE_EVENT,
	
	# ------------------ 
	EVT.TYPE.SCP_ON_CONTAINMENT: SCP_ON_CONTAINMENT,
	EVT.TYPE.SCP_BREACH_EVENT_1: SCP_BREACH_EVENT_1,
	EVT.TYPE.SCP_CONTAINED_EVENT: SCP_CONTAINED_EVENT,
	EVT.TYPE.SCP_NO_STAFF_EVENT: SCP_NO_STAFF_EVENT,
	EVT.TYPE.SCP_CONTAINMENT_AWARD_EVENT: SCP_CONTAINMENT_AWARD_EVENT,
	
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
	EVT.TYPE.UNHAPPY_HOUR: UNHAPPY_HOUR,
	EVT.TYPE.MYSTERY_MEAT_1: MYSTERY_MEAT_1,
	EVT.TYPE.MYSTERY_MEAT_2: MYSTERY_MEAT_2,
	EVT.TYPE.MYSTERY_MEAT_3: MYSTERY_MEAT_3
	# ------------------
}





# ------------------------------------------------------------------------
func create_sequence(option_selected:Dictionary) -> Dictionary:
	var random_int:int = U.generate_rand(0, 100)
	var end:bool = false
	var use_success_roll:bool = option_selected.val.option.has("success_rate")
	var is_success:bool = false
	var result_text:Array = []
	
	if "story" in option_selected.val.option:
		result_text = option_selected.val.option.story
	
	if "success_rate" in option_selected.val.option:
		is_success = (option_selected.val.option.success_rate) > random_int
		# add story segment

		if "effect" in option_selected.val.option:
			var effect:Dictionary = option_selected.val.option.effect	.call(is_success)
			

	return {
		"end": end,
		"is_success": is_success,
		"use_success_roll": use_success_roll,
		"text": result_text 
	}		
# ------------------------------------------------------------------------

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
