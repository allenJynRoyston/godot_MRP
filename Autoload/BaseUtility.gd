extends SubscribeWrapper

# ----------------------------------------
var POWERED:Dictionary = {
	"name": "POWERED",
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Powered.",
}

var MORALE_BOOST:Dictionary = {
	"name": "MORALE BOOST",
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "A temporary boost to morale.",
	"metrics": {
		RESOURCE.METRICS.MORALE: 2
	}
}

var HAPPY_HOUR:Dictionary = {
	"name": "HAPPY HOUR!",
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "A temporary boost to morale.",
	"metrics": {
		RESOURCE.METRICS.MORALE: 1,
		RESOURCE.METRICS.READINESS: -1
	}
}

var CONTRACTORS:Dictionary = {
	"name": "CONTRACTORS",
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Temporary employees that are used to fill any staffing postion (excluding D-Class).",
	"personnel": [
		RESOURCE.PERSONNEL.TECHNICIANS,
		RESOURCE.PERSONNEL.STAFF,
		RESOURCE.PERSONNEL.SECURITY
	]
}

var buff_data:Dictionary = {
	BASE.BUFF.POWERED: POWERED,
	BASE.BUFF.HAPPY_HOUR: HAPPY_HOUR,
	BASE.BUFF.MORALE_BOOST: MORALE_BOOST,
	BASE.BUFF.CONTRACTORS: CONTRACTORS
}
# ----------------------------------------


# ----------------------------------------
var UNPOWERED:Dictionary = {
	"name": "UNPOWERED",
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Unpowered.",
}

var MORALE_DRAIN:Dictionary = {
	"name": "MORALE DRAIN",
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "A temporary debuff to morale.",
	"metrics": {
		RESOURCE.METRICS.MORALE: -5
	}
}

var PANIC:Dictionary = {
	"name": "PANIC!",
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "Everybody is panicking!",
	"metrics": {
		RESOURCE.METRICS.MORALE: -5,
		RESOURCE.METRICS.SAFETY: -5,
		RESOURCE.METRICS.READINESS: -5
	}
		
}

var debuff_data:Dictionary = {
	BASE.DEBUFF.UNPOWERED: UNPOWERED,
	BASE.DEBUFF.MORALE_DRAIN: MORALE_DRAIN,
	BASE.DEBUFF.PANIC: PANIC
}
# ----------------------------------------

# ------------------------------------------------------------------------------
func return_buff(ref:int) -> Dictionary:
	buff_data[ref].ref = ref
	return buff_data[ref]
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func return_debuff(ref:int) -> Dictionary:
	debuff_data[ref].ref = ref
	return debuff_data[ref]
# ------------------------------------------------------------------------------


# ---------------------
func add_buff_or_deubff_to_base(type:BASE.TYPE, ref:int, duration:int) -> void:
	# add applies panic debuff to all floors (and rings
	match type: 
		BASE.TYPE.BUFF:		
			var already_exists:bool =  base_states.base.buffs.filter(func(x): return x.ref == ref).size() > 0
			if !already_exists:
				base_states.base.buffs.push_back({
					"ref": ref, 
					"duration": duration
				})
			else:
				base_states.base.buffs.map(func(x): 
					if x.ref == ref:
						x.duration += duration
					return x
				)
		BASE.TYPE.DEBUFF:
			var already_exists:bool =  base_states.base.debuffs.filter(func(x): return x.ref == ref).size() > 0
			if !already_exists:
				base_states.base.debuffs.push_back({
					"ref": ref, 
					"duration": duration
				})	
			else:
				base_states.base.debuffs.map(func(x): 
					if x.ref == ref:
						x.duration += duration
					return x
				)
# ---------------------

