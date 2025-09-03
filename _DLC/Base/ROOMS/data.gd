extends SubscribeWrapper
var ADMIN:Script = preload("res://_DLC/Base/ROOMS/admin.gd")
var LOGISTICS:Script = preload("res://_DLC/Base/ROOMS/logistics.gd")
var ENGINEERING:Script = preload("res://_DLC/Base/ROOMS/engineering.gd")


enum INFTYPE {	
	CURRENCIES, MONEY, SCIENCE, MATERIAL, CORE,
	METRICS, MORALE, SAFETY, READINESS,
	EXTRA_LEVEL,
	ENERGY,
}

var INFLUENCE_PRESETS:Dictionary = {
	# --------------------
	INFTYPE.CURRENCIES: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": false,
		"effect": {
			"description": "Description goes here...",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> Dictionary:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# copy it
				var dict_copy:Dictionary = room_details.currencies.duplicate()
				# get room level currency (added bonuses)
				var room_level_config:Dictionary = _new_room_config.floor[location.floor].ring[location.ring].room[location.room]
				var currencies:Dictionary = room_level_config.currencies
				
				# add any bonuses in the room to it
				for currency_ref in currencies:
					var amount:int = currencies[currency_ref]
					if currency_ref not in dict_copy:
						dict_copy[currency_ref] = 0
					dict_copy[currency_ref] += amount

				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):		
					# and apply the bonus to them
					for _ref in dict_copy:
						var amount:int = dict_copy[_ref]
						_new_room_config.floor[location.floor].ring[location.ring].room[room].currencies[_ref] += amount				

				# return update config
				return _new_room_config,			
		},		
	}, 	
	INFTYPE.MONEY: {
		"starting_range": 1,
		"horizontal": false, 
		"vertical": true,
		"effect": {
			"description": "Description goes here...",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> Dictionary:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# copy it
				var dict_copy:Dictionary = room_details.currencies.duplicate()
				# get room level currency (added bonuses)
				var room_level_config:Dictionary = _new_room_config.floor[location.floor].ring[location.ring].room[location.room]
				var currencies:Dictionary = room_level_config.currencies
				
				# add any bonuses in the room to it
				for currency_ref in currencies:
					var amount:int = currencies[currency_ref]
					if currency_ref not in dict_copy:
						dict_copy[currency_ref] = 0
					dict_copy[currency_ref] += amount

				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):		
					# and apply the bonus to them
					for _ref in dict_copy:
						if _ref == RESOURCE.CURRENCY.MONEY:
							var amount:int = dict_copy[_ref]
							_new_room_config.floor[location.floor].ring[location.ring].room[room].currencies[_ref] += amount				

				# return update config
				return _new_room_config,			
		},		
	}, 
	INFTYPE.SCIENCE: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": false,
		"effect": {
			"description": "Description goes here...",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> Dictionary:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# copy it
				var dict_copy:Dictionary = room_details.currencies.duplicate()
				# get room level currency (added bonuses)
				var room_level_config:Dictionary = _new_room_config.floor[location.floor].ring[location.ring].room[location.room]
				var currencies:Dictionary = room_level_config.currencies
				
				# add any bonuses in the room to it
				for currency_ref in currencies:
					var amount:int = currencies[currency_ref]
					if currency_ref not in dict_copy:
						dict_copy[currency_ref] = 0
					dict_copy[currency_ref] += amount

				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):		
					# and apply the bonus to them
					for _ref in dict_copy:
						if _ref == RESOURCE.CURRENCY.SCIENCE:
							var amount:int = dict_copy[_ref]
							_new_room_config.floor[location.floor].ring[location.ring].room[room].currencies[_ref] += amount				

				# return update config
				return _new_room_config,			
		},		
	}, 
	INFTYPE.MATERIAL: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": false,
		"effect": {
			"description": "Description goes here...",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> Dictionary:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# copy it
				var dict_copy:Dictionary = room_details.currencies.duplicate()
				# get room level currency (added bonuses)
				var room_level_config:Dictionary = _new_room_config.floor[location.floor].ring[location.ring].room[location.room]
				var currencies:Dictionary = room_level_config.currencies
				
				# add any bonuses in the room to it
				for currency_ref in currencies:
					var amount:int = currencies[currency_ref]
					if currency_ref not in dict_copy:
						dict_copy[currency_ref] = 0
					dict_copy[currency_ref] += amount

				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):		
					# and apply the bonus to them
					for _ref in dict_copy:
						if _ref == RESOURCE.CURRENCY.MATERIAL:
							var amount:int = dict_copy[_ref]
							_new_room_config.floor[location.floor].ring[location.ring].room[room].currencies[_ref] += amount				

				# return update config
				return _new_room_config,			
		},		
	}, 
	INFTYPE.CORE: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": false,
		"effect": {
			"description": "Description goes here...",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> Dictionary:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# copy it
				var dict_copy:Dictionary = room_details.currencies.duplicate()
				# get room level currency (added bonuses)
				var room_level_config:Dictionary = _new_room_config.floor[location.floor].ring[location.ring].room[location.room]
				var currencies:Dictionary = room_level_config.currencies
				
				# add any bonuses in the room to it
				for currency_ref in currencies:
					var amount:int = currencies[currency_ref]
					if currency_ref not in dict_copy:
						dict_copy[currency_ref] = 0
					dict_copy[currency_ref] += amount

				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):		
					# and apply the bonus to them
					for _ref in dict_copy:
						if _ref == RESOURCE.CURRENCY.CORE:
							var amount:int = dict_copy[_ref]
							_new_room_config.floor[location.floor].ring[location.ring].room[room].currencies[_ref] += amount				

				# return update config
				return _new_room_config,			
		},		
	},
	# --------------------	
	INFTYPE.METRICS: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": false,
		"effect": {
			"description": "METRICS BOOST",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> Dictionary:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# copy it
				var dict_copy:Dictionary = room_details.metrics.duplicate()
				# get room level currency (added bonuses)
				var room_level_config:Dictionary = _new_room_config.floor[location.floor].ring[location.ring].room[location.room]
				var vibe_metrics:Dictionary = room_level_config.metrics

				## add any bonuses in the room to it
				for vibe_ref in vibe_metrics:
					var amount:int = vibe_metrics[vibe_ref]
					if vibe_ref not in dict_copy:
						dict_copy[vibe_ref] = 0
					dict_copy[vibe_ref] += amount

				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):		
					for _ref in dict_copy:
						var amount:int = dict_copy[_ref]								
						_new_room_config.floor[location.floor].ring[location.ring].room[room].metrics[_ref] += amount

				# return update config
				return _new_room_config,			
		},		
	},			
	INFTYPE.MORALE: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": false,
		"effect": {
			"description": "MORALE BOOST",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> Dictionary:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# copy it
				var dict_copy:Dictionary = room_details.metrics.duplicate()
				# get room level currency (added bonuses)
				var room_level_config:Dictionary = _new_room_config.floor[location.floor].ring[location.ring].room[location.room]
				var vibe_metrics:Dictionary = room_level_config.metrics


				## add any bonuses in the room to it
				for vibe_ref in vibe_metrics:
					var amount:int = vibe_metrics[vibe_ref]
					if vibe_ref not in dict_copy:
						dict_copy[vibe_ref] = 0
					dict_copy[vibe_ref] += amount

				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):		
					for _ref in dict_copy:
						match _ref:
							RESOURCE.METRICS.MORALE:
								var amount:int = dict_copy[_ref]								
								_new_room_config.floor[location.floor].ring[location.ring].room[room].metrics[_ref] += amount

				# return update config
				return _new_room_config,			
		},		
	},
	INFTYPE.SAFETY: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": false,
		"effect": {
			"description": "SAFETY BOOST",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> Dictionary:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# copy it
				var dict_copy:Dictionary = room_details.metrics.duplicate()
				# get room level currency (added bonuses)
				var room_level_config:Dictionary = _new_room_config.floor[location.floor].ring[location.ring].room[location.room]
				var vibe_metrics:Dictionary = room_level_config.metrics

				## add any bonuses in the room to it
				for vibe_ref in vibe_metrics:
					var amount:int = vibe_metrics[vibe_ref]
					if vibe_ref not in dict_copy:
						dict_copy[vibe_ref] = 0
					dict_copy[vibe_ref] += amount

				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):		
					for _ref in dict_copy:
						match _ref:
							RESOURCE.METRICS.SAFETY:
								var amount:int = dict_copy[_ref]								
								_new_room_config.floor[location.floor].ring[location.ring].room[room].metrics[_ref] += amount

				# return update config
				return _new_room_config,			
		},		
	},	
	INFTYPE.READINESS: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": false,
		"effect": {
			"description": "READINESS BOOST",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> Dictionary:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# copy it
				var dict_copy:Dictionary = room_details.metrics.duplicate()
				# get room level currency (added bonuses)
				var room_level_config:Dictionary = _new_room_config.floor[location.floor].ring[location.ring].room[location.room]
				var vibe_metrics:Dictionary = room_level_config.metrics

				## add any bonuses in the room to it
				for vibe_ref in vibe_metrics:
					var amount:int = vibe_metrics[vibe_ref]
					if vibe_ref not in dict_copy:
						dict_copy[vibe_ref] = 0
					dict_copy[vibe_ref] += amount

				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):		
					for _ref in dict_copy:
						match _ref:
							RESOURCE.METRICS.READINESS:
								var amount:int = dict_copy[_ref]								
								_new_room_config.floor[location.floor].ring[location.ring].room[room].metrics[_ref] += amount

				# return update config
				return _new_room_config,			
		},		
	},
	# --------------------
	INFTYPE.EXTRA_LEVEL: {
		"starting_range": 1,
		"horizontal": true, 
		"vertical": false,
		"effect": {
			"description": "Description goes here...",
			"func": func(_new_room_config:Dictionary, ref:int, location:Dictionary) -> Dictionary:
				# self ref to get currency data
				var room_details:Dictionary = ROOM_UTIL.return_data(ref)
				# get room level currency (added bonuses)
				var room_level_config:Dictionary = _new_room_config.floor[location.floor].ring[location.ring].room[location.room]
				# now get adjacent rooms
				for room in ROOM_UTIL.find_influenced_rooms( location, room_details.influence ):		
					_new_room_config.floor[location.floor].ring[location.ring].room[room].abl_lvl += 1
				# return update config
				return _new_room_config,			
		},		
	},	
	# --------------------
}

