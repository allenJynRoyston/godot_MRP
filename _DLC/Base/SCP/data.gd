extends SubscribeWrapper


# -----------------------------------------------------------
var SCP99:Dictionary = {
	"nickname": "DEBUG",
	"description": func(_scp_details:Dictionary) -> Array:
		return [
			"%s description.", % _scp_details.name
		],
	"abstract": func(_scp_details:Dictionary) -> String:
		return "Abstract",
		
	"img_src": "res://Media/scps/mirror_frame.png",
	
	"days_until_contained": 3,
	"containment_requirements": [
		SCP.CONTAINMENT_TYPES.PHYSICAL,
	],

	"effect": {
		"description": "All adjacent rooms generate +1 RESEARCH.",
		"func": func(_new_room_config:Dictionary, _item:Dictionary) -> Dictionary:
			return GAME_UTIL.add_currency_to_adjacent_rooms(_new_room_config, 1, RESOURCE.CURRENCY.SCIENCE, _item.location),
	},	

	"event": {
		# ----------------------------
		EVT.TYPE.SCP_ON_CONTAINMENT: [
			{
				"story": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"SCP containment story...",
					],

				"choices": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "HEAL/HURT HP",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"HP SUCCESS"
									] if is_success else [
										"HP FAILURE"
									],
									"consequence": [
										EVT.CONSEQUENCE.HP_HEAL
									] if is_success else [
										EVT.CONSEQUENCE.HP_HURT
									]
								},
						},
						# -----------------------------------------
						{
							"title": "HEAL/HURT SP",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"SP SUCCESS"
									] if is_success else [
										"SP FAILURE"
									],
									"consequence": [
										EVT.CONSEQUENCE.SP_HEAL
									] if is_success else [
										EVT.CONSEQUENCE.SP_HURT
									]
								},
						},
						# -----------------------------------------						
						# -----------------------------------------
						{
							"title": "CHANGE MOOD",
							"success_rate": 10,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"CHANGE MOOD SUCCESS"
									] if is_success else [
										"CHANGE MOOD FAILURE"
									],
									"consequence": [
										EVT.CONSEQUENCE.MOOD_CHANGED_TO_STABLE
									] if is_success else [
										EVT.CONSEQUENCE.MOOD_CHANGED_TO_FRIGHTENED
									]
								},
						},
						# -----------------------------------------
						{
							"title": "KILL OPTION",
							"success_rate": 10,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"KILL OPTION SUCCESS"
									] if is_success else [
										"KILL OPTION FAILURE"
									],
									"consequence": [
										# NONE
									] if is_success else [
										EVT.CONSEQUENCE.CHANGE_STATUS_TO_KIA
									]
								},
						},
						# -----------------------------------------
						{
							"title": "INSANITY OPTION",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"INSANITY OPTION SUCCESS"
									] if is_success else [
										"INSANITY OPTION FAILURE"
									],
									"consequence": [
										# NONE
									] if is_success else [
										EVT.CONSEQUENCE.CHANGE_STATUS_TO_INSANE
									]
								},
						},
					],
				
			}
		],
		# ----------------------------
		
		# ----------------------------
		EVT.TYPE.SCP_BREACH_EVENT_1: [
			# -----------------------------------------------------------------------
			{
				"story": func(props:Dictionary) -> Array:
					#var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"%s is undergoing a breach event!" % _scp_details.name,
					],
				"choices": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "MORALE OPTION",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.MORALE, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"MORALE OPTION SUCCESS"
									] if is_success else [
										"MORALE OPTION FAILURE"
									]
								},
						},
						# -----------------------------------------
						{
							"title": "READINESS OPTION",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.READINESS, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"READINESS OPTION SUCCESS"
									] if is_success else [
										"READINESS OPTION FAILURE"
									]
								},
						},
						# -----------------------------------------
						{
							"title": "SAFETY OPTION ",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.SAFETY, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"SAFETY OPTION SUCCESS"
									] if is_success else [
										"SAFETY OPTION FAILURE"
									]
								},
						},
						# -----------------------------------------
						{
							"title": "ALTERNATIVE OPTION",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"ALTERNATIVE OPTION SUCCESS"
									] if is_success else [
										"ALTERNATIVE OPTION FAILURE"
									]
								},
						},
						# -----------------------------------------
					],
			},
			# ----------------------------------------------------------------------
		],
		# ----------------------------
		
		# ----------------------------
		EVT.TYPE.SCP_CONTAINED_EVENT: [
			# -----------------------------------------------------------------------
			{
				"story": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"%s is undergoing a containment event!" % _scp_details.name,
					],
				"choices": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "MORALE OPTION",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.MORALE, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"MORALE OPTION SUCCESS"
									] if is_success else [
										"MORALE OPTION FAILURE"
									]
								},
						},
						# -----------------------------------------
						{
							"title": "READINESS OPTION",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.READINESS, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"READINESS OPTION SUCCESS"
									] if is_success else [
										"READINESS OPTION FAILURE"
									]
								},
						},
						# -----------------------------------------
						{
							"title": "SAFETY OPTION ",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.SAFETY, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"SAFETY OPTION SUCCESS"
									] if is_success else [
										"SAFETY OPTION FAILURE"
									]
								},
						},
						# -----------------------------------------
						{
							"title": "ALTERNATIVE OPTION",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"ALTERNATIVE OPTION SUCCESS"
									] if is_success else [
										"ALTERNATIVE OPTION FAILURE"
									]
								},
						},
						# -----------------------------------------
					],
			},
			# ----------------------------------------------------------------------
		]
		# ----------------------------		
	}
}

