extends SubscribeWrapper

# -----------------------------------------------------------
var SCP0:Dictionary = {
	"nickname": "The Mirror",
	"description": func(_scp_details:Dictionary) -> Array:
		return [
			"%s is a 1.2m x 1.2m gilded picture frame containing no canvas or backing.", % _scp_details.name,
			"When affixed to a flat vertical surface, SCP-XXXX creates a window-like aperture into what appears to be an identical room mirroring the one it faces.",
			"This 'mirror room' displays subtle differences over time — such as displaced furniture, altered lighting, or the presence of shadows moving independently of any known source.",
			"Any living organism passing through SCP-XXXX will not emerge in the physical room beyond the frame but will instead vanish completely, presumed transported to the mirrored dimension.",
			"Attempts to tether or track subjects have all failed beyond the threshold.\n\nWhen left undisturbed, SCP-XXXX 'inhales' slowly — drawing air, paper, and small debris toward it at irregular intervals.",
			"The room on the other side reflects these interactions with a delay of approximately 3–5 seconds. No communication has ever been established with the mirrored space.",
			"SCP-XXXX is currently mounted in a reinforced, sensor-equipped containment chamber with no other ingress points."
		],
	"abstract": func(_scp_details:Dictionary) -> String:
		return "A gilded picture frame that opens a window into a subtly altered mirrored version of the room it faces. Objects entering vanish without trace. Categorized as SPATIAL and CONCEPTUAL.",
	"img_src": "res://Media/scps/mirror_frame.png",
	"breach_check_frequency": 1,
	
	"containment_requirements": [
		SCP.CONTAINMENT_TYPES.SPATIAL,
		SCP.CONTAINMENT_TYPES.CONCEPTUAL
	],

	"event": {
		# ----------------------------
		EVT.TYPE.SCP_ON_CONTAINMENT: [
			{
				"story": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"%s has been assigned to oversee initial containment of %s." % [_staff_details.name, _scp_details.name],
						"As containment seals engage, the aperture within %s begins its slow 'breathing' motion — a pulsing inhale that tugs at loose objects and clothing." % _scp_details.name,
						"Through the empty frame, the mirrored containment room appears — identical, yet off. The fluorescent lights flicker in the other room, though not in this one. A chair is slightly turned. A clipboard sits where none was placed.",
						"Suddenly, %s notices their own reflection lagging behind — the mirrored version remains still, staring back just a moment too long before mimicking their latest movement." % _staff_details.name,
						"The tension in the room rises. %s hesitates, unsure of what to do next." % _staff_details.name,
					],

				"choices": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "Attempt to communicate with the mirror version.",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.MORALE, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									return {
										"story": [
											"%s speaks to the figure. It tilts its head and writes something on a clipboard: 'WE SEE YOU'." % _staff_details.name
										],
										"restore_sanity": 1
									}
								else:
									return {
										"story": [
											"%s calls out, but the mirrored figure vanishes mid-motion." % _staff_details.name,
											"All camera feeds inside the chamber cut out."
										],
										"damage_hp": 1,
									},
						},
						# -----------------------------------------
						{
							"title": "Send in a drone for closer analysis.",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.READINESS, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									return {
										"story": [
											"A drone crosses through the aperture. The feed holds steady for a few moments, then displays a third, unknown chamber before cutting to black."
										]
									}
								else:
									return {
										"story": [
											"The drone halts mid-frame and vibrates violently before disintegrating into ash."
										],
										"damage_hp": 1,
									},
						},
						# -----------------------------------------
						{
							"title": "Touch the frame directly.",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.SAFETY, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 30),
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									return {
										"story": [
											"As their hand meets the frame, it pulses — and a mirrored hand lunges outward.",
											"Security intervenes just in time. %s is unharmed, but visibly disturbed." % _staff_details.name
										]
									}
								else:
									return {
										"story": [
											"As their hand meets the frame, it pulses — and a mirrored hand lunges outward.",
											"It grabs %s violently, pulling them into the reflection." % _staff_details.name,
											"Cameras monitoring the cell abruptly cut out.",
											"When security arrives, the room remains empty with no sign of %s anywhere." % _staff_details.name
										],
										"damage_hp": 1,
									},
						},
						# -----------------------------------------
						{
							"title": "Exit the containment chamber.",
							"success_rate": 50,
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									return {
										"story": [
											"%s makes their way to the exit, maintaining unbroken eye contact with the mirrored self." % _staff_details.name,
											"The reflection mirrors every step with unsettling precision. Just before the chamber door seals, it smiles faintly — a gesture not mirrored by %s." % _staff_details.name
										],
										"restore_hp": 1
									}
								else:
									return {
										"story": [
											"%s steps backward toward the exit, but the mirrored figure lags — slightly off-beat, slightly too close." % _staff_details.name,
											"As the chamber door begins to close, the reflection halts mid-step, locked in place with eyes fixed on %s." % _staff_details.name
										],
										"damage_hp": 1,
									},
						},
						# -----------------------------------------					
					],
				
			}
		],
		# ----------------------------
		
		# ----------------------------
		EVT.TYPE.SCP_BREACH_EVENT_1: [
			# -----------------------------------------------------------------------
			{
				"story": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"%s enters the chamber for a routine investigate when suddendly the warning light begins to flare." % _staff_details.name,
						"Unexpectedly, the doppelgänger emerges from the mirror, crossing the threshold which seperates the reflected world from our own, moving with jerky unnatural motions, eyes glowing faintly with an eerie light.",
						"%s frantically attempts leave, but the containment cells emergency locks engage, trapping %s in with their growingly distorted self." % [_staff_details.name,_staff_details.name],
						"The doppelgänger unexpectedly lurchers towards %s and grabs their arm!  Their life is in danger!  What should they do?" % _staff_details.name 
					],
				"choices": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes
					return [
						# -----------------------------------------
						{
							"title": "Struggle and flee!",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.MORALE, _staff_details, _vibes),
							"success_rate": 1, #get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 50),
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									return {
										"story": [
											"%s lashes out instinctively, landing a solid kick that causes the doppelgänger to stagger backward into the mirror." % _staff_details.name,
											"The emergency locks disengage. %s escapes the chamber, breath ragged but alive." % _staff_details.name
										],
									}
								else:
									return {
										"story": [
											"%s fights back desperately but the mirror-being seems preternaturally strong." % _staff_details.name,
											"A heavy blow lands across their face before they break free and stumble out, bleeding and shaken."
										],
										"restore_sanity": 2,
										"end": true
									},
						},
						# -----------------------------------------
						{
							"title": "Activate containment failsafe!",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.SAFETY, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 60),
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									return {
										"story": [
											"%s slams their hand onto the embedded failsafe node near the chamber door." % _staff_details.name,
											"Reinforced restraints drop from the ceiling, pinning the mirror entity against the far wall.",
											"%s escapes unharmed." % _staff_details.name
										],
									}
								else:
									return {
										"story": [
											"%s triggers the failsafe, but the mirror's effect causes it to echo in reverse — the restraints lock %s in place instead!" % [_staff_details.name, _staff_details.name],
											"The doppelgänger lands a brutal blow before slinking back into the frame.",
											"Moments later, the restraints release, but the damage is done."
										],
										"damage_hp": 1,
									},
						},
						# -----------------------------------------
						{
							"title": "Deploy preplanned MTF protocol.",
							"render_if": get_render_from_metrics(RESOURCE.METRICS.READINESS, _staff_details, _vibes),
							"success_rate": get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 65),
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									return {
										"story": [
											"%s initiates the MTF rapid-entry override. A secondary team breaches the door in seconds." % _staff_details.name,
											"The mirror entity, seemingly startled by their entrance, hesitates — enough time for %s to slip away safely." % _staff_details.name
										],
										"apply_buff": null
									}
								else:
									return {
										"story": [
											"The override is engaged, but the mirror reacts before the breach completes.",
											"%s is dragged halfway through the aperture as backup arrives too late to stop it." % _staff_details.name,
											"A boot and a scrap of torn uniform are all that remain."
										],
										"is_killed": true,
									},
						},
						# -----------------------------------------
						{
							"title": "Cut power to the chamber.",
							"render_if": get_render_from_currencies(RESOURCE.CURRENCY.SCIENCE, 50, _staff_details),
							"success_rate": 80,
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									return {
										"story": [
											"Power fails. Lights stutter, then go dark.",
											"In the darkness, the mirror entity shudders and seems to lose cohesion, disintegrating into reflected shards mid-motion.",
											"%s crawls to the door, which opens once backup systems engage." % _staff_details.name
										],
										"currency": 25
									}
								else:
									return {
										"story": [
											"The power fails... but instead of weakening it, the mirror seems to *thrive* in the darkness.",
											"A second doppelgänger slides out of the frame, their outline flickering like corrupted video.",
											"%s is overwhelmed before lights return. Nothing remains." % _staff_details.name
										],
										"is_killed": true,
									},
						},
						# -----------------------------------------
						{
							"title": "Do nothing.",
							"success_rate": 10,
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									return {
										"story": [
											"%s remains still, heart racing. The entity stares, mimics, then vanishes back through the mirror as if losing interest." % _staff_details.name,
											"The emergency locks open. %s flees immediately, unharmed but shaken." % _staff_details.name
										],
										"mood_changed_to": RESEARCHER.MOODS.FRIGHTENED
									}
								else:
									return {
										"story": [
											"%s stands paralyzed, hoping inaction will spare them." % _staff_details.name,
											"It doesn't.",
											"The entity lunges and drags them screaming into the mirrored world. The frame flashes once, then goes still.",
											"%s is gone." % _staff_details.name
										],
										"is_killed": true
									},
						}
					],
			},
			# ----------------------------------------------------------------------
		
			{
				"story": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"next story sequnce 1",
						"next story sequnce 2",
						"next story sequnce end",
					],
				"choices": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes
					return [
						# -----------------------------------------
						{
							"title": "Test test test!",
							"story": [
								"Next story sequence.",
								"Next story sequence 2.",
								"End story sequence."
							]
						},
					],					
			}
		]
		# ----------------------------
	}
}