var DEBUG_ROOM:Dictionary = {
	# ------------------------------------------
	"ref": ROOM.REF.DEBUG_ROOM,
	"categories": [ROOM.CATEGORY.UTILITY],
	
	"name": "DEBUG_ROOM",
	"shortname": "DEBUG_ROOM",
	"img_src": "res://Media/rooms/research_lab.png",
	"description": "Debug room.",
	"requires_unlock": false,	
	"required_energy": 0,
	"own_limit": 10,
	# ------------------------------------------

	# ------------------------------------------
	"can_contain": false,
	"can_assign_researchers": true,
	"required_staffing": [
		RESEARCHER.SPECIALIZATION.RESEARCHER
	],
	# ------------------------------------------

	# ------------------------------------------	
	"currencies": {
		RESOURCE.CURRENCY.MONEY: 5,
		RESOURCE.CURRENCY.MATERIAL: 4,
		RESOURCE.CURRENCY.SCIENCE: 3,
		RESOURCE.CURRENCY.CORE: 2,
	},
	"metrics": {
		RESOURCE.METRICS.MORALE: 0,
		RESOURCE.METRICS.SAFETY: 0,
		RESOURCE.METRICS.READINESS: 0
	},	
	"environmental":{
		"hazard": 0,
		"temp": 0,
		"pollution": 0
	},	
	# ------------------------------------------
	
	# ------------------------------------------
	"costs": {
		"unlock": 1,
		"purchase": 1,
	},
	# ------------------------------------------
	
	# --------------------------------------
	#"requires_specialization": RESEARCHER.SPECIALIZATION.ADMINISTRATION,
	# ------------------------------------------	
	
	# ------------------------------------------
	"abilities": func() -> Array: 
		return [
			ABL.get_ability(ABL.REF.HAPPY_HOUR, 0),
			ABL.get_ability(ABL.REF.UNHAPPY_HOUR, 1),
			#ABL.get_ability(ABL.REF.UPGRADE_FACILITY),
			#ABL.get_ability(ABL.REF.SET_WARNING_MODE),
			#ABL.get_ability(ABL.REF.SET_DANGER_MODE, 1),
			
			#ABL.get_ability(ABL.REF.UNLOCK_FACILITIES, 0),
			#ABL.get_ability(ABL.REF.HIRE_RESEARCHER, 0),
			#ABL.get_ability(ABL.REF.PROMOTE_RESEARCHER, 0),
			#ABL.get_ability(ABL.REF.CLONE_RESEARCHER, 0),
			#ABL.get_ability(ABL.REF.ADD_TRAIT, 0),
			#ABL.get_ability(ABL.REF.REMOVE_TRAIT, 0),
			#
			#ABL.get_ability(ABL.REF.MONEY_HACK, 0),
			#ABL.get_ability(ABL.REF.SCIENCE_HACK, 0),
			#ABL.get_ability(ABL.REF.CONVERT_TO_SCIENCE, 0),
			#ABL.get_ability(ABL.REF.CONVERT_TO_MONEY, 0),
		],	
	# ------------------------------------------
		
	# ------------------------------------------
	"passive_abilities": func() -> Array: 
		return [
			ABL_P.get_ability(ABL_P.REF.GENERATE_CORE_LVL_1, 0),
			ABL_P.get_ability(ABL_P.REF.GENERATE_SCIENCE_LVL_1, 1),
			#ABL_P.get_ability(ABL_P.REF.GENERATE_MATERIAL_LVL_1, 0),
			#ABL_P.get_ability(ABL_P.REF.GENERATE_CORE_LVL_1, 0),
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_STAFF, 1),
			#ABL_P.get_ability(ABL_P.REF.ADDITIONAL_STORE_UNLOCKS, 2),			
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_TECHNICIANS, 2),
			#ABL_P.get_ability(ABL_P.REF.SUPPLY_DCLASS),
			#ABL_P.get_ability(ABL_P.REF.FIREARM_TRAINING, 1),
			#ABL_P.get_ability(ABL_P.REF.HEAVY_WEAPONS_TRAINING, 2),
			#ABL_P.get_ability(ABL_P.REF.TECH_SUPPORT),
			#ABL_P.get_ability(ABL_P.REF.MEMETIC_SHILEDING),
		],	
	# ------------------------------------------		
}

#region ADMIN
var ADMIN_DEPARTMENT:Dictionary = ADMIN.get_room_data(ROOM.REF.ADMIN_DEPARTMENT)
var ADMIN_BRANCH:Dictionary = ADMIN.get_room_data(ROOM.REF.ADMIN_BRANCH)

var ADMIN_ROOM_1:Dictionary = ADMIN.get_room_data(ROOM.REF.ADMIN_ROOM_1)
var ADMIN_ROOM_2:Dictionary = ADMIN.get_room_data(ROOM.REF.ADMIN_ROOM_2)
var ADMIN_ROOM_3:Dictionary = ADMIN.get_room_data(ROOM.REF.ADMIN_ROOM_3)
var ADMIN_ROOM_4:Dictionary = ADMIN.get_room_data(ROOM.REF.ADMIN_ROOM_4)
var ADMIN_ROOM_5:Dictionary = ADMIN.get_room_data(ROOM.REF.ADMIN_ROOM_5)
var ADMIN_ROOM_6:Dictionary = ADMIN.get_room_data(ROOM.REF.ADMIN_ROOM_6)
var ADMIN_ROOM_7:Dictionary = ADMIN.get_room_data(ROOM.REF.ADMIN_ROOM_7)
var ADMIN_ROOM_8:Dictionary = ADMIN.get_room_data(ROOM.REF.ADMIN_ROOM_8)
var ADMIN_ROOM_9:Dictionary = ADMIN.get_room_data(ROOM.REF.ADMIN_ROOM_9)
var ADMIN_ROOM_10:Dictionary = ADMIN.get_room_data(ROOM.REF.ADMIN_ROOM_10)
#endregion

#region LOGISTICS
var LOGISTICS_DEPARTMENT:Dictionary = LOGISTICS.get_room_data(ROOM.REF.LOGISTICS_DEPARTMENT)
var LOGISTICS_BRANCH:Dictionary = LOGISTICS.get_room_data(ROOM.REF.LOGISTICS_BRANCH)

var LOGISTICS_ROOM_1:Dictionary = LOGISTICS.get_room_data(ROOM.REF.LOGISTICS_ROOM_1)
var LOGISTICS_ROOM_2:Dictionary = LOGISTICS.get_room_data(ROOM.REF.LOGISTICS_ROOM_2)
var LOGISTICS_ROOM_3:Dictionary = LOGISTICS.get_room_data(ROOM.REF.LOGISTICS_ROOM_3)
var LOGISTICS_ROOM_4:Dictionary = LOGISTICS.get_room_data(ROOM.REF.LOGISTICS_ROOM_4)
var LOGISTICS_ROOM_5:Dictionary = LOGISTICS.get_room_data(ROOM.REF.LOGISTICS_ROOM_5)
var LOGISTICS_ROOM_6:Dictionary = LOGISTICS.get_room_data(ROOM.REF.LOGISTICS_ROOM_6)
var LOGISTICS_ROOM_7:Dictionary = LOGISTICS.get_room_data(ROOM.REF.LOGISTICS_ROOM_7)
var LOGISTICS_ROOM_8:Dictionary = LOGISTICS.get_room_data(ROOM.REF.LOGISTICS_ROOM_8)
var LOGISTICS_ROOM_9:Dictionary = LOGISTICS.get_room_data(ROOM.REF.LOGISTICS_ROOM_9)
var LOGISTICS_ROOM_10:Dictionary = LOGISTICS.get_room_data(ROOM.REF.LOGISTICS_ROOM_10)

#region ENGINEERING
var ENGINEERING_DEPARTMENT:Dictionary = ENGINEERING.get_room_data(ROOM.REF.ENGINEERING_DEPARTMENT)
var ENGINEERING_BRANCH:Dictionary = ENGINEERING.get_room_data(ROOM.REF.ENGINEERING_BRANCH)

var ENG_ROOM_1:Dictionary = ENGINEERING.get_room_data(ROOM.REF.ENG_ROOM_1)
var ENG_ROOM_2:Dictionary = ENGINEERING.get_room_data(ROOM.REF.ENG_ROOM_2)
var ENG_ROOM_3:Dictionary = ENGINEERING.get_room_data(ROOM.REF.ENG_ROOM_3)
var ENG_ROOM_4:Dictionary = ENGINEERING.get_room_data(ROOM.REF.ENG_ROOM_4)
var ENG_ROOM_5:Dictionary = ENGINEERING.get_room_data(ROOM.REF.ENG_ROOM_5)
var ENG_ROOM_6:Dictionary = ENGINEERING.get_room_data(ROOM.REF.ENG_ROOM_6)
var ENG_ROOM_7:Dictionary = ENGINEERING.get_room_data(ROOM.REF.ENG_ROOM_7)
var ENG_ROOM_8:Dictionary = ENGINEERING.get_room_data(ROOM.REF.ENG_ROOM_8)
var ENG_ROOM_9:Dictionary = ENGINEERING.get_room_data(ROOM.REF.ENG_ROOM_9)
var ENG_ROOM_10:Dictionary = ENGINEERING.get_room_data(ROOM.REF.ENG_ROOM_10)
#endregion