var SCP0:Dictionary = {
	"nickname": "The Mirror",
	"description": func(_scp_details:Dictionary) -> Array:
		return [
			"%s is a 1.2m x 1.2m gilded frame with no backing or canvas." % _scp_details.name,
			"When mounted on a wall, it opens a portal to a mirrored room.",
			"This reflection shifts subtly — lights flicker, furniture moves, shadows drift.",
			"Subjects passing through %s disappear entirely, presumed relocated." % _scp_details.name,
			"All tracking or tethering attempts have failed beyond the frame.",
			"When idle, %s occasionally draws in air and loose material." % _scp_details.name,
			"The mirrored side reflects these effects with a 3–5 second delay.",
			"%s is housed in a sealed chamber under constant surveillance." % _scp_details.name
		],
	"abstract": func(_scp_details:Dictionary) -> String:
		return "A gilded frame that reveals a subtly altered mirror room. Objects entering vanish and do not return.",
	"img_src": "res://Media/scps/mirror_frame.png",
	
	"days_until_contained": 3,	
	"containment_requirements": [
		SCP.CONTAINMENT_TYPES.PHYSICAL,
		SCP.CONTAINMENT_TYPES.SPATIAL
	],

	"effect": {
		"description": "All adjacent rooms generate +1 RESEARCH.",
		"func": func(_new_room_config:Dictionary, _item:Dictionary) -> Dictionary:
			return GAME_UTIL.add_currency_to_adjacent_rooms(_new_room_config, 1, RESOURCE.CURRENCY.SCIENCE, _item.location),
	},	
	
	# ------------------------------------------
	"event": {
		# ----------------------------
		EVT.TYPE.SCP_ON_CONTAINMENT: [
			{
				"story": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"%s has been affixed inside a sealed observation chamber." % _scp_details.name,
						"The moment it made contact with the containment wall, it activated.",
						"A mirrored version of the chamber appeared instantly beyond the frame.",
						"A faint pull of air can be felt around the frame's edges, like shallow breathing.",						
						"Curiousity draws them in closer and they start walking towards the mirror, as if drawn to it.",
						"What should you do?",
					],

				"choices": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "Activate the intercom, tell them to leave immediately.",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.MORALE, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"The voice over the intercom is calm but firm: 'Step away from the frame. Now.'",
										"The staff member blinks, breathes, and backs away slowly before successfully exiting the chamber.",
										"And those thoughts were... unnerving.  Unnatural."
									] if is_success else [
										"The intercom crackles as you give the order but the staffer doesn't move.",
										"They stare entranced at their own reflection, seemingly paralyzed for a moment before walking towards their reflection.",
									],
									"consequence": [
										EVT.CONSEQUENCE.MOOD_CHANGED_TO_FRIGHTENED
									] if is_success else [
										EVT.CONSEQUENCE.CHANGE_STATUS_TO_KIA
									]
								},
						},
						# -----------------------------------------
						{
							"title": "Send in a security team to extract",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.SAFETY, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"The extraction team enters with tethers secured and visors down.",
										"No anomalies detected on exit—mirrored version remains still."
									] if is_success else [
										"In the mirror, the reflected security team suddenly raises their weapons.",
										"Gunfire erupts from the mirrored side, shattering the observation glass.",
										"Shards of broken glass convulse, drawing back toward the frame and sealing seamlessly.",
										"The security team retrieves the body in silence and exits the chamber."
									],
									"consequence": [
										
									] if is_success else [
										EVT.CONSEQUENCE.CHANGE_STATUS_TO_KIA
									]
								},
						},
						# -----------------------------------------
						{
							"title": "Activate the emergency blackout procedure.",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.READINESS, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"Emergency lights cut out, and the chamber is plunged into darkness.",
										"Infrared confirms the reflection vanishes when unobserved.",
									] if is_success else [
										"The lights flicker—then fail to respond.",
										"In the mirrored room, backup lights ignite first, illuminating movement.",
										"Contact with the chamber is lost for 17 seconds.",
									],
									"consequence": [
										
									] if is_success else [
										EVT.CONSEQUENCE.CHANGE_STATUS_TO_KIA
									]
								},
						},
						# -----------------------------------------
						{
							"title": "Do nothing",
							"success_rate": 20,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"You issue no orders. The chamber remains unnervingly still.",
										"Then, as if released, they stumble backward and flee the room.",
									] if is_success else [
										"No action is taken. The chamber is silent, save for the hum of equipment.",
										"They vanish into the frame without resistance. The aperture ripples once, then stills."
									],

									"consequence": [
										EVT.CONSEQUENCE.MOOD_CHANGED_TO_RELUCTANT
									] if is_success else [
										EVT.CONSEQUENCE.CHANGE_STATUS_TO_KIA
									]
								},
						},
						# -----------------------------------------					
					],
				
			},
			{
				"story": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"The mirror’s surface shimmers faintly, reflecting shadows that don’t belong to this world."
					],
			}
		],
		# ----------------------------
		
		# ----------------------------
		EVT.TYPE.SCP_BREACH_EVENT_1: [
			{
				"story": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"Cameras monitoring %s detect unusual activity within the containment cell." % _scp_details.name,
						"The image distorts as vague, shadowy humanoid shapes materialize near the mirror’s edge.",
						"These figures appear undefined but vaguely humanoid, all black as if made entirely out of shadows.",
						"They approach the threshold slowly, then press against it with increasing force, until blackness fills the reflection.",
						"The mirror bulges outward, cracks spidering along its edges. A breach appears imminent! What will you do?",
					],

				"choices": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "Have -- enter the chamber and speak to the reflections.",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.MORALE,  _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"Their reflection just stares.",
										"Silence begins to feed into their panic, and panic begins to manifest.",
										"The mirror beings to repair itself as things slowly return to normal.",
									] if is_success else [
										"%s enters the chamber and is instantly fixated on their reflection.",
										"%s beings walking towards the mirror, mumbling something that the camera can't quite pick up.",
									],
									"consequence": [
										
									] if is_success else [
										EVT.CONSEQUENCE.CHANGE_STATUS_TO_KIA
									],
									"end": is_success,
								},
						},
						# -----------------------------------------
						{
							"title": "Option",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.SAFETY, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"The containment chamber’s automated locks engage with a heavy metallic thud.",
										"Reinforced shutters slide into place, blocking all exits and isolating the mirror.",
										"The shadowy figures press against the barrier but fail to breach it.",
										"The room stabilizes as safety protocols hold strong."
									] if is_success else [
										"But for whatever reason, the lockdown system flickers, then fails to activate.",
										"The chamber doors remain unlocked as shadows seep through the edges.",
										"An ominous silence fills the room before the glass bursts from the frame; the alarms erupt loudly.",
										"Shadowy figures begin oozing from the shards, filling the chamber."
									],
									
									"consequence": [
										
									] if is_success else [
										
									],
									"end": is_success,
								},
						},
						# -----------------------------------------
						{
							"title": "Cut the power and kill the lights.",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.READINESS, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"The shadows recoil, their forms dissolving into the black void.",
										"Emergency backup lights flicker on, revealing an eerie stillness.",
										"The breach is temporarily halted as the mirror’s influence wanes."
									] if is_success else [
										"The sudden blackout silences the alarms and dims emergency lights to a faint glow.",
										"In the shadows, the humanoid figures shift and pulse, their forms bleeding past the mirror’s threshold.",
										"Cutting the power might have made this problem worse."
									],
									
									"consequence": [
										
									] if is_success else [
										
									],
									"end": is_success,
								},
						},
						# -----------------------------------------
						{
							"title": "Do nothing.",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"You hesitate, doing nothing as the mirror distorts further.",
										"The shadowy figures press harder against the cracked surface, darkening the reflection.",
										"The room grows colder; the breach looms ever closer, unchecked."
									] if is_success else [
										"The mirror shatters suddenly, shards scattering across the floor.",
										"Shadowy figures surge through the broken glass, flooding the chamber.",
										"%s attempts rushes to manually seal the door, but is grabbed and dragged into the chamber.",
										"The breach spreads uncontrollably, leaving chaos in its wake."
									],
									"consequence": [
										
									] if is_success else [
										EVT.CONSEQUENCE.CHANGE_STATUS_TO_KIA
									],
								},
						},
						# -----------------------------------------					
					],
				
			},
			{
				"story": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"It doesn't take long until the entire chamber is completely filled by a shadowy mass.",
						"They now run the risk of overflowing outside the chamber."
					],
				"choices": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "Send in the security forces to bolster the door.",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"Shadowy figures slam against the door from within the chamber but the structure holds.",
										"After a tense couple of hours, the slamming subsides and the mass appears to evaporate."
									] if is_success else [
										"Shadowy figures slam against the door from within the chamber but the structure holds, but the containment cell is heavily damaged.",
										"After a tense couple of hours, the slamming subsides and the mass appears to evaporate.",
									],
									"consequence": [

									] if is_success else [
										EVT.CONSEQUENCE.MOOD_CHANGED_TO_FRIGHTENED
									],
								},
						},
						# -----------------------------------------
						{
							"title": "Send in an MTF squad.",
							"success_rate": 80,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"A specialized MTF squad arrives, equipped with high-lumen strobes and ultraviolet emitters.",
										"They move with practiced coordination, flooding the chamber with searing pulses of light.",
										"The shadowy figures recoil violently, phasing in and out as the beams strike them.",
										"One operative plants a focused arc-light emitter near the mirror—its oscillating glow disrupts the breach.",
										"The reflection convulses, then steadies. The figures vanish back into the depths.",
										"The room is secured. The mirror is dormant. For now."
									] if is_success else [
										"The MTF squad enters, deploying high-intensity strobes and ultraviolet gear to disrupt the shadow mass.",
										"The light slows the figures—causing them to flicker violently—but the entities retaliate with ferocity.",
										"One by one, operatives are overwhelmed, their bodies swallowed by shifting black tendrils.",
										"In a final act, the squad leader activates an arc-light surge against the frame, overloading the system.",
										"The mirror emits a blinding flash… then stillness.",
										"The breach closes. Silence returns. The chamber is secure—but no one walks back out."
									],
									"consequence": [
										
									] if is_success else [
										
									],
								},
						},
					],
			}			
		],
		# ----------------------------
		
		# ----------------------------
		EVT.TYPE.SCP_CONTAINED_EVENT: [
			{
				"story": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"CONTAINED EVENT STORY",
					],

				"choices": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "MORALE OPTION",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.MORALE, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"MORALE SUCCESS"
									] if is_success else [
										"MORALE FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "SAFETY OPTION",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.SAFETY, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"SAFETY SUCCESS"
									] if is_success else [
										"SAFETY FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "READINESS OPTION",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.READINESS, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"READINESS SUCCESS"
									] if is_success else [
										"READINESS FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "ALT OPTION.",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"ALT SUCCESS"
									] if is_success else [
										"ALT FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------					
					],
				
			},
			{
				"story": func(props:Dictionary) -> Array:
					# var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"END EVENT",
					],
			}			
		],
		# ----------------------------		
		
		# ----------------------------
		EVT.TYPE.SCP_NO_STAFF_EVENT: [
			{
				"story": func(props:Dictionary) -> Array:
					var _scp_details:Dictionary = props.scp_details
					return [
						"NO STAFF EVENT",
					],

				"choices": func(props:Dictionary) -> Array:
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "MORALE OPTION",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.MORALE,_vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"MORALE SUCCESS"
									] if is_success else [
										"MORALE FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "SAFETY OPTION",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.SAFETY, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"SAFETY SUCCESS"
									] if is_success else [
										"SAFETY FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "READINESS OPTION",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.READINESS, _vibes),
							"success_rate": SCP_UTIL.get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"READINESS SUCCESS"
									] if is_success else [
										"READINESS FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------
						{
							"title": "ALT OPTION.",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								return {
									"story": [
										"ALT SUCCESS"
									] if is_success else [
										"ALT FAIL"
									],
									"consequence": [
										
									] if is_success else [
										
									]
								},
						},
						# -----------------------------------------					
					],
				
			},
			{
				"story": func(props:Dictionary) -> Array:
					var _scp_details:Dictionary = props.scp_details
					return [
						"END EVENT",
					],
			}			
		],
		# ----------------------------				
	}
	# ------------------------------------------	
	
}

