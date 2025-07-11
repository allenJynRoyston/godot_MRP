extends SubscribeWrapper


# -----------------------------------------------------------
var SCP0:Dictionary = {
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

	"event": {
		# ----------------------------
		EVT.TYPE.SCP_ON_CONTAINMENT: [
			{
				"story": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"%s has been assigned to oversee initial containment of %s." % [_staff_details.name, _scp_details.name],
					],

				"choices": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
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
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"%s is undergoing a breach event!" % _staff_details.name,
					],
				"choices": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "MORALE OPTION",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.MORALE, _staff_details, _vibes),
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
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.READINESS, _staff_details, _vibes),
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
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.SAFETY, _staff_details, _vibes),
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
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					return [
						"%s is undergoing a containment event!" % _staff_details.name,
					],
				"choices": func(props:Dictionary) -> Array:
					var _staff_details:Dictionary = props.selected_staff
					var _scp_details:Dictionary = props.scp_details
					var _vibes:Dictionary = props.vibes

					return [
						# -----------------------------------------
						{
							"title": "MORALE OPTION",
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.MORALE, _staff_details, _vibes),
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
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.READINESS, _staff_details, _vibes),
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
							"render_if": SCP_UTIL.get_render_from_metrics(RESOURCE.METRICS.SAFETY, _staff_details, _vibes),
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

var SCP1:Dictionary = {
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
	
	"days_until_contained": 3,	
	"containment_requirements": [
		SCP.CONTAINMENT_TYPES.PHYSICAL
	],


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
	SCP0, SCP1, SCP2, #SCP3, SCP4, SCP5, SCP6, SCP7, SCP8, SCP9,
	#SCP10, SCP11, SCP12, SCP13, SCP14, SCP15, SCP16, SCP17, SCP18, SCP19
]
# -----------------------------------------------------------