var SCP1:Dictionary = {
	"nickname": "The Latchkeeper",
	
	"description": func(_scp_details:Dictionary) -> String:
		return "%s is a rusted iron doorframe, approximately 2m by 0.9m, mounted on a mobile reinforced platform. Passing through %s causes subjects to vanish from baseline reality without return. Attempts to tether objects through it fail as tethers sever cleanly at passage. Though no physical door exists, every 37 hours %s produces a loud metallic latch noise and 'closes' for 1 hour, becoming inert. The inner edges flicker subtly, indicating dimensional discontinuity. It exhibits limited awareness, distorting in response to speech and mimicking heartbeat patterns. Personnel near %s report dreams of endless corridors and hear faint knocking from 'the other side'." % [_scp_details.name, _scp_details.name, _scp_details.name, _scp_details.name],
		
	"abstract": func(_scp_details:Dictionary) -> String:
		return "%s is a doorframe that distorts dimensional boundaries, reacts acoustically to stimuli, and imposes moral containment protocols due to its sentient, anxious behavior." % [_scp_details.name],
	
	"img_src": "",
	
	"containment_requirements": [
		SCP.CONTAINMENT_TYPES.DIMENSIONAL,
		SCP.CONTAINMENT_TYPES.ACOUSTIC,
		SCP.CONTAINMENT_TYPES.MORAL,
	],

	"event": {
		EVT.TYPE.SCP_ON_CONTAINMENT: {
			"story": func(props:Dictionary) -> Array:
				var _staff_details:Dictionary = props.selected_staff
				var _scp_details:Dictionary = props.scp_details
				return [
					"%s has been assigned to oversee initial containment of %s." % [_staff_details.name, _scp_details.name],
					"%s was secured inside a soundproof vault with dimensional locks engaged." % [_scp_details.name],
					"As %s adjusted the restraints, the frame emitted a low hum and vibrated gently." % [_scp_details.name],
					"A faint knocking echoed from inside the frame despite no visible opening.",
					"%s hesitated before whispering, 'Hello?'" % [_staff_details.name],
					"The inner edges of %s rippled briefly, resembling a curtain stirred by wind." % [_scp_details.name],
				],

			"choices": func(props:Dictionary) -> Dictionary:
				var _staff_details:Dictionary = props.selected_staff
				var _scp_details:Dictionary = props.scp_details
				return {
					"standard": [
						{
							"title": "Attempt communication using harmonic acoustic protocol",
							"success_rate": 65,
							"story": func(is_success:bool) -> Array:
								return [
									"A low harmonic tone plays through the speakers.",
									"%s quivers softly, then stills, as a whisper says: 'Thank you for knocking.' Containment stabilizes." % [_scp_details.name]
								] if is_success else [
									"The tone plays, but %s suddenly emits a harsh screech, shattering nearby glass." % [_scp_details.name],
									"%s's vibrations intensify, cracking the containment cell's walls." % [_scp_details.name],
								],
							"effect": func(is_success:bool) -> void:
								if is_success:
									# containment stabilized, no damage
									pass
								else:
									# containment cell damaged
									pass,
						},
						{
							"title": "Physically inspect the edges of the frame",
							"success_rate": 40,
							"story": func(is_success:bool) -> Array:
								return [
									"%s's edges feel impossibly cold but solid, with faint pulses matching a heartbeat." % [_scp_details.name],
									"%s remains inert during inspection." % [_scp_details.name]
								] if is_success else [
									"While touching %s, %s suddenly flinches and emits a violent pulse, knocking %s back." % [_scp_details.name, _scp_details.name, _staff_details.name],
									"%s is shaken but unharmed; containment protocols adjusted." % [_staff_details.name]
								],
							"effect": func(is_success:bool) -> void:
								if is_success:
									# knowledge gained, no harm
									pass
								else:
									# staff mood changed, containment protocols updated
									pass,
						},
						{
							"title": "Ignore subtle noises and secure the cell quickly",
							"success_rate": 85,
							"story": func(is_success:bool) -> Array:
								return [
									"%s's noises are ignored; containment cell locks successfully engaged." % [_scp_details.name],
									"Containment is secured without incident."
								] if is_success else [
									"%s emits an unexpected loud latch sound as the cell locks, startling %s." % [_scp_details.name, _staff_details.name],
									"Anomalous vibrations damage some containment sensors."
								],
							"effect": func(is_success:bool) -> void:
								if is_success:
									# containment secured, no damage
									pass
								else:
									# containment cell damaged
									pass,
						},
					],

					"traits": {
						RESEARCHER.TRAITS.AVERAGE: {
							"title": "Use routine protocols without deviation",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"%s follows standard procedures. Containment is uneventful." % [_staff_details.name]
								] if is_success else [
									"%s's lack of flexibility leads to a missed cue; %s reacts with a sudden pulse." % [_staff_details.name, _scp_details.name]
								],
							"effect": func(is_success:bool) -> void:
								if is_success:
									pass
								else:
									# minor containment cell damage
									pass,
						},
						RESEARCHER.TRAITS.PARANOID: {
							"title": "Suspect hidden dangers and proceed cautiously",
							"success_rate": 70,
							"story": func(is_success:bool) -> Array:
								return [
									"%s is hyper-aware of every sound and vibration, preventing surprises." % [_staff_details.name]
								] if is_success else [
									"%s’s nervousness causes delays, agitating %s into sudden vibration." % [_staff_details.name, _scp_details.name]
								],
							"effect": func(is_success:bool) -> void:
								if is_success:
									# staff mood improved, containment stable
									pass
								else:
									# containment cell damaged
									pass,
						},
					}
				},
			},
		}
}


