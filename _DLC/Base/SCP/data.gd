extends SubscribeWrapper

# -----------------------------------------------------------
func get_render_from_metrics(ref:int, vibes:Dictionary, threshold_amount:int) -> Dictionary:
	var amount:int = vibes[ref]
	var is_threshold_met:bool = threshold_amount >= amount
	var property:String
	
	match ref:
		RESOURCE.METRICS.MORALE:
			property = "MORALE"
		RESOURCE.METRICS.SAFETY:
			property = "SAFETY"
		RESOURCE.METRICS.READINESS:
			property = "READINESS"
	
	return {
		"property": property,
		"is_available": is_threshold_met,
		"hint_description": "%s must be at least %s (Currently at %s)." % [property, threshold_amount, amount]
	}
	
func get_render_from_currencies(ref:int, threshold_amount:int) -> Dictionary:
	var amount:int = resources_data[ref].amount
	var is_threshold_met:bool = threshold_amount >= amount
	var property:String
	
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
		"property": property,
		"is_available": is_threshold_met,
		"cost": {"currency": ref, "amount": threshold_amount, "text": "Expend %s %s?" % [threshold_amount, property]},
		"hint_description": "%s must have at least %s (You currently have %s)." % [property, threshold_amount, amount]
	}

func get_success_rate(ref:int, vibes:Dictionary, baseline:int = 10, factor_of:int = 20) -> int:
	var success_rate:int = baseline + (vibes[ref] * factor_of)
	return U.min_max(success_rate, 0, 100)
# -----------------------------------------------------------