#
#var LOGISTICS_ROOM_2:Dictionary = {
	#"ref": ROOM.REF.LOGISTICS_ROOM_2,
	#"categories": [ROOM.CATEGORY.LOGISTICS_LINKABLE],
	#"name": "LOGISTICS_ROOM_2",
	#"shortname": "LOGISTICS_ROOM_2",
	#"img_src": "res://Media/rooms/vehicle_bay.png",
	#"description": "Transport Hub – coordinates vehicle fleets and rapid deployment.",
#}
#
#var LOGISTICS_ROOM_3:Dictionary = {
	#"ref": ROOM.REF.LOGISTICS_ROOM_3,
	#"categories": [ROOM.CATEGORY.LOGISTICS_LINKABLE],
	#"name": "LOGISTICS_ROOM_3",
	#"shortname": "LOGISTICS_ROOM_3",
	#"img_src": "res://Media/rooms/armory.png",
	#"description": "Armory Annex – maintains weapons and gear for response teams.",
	#"metrics": {
		#RESOURCE.METRICS.READINESS: 2
	#},
#}
#
#var LOGISTICS_ROOM_4:Dictionary = {
	#"ref": ROOM.REF.LOGISTICS_ROOM_4,
	#"categories": [ROOM.CATEGORY.LOGISTICS_LINKABLE],
	#"name": "LOGISTICS_ROOM_4",
	#"shortname": "LOGISTICS_ROOM_4",
	#"img_src": "res://Media/rooms/distribution_center.png",
	#"description": "Distribution Center – optimizes allocation of resources across the site.",
	#"abilities": func() -> Array:
		#return [
			##ABL.get_ability(ABL.REF.INCREASE_SUPPLY),
			##ABL.get_ability(ABL.REF.REDUCE_COST, 1),
		#]
#}
#endregion
#
##region SCIENCE
#var SCIENCE_DEPARTMENT:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.SCIENCE_DEPARTMENT,
	#"categories": [ROOM.CATEGORY.DEPARTMENT],
	#"link_categories": ROOM.CATEGORY.SCIENCE_LINKABLE,
	#
	#"name": "SCIENCE_DEPARTMENT",
	#"shortname": "SCIENCE_DEPARTMENT",
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Responsible for the acquisition and execution of research initiatives.",
#
	#"costs": {
		#"unlock": 1,
		#"purchase": 10,
	#},		
#
	#"requires_unlock": false,	
	#"own_limit": 1,
	#"required_staffing": [],
	#"required_energy": 1,
#}
#
#var SECURITY_DEPARTMENT:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.SECURITY_DEPARTMENT,		
	#"categories": [ROOM.CATEGORY.DEPARTMENT],
	#"link_categories": ROOM.CATEGORY.SECURITY_LINKABLE,
	#
	#"name": "SECURITY_DEPARTMENT",
	#"shortname": "RESEARCHER_ROOM",
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Responsible for sustaining site security and operational stability, with emphasis on personnel SAFETY and READINESS.",
	#
	#"costs": {
		#"unlock": 1,
		#"purchase": 10,
	#},		
	#
	#"requires_unlock": false,	
	#"own_limit": 1,
	#"required_staffing": [],
	#"required_energy": 1,
#}
#
#var ENGINEERING_DEPARTMENT:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.ENGINEERING_DEPARTMENT,		
	#"categories": [ROOM.CATEGORY.DEPARTMENT],
	#"link_categories": ROOM.CATEGORY.ENGINEERING_LINKABLE,
	#
	#"name": "ENGINEERING_DEPARTMENT",
	#"shortname": "ENGINEERING_DEPARTMENT",
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Attach other ENGINEERING rooms for utility.",
	#
	#"effect": {
		#"description": "Nearby rooms share the same bonuses applied to this room."
	#},
	#
	#"requires_unlock": true,	
	#"own_limit": 1,
	#"required_staffing": [],
	#"required_energy": 1,
	#
	#"costs": {
		#"unlock": 1,
		#"purchase": 10,
	#},		
	#
	#"passive_abilities": func() -> Array: 
		#return [
			#ABL_P.get_ability(ABL_P.REF.MTF_A),
			#ABL_P.get_ability(ABL_P.REF.MTF_B),
			#ABL_P.get_ability(ABL_P.REF.MTF_C),
			#ABL_P.get_ability(ABL_P.REF.MTF_D),
		#],
#}
#
#
#var MEDICAL_DEPARTMENT:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.MEDICAL_DEPARTMENT,
	#"categories": [ROOM.CATEGORY.DEPARTMENT],
	#"link_categories": ROOM.CATEGORY.MEDICAL_LINKABLE,
	#
	#"name": "MEDICAL_DEPARTMENT",
	#"shortname": "MEDICAL_DEPARTMENT",
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Attach other MEDICAL rooms for utility.",
#
	#"costs": {
		#"unlock": 1,
		#"purchase": 10,
	#},		
#
	#"requires_unlock": true,	
	#"own_limit": 1,
	#"required_staffing": [],
	#"required_energy": 1,
#}
#
#var ETHICS_DEPARTMENT:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.ETHICS_DEPARTMENT,
	#"categories": [ROOM.CATEGORY.DEPARTMENT],
	#"link_categories": ROOM.CATEGORY.ETHICS_LINKABLE,
	#
	#"name": "ETHICS_DEPARTMENT",
	#"shortname": "ETHICS_DEPARTMENT",
	#"img_src": "res://Media/rooms/ethics.png",
	#"description": "Attach other ETHICS rooms to oversee moral compliance and monitor questionable decisions.",
#
	#"costs": {
		#"unlock": 1,
		#"purchase": 10,
	#},		
#
	#"requires_unlock": true,	
	#"own_limit": 1,
	#"required_staffing": [],
	#"required_energy": 1,
#}
#
#var CONTAINMENT_CELL:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.STANDARD_CONTAINMENT_CELL,
	#"categories": [ROOM.CATEGORY.CONTAINMENT],
	#"link_categories": ROOM.CATEGORY.CONTAINMENT_LINKABLES,
	#
	#"name": "CONTAINMENT CELL",
	#"shortname": "C.CELL",
	#"img_src": "res://Media/rooms/ethics.png",
	#"description": "Attach other STANDARD_CONTAINMENT_CELL.",
	#"can_contain": true,
	#
	#"costs": {
		#"unlock": 1,
		#"purchase": 25,
	#},		
	#
	#"requires_unlock": false,	
	#"own_limit": 20,
	#"required_staffing": [],
	#"required_energy": 0,	
#}
##endregion

#
#region ENGINEERING linkables
#var ENGINEERING_LINK_1:Dictionary = {
	#"ref": ROOM.REF.ENGINEERING_LINK_1,
	#"categories": [ROOM.CATEGORY.ENGINEERING_LINKABLE],
	#"name": "HEATING",
	#"shortname": "HEATING",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Enables HEATING in the engineering tab.",
	#
	#"requires_unlock": false,
#}
#
#var ENGINEERING_LINK_2:Dictionary = {
	#"ref": ROOM.REF.ENGINEERING_LINK_2,
	#"categories": [ROOM.CATEGORY.ENGINEERING_LINKABLE],	
	#"name": "COOLING",
	#"shortname": "COOLING",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Enables COOLING in the engineering tab.",
	#
	#"requires_unlock": false,
#}
#
#var ENGINEERING_LINK_3:Dictionary = {
	#"ref": ROOM.REF.ENGINEERING_LINK_3,
	#"categories": [ROOM.CATEGORY.ENGINEERING_LINKABLE],
	#"name": "VENTILATION",
	#"shortname": "VENTILATION",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Enables VENTILATION in the engineering tab.",
	#
	#"requires_unlock": false,
#}
#
#var ENGINEERING_LINK_4:Dictionary = {
	#"ref": ROOM.REF.ENGINEERING_LINK_4,
	#"categories": [ROOM.CATEGORY.ENGINEERING_LINKABLE],	
	#"name": "SRA",
	#"shortname": "SRA",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Enables SRA in the engineering tab.",
#}
#
#var ENGINEERING_LINK_5:Dictionary = {
	#"ref": ROOM.REF.ENGINEERING_LINK_5,
	#"categories": [ROOM.CATEGORY.ENGINEERING_LINKABLE],	
	#"name": "Energy",
	#"shortname": "Energy",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Enables ENERGY in the engineering tab.",
#}
#
#var ENGINEERING_LINK_6:Dictionary = {
	#"ref": ROOM.REF.ENGINEERING_LINK_6,
	#"categories": [ROOM.CATEGORY.ENGINEERING_LINKABLE],	
	#"name": "Logistics",
	#"shortname": "Logistics",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Enables LOGISTICS in the engineering tab.",
#}
##endregion
#
##region SECURITY linkables
#var SECURITY_LINK_1:Dictionary = {
	#"ref": ROOM.REF.SECURITY_LINK_1,
	#"categories": [ROOM.CATEGORY.SECURITY_LINKABLE],
	#"name": "EMERGENCY BROADCAST ",
	#"shortname": "E.BROADCAST",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Enables HEATING in the engineering tab.",
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.SET_WARNING_MODE),
			#ABL.get_ability(ABL.REF.SET_DANGER_MODE, 1),
		#],				
#}
#
#var SECURITY_LINK_2:Dictionary = {
	#"ref": ROOM.REF.SECURITY_LINK_2,
	#"categories": [ROOM.CATEGORY.SECURITY_LINKABLE],
	#"name": "HIRE SECURITY",
	#"shortname": "HIRE",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Enables HEATING in the engineering tab.",
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.HIRE_SECURITY),
		#]
#}
#
#var SECURITY_LINK_3:Dictionary = {
	#"ref": ROOM.REF.SECURITY_LINK_3,
	#"categories": [ROOM.CATEGORY.SECURITY_LINKABLE],
	#"name": "SAFETY +",
	#"shortname": "SAFETY",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Enables SAFETY.",
	#"metrics": {
		#RESOURCE.METRICS.SAFETY: 1,
	#},		