var SCP2:Dictionary = {
	"nickname": "The Remembering Bell",
	"description": func(_scp_details:Dictionary) -> String:
		return "%s is a weathered brass bell approximately 0.7 meters in height, suspended within an iron frame bolted to a concrete base. When struck, the bell emits no audible sound, yet induces vivid, involuntary recollections in all sentient organisms within a 12-meter radius. These memories often involve events the subject has no recollection of ever experiencing—many of which are inconsistent with established personal history or recorded reality.\n\n%s’s effects persist for several minutes after activation and are not mitigated by ear protection, soundproof barriers, or indirect observation. Subjects exposed repeatedly may experience identity confusion, emotional instability, or develop false autobiographical narratives. The bell does not appear to degrade with use or age. Its origin remains unknown, though it was recovered from a collapsed monastery in Southern ████████." % [_scp_details.name, _scp_details.name],
	"abstract": func(_scp_details:Dictionary) -> String:
		return "A silent brass bell that induces false or conflicting memories in nearby observers. Categorized as MEMETIC and CONCEPTUAL.",
	"img_src": "res://Media/scps/remembering_bell.png",
	
	"containment_requirements": [
		SCP.CONTAINMENT_TYPES.MEMETIC,
		SCP.CONTAINMENT_TYPES.CONCEPTUAL
	],

	"event": {
		EVT.TYPE.SCP_ON_CONTAINMENT: {
			"story": func(_staff_details:Dictionary, _scp_details:Dictionary) -> Array:
				return [
					"%s has been tasked with overseeing initial placement of %s into its sealed chamber." % [_staff_details.name, _scp_details.name],
					"As the containment team secures the object, an accidental jostling causes the bell to swing slightly.",
					"Though no sound is heard, all personnel within range abruptly stop moving.",
					"%s stumbles backward, eyes wide, muttering about a sibling they never had." % _staff_details.name,
					"The rest of the team recovers within minutes, but subtle discrepancies in personal histories begin to surface during debriefing."
				],

			"choices": func(_staff_details:Dictionary, _scp_details:Dictionary) -> Dictionary:
				return {
					"standard": [
						{
							"show": true,
							"title": "Strike the bell deliberately for controlled observation.",
							"success_rate": 50,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s taps %s with a padded mallet. They report remembering a childhood in a city they've never visited." % [_staff_details.name, _scp_details.name]
								] if is_success else [
									"%s strikes %s. They collapse, screaming about a fire no one else remembers. Upon recovery, their name and personal identity are inconsistent with Foundation records." % [_staff_details.name, _scp_details.name]
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# change in mood
									pass
								else:
									# change in personality
									pass,
						},

						{
							"show": true,
							"title": "Attempt to record its effects from outside the containment cell.",
							"success_from": RESOURCE.METRICS.MORALE,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s observes through a remote feed. No memory anomalies are reported during the test." % _staff_details.name
								] if is_success else [
									"%s experiences a sudden flashback despite not being physically present. The memory involves a failed containment event that never occurred." % _staff_details.name
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# nothing happens
									pass
								else:
									# change in mood
									pass,
						},
						{
							"show": true,
							"title": "Insulate the bell with layered conceptual dampeners.",
							"success_from": RESOURCE.METRICS.SAFETY,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"Dampeners are installed successfully. %s remains inert even when brushed accidentally." % _scp_details.name
								] if is_success else [
									"The dampeners are flawed. %s emits a silent 'toll' that causes a containment technician to forget their own name." % _scp_details.name
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# a resource is gained
									pass
								else:
									# containment cell is damaged
									pass,
						},
						{
							"show": true,
							"title": "Have %s touch the bell directly while monitored." % _staff_details.name,
							"success_from": RESOURCE.METRICS.READINESS,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s places their hand on %s and reports feeling calm. Upon interview, they remember a peaceful childhood they never had." % [_staff_details.name, _scp_details.name]
								] if is_success else [
									"%s touches %s and goes catatonic for several hours. Upon awakening, they insist their name is someone else and refuse to acknowledge Foundation protocols." % [_staff_details.name, _scp_details.name]
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# change in mood
									pass
								else:
									# change in personality
									pass,
						}
					],
				},

		}
	}
}

