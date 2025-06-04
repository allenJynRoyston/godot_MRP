extends SubscribeWrapper


var SCP0:Dictionary = {
	# -----------------------------------
	"nickname": "First Snow",
	"description": "█████ and ██████ standing beside a snowman, both smiling. On the back it reads: 'Our first winter together.'",

	# ------------------------------------------
	"effects": {
		"description": "Adds 150 MONEY per day.", 
		"currencies": {
			RESOURCE.CURRENCY.MONEY: 150
		},
	},
	# ------------------------------------------
	# ------------------------------------------
	"on_contain": {
		# -----------------
		"text": [
			"Contain story goes here.",
		],
		# -----------------
		"responses": {
			EVT.RESPONSE.ALWAYS: {
				"title": "DO NOTHING",
				"story": func(is_successful:bool) -> Array:
					if is_successful:
						return ["ALWAYS PASS STORY"]
					else:
						return ["ALWAYS FAIL STORY"],
			},
			EVT.RESPONSE.MORALE: {
				"title": "Split the money.",
				"story": func(is_successful:bool) -> Array:
					if is_successful:
						return ["MORALE PASS STORY"]
					else:
						return ["MORALE FAIL STORY"],
			},
			EVT.RESPONSE.SAFETY: {
				"title": "Lockdown the room.",
				"story": func(is_successful:bool) -> Array:
					if is_successful:
						return ["SAFETY PASS STORY"]
					else:
						return ["SAFETY FAIL STORY"],
			},
			EVT.RESPONSE.READINESS: {
				"title": "Send in an MTF.",
				"story": func(is_successful:bool) -> Array:
					if is_successful:
						return ["READINESS PASS STORY"]
					else:
						return ["READINESS FAIL STORY"],
			}
		},
		# -----------------
		"consequence":{
			EVT.CONSEQUNCE.UNSUPERVISED: {
				"text": ["UNSUPERVISED story results"],
				"allowed_responses": [],
				"effect": func(is_success:bool) -> void:
					if is_success:
						print("RUN BAD EFFECT SUCCESS")
					else:
						print("RUN BAD EFFECT FAIL"),
			},
			EVT.CONSEQUNCE.NEUTRAL: {
				"text": ["NEUTRAL story results"],
				"allowed_responses": [],
				"effect": func(is_success:bool) -> void:
					if is_success:
						print("RUN NEUTRAL EFFECT SUCCESS")
					else:
						print("RUN NEUTRAL EFFECT FAIL"),
			},			
			EVT.CONSEQUNCE.GOOD: {
				"text": ["GOOD story results"],
				"allowed_responses": [EVT.RESPONSE.MORALE],
				"effect": func(is_success:bool) -> void:
					if is_success:
						print("RUN GOOD EFFECT SUCCESS")
					else:
						print("RUN GOOD EFFECT FAIL"),
				
			},
			EVT.CONSEQUNCE.BAD: {
				"text": ["BAD story results"],
				"allowed_responses": [EVT.RESPONSE.SAFETY, EVT.RESPONSE.READINESS],
				"effect": func(is_success:bool) -> void:
					if is_success:
						print("RUN BAD EFFECT SUCCESS")
					else:
						print("RUN BAD EFFECT FAIL"),
			},
		},
		# -----------------
		"default_consequence": EVT.CONSEQUNCE.NEUTRAL,
		# -----------------
		"specialization": {
			RESEARCHER.SPECIALIZATION.ADMINISTRATION: {
				"text": ["ADMINISTRATION story"],
				"consequence_result": EVT.CONSEQUNCE.GOOD,
			},
			RESEARCHER.SPECIALIZATION.ENGINEERING: {
				"text": ["ENGINEERING story"],
				"consequence_result": EVT.CONSEQUNCE.BAD,
			},
		}
		# -----------------
	},
	# ------------------------------------------
	
		
	# -----------------------------------
}

var SCP1:Dictionary = {
	# -----------------------------------
	"nickname": "Picnic Afternoon",
	"description": "█████ pouring wine while ██████ laughs. A red-checkered blanket is spread out under a large oak tree.",
	# -----------------------------------
}

var SCP2:Dictionary = {
	# -----------------------------------
	"nickname": "The Proposal",
	"description": "█████ kneeling before ██████ near a cliffside view. The sky is overcast. On the back it reads: 'She said yes.'",
	# -----------------------------------
}

var SCP3:Dictionary = {
	# -----------------------------------
	"nickname": "Broken Glass",
	"description": "Shards visible across a kitchen tile floor. ██████ appears mid-gesture. ██████ is partially out of frame, turning away.",
	# -----------------------------------
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
