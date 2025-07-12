extends Node


enum CONTAINMENT_TYPES {
  # CORE
  PHYSICAL,
  CHEMICAL,
  MEMETIC,
  PSYCHIC,
  TEMPORAL,
  SPATIAL,
  DIMENSIONAL,
  BIOLOGICAL,
  ENERGETIC,
  INFOHAZARD,

  # EXTENDED
  CONCEPTUAL,
  ONTOLOGICAL,
  REALITY_BENDING,
  ACOUSTIC,
  LINGUISTIC,
  TECHNOLOGICAL,
  INTERNALIZED,
  ECOSYSTEMIC,
  SOCIAL,
  MORAL
}


var ref_data: Dictionary = {
	# --------------------------- CORE ---------------------------
	CONTAINMENT_TYPES.PHYSICAL: {
		"name": "PHYSICAL",
		"description": "Requires tangible barriers like walls, locks, or restraints."
	},
	CONTAINMENT_TYPES.CHEMICAL: {
		"name": "CHEMICAL",
		"description": "Controlled through chemical agents or reactive compounds."
	},
	CONTAINMENT_TYPES.MEMETIC: {
		"name": "MEMETIC",
		"description": "Involves dangerous ideas or symbols that spread cognitively."
	},
	CONTAINMENT_TYPES.PSYCHIC: {
		"name": "PSYCHIC",
		"description": "Requires protection from mental or telepathic intrusion."
	},
	CONTAINMENT_TYPES.TEMPORAL: {
		"name": "TEMPORAL",
		"description": "Affected by or manipulating the flow of time."
	},
	CONTAINMENT_TYPES.SPATIAL: {
		"name": "SPATIAL",
		"description": "Distorts or depends on irregular geometry or space."
	},
	CONTAINMENT_TYPES.DIMENSIONAL: {
		"name": "DIMENSIONAL",
		"description": "Exists partially or entirely outside baseline reality."
	},
	CONTAINMENT_TYPES.BIOLOGICAL: {
		"name": "BIOLOGICAL",
		"description": "Living or organic; requires biocontainment protocols."
	},
	CONTAINMENT_TYPES.ENERGETIC: {
		"name": "ENERGETIC",
		"description": "Emits or feeds on anomalous energy fields."
	},
	CONTAINMENT_TYPES.INFOHAZARD: {
		"name": "INFOHAZARD",
		"description": "Dangerous to know, read, or perceive directly."
	},

	# --------------------------- EXTENDED ---------------------------
	CONTAINMENT_TYPES.CONCEPTUAL: {
		"name": "CONCEPTUAL",
		"description": "Exists as or affects abstract concepts or thoughts."
	},
	CONTAINMENT_TYPES.ONTOLOGICAL: {
		"name": "ONTOLOGICAL",
		"description": "Alters or contradicts fundamental properties of being."
	},
	CONTAINMENT_TYPES.REALITY_BENDING: {
		"name": "REALITY-BENDING",
		"description": "Modifies reality through unknown or inherent means."
	},
	CONTAINMENT_TYPES.ACOUSTIC: {
		"name": "ACOUSTIC",
		"description": "Transmits anomalies through sound or vibration."
	},
	CONTAINMENT_TYPES.LINGUISTIC: {
		"name": "LINGUISTIC",
		"description": "Affects or is activated by spoken or written language."
	},
	CONTAINMENT_TYPES.TECHNOLOGICAL: {
		"name": "TECHNOLOGICAL",
		"description": "Interacts with or depends on digital or mechanical systems."
	},
	CONTAINMENT_TYPES.INTERNALIZED: {
		"name": "INTERNALIZED",
		"description": "Contained by embedding within a host or object."
	},
	CONTAINMENT_TYPES.ECOSYSTEMIC: {
		"name": "ECOSYSTEMIC",
		"description": "Requires environmental or habitat-wide containment."
	},
	CONTAINMENT_TYPES.SOCIAL: {
		"name": "SOCIAL",
		"description": "Spreads through or manipulates social structures or behavior."
	},
	CONTAINMENT_TYPES.MORAL: {
		"name": "MORAL",
		"description": "Depends on ethical perception; breaks norms when judged."
	}
}


# ---------------------------
func return_type_data(ref:int) -> Dictionary:
	return ref_data[ref]
# ---------------------------