var SCP3:Dictionary = {
	"nickname": "The Voice in the Slide",
	"description": func(_scp_details:Dictionary) -> String:
		return "%s is a disassembled portion of a playground slide, recovered from a condemned school in [REDACTED]. The object is composed of smooth, painted aluminum, and emits a faint humming sound when not observed directly. When assembled and used as a functional slide, any individual descending it will hear a whispered voice reciting highly specific memories—frequently those the subject has forgotten or repressed. Prolonged exposure results in temporary dissociation, vivid hallucinations, and in 27% of cases, personality displacement." % [_scp_details.name],
	"abstract": func(_scp_details:Dictionary) -> String:
		return "%s is a memetic-psychic anomaly centered on a playground slide segment. Users exposed to it experience recovered memories or assumed false identities, requiring MEMETIC and PSYCHIC containment precautions." % [_scp_details.name],
	"img_src": "",

	"containment_requirements": [
		SCP.CONTAINMENT_TYPES.MEMETIC,
		SCP.CONTAINMENT_TYPES.PSYCHIC
	],

	"event": {
		EVT.TYPE.SCP_ON_CONTAINMENT: {
			"story": func(_staff_details:Dictionary, _scp_details:Dictionary) -> Array:
				return [
					"%s has been tasked with overseeing initial placement of %s into its sealed chamber." %[_staff_details.name, _scp_details.name],
					"The object has been reconstructed for brief testing before long-term containment.",
					"Security footage is restricted to prevent accidental auditory exposure."
				],

			"choices": func(_staff_details:Dictionary, _scp_details:Dictionary) -> Dictionary:
				return {
					"standard": [
						{
							"show": true,
							"title": "Test the slide mechanism personally before sealing.",
							"success_rate": 50,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
										"%s descends the slide and reports a faint whisper of a childhood pet's name." % [_staff_details.name],
										"The experience is unsettling but ultimately harmless.",
										"%s completes the sealing process without further incident." % [_staff_details.name],
									] if is_success else [
										"%s descends the slide and goes silent midway." % [_staff_details.name],
										"When recovered, they identify themselves by a different name and claim to be a teacher from 1974.",
										"Containment proceeds, but psychiatric review is mandated." 
									],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# Nothing happens
									pass
								else:
									# Staff member has a change in personality
									pass,
						},

						{
							"show": true,
							"title": "Use a D-Class to trigger activation.",
							"success_from": RESOURCE.METRICS.MORALE,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return  [
										"The D-Class subject descends the slide, laughing nervously.",
										"They report hearing a nursery rhyme they’d forgotten.",
										"Containment is completed without incident.",
									] if is_success else [
										"The D-Class becomes hysterical halfway down the slide.",
										"They scream for their 'real parents' before collapsing.",
										"Containment is completed, but morale among nearby personnel drops."
									],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# Nothing happens
									pass
								else:
									# Base morale decreases
									pass,
						},
						{
							"show": true,
							"title": "Shield the room with psychic dampeners.",
							"success_from": RESOURCE.METRICS.SAFETY,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"Psychic dampeners successfully mask the anomalous effects.",
									"%s observes no unusual behavior during transfer." % [_staff_details.name],
									"The object is sealed and cataloged." 
								] if is_success else  [
									"The dampeners short-circuit midway through transfer.",
									"%s stares at the slide and murmurs unknown names." % [_staff_details.name],
									"Later examination reveals their emotional profile has shifted drastically."
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# Nothing happens
									pass
								else:
									# Staff member has a change in mood
									pass,
						},
						{
							"show": true,
							"title": "Seal the object without reconstruction.",
							"success_from": RESOURCE.METRICS.READINESS,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s orders containment without reassembly of the slide." % [_staff_details.name],
									"No activation is triggered.",
									"The object is successfully stored under passive memetic screening."
								] if is_success else [
									"Without testing, a latent activation pulse occurs during sealing.",
									"Three guards report hearing voices in the hallway and require psychiatric evaluation.",
									"Containment cell shielding needs immediate reinforcement."
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# Nothing happens
									pass
								else:
									# Containment cell is damaged
									pass,
						}
					],

				},
		}
	}
}


