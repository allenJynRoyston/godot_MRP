extends SubscribeWrapper


var SCP0:Dictionary = {
	"nickname": "The Mirror",
	"description": func(_scp_details:Dictionary) -> String:
		return "SCP-XXXX is a 1.2m x 1.2m gilded picture frame containing no canvas or backing. When affixed to a flat vertical surface, SCP-XXXX creates a window-like aperture into what appears to be an identical room mirroring the one it faces. This 'mirror room' displays subtle differences over time — such as displaced furniture, altered lighting, or the presence of shadows moving independently of any known source. Any living organism passing through SCP-XXXX will not emerge in the physical room beyond the frame but will instead vanish completely, presumed transported to the mirrored dimension. Attempts to tether or track subjects have all failed beyond the threshold.\n\nWhen left undisturbed, SCP-XXXX 'inhales' slowly — drawing air, paper, and small debris toward it at irregular intervals. The room on the other side reflects these interactions with a delay of approximately 3–5 seconds. No communication has ever been established with the mirrored space.\n\nSCP-XXXX is currently mounted in a reinforced, sensor-equipped containment chamber with no other ingress points.",
	"abstract": func(_scp_details:Dictionary) -> String:
		return "A gilded picture frame that opens a window into a subtly altered mirrored version of the room it faces. Objects entering vanish without trace. Categorized as SPATIAL and CONCEPTUAL.",
	"img_src": "res://Media/scps/mirror_frame.png",
	
	"containment_requirements": [
		SCP.CONTAINMENT_TYPES.SPATIAL,
		SCP.CONTAINMENT_TYPES.CONCEPTUAL
	],

	"event": {
		EVT.TYPE.SCP_ON_CONTAINMENT: {
			"story": func(_staff_details:Dictionary, _scp_details:Dictionary) -> Array:
				return [
					"%s has been assigned to oversee initial observation of %s." % [_staff_details.name, _scp_details.name],
					"As containment seals engage, the aperture within %s begins its slow 'breathing' motion — a pulsing inhale that tugs at loose objects and clothing." % _scp_details.name,
					"Through the empty frame, the mirrored containment room appears — identical, yet off. The fluorescent lights flicker in the other room, though not in this one. A chair is slightly turned. A clipboard sits where none was placed.",
					"Suddenly, %s notices their own reflection lagging behind — the mirrored version remains still, staring back just a moment too long before mimicking their latest movement." % _staff_details.name,
					"The tension in the room rises. %s looks visibly uncomfortable, but transfixed on their reflection." % [_staff_details.name],
				],

			"choices": func(_staff_details:Dictionary, _scp_details:Dictionary) -> Dictionary:
				return {
					"standard": [
						{
							"show": true,
							"title": "Back away from the frame and seal the chamber.",
							"success_rate": 50,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s slowly moves towards the exit. The mirrored version does the same.  As the door closes, the mirror version stands there and smiles." % _staff_details.name
								] if is_success else [
									"%s slowly moves towards the exit, but the mirrored version lingers — staring, unmoving. As the chamber door seals, a low grinding noise echoes behind it. One of the reinforced panels begins to bow outward." % _staff_details.name
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# nothing happens
									pass
								else:
									# containment cell is damaged
									pass,
						},

						{
							"show": true,
							"title": "Attempt to communicate with the mirror version.",
							"success_from": RESOURCE.METRICS.MORALE,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s speaks to the figure. It tilts its head and writes something on a clipboard: 'WE SEE YOU'." % _staff_details.name
								] if is_success else [
									"%s calls out, but the mirrored figure vanishes mid-motion. All camera feeds inside the chamber cut out." % _staff_details.name
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# researcher has a change in mood
									pass
								else:
									# NOTHING HAPPENS
									pass,
						},
						{
							"show": true,
							"title": "Send in a drone for closer analysis.",
							"success_from": RESOURCE.METRICS.SAFETY,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"A drone crosses through the aperture. The feed holds steady for a few moments, then displays a third, unknown chamber before cutting to black."
								] if is_success else [
									"The drone halts mid-frame and vibrates violently before disintegrating into ash."
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# a resource is gained
									pass
								else:
									# a resource is lost
									pass,
						},
						{
							"show": true,
							"title": "Touch the frame directly.",
							"success_from": RESOURCE.METRICS.READINESS,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"As their hand meets the frame, it pulses — and a mirrored hand lunges outward. Security intervenes just in time. %s is unharmed, but visibly disturbed." % _staff_details.name
								] if is_success else [
									"As their hand meets the frame, it pulses — and a mirrored hand lunges outward. It grabs %s violently, pulling them into the reflection.  Cameras monitor the cell abruptly cut out.  When security gets into the room, the room remains empty with no sign of %s anywhere." % _staff_details.name
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# researcher has a change in personality (usually like a phobia)
									pass
								else:
									# researcher killed
									pass,
						}
					],

					"trait": {
						RESEARCHER.TRAITS.ACROPHOBIA: {
							"title": "Engage in extended observation of their reflection.",
							"success_from": RESOURCE.METRICS.MORALE,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s stares at their mirrored self for minutes. The mirror blinks first. For now, containment holds." % _staff_details.name
								] if is_success else [
									"%s becomes transfixed. When guards pull them away, the mirrored version does not follow — it simply remains, smiling." % _staff_details.name
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# buff or debuff is applied to the facility
									pass
								else:
									# researcher has a change in personality (usually like a phobia)
									pass,
						}
					}
				},


		}
	}
}


