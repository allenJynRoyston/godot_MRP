@tool
extends Node

enum AREA { THIS_ROOM, ADJACENT }
enum OPERATOR { ADD, SUBTRACT }
enum RESOURCE_TYPE { CURRENCY, METRIC, PERSONNEL }
enum DURATION {DAILY, WEEKLY}

enum REF {
	# -----------------  DEPARTMENTS
	DEBUG_DEPARTMENT,
	PROCUREMENT_DEPARTMENT,
	ADMIN_DEPARTMENT, 
	SCIENCE_DEPARTMENT,
	LOGISTICS_DEPARTMENT, 
	ENGINEERING_DEPARTMENT, 
	SECURITY_DEPARTMENT,
	ANTIMEMETICS_DEPARTMENT,
	THEOLOGY_DEPARTMENT,
	TEMPORAL_DEPARTMENT,
	MISCOMMUNICATION_DEPARTMENT,
	PATAPHYSICS_DEPARTMENT,
	
	# -----------------  CONTAINMENT_CELL
	CONTAINMENT_CELL,
	
	# -----------------  UTILITY
	UTIL_LEVEL_UP_1, UTIL_LEVEL_UP_2, UTIL_LEVEL_UP_3,
	UTIL_LEVEL_DOWN_1, UTIL_LEVEL_DOWN_2, UTIL_LEVEL_DOWN_3,
	UTIL_ADD_ENERGY_1, UTIL_ADD_ENERGY_2, UTIL_ADD_ENERGY_3,
	
	UTIL_ADD_CURRENCY_MONEY, UTIL_ADD_CURRENCY_MATERIAL, UTIL_ADD_CURRENCY_SCIENCE, UTIL_ADD_CURRENCY_CORE,
	UTIL_RMV_CURRENCY_MONEY, UTIL_RMV_CURRENCY_MATERIAL, UTIL_RMV_CURRENCY_SCIENCE, UTIL_RMV_CURRENCY_CORE,
	
	UTIL_ADD_METRIC_MORALE, UTIL_ADD_METRIC_SAFETY, UTIL_ADD_METRIC_READINESS,
	UTIL_RMV_METRIC_MORALE, UTIL_RMV_METRIC_SAFETY, UTIL_RMV_METRIC_READINESS,
	
	UTIL_DOUBLE_ECON_OUTPUT, UTIL_TRIPLE_ECON_OUTPUT, UTIL_HALF_ECON_OUTPUT, UTIL_ZERO_ECON_OUTPUT,
}

enum EMERGENCY_MODES { 
	NORMAL, 
	CAUTION, 
	LOCKDOWN, 
	DANGER 
}

enum CATEGORY {
	DEPARTMENT,
	BRANCH,
	CONTAINMENT, 
	
	PROCUREMENT,
	ADMIN,
	SCIENCE,
	SECURITY,
	LOGISTICS,
	ENGINEERING,
	ANTIMEMETICS,
	THEOLOGY,
	TEMPORAL,
	MISCOMMUNICATION,
	PATAPHYSICS,

	UTILITY, 
	UNIQUE
}

enum EFFECTS {
	PROCUREMENT_PASSIVE_1,
	PROCUREMENT_PASSIVE_2,
	
	ADMIN_PASSIVE_1,
	ENGINEERING_PASSIVE_1,
	SECURITY_PASSIVE_1,
	SCIENCE_PASSIVE_1,
	LOGISTICS_PASSIVE_1,
	ANTIMEMETICS_PASSIVE_1,
	THEOLOGY_PASSIVE_1,
	TEMPORAL_PASSIVE_1,
	MISCOMMUNICATION_PASSIVE_1,
	PATAPHYSICS_PASSIVE_1,
	
	
	# ---------------
	DOUBLE_ECON_OUTPUT,
	TRIPLE_ECON_OUTPUT,
	HALF_ECON_OUTPUT,
	ZERO_ECON_OUTPUT,
	
	#---------------- SCP RELATED EFFECTS
	SET_LEVEL_TO_1,
	TELEPORTS,
	BUILD_RANDOM_ROOM,
}