var SCP4:Dictionary = {
	# -----------------------------------
	"nickname": "City Lights",
	"description": "██████ and ██████ on a rooftop at night, arms around each other. Neon reflections glow in the background.",
	# -----------------------------------
}

var SCP5:Dictionary = {
	# -----------------------------------
	"nickname": "Final Argument",
	"description": "Blurry capture. ██████ facing the camera; ██████ in profile, mid-sentence. A chair is overturned. Timestamp matches night of disappearance.",
	# -----------------------------------
}

var SCP6:Dictionary = {
	# -----------------------------------
	"nickname": "Quiet Morning",
	"description": "██████ and ██████ seated at a table, both reading. A half-eaten breakfast is visible. Light enters from the left.",
	# -----------------------------------
}

var SCP7:Dictionary = {
	# -----------------------------------
	"nickname": "The Garden",
	"description": "██████ planting herbs while ██████ holds a watering can. Soil is freshly turned. On the back: 'Spring — finally ours.'",
	# -----------------------------------
}

var SCP8:Dictionary = {
	# -----------------------------------
	"nickname": "Shared Umbrella",
	"description": "Subjects standing close under a large umbrella. Rain visibly falling. ██████ appears to be speaking. Streetlights are active.",
	# -----------------------------------
}

var SCP9:Dictionary = {
	# -----------------------------------
	"nickname": "Disappearance",
	"description": "██████ stands alone at the station platform. ██████ is not visible. On the back: 'Waited. Never came.'",
	# -----------------------------------
}