var SCP2:Dictionary = {
	"nickname": "The Tiny Intruder",
	
	"description": func(_scp_details:Dictionary) -> Array:
		return [
			"%s is a fully furnished miniature dollhouse, measuring approximately 0.5m in height and 0.3m in width.",
			"It is capable of independent locomotion via two humanoid-sized legs for a human of that stature, and displays a high degree of sentience.",
			"%s enters residential homes by unknown means, typically between 2 AM and 4 AM local time, and proceeds to commit burglary.",
			"Security footage shows that %s will wander the premises, often rearranging small objects, changing TV channels, stealing minor trinkets that have only minor financial value, and occasionally leaving handwritten notes reading 'Nice place.'",
			"The structure wears a custom-sized black ski mask, permanently stitched to its roof.",
			"%s has not shown any signs of hostility, but as one can imagine, stumbling upon a tiny house-shaped with a ski mask in the middle of the night have lead to some serious confrontations.",
			"Before containment, %s has been associated with ████ calls to 911, ██ 18 injuries — █ which were serious — and ██████ gun related fatalities, either accidental by the homeowners themselves or law enforcement." % _scp_details.name,
			"█████ in total have been administered Class-B amnestics, while an additional ██ required serious ████████ ████████.",
		],
	"abstract": func(_scp_details:Dictionary) -> String:
		return "%s is a sentient miniature dollhouse wearing a ski mask that infiltrates homes at night, exhibiting curious but harmless behavior." % [_scp_details.name],
	
	"img_src": "res://Media/scps/tiny_intruder.jpg",
	
	"containment_requirements": [
		SCP.CONTAINMENT_TYPES.MEMETIC,
		SCP.CONTAINMENT_TYPES.CONCEPTUAL
	],


}


# -----------------------------------------------------------
var list:Array[Dictionary] = [
	SCP0, #SCP3, SCP4, SCP5, SCP6, SCP7, SCP8, SCP9,
	#SCP10, SCP11, SCP12, SCP13, SCP14, SCP15, SCP16, SCP17, SCP18, SCP19,
	SCP99,
]
# -----------------------------------------------------------