func return_category_title(ref: CATEGORY) -> String:
	match ref:
		CATEGORY.DEPARTMENT:
			return "DEPARTMENT"
		CATEGORY.BRANCH:
			return "BRANCH"
		CATEGORY.CONTAINMENT:
			return "CONTAINMENT"

		CATEGORY.PROCUREMENT:
			return "PROCUREMENT"
		CATEGORY.ADMIN:
			return "ADMIN"
		CATEGORY.SECURITY:
			return "SECURITY"
		CATEGORY.SCIENCE:
			return "SCIENCE"
		CATEGORY.LOGISTICS:
			return "LOGISTICS"
		CATEGORY.ENGINEERING:
			return "ENGINEERING"
		CATEGORY.ANTIMEMETICS:
			return "THERE IS NO ANTIMEMETICS"
		CATEGORY.THEOLOGY:
			return "THEOLOGY"
		CATEGORY.TEMPORAL:
			return "TEMPORAL"
		CATEGORY.MISCOMMUNICATION:
			return "MISCOMMUNICATION"
		CATEGORY.PATAPHYSICS:
			return "PATAPHYSICS"

		CATEGORY.UTILITY:
			return "UTILITY"
		CATEGORY.UNIQUE:
			return "UNIQUE"

		_:
			return "UNKNOWN"

func get_op_string(operation:ROOM.OPERATOR) -> String:
	return "[b][color='GREEN']PRODUCES[/color][b]" if operation == ROOM.OPERATOR.ADD else "[b][color='RED']EXPENDS[/color][/b]"