var SCP10:Dictionary = {
	# -----------------------------------
	"nickname": "Laundry Day",
	"description": "██████ and ██████ folding clothes in a shared space. Light streaming in through a nearby window. On the back: 'Normal can be good.'",
	# -----------------------------------
}

var SCP11:Dictionary = {
	# -----------------------------------
	"nickname": "Dinner for Two",
	"description": "A table set for two. ██████ is pouring wine; ██████ is laughing. Candles are lit. On the back: 'Tried that recipe. Nailed it.'",
	# -----------------------------------
}

var SCP12:Dictionary = {
	# -----------------------------------
	"nickname": "Morning Routine",
	"description": "██████ brushing hair while ██████ prepares tea in the background. Mirror captures both subjects. Photo slightly faded.",
	# -----------------------------------
}

var SCP13:Dictionary = {
	# -----------------------------------
	"nickname": "Library Silence",
	"description": "██████ and ██████ seated on the floor between bookshelves. ██████ is asleep, head resting on ██████'s shoulder. No date marked.",
	# -----------------------------------
}

var SCP14:Dictionary = {
	# -----------------------------------
	"nickname": "Work Trip",
	"description": "██████ in formal attire, suitcase in hand. ██████ behind glass door. On the back: 'One week. Promise.'",
	# -----------------------------------
}