#}
#
#var SECURITY_LINK_4:Dictionary = {
	#"ref": ROOM.REF.SECURITY_LINK_4,
	#"categories": [ROOM.CATEGORY.SECURITY_LINKABLE],
	#"name": "READINESS +",
	#"shortname": "READINESS",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Increases READINESS.",
	#"metrics": {
		#RESOURCE.METRICS.READINESS: 1,
	#},		
#}
##endregion
#
##region SCIENCE linkables
#var SCIENCE_LINK_1:Dictionary = {
	#"ref": ROOM.REF.SCIENCE_LINK_1,
	#"categories": [ROOM.CATEGORY.SCIENCE_LINKABLE],
	#"name": "ACADEMIC OUTREACH",
	#"shortname": "ACADEMIC OUTREACH",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Description goes here...",		
	#"effect": {
		#"description": "Converts any unused energy into SCIENCE.",
		#"func": func(_new_room_config:Dictionary, _item:Dictionary) -> Dictionary:
			## IMPLEMENT
			#return _new_room_config,
	#}
#}
#
#var SCIENCE_LINK_2:Dictionary = {
	#"ref": ROOM.REF.SCIENCE_LINK_2,
	#"categories": [ROOM.CATEGORY.SCIENCE_LINKABLE],
	#"name": "SCIENCE_LINK_2",
	#"shortname": "SCIENCE_LINK_2",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "...",
	#"currencies": {
		#RESOURCE.CURRENCY.SCIENCE: 1,
	#},	
#}
#
#var SCIENCE_LINK_3:Dictionary = {
	#"ref": ROOM.REF.SCIENCE_LINK_3,
	#"categories": [ROOM.CATEGORY.SCIENCE_LINKABLE],
	#"name": "SCIENCE_LINK_3",
	#"shortname": "SCIENCE_LINK_3",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "...",
	#"metrics": {
		#RESOURCE.METRICS.READINESS: 1
	#},		
#}
#
#var SCIENCE_LINK_4:Dictionary = {
	#"ref": ROOM.REF.SCIENCE_LINK_4,
	#"categories": [ROOM.CATEGORY.SCIENCE_LINKABLE],
	#"name": "RESEARCH & DEVELOPMENT",
	#"shortname": "R&D",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "...",
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.UNLOCK_FACILITIES),
		#]	
#}
##endregion
#
##region MEDICAL linkables
#var MEDICAL_LINK_1:Dictionary = {
	#"ref": ROOM.REF.MEDICAL_LINK_1,
	#"categories": [ROOM.CATEGORY.MEDICAL_LINKABLE],
	#"name": "MEDICAL_LINK_1",
	#"shortname": "MEDICAL_LINK_1",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "...",		
#}
#
#var MEDICAL_LINK_2:Dictionary = {
	#"ref": ROOM.REF.MEDICAL_LINK_2,
	#"categories": [ROOM.CATEGORY.MEDICAL_LINKABLE],
	#"name": "MEDICAL_LINK_2",
	#"shortname": "MEDICAL_LINK_2",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "..."
#}
#
#var MEDICAL_LINK_3:Dictionary = {
	#"ref": ROOM.REF.MEDICAL_LINK_3,
	#"categories": [ROOM.CATEGORY.MEDICAL_LINKABLE],
	#"name": "MEDICAL_LINK_3",
	#"shortname": "MEDICAL_LINK_3",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "...",
	#"metrics": {
		#RESOURCE.METRICS.MORALE: 1
	#},		
#}
#
#var MEDICAL_LINK_4:Dictionary = {
	#"ref": ROOM.REF.SCIENCE_LINK_4,
	#"categories": [ROOM.CATEGORY.MEDICAL_LINKABLE],
	#"name": "MEDICAL_LINK_4",
	#"shortname": "MEDICAL_LINK_4",	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "...",
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.ADD_TRAIT),
			#ABL.get_ability(ABL.REF.REMOVE_TRAIT, 1),
		#]	
#}
##endregion
#
##region LOGISTICS linkables
#var LOGISTICS_ROOM_1:Dictionary = {
	#"ref": ROOM.REF.LOGISTICS_ROOM_1,
	#"categories": [ROOM.CATEGORY.LOGISTICS_LINKABLE],
	#"name": "LOGISTICS_ROOM_1",
	#"shortname": "LOGISTICS_ROOM_1",
	#"img_src": "res://Media/rooms/storage.png",
	#"description": "Central Supply Depot – stores essential materials and equipment.",
#}
#
#var LOGISTICS_ROOM_2:Dictionary = {
	#"ref": ROOM.REF.LOGISTICS_ROOM_2,
	#"categories": [ROOM.CATEGORY.LOGISTICS_LINKABLE],
	#"name": "LOGISTICS_ROOM_2",
	#"shortname": "LOGISTICS_ROOM_2",
	#"img_src": "res://Media/rooms/vehicle_bay.png",
	#"description": "Transport Hub – coordinates vehicle fleets and rapid deployment.",
#}
#
#var LOGISTICS_ROOM_3:Dictionary = {
	#"ref": ROOM.REF.LOGISTICS_ROOM_3,
	#"categories": [ROOM.CATEGORY.LOGISTICS_LINKABLE],
	#"name": "LOGISTICS_ROOM_3",
	#"shortname": "LOGISTICS_ROOM_3",
	#"img_src": "res://Media/rooms/armory.png",
	#"description": "Armory Annex – maintains weapons and gear for response teams.",
	#"metrics": {
		#RESOURCE.METRICS.READINESS: 2
	#},
#}
#
#var LOGISTICS_ROOM_4:Dictionary = {
	#"ref": ROOM.REF.LOGISTICS_ROOM_4,
	#"categories": [ROOM.CATEGORY.LOGISTICS_LINKABLE],
	#"name": "LOGISTICS_ROOM_4",
	#"shortname": "LOGISTICS_ROOM_4",
	#"img_src": "res://Media/rooms/distribution_center.png",
	#"description": "Distribution Center – optimizes allocation of resources across the site.",
	#"abilities": func() -> Array:
		#return [
			##ABL.get_ability(ABL.REF.INCREASE_SUPPLY),
			##ABL.get_ability(ABL.REF.REDUCE_COST, 1),
		#]
#}
##endregion
#
##region ETHICS linkables
#var ETHICS_LINK_1:Dictionary = {
	#"ref": ROOM.REF.ETHICS_LINK_1,
	#"categories": [ROOM.CATEGORY.ETHICS_LINKABLE],
	#"name": "ETHICS_LINK_1",
	#"shortname": "ETHICS_LINK_1",
	#"img_src": "res://Media/rooms/council_chamber.png",
	#"description": "Council Hearing Room – formal space for deliberation and oversight.",
#}
#
#var ETHICS_LINK_2:Dictionary = {
	#"ref": ROOM.REF.ETHICS_LINK_2,
	#"categories": [ROOM.CATEGORY.ETHICS_LINKABLE],
	#"name": "ETHICS_LINK_2",
	#"shortname": "ETHICS_LINK_2",
	#"img_src": "res://Media/rooms/interview_room.png",
	#"description": "Interview Suite – used to question staff or D-Class on sensitive incidents.",
#}
#
#var ETHICS_LINK_3:Dictionary = {
	#"ref": ROOM.REF.ETHICS_LINK_3,
	#"categories": [ROOM.CATEGORY.ETHICS_LINKABLE],
	#"name": "ETHICS_LINK_3",
	#"shortname": "ETHICS_LINK_3",
	#"img_src": "res://Media/rooms/wellness_center.png",
	#"description": "Wellness Office – supports mental health and ensures humane conditions.",
	#"metrics": {
		#RESOURCE.METRICS.MORALE: 3
	#},
#}
#
#var ETHICS_LINK_4:Dictionary = {
	#"ref": ROOM.REF.ETHICS_LINK_4,
	#"categories": [ROOM.CATEGORY.ETHICS_LINKABLE],
	#"name": "ETHICS_LINK_4",
	#"shortname": "ETHICS_LINK_4",
	#"img_src": "res://Media/rooms/oversight_hub.png",
	#"description": "Oversight Hub – provides active monitoring of questionable operations.",
	#"abilities": func() -> Array:
		#return [
			##ABL.get_ability(ABL.REF.PREVENT_BREACH),
			##ABL.get_ability(ABL.REF.INCREASE_MORALE, 1),
		#]
#}
##endregion
#
##region CONTAINMENT linkables
#var CONTAINMENT_LINK_1:Dictionary = {
	#"ref": ROOM.REF.CONTAINMENT_LINK_1,
	#"categories": [ROOM.CATEGORY.CONTAINMENT_LINKABLES],
	#"name": "Observation Chamber",
	#"shortname": "OBSERVATION_CHAMBER",
	#"img_src": "res://Media/rooms/council_chamber.png",
	#"description": "Reinforced viewing area with one-way glass and monitoring equipment, allowing staff to observe the anomaly without direct exposure.",
#}
#
#var CONTAINMENT_LINK_2:Dictionary = {
	#"ref": ROOM.REF.CONTAINMENT_LINK_2,
	#"categories": [ROOM.CATEGORY.CONTAINMENT_LINKABLES],
	#"name": "Interview Suite",
	#"shortname": "INTERVIEW_SUITE",
	#"img_src": "res://Media/rooms/interview_room.png",
	#"description": "Secure, shielded room for controlled communication with anomalies. Built-in restraints and emergency shutdowns protect staff.",
#}
#
#var CONTAINMENT_LINK_3:Dictionary = {
	#"ref": ROOM.REF.CONTAINMENT_LINK_3,
	#"categories": [ROOM.CATEGORY.CONTAINMENT_LINKABLES],
	#"name": "Support Annex",
	#"shortname": "SUPPORT_ANNEX",
	#"img_src": "res://Media/rooms/wellness_center.png",
	#"description": "Provides quick access to life-support, sedation, or reinforcement systems tied to the containment cell.",
	#"metrics": {
		#RESOURCE.METRICS.SAFETY: 2
	#},