func return_effect(ref:EFFECTS) -> Dictionary:
	match ref:
		# -----------------------
		EFFECTS.PROCUREMENT_PASSIVE_1:
			return {		
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "If an ADMIN DEPARTMENT is built in the same SECTOR, INCREASE this facility by +3 LEVELS." % [get_op_string(operation)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return ROOM_UTIL.ring_contains(ROOM.REF.ADMIN_DEPARTMENT, _location),
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.bonus += 3
			}		
		EFFECTS.PROCUREMENT_PASSIVE_2:
			return {		
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "Facility modifer now includes READINESS." % [get_op_string(operation)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					if RESOURCE.METRICS.READINESS not in _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.metric:
						_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.metric.append(RESOURCE.METRICS.READINESS)
			}					
		# -----------------------
		EFFECTS.ADMIN_PASSIVE_1:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "If LEVEL is 2 or less, then this facility also %s READINESS." % [get_op_string(operation)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level <= 2,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					if RESOURCE.METRICS.READINESS not in _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.metric:
						_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.metric.append(RESOURCE.METRICS.READINESS)
			}
		EFFECTS.LOGISTICS_PASSIVE_1:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "If two different resources from ECONOMY are %s here, increase this facilities level by [b]+3[/b]." % [get_op_string(operation)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.currency.size() >= 2,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level += 3
			}
		EFFECTS.ENGINEERING_PASSIVE_1:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "The LEVEL of this facility produces the same in ENERGY.",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var ring_config_data:Dictionary = _new_room_config.floor[_location.floor].ring[_location.ring]
					ring_config_data.energy.available += _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level
			}
		EFFECTS.ANTIMEMETICS_PASSIVE_1:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "If no other departments are present then this facility %s instead of %s" % [get_op_string(ROOM.OPERATOR.ADD), get_op_string(ROOM.OPERATOR.SUBTRACT)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return ROOM_UTIL.get_departments(_location).size() == 1,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.operator = ROOM.OPERATOR.ADD
			}						
		EFFECTS.THEOLOGY_PASSIVE_1:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "If you have more MONEY than SCIENCE, add SCIENCE modifer to this facility, else, add MONEY." % [get_op_string(operation)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var money:int = GAME_UTIL.resources_data[RESOURCE.CURRENCY.MONEY].amount
					var science:int = GAME_UTIL.resources_data[RESOURCE.CURRENCY.SCIENCE].amount
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.currency.append(RESOURCE.CURRENCY.SCIENCE if money > science else RESOURCE.CURRENCY.MONEY)
			}
		EFFECTS.TEMPORAL_PASSIVE_1:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "This facility %s MATERIAL on even days, and SCIENCE on odd days." % [get_op_string(operation)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var day:int = GAME_UTIL.progress_data.day - 1
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.currency.append(RESOURCE.CURRENCY.MATERIAL if day % 2 == 0 else RESOURCE.CURRENCY.SCIENCE)
			}
		EFFECTS.MISCOMMUNICATION_PASSIVE_1:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "If there is another MISSCOMMUNICATION DEPARTMENT present then this facility %s instead of %s, else reverse." % [get_op_string(ROOM.OPERATOR.ADD), get_op_string(ROOM.OPERATOR.SUBTRACT)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var count:int = ROOM_UTIL.ring_contains_count(ROOM.REF.MISCOMMUNICATION_DEPARTMENT, _location)
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.operator = ROOM.OPERATOR.ADD if count > 1 else ROOM.OPERATOR.SUBTRACT
			}
		EFFECTS.PATAPHYSICS_PASSIVE_1:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "Other departments in this wing are the same level as this facility.",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var departments:Array = ROOM_UTIL.get_departments(_location)
					var level:int = _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level
					for item in departments:
						_new_room_config.floor[item.location.floor].ring[item.location.ring].room[item.location.room].department_props.level = level
			}
		EFFECTS.SCIENCE_PASSIVE_1:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "LEVEL is increased by +3 if an SCP is contained in the same SECTOR.",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					# TODO CHECK FOR SCP
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level += 3,
			}			
		EFFECTS.SECURITY_PASSIVE_1:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "If 2 or more MTF teams are present in this SECTOR, apply READINESS to ALL departments.",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					# TODO do check for this
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var departments:Array = ROOM_UTIL.get_departments(_location)
					for item in departments:
						if RESOURCE.METRICS.READINESS not in _new_room_config.floor[item.location.floor].ring[item.location.ring].room[item.location.room].department_props.metric:
							_new_room_config.floor[item.location.floor].ring[item.location.ring].room[item.location.room].department_props.metric.append(RESOURCE.METRICS.READINESS)
			}					
		# -----------------------
		
		# -----------------------
		EFFECTS.DOUBLE_ECON_OUTPUT:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "[b]DOUBLE[/b] the LEVEL nearby departments.",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var level:int = _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level = level * 2
			}
		EFFECTS.TRIPLE_ECON_OUTPUT:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "[b]TRIPLE[/b] the LEVEL nearby departments.",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var level:int = _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level = level * 3
			}
		EFFECTS.HALF_ECON_OUTPUT:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "[b]HALVES[/b] the LEVEL nearby departments.",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var level:int = _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level = int(round(level * 0.5))
			}
		EFFECTS.ZERO_ECON_OUTPUT:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "[b]SET[/b] the LEVEL nearby departments to [b]ZERO[/b].",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var level:int = _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level = 0
			}			
		# -----------------------
		
		# -----------------------
		EFFECTS.SET_LEVEL_TO_1:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "[b]LEVEL[/b] cannot exceed [b]1[/b].",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var level:int = _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_props.level = 1
			}
		EFFECTS.TELEPORTS:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "This facility teleports (if space is available).",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"end_of_turn": func(_location:Dictionary) -> void:
					var available_slots:Array = []
					for room in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
						var room_details:Dictionary = ROOM_UTIL.return_data_via_location( {"floor": _location.floor, "ring":  _location.ring, "room": room} )
						if room_details.is_empty():
							available_slots.append(room)

					if !available_slots.is_empty():
						SUBSCRIBE.purchased_facility_arr = GAME_UTIL.purchased_facility_arr.map(func(x):
							if x.location == _location:
								var new_location:Dictionary = {"floor": x.location.floor, "ring": x.location.ring, "room": available_slots[randi() % available_slots.size()]} 
								SCP_UTIL.force_move_location(x.location, new_location)
								x.location = new_location
							return x
						),
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					pass
			}
		EFFECTS.BUILD_RANDOM_ROOM:
			return {
				"description":	func(operation:int = ROOM.OPERATOR.ADD) -> String:
					return "Build random rooms in it's area of influence (if space is available).",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"end_of_turn": func(_location:Dictionary) -> void:
					var available_slots:Array = []
					for room in [0, 1, 2, 3, 4, 5, 6, 7, 8]:
						var room_details:Dictionary = ROOM_UTIL.return_data_via_location( {"floor": _location.floor, "ring":  _location.ring, "room": room} )
						if room_details.is_empty():
							available_slots.append(room)

					if !available_slots.is_empty():
						for item in GAME_UTIL.purchased_facility_arr:
							if item.location == _location:
								var adjacent_rooms:Array = ROOM_UTIL.find_adjacent_rooms(item.location.room)
								var new_location:Dictionary = {"floor": _location.floor, "ring":  _location.ring, "room": adjacent_rooms[randi() % adjacent_rooms.size()]}
								var room_details:Dictionary = ROOM_UTIL.return_data_via_location( new_location  )
								if room_details.is_empty():
									ROOM_UTIL.add_random_room(new_location),
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					pass
			}
		# -----------------------
	return {}