var SCP15:Dictionary = {
	# -----------------------------------
	"nickname": "The Chair",
	"description": "Single image of ██████ sitting in a dimly lit office chair. ██████ stands behind, face obscured. Photo is torn at the edges.",
	# -----------------------------------
}

var SCP16:Dictionary = {
	# -----------------------------------
	"nickname": "Lights Out",
	"description": "███ and ██████ under blankets, flashlight between them. Shadows on the wall form unclear patterns. On the back: 'Power cut — best night.'",
	# -----------------------------------
}

var SCP17:Dictionary = {
	# -----------------------------------
	"nickname": "Missed Time",
	"description": "███ and ██████ sitting apart on a bench. Clock in background reads 3:14 AM. Both subjects appear unaware of the camera.",
	# -----------------------------------
}

var SCP18:Dictionary = {
	# -----------------------------------
	"nickname": "Reflection",
	"description": "██████ taking a photo in a mirror; ██████ visible behind, smiling. Note on back: 'Caught him sneaking up again.'",
	# -----------------------------------
}

var SCP19:Dictionary = {
	# -----------------------------------
	"nickname": "Framed Memory",
	"description": "Portrait of ██████ and ██████ hung on a wall. Frame cracked. On the back: 'We looked happy. Maybe we were.'",
}
# -----------------------------------------------------------