# -----------------------------------------------------------
var SCP0:Dictionary = {
	"nickname": "The Mirror",
	"description": func(_scp_details:Dictionary) -> String:
		return "SCP-XXXX is a 1.2m x 1.2m gilded picture frame containing no canvas or backing. When affixed to a flat vertical surface, SCP-XXXX creates a window-like aperture into what appears to be an identical room mirroring the one it faces. This 'mirror room' displays subtle differences over time — such as displaced furniture, altered lighting, or the presence of shadows moving independently of any known source. Any living organism passing through SCP-XXXX will not emerge in the physical room beyond the frame but will instead vanish completely, presumed transported to the mirrored dimension. Attempts to tether or track subjects have all failed beyond the threshold.\n\nWhen left undisturbed, SCP-XXXX 'inhales' slowly — drawing air, paper, and small debris toward it at irregular intervals. The room on the other side reflects these interactions with a delay of approximately 3–5 seconds. No communication has ever been established with the mirrored space.\n\nSCP-XXXX is currently mounted in a reinforced, sensor-equipped containment chamber with no other ingress points.",
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
		EVT.TYPE.SCP_ON_CONTAINMENT: {
			"story": func(props:Dictionary) -> Array:
				var _staff_details:Dictionary = props.selected_staff
				var _scp_details:Dictionary = props.scp_details
				return [
					"%s has been assigned to oversee initial observation of %s." % [_staff_details.name, _staff_details.name],
					"As containment seals engage, the aperture within %s begins its slow 'breathing' motion — a pulsing inhale that tugs at loose objects and clothing." % _scp_details.name,
					"Through the empty frame, the mirrored containment room appears — identical, yet off. The fluorescent lights flicker in the other room, though not in this one. A chair is slightly turned. A clipboard sits where none was placed.",
					"Suddenly, %s notices their own reflection lagging behind — the mirrored version remains still, staring back just a moment too long before mimicking their latest movement." % _staff_details.name,
					"The tension in the room rises. %s hesitates, unsure of what to do next." % [_staff_details.name],
				],

			"choices": func(props:Dictionary) -> Dictionary:
				var _staff_details:Dictionary = props.selected_staff
				var _scp_details:Dictionary = props.scp_details
				var _vibes:Dictionary = props.vibes
				return {
					"standard": [
						{
							"title": "Exit the containment chamber.",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"%s makes their way to the exit, maintaining unbroken eye contact with the mirrored self. The reflection mirrors every step with unsettling precision. Just before the chamber door seals, it smiles faintly — a gesture not mirrored by %s." % [_staff_details.name, _staff_details.name]
								] if is_success else [
									"%s steps backward toward the exit, but the mirrored figure lags — slightly off-beat, slightly too close. As the chamber door begins to close, the reflection halts mid-step, locked in place with eyes fixed on %s." % [_staff_details.name, _staff_details.name]
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},


						{
							"title": "Attempt to communicate with the mirror version.",
							"success_rate": get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 50),
							"story": func(is_success:bool) -> Array:
								return [
									"%s speaks to the figure. It tilts its head and writes something on a clipboard: 'WE SEE YOU'." % _staff_details.name
								] if is_success else [
									"%s calls out, but the mirrored figure vanishes mid-motion. All camera feeds inside the chamber cut out." % _staff_details.name
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},
						{
							"title": "Send in a drone for closer analysis.",
							"success_rate": get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 50),
							"story": func(is_success:bool) -> Array:
								return [
									"A drone crosses through the aperture. The feed holds steady for a few moments, then displays a third, unknown chamber before cutting to black."
								] if is_success else [
									"The drone halts mid-frame and vibrates violently before disintegrating into ash."
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},
						{
							"title": "Touch the frame directly.",
							"success_rate": get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 50),
							"story": func(is_success:bool) -> Array:
								return [
									"As their hand meets the frame, it pulses — and a mirrored hand lunges outward. Security intervenes just in time. %s is unharmed, but visibly disturbed." % _staff_details.name
								] if is_success else [
									"As their hand meets the frame, it pulses — and a mirrored hand lunges outward. It grabs %s violently, pulling them into the reflection.  Cameras monitor the cell abruptly cut out.  When security gets into the room, the room remains empty with no sign of %s anywhere." % _staff_details.name
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						}
					],

					"traits": {
						RESEARCHER.TRAITS.AVERAGE: {
							"title": "Maintain observation without direct interaction.",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"%s remains still, recording data without approaching the anomaly. The mirrored version does the same. After several minutes, both researchers and reflection cease all motion simultaneously. No abnormalities reported." % _staff_details.name
								] if is_success else [
									"%s maintains passive observation, but gradually becomes unsettled. The reflection does not blink — nor breathe. A subtle distortion appears in the mirrored image, though no corresponding change occurs in the real room." % _staff_details.name
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},

						
						RESEARCHER.TRAITS.NARCISSIST: {
							"title": "Approach the mirror to study their own reflection in detail.",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"%s leans in, fascinated by the mirrored self. The figure responds in kind, perfectly synchronized. For a moment, a sense of connection — then the reflection mouths something silently: 'I am you.'"
								] if is_success else [
									"%s begins speaking to their reflection, entranced. The mirror version does not blink. It grins wide, and so does %s. When security intervenes, %s resists removal." 
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},

						RESEARCHER.TRAITS.INTROVERT: {
							"title": "Request remote observation instead of staying in the chamber.",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"%s requests a transfer to the monitoring suite. From behind the glass, the reflection continues to mimic. Safer, but the unease remains." 
								] if is_success else [
									"Even from the remote station, %s finds the reflection watching them through the feed. It taps once on the mirrored side of the camera — a sound is heard in the control room."
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},

						RESEARCHER.TRAITS.EXTROVERT: {
							"title": "Invite another researcher in to verify what they're seeing.",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"%s brings in an assistant. Together, they compare movements — confirming a slight delay. The mirrored versions nod to each other. Nothing else occurs."
								] if is_success else [
									"The second researcher does not appear in the mirror. Only %s is reflected — now alone, and staring at an empty mirrored room."
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},

						RESEARCHER.TRAITS.PARANOID: {
							"title": "Demand immediate scan for hidden observers or surveillance devices.",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"%s sweeps the room with a personal EMF scanner. Nothing unusual detected. They request camera logs for the last 48 hours." 
								] if is_success else [
									"%s insists something is recording from the mirror. They disable the chamber camera and begin dismantling equipment. Reflection mirrors the breakdown — but with tools not present in this room."
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},

						RESEARCHER.TRAITS.OPTIMIST: {
							"title": "Smile and wave at the mirrored figure.",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"%s waves at the mirror calmly. The mirrored version waves back — and gives a small, encouraging nod. Sensors register a brief drop in ambient EM field activity."
								] if is_success else [
									"%s smiles, but the mirror version does not. It frowns, then mimics the wave with a stiff, unnatural motion. The lights flicker once."
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},

						RESEARCHER.TRAITS.PESSIMIST: {
							"title": "Assume the worst and recommend containment lockdown.",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"%s declares the anomaly an existential threat and begins preemptive lockdown protocol. Command agrees. Mirror activity ceases for the time being." 
								] if is_success else [
									"%s issues a lockdown warning. Seconds later, the mirrored room darkens. The reflection remains — faintly visible, watching in the dark."
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},

						RESEARCHER.TRAITS.WORKAHOLIC: {
							"title": "Begin logging detailed anomaly behavior despite growing risks.",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"%s sets up live documentation, noting minor visual delays and behavior loops. They remain focused, even as the mirrored version stops mirroring and begins taking its own notes." 
								] if is_success else [
									"%s documents aggressively. The mirrored self grows more agitated, then begins scribbling on the glass from the other side. The notes are reversed, but they spell a name — %s's own." 
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},

						RESEARCHER.TRAITS.LAZY: {
							"title": "Remain seated and observe from a distance.",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"%s refuses to approach the mirror directly. From their seat, they record minor movements in the reflection — all consistent with ambient motion."
								] if is_success else [
									"%s lounges across the room. The mirror version stands at the frame, beckoning them. It does not leave until the chamber lights are turned off."
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},

						RESEARCHER.TRAITS.SARCASTIC: {
							"title": "Mock the mirror figure with exaggerated gestures.",
							"success_rate": 40,
							"story": func(is_success:bool) -> Array:
								return [
									"%s exaggerates movements and grimaces at the mirror. The mirrored version responds in kind — but gradually becomes out of sync, as if insulted." 
								] if is_success else [
									"%s mocks the reflection openly. The mirrored version stops mirroring, leans in close, and mouths something clearly: 'We are not amused.'"
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						}
					}

				},


		},
		# ----------------------------
		
		# ----------------------------
		EVT.TYPE.SCP_BREACH_EVENT_1: {
			"story": func(props:Dictionary) -> Array:
				var _staff_details:Dictionary = props.selected_staff
				var _scp_details:Dictionary = props.scp_details
				return [
					"An alarm blares suddenly as the containment chamber housing %s detects an abrupt energy surge." % _scp_details.name,
					"The gilded frame begins to shimmer violently, the mirrored aperture fluctuating between clarity and static noise.",
					"%s rushes into the chamber just as a figure steps out from the mirror dimension — an exact but distorted copy of themselves." % _staff_details.name,
					"The doppelgänger moves with jerky, unnatural motions, eyes glowing faintly with an eerie light.",
					"%s attempts to communicate, but the mirrored entity only snarls and lunges forward, forcing a rapid retreat." % _staff_details.name,
					"The containment system fails to re-engage as the mirror flickers wildly, and several other distorted reflections appear momentarily around the room, causing chaos and confusion.",
					"Security teams are deployed to recontain %s and subdue the intruding entities." % _scp_details.name
				],

			"choices": func(props:Dictionary) -> Dictionary:
				var _staff_details:Dictionary = props.selected_staff
				var _scp_details:Dictionary = props.scp_details
				var _vibes:Dictionary = props.vibes
				return {
					"standard": [
						{
							"title": "Do nothing.",
							"success_rate": 10,
							"story": func(is_success:bool) -> Array:
								return [
									"%s freezes, choosing not to interact or respond. Minutes pass. The mirrored figure mimics the stillness, posture-perfect. Then, with no warning, the mirrored version blinks — twice — and smiles faintly before walking out of frame. The real room remains unchanged." % _staff_details.name
								] if is_success else [
									"%s remains motionless, doing nothing. Across the frame, the mirrored version gradually desynchronizes, tilting its head with increasing curiosity. Eventually, it lifts a hand and taps on the inside of the glass. Something knocks back — from this side." % _staff_details.name
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# Small sanity bonus or insight
									return {}
								else:
									# Raises internal threat level or triggers latent hazard
									return {},
						},
						{
							"render_if": get_render_from_metrics(RESOURCE.METRICS.MORALE, _vibes, 2),
							"success_rate": get_success_rate(RESOURCE.METRICS.MORALE, _vibes, 50),
							"title": "Activate emergency dimensional lockdown protocols.",
							"story": func(is_success:bool) -> Array:
								return [
									"Automated barriers slide down, sealing off the chamber as energy pulses intensify within %s." % _scp_details.name,
									"The mirror's surface distorts and then abruptly goes dark, signaling containment restoration."
								] if is_success else [
									"Lockdown protocols activate, but the dimensional seals falter under pressure.",
									"%s's distorted figures slip through cracks in containment, forcing a frantic manual override." % _scp_details.name
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# containment secured
									return {}
								else:
									# containment partially breached, increased risk
									return {},
						},

						{
							"render_if": get_render_from_metrics(RESOURCE.METRICS.SAFETY, _vibes, 2),
							"success_rate": get_success_rate(RESOURCE.METRICS.SAFETY, _vibes, 50),
							"title": "Attempt to communicate with the mirrored entities.",
							"story": func(is_success:bool) -> Array:
								return [
									"%s tries to calm the intruders, speaking softly. One figure hesitates, then mimics a peaceful gesture before fading back into the mirror." % _staff_details.name
								] if is_success else [
									"Communication attempts provoke aggression. The mirrored entities howl and shatter nearby glass.",
									"%s is forced to retreat as the mirror's surface cracks ominously." % _staff_details.name
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# morale boost, partial containment regained
									return {}
								else:
									# morale penalty, containment destabilized
									return {},
						},

						{
							"render_if": get_render_from_metrics(RESOURCE.METRICS.READINESS, _vibes, 2),
							"success_rate": get_success_rate(RESOURCE.METRICS.READINESS, _vibes, 50),
							"title": "Deploy sedative gas into the chamber.",
							"story": func(is_success:bool) -> Array:
								return [
									"The chamber fills with a fine mist. The mirrored intruders stagger, then dissolve into shadowy wisps that vanish back through the frame.",
									"%s breathes a sigh of relief as containment stabilizes." % _staff_details.name
								] if is_success else [
									"Gas deployment has little effect; the entities seem unaffected and grow more agitated.",
									"%s barely escapes the chamber as containment alarms escalate." % _staff_details.name
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# containment stabilized, minor resource loss
									return {}
								else:
									# containment breach worsens, staff injured
									return {},
						},

						{
							"render_if": get_render_from_currencies(RESOURCE.CURRENCY.SCIENCE, 50),
							"title": "Cut power to the containment chamber.",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"Power shutdown plunges the chamber into darkness, and the mirror's glow fades.",
									"Silence follows as the entities retreat back into the reflection."
								] if is_success else [
									"Power loss triggers fail-safes causing the mirror to fracture violently.",
									"Fragments of the mirror dimension spill into the containment area, causing widespread damage."
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# emergency containment success
									return {}
								else:
									# critical containment failure
									return {},
						}
					],

					"traits": {
						RESEARCHER.TRAITS.PARANOID: {
							"title": "Refuse direct confrontation and coordinate remote operations.",
							"success_rate": 50,
							"story": func(is_success:bool) -> Array:
								return [
									"%s manages containment remotely, avoiding the chaotic chamber. Their cautious approach helps limit damage." % _staff_details.name
								] if is_success else [
									"Remote control failures force %s to enter the chamber, risking direct exposure to the anomalies." % _staff_details.name
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},

						RESEARCHER.TRAITS.EXTROVERT: {
							"title": "Lead frontline efforts to subdue the breach.",
							"success_rate": 55,
							"story": func(is_success:bool) -> Array:
								return [
									"%s inspires the security team, coordinating a strong offensive to regain control." % _staff_details.name
								] if is_success else [
									"Overconfidence causes %s to be overwhelmed by the entities, forcing a retreat." % _staff_details.name
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						},

						RESEARCHER.TRAITS.NARCISSIST: {
							"title": "Attempt to confront the mirror copies alone.",
							"success_rate": 35,
							"story": func(is_success:bool) -> Array:
								return [
									"%s steps boldly into the chamber, confronting their mirrored doppelgängers. For a moment, tension hangs thick, but the copies back down." % _staff_details.name
								] if is_success else [
									"%s is quickly overwhelmed by the mirrored entities, forced to flee with assistance." % _staff_details.name
								],
							"effect": func(is_success:bool) -> Dictionary:
								if is_success:
									# reduced damage
									return {}
								else:
									# staff risk increased
									return {},
						}
					}
				},
		},
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