# ---------------------
func add_buff_or_debuff_to_floor(type:BASE.TYPE, ref:int, duration:int, for_floor:int) -> void:
	# add applies panic debuff to all floors (and rings
	for floor_index in room_config.floor.size():
		if floor_index == for_floor:
			match type: 
				BASE.TYPE.BUFF:		
					var already_exists:bool =  base_states.floor[str(floor_index)].buffs.filter(func(x): return x.ref == ref).size() > 0
					if !already_exists:
						base_states.floor[str(floor_index)].buffs.push_back({
							"ref": ref, 
							"duration": duration
						})	
					else:
						base_states.floor[str(floor_index)].buffs.map(func(x): 
							if x.ref == ref:
								x.duration += duration
							return x
						)
				BASE.TYPE.DEBUFF:
					var already_exists:bool =  base_states.floor[str(floor_index)].buffs.filter(func(x): return x.ref == ref).size() > 0
					if !already_exists:	
						base_states.floor[str(floor_index)].debuffs.push_back({
							"ref": ref, 
							"duration": duration
						})	
					else:
						base_states.floor[str(floor_index)].debuffs.map(func(x): 
							if x.ref == ref:
								x.duration += duration
							return x
						)
	SUBSCRIBE.base_states = base_states
# ---------------------

# ---------------------
func add_buff_or_debuff_to_ring(type:BASE.TYPE, ref:int, duration:int, for_floor:int, rings:Array = []) -> void:
	# add applies panic debuff to all floors (and rings
	for floor_index in room_config.floor.size():
		if floor_index == for_floor:
			for ring_index in rings:
				match type: 
					BASE.TYPE.BUFF:		
						var already_exists:bool =  base_states.ring[str(floor_index, ring_index)].buffs.filter(func(x): return x.ref == ref).size() > 0
						if !already_exists:
							base_states.ring[str(floor_index, ring_index)].buffs.push_back({
								"ref": ref, 
								"duration": duration
							})	
						else:
							base_states.ring[str(floor_index, ring_index)].buffs.map(func(x): 
								if x.ref == ref:
									x.duration += duration
								return x
							)
					BASE.TYPE.DEBUFF:		
						var already_exists:bool =  base_states.ring[str(floor_index, ring_index)].debuffs.filter(func(x): return x.ref == ref).size() > 0
						if !already_exists:
							base_states.ring[str(floor_index, ring_index)].debuffs.push_back({
								"ref": ref, 
								"duration": duration
							})	
						else:
							base_states.ring[str(floor_index, ring_index)].debuffs.map(func(x): 
								if x.ref == ref:
									x.duration += duration
								return x
							)
	SUBSCRIBE.base_states = base_states
# ---------------------

# ---------------------
func add_buff_or_debuff_to_rooms(type:BASE.TYPE, ref:int, duration:int, for_floor:int, rings:Array = [], for_rooms:Array = []) -> void:
	# add applies panic debuff to all floors (and rings
	for floor_index in room_config.floor.size():
		if floor_index == for_floor:
			for ring_index in rings:
				for room_index in room_config.floor[floor_index].ring[ring_index].room.size():
					if room_index in for_rooms:
						match type: 
							BASE.TYPE.BUFF:		
								var already_exists:bool = base_states.room[str(floor_index, ring_index, room_index)].buffs.filter(func(x): return x.ref == ref).size() > 0
								if !already_exists:
									base_states.room[str(floor_index, ring_index, room_index)].buffs.push_back({
										"ref": ref, 
										"duration": duration
									})	
								else:
									base_states.room[str(floor_index, ring_index, room_index)].buffs.map(func(x): 
										if x.ref == ref:
											x.duration += duration
										return x
									)
							BASE.TYPE.DEBUFF:
								var already_exists:bool = base_states.room[str(floor_index, ring_index, room_index)].debuffs.filter(func(x): return x.ref == ref).size() > 0
								if !already_exists:								
									base_states.room[str(floor_index, ring_index, room_index)].debuffs.push_back({
										"ref": ref, 
										"duration": duration
									})
								else:
									base_states.room[str(floor_index, ring_index, room_index)].debuffs.map(func(x): 
										if x.ref == ref:
											x.duration += duration
										return x
									)
	SUBSCRIBE.base_states = base_states
# ---------------------