# -----------------------------------------------------------
var list:Array[Dictionary] = [
	SCP0#, SCP1, SCP2, SCP3, SCP4, SCP5, SCP6, SCP7, SCP8, SCP9,
	#SCP10, SCP11, SCP12, SCP13, SCP14, SCP15, SCP16, SCP17, SCP18, SCP19
]
# -----------------------------------------------------------


# -----------------------------------------------------------
func get_render_from_metrics(ref:int, staff_details:Dictionary, vibes:Dictionary, threshold_amount:int = 0) -> Dictionary:
	var available_amount:int = vibes[ref]
	var is_threshold_met:bool = available_amount >= threshold_amount
	var property:String
	var lockout:bool = false 
	var hint_description:String = "%s must be at least %s (Currently at %s)." % [property, threshold_amount, available_amount]
	
	match ref:
		RESOURCE.METRICS.MORALE:
			property = "MORALE"
			if staff_details.mood.ref == RESEARCHER.MOODS.DEPRESSED:
				lockout = true
				hint_description = "Unavailable due to current mood."
		RESOURCE.METRICS.SAFETY:
			property = "SAFETY"
			if staff_details.mood.ref == RESEARCHER.MOODS.FRIGHTENED:
				lockout = true
				hint_description = "Unavailable due to current mood."			
		RESOURCE.METRICS.READINESS:
			property = "READINESS"
			if staff_details.mood.ref == RESEARCHER.MOODS.RELUCTANT:
				lockout = true
				hint_description = "Unavailable due to current mood."
	
	return {
		"lockout": lockout,
		"property": property,
		"is_available": is_threshold_met,
		"hint_description": hint_description
	}
	
func get_render_from_currencies(ref:int, threshold_amount:int, staff_details:Dictionary, ) -> Dictionary:
	var available_amount:int = resources_data[ref].amount
	var is_threshold_met:bool = available_amount >= threshold_amount
	var has_resourceful_trait:bool = false
	var property:String
	var show:bool = staff_details.trait.ref == RESEARCHER.TRAITS.RESOURCEFUL
	
	match ref:
		RESOURCE.CURRENCY.MONEY:
			property = "MONEY"
		RESOURCE.CURRENCY.MATERIAL:
			property = "MATERIAL"
		RESOURCE.CURRENCY.SCIENCE:
			property = "SCIENCE"
		RESOURCE.CURRENCY.CORE:
			property = "CORE"
		
	return {
		"show": show,
		"property": property,
		"is_available": is_threshold_met and has_resourceful_trait,
		"cost": {"currency": ref, "amount": threshold_amount, "text": "Expend %s %s?" % [threshold_amount, property]},
		"hint_description": "%s must have at least %s (You currently have %s)." % [property, threshold_amount, available_amount]
	}

func get_success_rate(ref:int, vibes:Dictionary, baseline:int = 10, factor_of:int = 20) -> int:
	var success_rate:int = baseline + (vibes[ref] * factor_of)
	return U.min_max(success_rate, 0, 100)
	
	
func staff_is_killed(scp_details:Dictionary, staff_details:Dictionary) -> Dictionary:
	return {
		"staff": { 
			"action": 'kia',
			"scp_details": scp_details,
			"staff_details": staff_details
		}
	}
# -----------------------------------------------------------