var SCP1:Dictionary = {
	"nickname": "The Oracle Keys",
	"description": func(_scp_details:Dictionary) -> String:
		return "%s is a heavily worn Underwood No. 5 typewriter, circa 1915. When loaded with blank paper and left unattended, %s will begin typing autonomously. The typed content consists of vivid, highly detailed descriptions of future events — often involving personnel near its vicinity or Foundation operations worldwide. Events described by %s have a 92%% accuracy rate when left unaltered. Interventions based on these writings often cause deviations, usually resulting in unintended consequences.\n\nAttempts to trace the source of the autonomous typing have revealed no internal mechanisms or power source beyond the standard mechanical components. Infrared and thermal imaging during operation show no signs of heat, pressure, or motion.\n\nNotably, %s never repeats predictions and occasionally types messages addressed directly to personnel, often using unsettlingly personal language. If forcibly interrupted mid-operation, %s will jam until repaired — typically by the person it last named." % [_scp_details.name, _scp_details.name, _scp_details.name, _scp_details.name, _scp_details.name],
	"abstract": func(_scp_details:Dictionary) -> String:
		return "A haunted typewriter that autonomously types predictions of future events with alarming accuracy. Categorized as INFOHAZARD and PSYCHIC.",
	"img_src": "res://Media/scps/typewriter.png",
	
	"containment_requirements": [
		SCP.CONTAINMENT_TYPES.INFOHAZARD,
		SCP.CONTAINMENT_TYPES.PSYCHIC
	],

	"event": {
		EVT.TYPE.SCP_ON_CONTAINMENT: {
			"story": func(_staff_details:Dictionary, _scp_details:Dictionary) -> Array:
				return [
					"%s has been selected to lead initial assessment of %s." % [_staff_details.name, _scp_details.nickname],
					"%s sits quietly in its containment cell, a sheet of blank paper already loaded. As power stabilizers cycle, it begins typing — loudly and with purpose." % _scp_details.name,
					"The clack of keys echoes through the chamber. Words appear: 'DO NOT LET HIM ANSWER THE PHONE AT 14:17.'",
					"%s leans in to read more. The paper continues: 'He dies either way. But the scream is... avoidable.'" % _staff_details.name,
					"The room goes cold. The typewriter pauses. Then slowly types: 'Hello, %s.'" % _staff_details.name
				],

			"choices": func(_staff_details:Dictionary, _scp_details:Dictionary) -> Dictionary:
				return {
					"standard": [
						{
							"show": true,
							"title": "Remove the paper and seal it for analysis.",
							"success_rate": 100,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s carefully removes the page. The keys snap once, like a farewell. The typewriter goes silent." % _staff_details.name
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								pass,
						},
						{
							"show": true,
							"title": "Ask it a direct question.",
							"success_from": RESOURCE.METRICS.MORALE,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s asks, 'What happens to me?' The typewriter pauses, then types: 'Not today.'" % _staff_details.name
								] if is_success else [
									"%s asks, 'What happens to me?' The typewriter hammers out: 'Turn around.' There is no one there." % _staff_details.name
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								pass,
						},
						{
							"show": true,
							"title": "Attempt to disrupt typing mid-sentence.",
							"success_from": RESOURCE.METRICS.SAFETY,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s stops the carriage arm. The machine grinds to a halt. Later diagnostics show no physical reason for the jam." % _staff_details.name
								] if is_success else [
									"%s touches the carriage arm. It snaps shut, breaking two fingers. Blood spatters across the keys, which resume typing uninterrupted." % _staff_details.name
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								pass,
						},
						{
							"show": true,
							"title": "Read the full page aloud.",
							"success_from": RESOURCE.METRICS.READINESS,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s reads aloud. As each line is spoken, the room vibrates slightly. At the last word, all equipment resets. Time skipped ahead 12 seconds." % _staff_details.name
								] if is_success else [
									"%s reads aloud. A klaxon sounds from a nearby wing, despite no breach. Containment systems require a full reset." % _staff_details.name
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								pass,
						}
					],

					"trait": {
						RESEARCHER.TRAITS.THALASSOPHOBIA: {
							"title": "Scan the machine for hidden transmitters or trackers.",
							"success_from": RESOURCE.METRICS.SAFETY,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s takes apart the chassis. Inside is nothing — except a folded photo of them as a child. They never posed for it." % _staff_details.name
								] if is_success else [
									"%s attempts a scan, but all instruments display nonsense characters — the same ones %s types when left without paper." % [_staff_details.name, _scp_details.name]
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								pass,
						}
					}
				},
		}
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

					"trait": {
						RESEARCHER.TRAITS.ACROPHOBIA: {
							"title": "Stare into the reflection on the bell’s surface.",
							"success_from": RESOURCE.METRICS.MORALE,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"%s sees a distorted version of themselves, then looks away, shaken but unharmed." % _staff_details.name
								] if is_success else [
									"%s sees a version of themselves plummeting from a high place—an event that never occurred. They become visibly distressed and refuse to approach the bell again." % _staff_details.name
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# change in mood
									pass
								else:
									# change in personality
									pass,
						}
					}
				},

		}
	}
}