#}
#
#var CONTAINMENT_LINK_4:Dictionary = {
	#"ref": ROOM.REF.CONTAINMENT_LINK_4,
	#"categories": [ROOM.CATEGORY.CONTAINMENT_LINKABLES],
	#"name": "Control Hub",
	#"shortname": "CONTROL_HUB",
	#"img_src": "res://Media/rooms/oversight_hub.png",
	#"description": "Centralized controls for automated defenses, environmental systems, and failsafes. Operators can trigger countermeasures instantly.",
	#"abilities": func() -> Array:
		#return [
			##ABL.get_ability(ABL.REF.PREVENT_BREACH),
			##ABL.get_ability(ABL.REF.CONTAINMENT_STRENGTHEN, 1),
		#]
#}
##endregion
#
##region SPECIALS
## ------------------------------------------------------------------------------ SPECIALS
#var DIRECTORS_OFFICE:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.DIRECTORS_OFFICE,	
	#"name": "DIRECTORS OFFICE",
	#"shortname": "D.OFFICE",
	#"categories": [ROOM.CATEGORY.SPECIAL],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "The site directors office.",
	##"event_trigger": {
		##"ref": EVT.TYPE.DIRECTORS_OFFICE,
		##"day": 2
	##},
	## ------------------------------------------
#
	## ------------------------------------------
	#"own_limit": 1,	
	#"can_destroy": false,
	#"requires_unlock": false,		
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.ADMIN
	#],
	## ------------------------------------------
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"currencies": {
		#RESOURCE.CURRENCY.MONEY: 1,
		#RESOURCE.CURRENCY.SCIENCE: 1,
		#RESOURCE.CURRENCY.MATERIAL: 1,
		#RESOURCE.CURRENCY.CORE: 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------	
	#"metrics": {
		#RESOURCE.METRICS.MORALE: 0,
		#RESOURCE.METRICS.SAFETY: 0,
		#RESOURCE.METRICS.READINESS: 0
	#},	
	## ------------------------------------------	
	#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.TRIGGER_ONSITE_NUKE, 0)
		#],	
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
#
			#
		#],	
	## ------------------------------------------		
#}
#
#var HQ:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.HQ,		
	#"name": "HEADQUARTERS",
	#"shortname": "HQ",
	#"categories": [ROOM.CATEGORY.SPECIAL],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Base headquarters.",
		#
	## ------------------------------------------
	#"own_limit": 1,	
	#"can_destroy": false,
	#"requires_unlock": false,		
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.ADMIN
	#],
	## ------------------------------------------
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------	
	#"metrics": {
		#RESOURCE.METRICS.MORALE: 1,
		#RESOURCE.METRICS.SAFETY: 1,
		#RESOURCE.METRICS.READINESS: 1
	#},	
	## ------------------------------------------		
		#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.UNLOCK_FACILITIES),
			##ABL.get_ability(ABL.REF.HIRE_RESEARCHERS, 1),
			##ABL.get_ability(ABL.REF.PROMOTE_RESEARCHER, 2),
		#],	
	## ------------------------------------------
	#
	## ------------------------------------------
	##"passive_abilities": func() -> Array: 
		##return [
			##ABL_P.get_ability(ABL_P.REF.SUPPLY_SECURITY, 0),
			##ABL_P.get_ability(ABL_P.REF.SUPPLY_STAFF, 0),
			##ABL_P.get_ability(ABL_P.REF.SUPPLY_TECHNICIANS, 0),
			##ABL_P.get_ability(ABL_P.REF.SUPPLY_DCLASS, 0)
			##
		##],	
	## ------------------------------------------				
#}
#
##var HR_DEPARTMENT:Dictionary = {
	### ------------------------------------------
	##"ref": ROOM.REF.HR_DEPARTMENT,
	##"name": "HR DEPARTMENT",
	##"shortname": "HR",
	##"categories": [ROOM.CATEGORY.SPECIAL],
	##"img_src": "res://Media/rooms/research_lab.png",
	##"description": "A one-stop shop for recruitment.",
	### ------------------------------------------
##
	### ------------------------------------------
	##"own_limit": 1,	
	##"required_staffing": [
		##RESEARCHER.SPECIALIZATION.ADMIN
	##],
	### ------------------------------------------
	##
	### ------------------------------------------
	##"costs": {
		##"unlock": 1,
		##"purchase": 1,
	##},
	### ------------------------------------------
	##
	### ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
			##ABL.get_ability(ABL.REF.HIRE_RESEARCHERS),
			##ABL.get_ability(ABL.REF.HIRE_ADMIN),
			##ABL.get_ability(ABL.REF.HIRE_SECURITY),
			##ABL.get_ability(ABL.REF.HIRE_DCLASS),
		##],		
##}
#
#var OPERATIONS_SUPPORT:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.OPERATIONS_SUPPORT,
	#"name": "OPERATIONS_SUPPORT",
	#"shortname": "OP.SUPPORT",
	#"categories": [ROOM.CATEGORY.SPECIAL],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Can recruit additional specilized personnel.",
	## ------------------------------------------
#
	## ------------------------------------------
	#"own_limit": 1,	
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER, 
		#RESEARCHER.SPECIALIZATION.SECURITY, 
		#RESEARCHER.SPECIALIZATION.ADMIN
	#],
	## ------------------------------------------
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
#
		#],	
	## ------------------------------------------	
#}
#
#var GENERATOR_SUBSTATION:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.GENERATOR_SUBSTATION,
	#"name": "GENERATOR_SUBSTATION",
	#"shortname": "GEN.SUBSTAITON",
	#"categories": [ROOM.CATEGORY.SPECIAL],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Can make adjustments to the power generator.",
	## ------------------------------------------
#
	## ------------------------------------------
	#"own_limit": 1,	
	#"requires_unlock": false,
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER, 
		#RESEARCHER.SPECIALIZATION.SECURITY, 
		#RESEARCHER.SPECIALIZATION.ADMIN
	#],
	## ------------------------------------------
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
#
		#],	
	## ------------------------------------------	
#}
#
#var	PROBABILITY_ROOM:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.PROBABILITY_ROOM,
	#"name": "PROBABILITY_ROOM",
	#"shortname": "PROBABILITY_ROOM",
	#"categories": [ROOM.CATEGORY.SPECIAL],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "PROBABILITY_ROOM description",
	## ------------------------------------------
#
	## ------------------------------------------
	#"own_limit": 1,	
	#"requires_unlock": false,
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER, 
		#RESEARCHER.SPECIALIZATION.SECURITY, 
		#RESEARCHER.SPECIALIZATION.ADMIN
	#],
	## ------------------------------------------
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
#
		#],	
	## ------------------------------------------	
#}
#
#var CHRONO_ROOM:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.CHRONO_ROOM,
	#"name": "CHRONO_ROOM",
	#"shortname": "CHRONO_ROOM",
	#"categories": [ROOM.CATEGORY.SPECIAL],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "CHRONO_ROOM description.",
	## ------------------------------------------
#
	## ------------------------------------------
	#"own_limit": 1,	
	#"requires_unlock": false,
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER, 
		#RESEARCHER.SPECIALIZATION.SECURITY, 
		#RESEARCHER.SPECIALIZATION.ADMIN
	#],
	## ------------------------------------------
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
#
		#],	
	## ------------------------------------------	
#}
#
#var NUCLEAR_FAILSAFE:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.GENERATOR_SUBSTATION,
	#"name": "NUCLEAR_FAILSAFE",
	#"shortname": "NUKEFAILSAFE",
	#"categories": [ROOM.CATEGORY.SPECIAL],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "NUCLEAR_FAILSAFE description",
	## ------------------------------------------
#
	## ------------------------------------------
	#"own_limit": 1,	
	#"requires_unlock": false,
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.ADMIN
	#],
	## ------------------------------------------
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 0,
		#"purchase": 0,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.CANCEL_NUCLEAR_DETONATION)
		#],	
	## ------------------------------------------	
#}
## ------------------------------------------------------------------------------ 
##endregion
#
##region RECRUITMENT
## ------------------------------------------------------------------------------ RECRUITMENT
#var PRISONER_BLOCK:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.PRISONER_BLOCK,	
	#"name": "PRISONER BLOCK",
	#"shortname": "P.BLOCK",
	#"categories": [ROOM.CATEGORY.RECRUITMENT],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "A prisoner block designed specifically to house D-Class personel.",
	## ------------------------------------------
#
	## ------------------------------------------
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.SECURITY, 
		#RESEARCHER.SPECIALIZATION.RESEARCHER
	#],	
	## ------------------------------------------
	#
	## ------------------------------------------
	#"personnel_capacity": {
		#RESEARCHER.SPECIALIZATION.DCLASS: 5, 
	#},	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.HIRE_DCLASS),
		#],		
	## ------------------------------------------
#}
#
#var ADMIN_OFFICE:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.ADMIN_OFFICE,	
	#"name": "ADMIN OFFICE",
	#"shortname": "A.OFFICE",
	#"categories": [ROOM.CATEGORY.RECRUITMENT],
	#"link_categories": ROOM.CATEGORY.ADMIN,	
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Allows the use of administrative functions.",
	## ------------------------------------------
#
	## ------------------------------------------
	#"own_limit": 10,	
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.HIRE_ADMIN),
		#],		
	## ------------------------------------------
#}
#
##var SECURITY_DEPARTMENT:Dictionary = {
	### ------------------------------------------
	##"ref": ROOM.REF.SECURITY_DEPARTMENT,
	##"name": "SECURITY DEPARTMENT",
	##"shortname": "SEC.DPT",
	##"categories": [ROOM.CATEGORY.RECRUITMENT],
	##"img_src": "res://Media/rooms/research_lab.png",
	##"description": "Supplies security.",
	### ------------------------------------------
	##
	### ------------------------------------------
	##"required_staffing": [
		##RESEARCHER.SPECIALIZATION.SECURITY, 
		##RESEARCHER.SPECIALIZATION.ADMIN
	##],	
	### ------------------------------------------	
