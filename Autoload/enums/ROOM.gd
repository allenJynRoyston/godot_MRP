@tool
extends Node

enum AREA { THIS_ROOM, ADJACENT }
enum OPERATOR { ADD, SUBTRACT }
enum RESOURCE_TYPE { CURRENCY, METRIC, PERSONNEL }
enum DURATION {DAILY, WEEKLY}

enum REF {
	DEBUG_ROOM,
	
	# -----------------  ADMIN
	ADMIN_DEPARTMENT, ADMIN_BRANCH,
	ADMIN_ROOM_1, ADMIN_ROOM_2, ADMIN_ROOM_3, ADMIN_ROOM_4, ADMIN_ROOM_5, 
	ADMIN_ROOM_6, ADMIN_ROOM_7, ADMIN_ROOM_8, ADMIN_ROOM_9, ADMIN_ROOM_10,
	
	# -----------------  LOGISTICS
	LOGISTICS_DEPARTMENT, LOGISTICS_BRANCH,
	LOGISTICS_ROOM_1, LOGISTICS_ROOM_2, LOGISTICS_ROOM_3, LOGISTICS_ROOM_4, LOGISTICS_ROOM_5, 
	LOGISTICS_ROOM_6, LOGISTICS_ROOM_7, LOGISTICS_ROOM_8, LOGISTICS_ROOM_9, LOGISTICS_ROOM_10,
	
	# -----------------  ENGINEERING
	ENGINEERING_DEPARTMENT, ENGINEERING_BRANCH,
	ENG_ROOM_1, ENG_ROOM_2, ENG_ROOM_3, ENG_ROOM_4, ENG_ROOM_5,
	ENG_ROOM_6, ENG_ROOM_7, ENG_ROOM_8, ENG_ROOM_9, ENG_ROOM_10,	
	
	# -----------------  ANTIMEMETICS DEPARTMENTS
	ANTIMEMETICS_DEPARTMENT,
	
	# -----------------  CONTAINMENT_CELL
	CONTAINMENT_CELL,
	
	# -----------------  UTILITY
	UTIL_LEVEL_UP_1, UTIL_LEVEL_UP_2, UTIL_LEVEL_UP_3,
	UTIL_LEVEL_DOWN_1, UTIL_LEVEL_DOWN_2, UTIL_LEVEL_DOWN_3,
	
	UTIL_ADD_CURRENCY_MONEY, UTIL_ADD_CURRENCY_MATERIAL, UTIL_ADD_CURRENCY_SCIENCE, UTIL_ADD_CURRENCY_CORE,
	UTIL_RMV_CURRENCY_MONEY, UTIL_RMV_CURRENCY_MATERIAL, UTIL_RMV_CURRENCY_SCIENCE, UTIL_RMV_CURRENCY_CORE,
	
	UTIL_ADD_METRIC_MORALE, UTIL_ADD_METRIC_SAFETY, UTIL_ADD_METRIC_READINESS,
	UTIL_RMV_METRIC_MORALE, UTIL_RMV_METRIC_SAFETY, UTIL_RMV_METRIC_READINESS,
	
	UTIL_BUFF_EFFECT_1, UTIL_BUFF_EFFECT_2,
	UTIL_DEBUFF_EFFECT_1, UTIL_DEBUFF_EFFECT_2,
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
	
	ADMIN,
	LOGISTICS,
	ENGINEERING,
	ANTIMEMETICS,

	UTILITY, 
}

enum EFFECTS {
	ADMIN_DEFAULT,
	ENGINEERING_DEFAULT,
	LOGISTICS_DEFAULT,
	ANTIMEMETICS_DEFAULT,
	
	EFFECT_1,
	EFFECT_2,
}

func return_category_title(ref: CATEGORY) -> String:
	match ref:
		CATEGORY.UTILITY:
			return "UTILITY"
					
		CATEGORY.DEPARTMENT:
			return "DEPARTMENT"
		CATEGORY.BRANCH:
			return "BRANCH"

		CATEGORY.ADMIN:
			return "ADMIN"
		CATEGORY.LOGISTICS:
			return "LOGISTICS"
		CATEGORY.ENGINEERING:
			return "ENGINEERING"
		CATEGORY.ANTIMEMETICS:
			return "ANTIMEMETICS"			
			
		CATEGORY.CONTAINMENT:
			return "CONTAINMENT"

		_:
			return "UNKNOWN"

func get_op_string(operation:ROOM.OPERATOR) -> String:
	return "[b][color='GREEN']PRODUCES[/color][b]" if operation == ROOM.OPERATOR.ADD else "[b][color='RED']EXPENDS[/color][/b]"

func return_effect(ref:EFFECTS) -> Dictionary:
	match ref:
		EFFECTS.ADMIN_DEFAULT:
			return {
				"description":	func(operation:int) -> String:
					return "If LEVEL is 2 or less, then this building also %s READINESS." % [get_op_string(operation)],
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
					return "Generate +1 HEAT if LEVEL is above 3.",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return false,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					pass
			}
		EFFECTS.ANTIMEMETICS_DEFAULT:
			return {
				"description":	func(operation:int) -> String:
					return "If no other departments are present then this facility %s instead of %s" % [get_op_string(ROOM.OPERATOR.ADD), get_op_string(ROOM.OPERATOR.SUBTRACT)],
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return ROOM_UTIL.get_departments(_location).size() == 0,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					_new_room_config.floor[_location.floor].ring[_location.ring].room[_location.room].department_properties.operator = ROOM.OPERATOR.ADD
			}						
			
			
		EFFECTS.EFFECT_1:
			return {
				"description":	func(operation:int) -> String:
					return "EFFECT 1",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					pass
			}
		EFFECTS.EFFECT_2:
			return {
				"description":	func(operation:int) -> String:
					return "EFFECT 2",
				"applies": func(_new_room_config:Dictionary, _location:Dictionary) -> bool:
					return true,
				"func": func(_new_room_config:Dictionary, _location:Dictionary) -> void:
					pass
			}				
	return {}