var SCP3:Dictionary = {
	"nickname": "Chrono Labyrinth",
	"description": func(_scp_details:Dictionary) -> String:
		return "%s is an extradimensional maze, measuring approximately 30 meters by 30 meters in size. The walls and pathways within SCP-%s exhibit temporal anomalies, causing time loops and shifts. These anomalies manifest randomly, making navigation extremely hazardous." % [_scp_details.name, _scp_details.name],
	"abstract": func(_scp_details:Dictionary) -> String:
		return "An extradimensional maze exhibiting temporal anomalies, posing significant navigational hazards.",
	"img_src": "",
	
	"containment_requirements": [
		SCP.CONTAINMENT_TYPES.SPATIAL,
		SCP.CONTAINMENT_TYPES.TEMPORAL,
		SCP.CONTAINMENT_TYPES.DIMENSIONAL
	],

	"event": {
		EVT.TYPE.SCP_ON_CONTAINMENT: {
			"story": func(_staff_details:Dictionary, _scp_details:Dictionary) -> Array:
				return [
					"During initial containment of SCP-3487, exploration teams reported temporal distortions intensifying near the maze's core.",
					"Dr. %s, lead researcher, initiated a trial to stabilize the temporal flux using prototype temporal anchors." % [_staff_details.name],
					"After activating the anchors, SCP-3487's anomalies momentarily ceased, providing a window for mapping.",
					"However, the stability rapidly deteriorated, causing severe temporal dissonance within the maze.",
					"Team members experienced disorientation and memory lapses, consistent with exposure to SCP-3487's effects."
				],

			"choices": func(_staff_details:Dictionary, _scp_details:Dictionary) -> Dictionary:
				return {
					"standard": [
						{
							"show": true,
							"title": "Activate Temporal Anchors",
							"success_rate": 70,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"Dr. %s successfully activated the temporal anchors, stabilizing SCP-3487 temporarily." % [_staff_details.name],
									"Research progress was made, with valuable data on spatial-temporal shifts documented."
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# No adverse effect on the containment cell or personnel
									pass
								else:
									# Temporary containment breach, increased temporal instability
									# (Outcome 5: Containment cell is damaged)
									pass,
						},
						{
							"show": true,
							"title": "Initiate Time Dilation Protocol",
							"success_rate": 40,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"Despite precautions, time dilation caused by SCP-3487 intensified unpredictably.",
									"Several team members reported psychological effects, including heightened anxiety and paranoia."
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									# Psychological impact observed, but contained
									# (Outcome 4: Staff member has a change in mood)
									pass
								else:
									#// Severe psychological trauma, affecting entire team
									#// (Outcome 7: Morale altered)
									pass,
						}
					],

					"trait": {
						RESEARCHER.TRAITS.ACROPHOBIA: {
							"title": "Researcher with Acrophobia",
							"success_from": RESOURCE.METRICS.MORALE,
							"story": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> Array:
								return [
									"Dr. %s, despite acrophobia, managed to contribute significantly to containment efforts." % [_staff_details.name],
									"Exposure to SCP-3487's anomalies, surprisingly, alleviated personal fears temporarily."
								],
							"effect": func(_staff_details:Dictionary, _scp_details:Dictionary, is_success:bool) -> void:
								if is_success:
									#// Improved morale due to personal triumph
									#// (Outcome 3: Staff member has a change in personality)
									pass
								else:
									#// Increased anxiety, requiring temporary reassignment
									#// (Outcome 4: Staff member has a change in mood)
									pass,
						}
					}
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

# -----------------------------------
var list:Array[Dictionary] = [
	SCP0, SCP1, SCP2, SCP3, SCP4, SCP5, SCP6, SCP7, SCP8, SCP9,
	SCP10, SCP11, SCP12, SCP13, SCP14, SCP15, SCP16, SCP17, SCP18, SCP19
]
# -----------------------------------