##
	### ------------------------------------------
	##"costs": {
		##"unlock": 1,
		##"purchase": 1,
	##},
	### ------------------------------------------
	##
	### ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
			##ABL.get_ability(ABL.REF.HIRE_SECURITY),
		##],		
	### ------------------------------------------
##}
#
#var ACADEMIC_OUTREACH:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.ACADEMIC_OUTREACH,
	#"name": "ACADEMIC OUTREACH",
	#"shortname": "ACA OUTREACH",
	#"categories": [ROOM.CATEGORY.RECRUITMENT],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Supplies security.",
	## ------------------------------------------
	#
	## ------------------------------------------
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER, 
		#RESEARCHER.SPECIALIZATION.ADMIN
	#],	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.HIRE_RESEARCHERS),
		#],		
	## ------------------------------------------
#}
#
#var MTF_BARRICKS:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.MTF_BARRICKS,
	#"name": "MTF_BARRICKS",
	#"shortname": "MTF_BARRICKS",
	#"categories": [ROOM.CATEGORY.RECRUITMENT],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Trains and houses specialized Mobile Taskforce Teams (MTF).",
	## ------------------------------------------
	#
	## ------------------------------------------
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.ADMIN,		
		#RESEARCHER.SPECIALIZATION.SECURITY, 
		#RESEARCHER.SPECIALIZATION.SECURITY, 
	#],	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
			#ABL_P.get_ability(ABL_P.REF.MTF_A),
			#ABL_P.get_ability(ABL_P.REF.MTF_B),			
			#ABL_P.get_ability(ABL_P.REF.MTF_C),			
			#ABL_P.get_ability(ABL_P.REF.MTF_D),			
		#],		
	## ------------------------------------------
#}
#
#
#var MINIERAL_MINING:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.MINIERAL_MINING,
	#"name": "MINERAL MINING",
	#"shortname": "MIN.MINING",
	#"categories": [ROOM.CATEGORY.SPECIAL],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Mines minerals which can be converted to other resources, can only be placed on the bottom floor.",
	## ------------------------------------------
	#
	## ------------------------------------------
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER, 
		#RESEARCHER.SPECIALIZATION.ADMIN
	#],	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#
		#],		
	## ------------------------------------------
#}
#
#var GEOTHERMAL_POWER:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.GEOTHERMAL_POWER,
	#"name": "GEOTHERMAL POWER",
	#"shortname": "GEO.POWER",
	#"categories": [ROOM.CATEGORY.SPECIAL],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Mines minerals which can be converted to other resources, can only be placed on the bottom floor.",
	## ------------------------------------------
	#
	## ------------------------------------------
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER, 
		#RESEARCHER.SPECIALIZATION.ADMIN
	#],	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#
		#],		
	## ------------------------------------------
#}
## ------------------------------------------------------------------------------ 
##endregion
#
##region CONTAINMENT
## ------------------------------------------------------------------------------ CONTAINMENTS
##var STANDARD_CONTAINMENT_CELL:Dictionary = {
	### ------------------------------------------
	##"ref": ROOM.REF.STANDARD_CONTAINMENT_CELL,		
	##"name": "STANDARD CONTAINMENT",
	##"shortname": "S.CONTAINMENT",
	##"categories": [ROOM.CATEGORY.DEPARTMENT],
	##"img_src": "res://Media/rooms/research_lab.png",
	##"description": "Containment cell used to house anamolous objects.",
		##
	### ------------------------------------------
	##"requires_unlock": false,
	##"can_contain": true,
	##"can_destroy": false,
	##"containment_properties": [
		##SCP.CONTAINMENT_TYPES.PHYSICAL
	##],
	##"required_staffing": [
		##RESEARCHER.SPECIALIZATION.RESEARCHER, 
		##RESEARCHER.SPECIALIZATION.SECURITY
	##],	
	### ------------------------------------------
##
	### ------------------------------------------
	##"costs": {
		##"unlock": 1,
		##"purchase": 1,
	##},
	### ------------------------------------------
		##
	### ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
##
		##],	
	### ------------------------------------------	
	##
	### ------------------------------------------
	##"passive_abilities": func() -> Array: 
		##return [
			##ABL_P.get_ability(ABL_P.REF.GENERATE_RESEARCH_FROM_SCP, 0),
			##ABL_P.get_ability(ABL_P.REF.GENERATE_MONEY_FROM_SCP, 1)
		##],	
	### ------------------------------------------			
##}
## ------------------------------------------------------------------------------ 
##endregion
#
##region RESOURCES
### ------------------------------------------------------------------------------ RESOURCES
##var MONEY_GEN_1:Dictionary = {
	### ------------------------------------------
	##"ref": ROOM.REF.MONEY_GEN_1,	
	##"name": "ECONOMIC RECLIMATION DIVISION",
	##"shortname": "ECO DIV",
	##"categories": [ROOM.CATEGORY.RESOURCES],	
	##"img_src": "res://Media/rooms/research_lab.png",
	##"description": "A covert unit used to sustain Foundation operations through unofficial financial channels.",
	### ------------------------------------------
##
	### ------------------------------------------
	##"required_staffing": [
		##RESEARCHER.SPECIALIZATION.RESEARCHER, 
		##RESEARCHER.SPECIALIZATION.ADMIN
	##],	
	##"costs": {
		##"unlock": 1,
		##"purchase": 1,
	##},
	##"currencies": {
		##RESOURCE.CURRENCY.MONEY: 1,
		##RESOURCE.CURRENCY.MATERIAL: 0,
		##RESOURCE.CURRENCY.SCIENCE: 0,
		##RESOURCE.CURRENCY.CORE: 0,
	##},	
	### ------------------------------------------
		##
	### ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
			##ABL.get_ability(ABL.REF.INSTANT_MONEY_LVL_1),
			##ABL.get_ability(ABL.REF.INSTANT_SCIENCE_LVL_1, 1),
		##],	
			##
	##"passive_abilities": func() -> Array: 
		##return [
			##ABL_P.get_ability(ABL_P.REF.GENERATE_MONEY_LVL_1, 0),
		##],	
	### ------------------------------------------		
##}
##
##var MONEY_GEN_2:Dictionary = {
	### ------------------------------------------
	##"ref": ROOM.REF.MONEY_GEN_2,	
	##"name": "MONEY_GEN_2",
	##"shortname": "MONEY_GEN_2",
	##"categories": [ROOM.CATEGORY.RESOURCES],	
	##"img_src": "res://Media/rooms/research_lab.png",
	##"description": "+50 MONEY when placed adjacent to other MONEY_GEN_2.",
	### ------------------------------------------
##
	### ------------------------------------------
	##"required_staffing": [
		##RESEARCHER.SPECIALIZATION.RESEARCHER, 
		##RESEARCHER.SPECIALIZATION.ADMIN
	##],	
	##"costs": {
		##"unlock": 1,
		##"purchase": 1,
	##},
	##"currencies": {
		##RESOURCE.CURRENCY.MONEY: 2,
		##RESOURCE.CURRENCY.MATERIAL: 0,
		##RESOURCE.CURRENCY.SCIENCE: 0,
		##RESOURCE.CURRENCY.CORE: 0,
	##},		
	### ------------------------------------------
		##
	### ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
			##ABL.get_ability(ABL.REF.INSTANT_MONEY_LVL_1, 1),
		##],	
			##
	##"passive_abilities": func() -> Array: 
		##return [
			##ABL_P.get_ability(ABL_P.REF.GENERATE_MONEY_LVL_1),
		##],	
	### ------------------------------------------		
##}
##
##var RESEARCH_GEN_1:Dictionary = {
	### ------------------------------------------
	##"ref": ROOM.REF.RESEARCH_GEN_1,	
	##"name": "RESEARCH LAB",
	##"shortname": "R.LAB",
	##"categories": [ROOM.CATEGORY.RESOURCES],	
	##"img_src": "res://Media/rooms/research_lab.png",
	##"description": "A covert unit used to sustain Foundation operations through unofficial financial channels.",
	### ------------------------------------------
##
	### ------------------------------------------
	##"required_staffing": [
		##RESEARCHER.SPECIALIZATION.RESEARCHER, 
		##RESEARCHER.SPECIALIZATION.RESEARCHER
	##],
	##"costs": {
		##"unlock": 1,
		##"purchase": 1,
	##},
	##"currencies": {
		##RESOURCE.CURRENCY.MONEY: 0,
		##RESOURCE.CURRENCY.MATERIAL: 0,
		##RESOURCE.CURRENCY.SCIENCE: 1,
		##RESOURCE.CURRENCY.CORE: 0,
	##},	
	### ------------------------------------------
		##
	### ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
			##ABL.get_ability(ABL.REF.INSTANT_SCIENCE_LVL_1, 1),
		##],	
			##
	##"passive_abilities": func() -> Array: 
		##return [
			##ABL_P.get_ability(ABL_P.REF.GENERATE_SCIENCE_LVL_1),
		##],	
	### ------------------------------------------		
##}
##
##var RESEARCH_GEN_2:Dictionary = {
	### ------------------------------------------
	##"ref": ROOM.REF.RESEARCH_GEN_2,	
	##"name": "RESEARCH_GEN_2",
	##"shortname": "RESEARCH_GEN_2",
	##"categories": [ROOM.CATEGORY.RESOURCES],	
	##"img_src": "res://Media/rooms/research_lab.png",
	##"description": "+25 RESEARCH when placed adjacent to other RESEARCH_GEN_2.",
	### ------------------------------------------
##
	### ------------------------------------------
	##"required_staffing": [
		##RESEARCHER.SPECIALIZATION.RESEARCHER, 
		##RESEARCHER.SPECIALIZATION.ADMIN
	##],	
	##"costs": {
		##"unlock": 1,
		##"purchase": 1,
	##},
	##"currencies": {
		##RESOURCE.CURRENCY.MONEY: 0,
		##RESOURCE.CURRENCY.MATERIAL: 0,
		##RESOURCE.CURRENCY.SCIENCE: 1,
		##RESOURCE.CURRENCY.CORE: 0,
	##},		
	### ------------------------------------------
		##
	### ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
			##
		##],	
			##
	##"passive_abilities": func() -> Array: 
		##return [
			##
		##],	
	### ------------------------------------------		
