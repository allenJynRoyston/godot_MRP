@tool
extends Node

enum AREA { THIS_ROOM, ADJACENT }
enum OPERATOR { ADD, SUBTRACT }
enum RESOURCE_TYPE { CURRENCY, METRIC, PERSONNEL }
enum DURATION {DAILY, WEEKLY}

enum REF {
	DEBUG_ROOM,
	
	# -----------------  DEPARTMENTS
	PROCUREMENT_DEPARTMENT,
	ADMIN_DEPARTMENT, 
	LOGISTICS_DEPARTMENT, 
	ENGINEERING_DEPARTMENT, 
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
	PROCUREMENT_DEFAULT,
	ADMIN_DEFAULT,
	ENGINEERING_DEFAULT,
	LOGISTICS_DEFAULT,
	ANTIMEMETICS_DEFAULT,
	THEOLOGY_DEFAULT,
	TEMPORAL_DEFAULT,
	MISCOMMUNICATION_DEFAULT,
	PATAPHYSICS_DEFAULT,
	
	# ---------------
	DOUBLE_ECON_OUTPUT,
	TRIPLE_ECON_OUTPUT,
	HALF_ECON_OUTPUT,
	ZERO_ECON_OUTPUT,
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
		EFFECTS.PROCUREMENT_DEFAULT:
			return {
				"description":	func(operation:int) -> String:
					return "If an ADMIN DEPARTMENT is built in the same WING, this facility %s +3 more." % [get_op_string(operation)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return ROOM_UTIL.ring_contains(ROOM.REF.ADMIN_DEPARTMENT, _location),
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.bonus += 3
			}		
		EFFECTS.ADMIN_DEFAULT:
			return {
				"description":	func(operation:int) -> String:
					return "If LEVEL is 2 or less, then this facility also %s READINESS." % [get_op_string(operation)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.level <= 2,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					if RESOURCE.METRICS.READINESS not in _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.metric:
						_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.metric.append(RESOURCE.METRICS.READINESS)
			}
		EFFECTS.LOGISTICS_DEFAULT:
			return {
				"description":	func(operation:int) -> String:
					return "If two different resources from ECONOMY are %s here, increase this facilities level by [b]+3[/b]." % [get_op_string(operation)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.currency.size() >= 2,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.level += 3
			}
		EFFECTS.ENGINEERING_DEFAULT:
			return {
				"description":	func(operation:int) -> String:
					return "The LEVEL of this facility produces the same in ENERGY.",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var ring_config_data:Dictionary = _new_room_config.floor[_location.floor].ring[_location.ring]
					ring_config_data.energy.available += _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.level
			}
		EFFECTS.ANTIMEMETICS_DEFAULT:
			return {
				"description":	func(operation:int) -> String:
					return "If no other departments are present then this facility %s instead of %s" % [get_op_string(ROOM.OPERATOR.ADD), get_op_string(ROOM.OPERATOR.SUBTRACT)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return ROOM_UTIL.get_departments(_location).size() == 1,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.operator = ROOM.OPERATOR.ADD
			}						
		EFFECTS.THEOLOGY_DEFAULT:
			return {
				"description":	func(operation:int) -> String:
					return "If you have more MONEY than SCIENCE, add SCIENCE modifer to this facility, else, add MONEY." % [get_op_string(operation)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var money:int = GAME_UTIL.resources_data[RESOURCE.CURRENCY.MONEY].amount
					var science:int = GAME_UTIL.resources_data[RESOURCE.CURRENCY.SCIENCE].amount
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.currency.append(RESOURCE.CURRENCY.SCIENCE if money > science else RESOURCE.CURRENCY.MONEY)
			}
		EFFECTS.TEMPORAL_DEFAULT:
			return {
				"description":	func(operation:int) -> String:
					return "This facility %s MATERIAL on even days, and SCIENCE on odd days." % [get_op_string(operation)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var day:int = GAME_UTIL.progress_data.day - 1
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.currency.append(RESOURCE.CURRENCY.MATERIAL if day % 2 == 0 else RESOURCE.CURRENCY.SCIENCE)
			}
		EFFECTS.MISCOMMUNICATION_DEFAULT:
			return {
				"description":	func(operation:int) -> String:
					return "If there is another MISSCOMMUNICATION DEPARTMENT present then this facility %s instead of %s, else reverse." % [get_op_string(ROOM.OPERATOR.ADD), get_op_string(ROOM.OPERATOR.SUBTRACT)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var count:int = ROOM_UTIL.ring_contains_count(ROOM.REF.MISCOMMUNICATION_DEPARTMENT, _location)
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.operator = ROOM.OPERATOR.ADD if count > 1 else ROOM.OPERATOR.SUBTRACT
			}
		EFFECTS.PATAPHYSICS_DEFAULT:
			return {
				"description":	func(operation:int) -> String:
					return "Other departments in this wing are the same level as this facility." % [get_op_string(operation)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var departments:Array = ROOM_UTIL.get_departments(_location)
					var level:int = _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.level
					for item in departments:
						_new_room_config.floor[item.location.floor].ring[item.location.ring].room[item.location.room].department_properties.level = level
			}
		# -----------------------
		
		# -----------------------
		EFFECTS.DOUBLE_ECON_OUTPUT:
			return {
				"description":	func(operation:int) -> String:
					return "[b]DOUBLE[/b] the LEVEL nearby departments.",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var level:int = _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.level
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.level = level * 2

			}
		EFFECTS.TRIPLE_ECON_OUTPUT:
			return {
				"description":	func(operation:int) -> String:
					return "[b]TRIPLE[/b] the LEVEL nearby departments.",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var level:int = _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.level
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.level = level * 3
			}
		EFFECTS.HALF_ECON_OUTPUT:
			return {
				"description":	func(operation:int) -> String:
					return "[b]HALVES[/b] the LEVEL nearby departments.",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var level:int = _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.level
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.level = int(round(level * 0.5))
			}
		EFFECTS.ZERO_ECON_OUTPUT:
			return {
				"description":	func(operation:int) -> String:
					return "[b]SET[/b] the LEVEL nearby departments to [b]ZERO[/b].",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					var level:int = _new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.level
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.level = 0
			}			
		# -----------------------
		
	return {}