##}
##
##var MATERIAL_GEN_1:Dictionary = {
	### ------------------------------------------
	##"ref": ROOM.REF.MATERIAL_GEN_1,
	##"name": "ENGINEERING BAY",
	##"shortname": "ENG.BAY",
	##"categories": [ROOM.CATEGORY.RESOURCES],
	##"img_src": "res://Media/rooms/research_lab.png",
	##"description": "Utilize technicians to increase safety and readiness.",
	### ------------------------------------------
	##
	### ------------------------------------------
	##"required_staffing": [
		##RESEARCHER.SPECIALIZATION.RESEARCHER
	##],	
	##"costs": {
		##"unlock": 1,
		##"purchase": 1,
	##},
	##"currencies": {
		##RESOURCE.CURRENCY.MONEY: 0,
		##RESOURCE.CURRENCY.MATERIAL: 1,
		##RESOURCE.CURRENCY.SCIENCE: 0,
		##RESOURCE.CURRENCY.CORE: 0,
	##},	
	### ------------------------------------------
	##
	### ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
			##ABL.get_ability(ABL.REF.INSTANT_MATERIAL_LVL_1, 1),
		##],	
			##
	##"passive_abilities": func() -> Array: 
		##return [
			##ABL_P.get_ability(ABL_P.REF.GENERATE_MATERIAL_LVL_1),
		##],	
	### ------------------------------------------		
##}
##
##var MATERIAL_GEN_2:Dictionary = {
	### ------------------------------------------
	##"ref": ROOM.REF.MATERIAL_GEN_2,	
	##"name": "MATERIAL_GEN_2",
	##"shortname": "MATERIAL_GEN_2",
	##"categories": [ROOM.CATEGORY.RESOURCES],	
	##"img_src": "res://Media/rooms/research_lab.png",
	##"description": "+10 MATERIAL when placed adjacent to other MATERIAL_GEN_2.",
	### ------------------------------------------
##
	### ------------------------------------------
	##"required_staffing": [
		##RESEARCHER.SPECIALIZATION.RESEARCHER, 
		##RESEARCHER.SPECIALIZATION.ADMIN
	##],	
	##"costs": {
		##"unlock": 1,
		##"purchase": 1,
	##},
	##"currencies": {
		##RESOURCE.CURRENCY.MONEY: 0,
		##RESOURCE.CURRENCY.MATERIAL: 2,
		##RESOURCE.CURRENCY.SCIENCE: 0,
		##RESOURCE.CURRENCY.CORE: 0,
	##},		
	### ------------------------------------------
		##
	### ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
			##
		##],	
			##
	##"passive_abilities": func() -> Array: 
		##return [
			##
		##],	
	### ------------------------------------------		
##}
##
##
##var CORE_GEN_1:Dictionary = {
	### ------------------------------------------
	##"ref": ROOM.REF.CORE_GEN_1,
	##"name": "CORE_ROOM",
	##"shortname": "CORE_ROOM",
	##"categories": [ROOM.CATEGORY.RESOURCES],
	##"img_src": "res://Media/rooms/research_lab.png",
	##"description": "CORE_ROOM description.",
	### ------------------------------------------
	##
	### ------------------------------------------
	##"required_staffing": [
		##RESEARCHER.SPECIALIZATION.RESEARCHER
	##],	
	##"costs": {
		##"unlock": 1,
		##"purchase": 1,
	##},
	##"currencies": {
		##RESOURCE.CURRENCY.MONEY: 0,
		##RESOURCE.CURRENCY.MATERIAL: 0,
		##RESOURCE.CURRENCY.SCIENCE: 0,
		##RESOURCE.CURRENCY.CORE: 1,
	##},	
	### ------------------------------------------
	##
	### ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
			##ABL.get_ability(ABL.REF.INSTANT_CORE_LVL_1, 1),
		##],	
			##
	##"passive_abilities": func() -> Array: 
		##return [
			##ABL_P.get_ability(ABL_P.REF.GENERATE_CORE_LVL_1),
		##],	
	### ------------------------------------------		
##}
##
##var CORE_GEN_2:Dictionary = {
	### ------------------------------------------
	##"ref": ROOM.REF.CORE_GEN_2,	
	##"name": "CORE_GEN_2",
	##"shortname": "CORE_GEN_2",
	##"categories": [ROOM.CATEGORY.RESOURCES],	
	##"img_src": "res://Media/rooms/research_lab.png",
	##"description": "+1 CORE when placed adjacent to other CORE_GEN_2.",
	### ------------------------------------------
##
	### ------------------------------------------
	##"required_staffing": [
		##RESEARCHER.SPECIALIZATION.RESEARCHER, 
		##RESEARCHER.SPECIALIZATION.ADMIN
	##],	
	##"costs": {
		##"unlock": 1,
		##"purchase": 1,
	##},
	##"currencies": {
		##RESOURCE.CURRENCY.MONEY: 0,
		##RESOURCE.CURRENCY.MATERIAL: 0,
		##RESOURCE.CURRENCY.SCIENCE: 0,
		##RESOURCE.CURRENCY.CORE: 2,
	##},		
	### ------------------------------------------
		##
	### ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
			##
		##],	
			##
	##"passive_abilities": func() -> Array: 
		##return [
			##
		##],	
	### ------------------------------------------		
##}
##
##var MONEY_CONVERTER:Dictionary = {
	### ------------------------------------------
	##"ref": ROOM.REF.MONEY_CONVERTER,	
	##"name": "MONEY_CONVERTER",
	##"shortname": "MONEY_CONVERTER",
	##"categories": [ROOM.CATEGORY.RESOURCES],	
	##"img_src": "res://Media/rooms/research_lab.png",
	##"description": "Convert MONEY into other resources.",
	### ------------------------------------------
##
	### ------------------------------------------
	##"required_staffing": [
		##RESEARCHER.SPECIALIZATION.RESEARCHER, 
		##RESEARCHER.SPECIALIZATION.ADMIN
	##],	
	### ------------------------------------------
##
	### ------------------------------------------
	##"costs": {
		##"unlock": 1,
		##"purchase": 1,
	##},
	### ------------------------------------------
		##
	### ------------------------------------------
	##"abilities": func() -> Array: 
		##return [
			##ABL.get_ability(ABL.REF.CONVERT_MONEY_INTO_SCIENCE),
			##ABL.get_ability(ABL.REF.CONVERT_MONEY_INTO_MATERIAL),
			##ABL.get_ability(ABL.REF.CONVERT_MONEY_INTO_CORE),
		##],	
	### ------------------------------------------		
##}
## ------------------------------------------------------------------------------ 
##endregion
#
##region ENERGY
#var ENERGY_CAPACITOR_1:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.ENERGY_CAPACITOR_1,
	#"name": "ENERGY_CAPACITOR_1",
	#"shortname": "E.CAPACITOR_1",
	#"categories": [ROOM.CATEGORY.ENERGY],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Increases energy for the entire wing by 5.",
	## ------------------------------------------
	#
	## ------------------------------------------
	#"requires_unlock": false,	
	#"required_energy": 0,
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER
	#],	
	#"own_limit": 10,	
	## ------------------------------------------	
	#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
#
	## ------------------------------------------
	#"effect": {
		#"description": "Adds +5 available energy to the wing.",
		#"func": func(_new_room_config:Dictionary, _item:Dictionary) -> Dictionary:
			#var floor:int = _item.location.floor
			#var ring:int = _item.location.ring
			#var room:int = _item.location.room
			#var ring_config_data:Dictionary = _new_room_config.floor[floor].ring[ring]
			#_new_room_config.floor[floor].ring[ring].energy.available += 5
			#return _new_room_config,
	#},
	## ------------------------------------------
	#
#}
#
#var ENERGY_CAPACITOR_2:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.ENERGY_CAPACITOR_2,
	#"name": "ENERGY_CAPACITOR_2",
	#"shortname": "E.CAPACITOR_2",
	#"categories": [ROOM.CATEGORY.ENERGY],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Increases energy for the entire wing by 10.",
	## ------------------------------------------
	#
	## ------------------------------------------
	#"requires_unlock": false,	
	#"required_energy": 0,
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER
	#],	
	#"own_limit": 10,	
	## ------------------------------------------	
	#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
#
	## ------------------------------------------
	#"effect": {
		#"description": "Adds +10 available energy to the wing.",
		#"func": func(_new_room_config:Dictionary, _item:Dictionary) -> Dictionary:
			#var floor:int = _item.location.floor
			#var ring:int = _item.location.ring
			#var room:int = _item.location.room
			#var ring_config_data:Dictionary = _new_room_config.floor[floor].ring[ring]
			#_new_room_config.floor[floor].ring[ring].energy.available += 10
			#return _new_room_config,
	#},
	## ------------------------------------------
#}
#
#var ENERGY_CAPACITOR_3:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.ENERGY_CAPACITOR_3,
	#"name": "ENERGY_CAP3ACITOR_3",
	#"shortname": "E.CAPACITOR_3",
	#"categories": [ROOM.CATEGORY.ENERGY],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Increases energy for the entire wing by 15.",
	## ------------------------------------------
	#
	## ------------------------------------------
	#"requires_unlock": false,	
	#"required_energy": 0,
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER
	#],	
	#"own_limit": 10,	
	## ------------------------------------------	
	#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
#
	## ------------------------------------------
	#"effect": {
		#"description": "Adds +15 available energy to the wing.",
		#"func": func(_new_room_config:Dictionary, _item:Dictionary) -> Dictionary:
			#var floor:int = _item.location.floor
			#var ring:int = _item.location.ring
			#var room:int = _item.location.room
			#var ring_config_data:Dictionary = _new_room_config.floor[floor].ring[ring]
			#_new_room_config.floor[floor].ring[ring].energy.available += 15
			#return _new_room_config,
	#},
	## ------------------------------------------
#}
#
#
#var ENERGY_SYPHON:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.ENERGY_SYPHON,
	#"name": "ENERGY_SYPHON",
	#"shortname": "E.SYPHON",
	#"categories": [ROOM.CATEGORY.ENERGY],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Any unused energy from the corresponding wing is available for this wing.  (0 <- 1, 1 <- 2, etc)",	
	## ------------------------------------------
	#
	## ------------------------------------------
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER
	#],	
	## ------------------------------------------	
	#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"effect": {
		#"description": "Syphons unused energy from neighboring wings.",
		#"after_func": func(_new_room_config:Dictionary, _item:Dictionary) -> Dictionary:
			#var floor:int = _item.location.floor
			#var ring:int = _item.location.ring
			#var room:int = _item.location.room
			#var ring_config_data:Dictionary = _new_room_config.floor[floor].ring[ring]
			#var adjacent_ring:int = U.min_max(ring + 1, 0, 3, true)
			#var adjacent_energy:Dictionary = _new_room_config.floor[floor].ring[adjacent_ring].energy
			#var syphon_amount:int = adjacent_energy.available - adjacent_energy.used
#
			#_new_room_config.floor[floor].ring[adjacent_ring].energy.available = adjacent_energy.used
			#_new_room_config.floor[floor].ring[ring].energy.available += syphon_amount
			#return _new_room_config,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
			#
		#],	
	## ------------------------------------------	
#}
## ------------------------------------------------------------------------------ 
##endregion
#
##region UTILITY
## ------------------------------------------------------------------------------ UTILITY
#var UI_ASSIST:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.UI_ASSIST,
	#"name": "UI_ASSIST",
	#"shortname": "UI.ASSIST",
	#"categories": [ROOM.CATEGORY.SPECIAL],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Containment breaches are less likely to occur, however...",	
	## ------------------------------------------
#
	## ------------------------------------------
	#"own_limit": 1,	
	#"requires_unlock": false,
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.ADMIN
	#],	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
			##ABL_P.get_ability(ABL_P.REF.PREDICTIVE_TIMELINE),
			##ABL_P.get_ability(ABL_P.REF.OBJECTIVE_ASSIST),
		#],	
	## ------------------------------------------	
#}
#
#var STAFF_ROOM:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.STAFF_ROOM,
	#"name": "STAFF ROOM",
	#"shortname": "STF ROOM",
	#"categories": [ROOM.CATEGORY.UTILITY],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Increases MORALE while offering optional team-bonding experiences.",
	## ------------------------------------------
	#
	## ------------------------------------------
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER
	#],	
	## ------------------------------------------
		#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"metrics": {
		#RESOURCE.METRICS.MORALE: 1,
	#},	
	## ------------------------------------------
	#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#ABL.get_ability(ABL.REF.HAPPY_HOUR),
			#ABL.get_ability(ABL.REF.UNHAPPY_HOUR),
		#],	
	## ------------------------------------------	
#}
#
#var CAFETERIA:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.CAFETERIA,
	#"name": "CAFETERIA",
	#"shortname": "CAFETERIA",
	#"categories": [ROOM.CATEGORY.UTILITY],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Increases READINESS and...",
	## ------------------------------------------
	#
	## ------------------------------------------
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER
	#],	
	## ------------------------------------------
		#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"metrics": {
		#RESOURCE.METRICS.READINESS: 1,
	#},	
	## ------------------------------------------
	#
	## ------------------------------------------
	#"abilities": func() -> Array: 
		#return [
			#
		#],	
	## ------------------------------------------	
#}
#
#var WEAPONS_RANGE:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.WEAPONS_RANGE,
	#"name": "WEAPONS RANGE",
	#"shortname": "W.RANGE",
	#"categories": [ROOM.CATEGORY.UTILITY],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Increases security and provides training.",	
	## ------------------------------------------
#
	## ------------------------------------------
	#"unlock_level": 1,		
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.SECURITY
	#],	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
			##ABL_P.get_ability(ABL_P.REF.FIREARM_TRAINING),
			##ABL_P.get_ability(ABL_P.REF.HEAVY_WEAPONS_TRAINING, 1)
		#],	
	## ------------------------------------------	
#}
#
#var SCRANTON_REALITY_ANCHOR:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.SCRANTON_REALITY_ANCHOR,
	#"name": "SCRANTON REALITY ANCHOR",
	#"shortname": "SRA",
	#"categories": [ROOM.CATEGORY.UTILITY],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "Containment breaches are less likely to occur, but are expensive and fault prone.",	
	## ------------------------------------------
#
	## ------------------------------------------
	#"unlock_level": 1,		
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER,
		#RESEARCHER.SPECIALIZATION.SECURITY
	#],	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
#
		#],	
	## ------------------------------------------	
#}
#
#var HP_CLINIC:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.HP_CLINIC,
	#"name": "HP_CLINIC",
	#"shortname": "HP_CLINIC",
	#"categories": [ROOM.CATEGORY.UTILITY],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "HP_CLINIC description",	
	## ------------------------------------------
#
	## ------------------------------------------
	#"unlock_level": 1,		
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER
	#],	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
#
		#],	
	## ------------------------------------------	
#}
#
#var SP_CLINIC:Dictionary = {
	## ------------------------------------------
	#"ref": ROOM.REF.SP_CLINIC,
	#"name": "SP_CLINIC",
	#"shortname": "SRA",
	#"categories": [ROOM.CATEGORY.UTILITY],
	#"img_src": "res://Media/rooms/research_lab.png",
	#"description": "SP_CLINIC description",	
	## ------------------------------------------
#
	## ------------------------------------------
	#"unlock_level": 1,		
	#"required_staffing": [
		#RESEARCHER.SPECIALIZATION.RESEARCHER
	#],	
	## ------------------------------------------	
#
	## ------------------------------------------
	#"costs": {
		#"unlock": 1,
		#"purchase": 1,
	#},
	## ------------------------------------------
	#
	## ------------------------------------------
	#"passive_abilities": func() -> Array: 
		#return [
#
		#],	
	## ------------------------------------------	
#}


# ------------------------------------------------------------------------------ 
#endregion


# -----------------------------------	
var list:Array[Dictionary] = [
	DEBUG_ROOM,
	# ADMIN ROOMS
	ADMIN_DEPARTMENT, ADMIN_BRANCH,
	ADMIN_ROOM_1, ADMIN_ROOM_2, ADMIN_ROOM_3, ADMIN_ROOM_4, ADMIN_ROOM_5,
	ADMIN_ROOM_6, ADMIN_ROOM_7, ADMIN_ROOM_8, ADMIN_ROOM_9, ADMIN_ROOM_10,
	
	# LOGISTICS
	LOGISTICS_DEPARTMENT, LOGISTICS_BRANCH,
	LOGISTICS_ROOM_1, LOGISTICS_ROOM_2, LOGISTICS_ROOM_3, LOGISTICS_ROOM_4, LOGISTICS_ROOM_5,
	LOGISTICS_ROOM_6, LOGISTICS_ROOM_7, LOGISTICS_ROOM_8, LOGISTICS_ROOM_9, LOGISTICS_ROOM_10,
	
	# ENGINEERING
	ENGINEERING_DEPARTMENT, ENGINEERING_BRANCH,
	ENG_ROOM_1, ENG_ROOM_2, ENG_ROOM_3, ENG_ROOM_4, ENG_ROOM_5,
	ENG_ROOM_6, ENG_ROOM_7, ENG_ROOM_8, ENG_ROOM_9, ENG_ROOM_10,
	
	## --------------	ENGINEERING ROOMS
	#ENGINEERING_DEPARTMENT, 
	#ENGINEERING_LINK_1, ENGINEERING_LINK_2, ENGINEERING_LINK_3, ENGINEERING_LINK_4, ENGINEERING_LINK_5, ENGINEERING_LINK_6,
	#
	#SECURITY_DEPARTMENT, SCIENCE_DEPARTMENT, MEDICAL_DEPARTMENT, ETHICS_DEPARTMENT, LOGISTICS_DEPARTMENT,
	#CONTAINMENT_CELL,
	#
	## --------------	ENGINEERING ROOMS
#
	## ---------------	ENGINEERING LINKABLES
	#SECURITY_LINK_1, SECURITY_LINK_2, SECURITY_LINK_3, SECURITY_LINK_4,
	## ---------------	SCIENCE LINKABLES
	#SCIENCE_LINK_1, SCIENCE_LINK_2, SCIENCE_LINK_3, SCIENCE_LINK_4,
	## ---------------	MEDICAL LINKABLES
	#MEDICAL_LINK_1, MEDICAL_LINK_2, MEDICAL_LINK_3, MEDICAL_LINK_4,
	## ---------------	LOGISTICS LINKABLES
	#LOGISTICS_ROOM_1, LOGISTICS_ROOM_2, LOGISTICS_ROOM_3, LOGISTICS_ROOM_4,	
	## ---------------	ETHICS LINKABLES
	#ETHICS_LINK_1, ETHICS_LINK_2, ETHICS_LINK_3, ETHICS_LINK_4,		
	## ---------------	CONTAINMENT
	#CONTAINMENT_LINK_1, CONTAINMENT_LINK_2, CONTAINMENT_LINK_3, CONTAINMENT_LINK_4,	
	#
	#
	## --------------- RECRUITMENT
	#PRISONER_BLOCK, OPERATIONS_SUPPORT, 
	#MTF_BARRICKS,
	#
	## --------------- ENERGY
	#ENERGY_CAPACITOR_1, 
	#ENERGY_CAPACITOR_2,
	#ENERGY_CAPACITOR_3,
	#
	#ENERGY_SYPHON,
	#
	## --------------- UTILITY
	#UI_ASSIST, WEAPONS_RANGE, SCRANTON_REALITY_ANCHOR,
	#HP_CLINIC, SP_CLINIC,
	#STAFF_ROOM, CAFETERIA
	
	
]
# -----------------------------------	
