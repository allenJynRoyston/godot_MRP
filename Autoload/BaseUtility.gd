extends SubscribeWrapper

# ----------------------------------------
var MORALE_BOOST:Dictionary = {
	"ref": BASE.BUFF.MORALE_BOOST,
	"name": "MORALE BOOST",
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "A temporary boost to morale.",
	"metrics": {
		RESOURCE.METRICS.MORALE: 2
	}
}

var CONTRACTORS:Dictionary = {
	"ref": BASE.BUFF.CONTRACTORS,
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
	BASE.BUFF.MORALE_BOOST: MORALE_BOOST,
	BASE.BUFF.CONTRACTORS: CONTRACTORS
}
# ----------------------------------------


# ----------------------------------------
var MORALE_DRAIN:Dictionary = {
	"ref": BASE.DEBUFF.MORALE_DRAIN,
	"name": "MORALE DRAIN",
	"img_src": "res://Media/rooms/redacted.jpg",
	"description": "A temporary debuff to morale.",
	"metrics": {
		RESOURCE.METRICS.MORALE: -5
	}
}

var PANIC:Dictionary = {
	"ref": BASE.DEBUFF.PANIC,
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
func add_buff_to_base(type:BASE.TYPE, ref:int, duration:int) -> void:
	# add applies panic debuff to all floors (and rings
	for floor_index in room_config.floor.size():
		match type: 
			BASE.TYPE.BUFF:		
				base_states.floor[str(floor_index)].buffs.push_back({
					"ref": ref, 
					"duration": 5
				})	
			BASE.TYPE.DEBUFF:		
				base_states.floor[str(floor_index)].debuffs.push_back({
					"ref": ref, 
					"duration": 5
				})	
# ---------------------

# ---------------------
func add_buff_to_floor(type:BASE.TYPE, ref:int, duration:int, for_floor:int) -> void:
	# add applies panic debuff to all floors (and rings
	for floor_index in room_config.floor.size():
		if floor_index == for_floor:
			for ring_index in room_config.floor[floor_index].ring.size():
				match type: 
					BASE.TYPE.BUFF:		
						
						base_states.ring[str(floor_index, ring_index)].buffs.push_back({
							"ref": ref, 
							"duration": 5
						})	
					BASE.TYPE.DEBUFF:		
						base_states.ring[str(floor_index, ring_index)].debuffs.push_back({
							"ref": ref, 
							"duration": 5
						})	
# ---------------------

# ---------------------
func add_buff_to_floor_and_rings(type:BASE.TYPE, ref:int, duration:int, for_floor:int, rings:Array = []) -> void:
	# add applies panic debuff to all floors (and rings
	for floor_index in room_config.floor.size():
		if floor_index == for_floor:
			for ring_index in rings:
				match type: 
					BASE.TYPE.BUFF:		
						base_states.ring[str(floor_index, ring_index)].buffs.push_back({
							"ref": ref, 
							"duration": 5
						})	
					BASE.TYPE.DEBUFF:		
						base_states.ring[str(floor_index, ring_index)].debuffs.push_back({
							"ref": ref, 
							"duration": 5
						})	
# ---------------------

# ---------------------
func add_buff_to_rooms(type:BASE.TYPE, ref:int, duration:int, for_floor:int, rings:Array = [], for_rooms:Array = []) -> void:
	# add applies panic debuff to all floors (and rings
	for floor_index in room_config.floor.size():
		if floor_index == for_floor:
			for ring_index in rings:
				for room_index in room_config.floor[floor_index].ring[ring_index].room.size():
					if room_index in for_rooms:
						match type: 
							BASE.TYPE.BUFF:		
								base_states.room[str(floor_index, ring_index, room_index)].buffs.push_back({
									"ref": ref, 
									"duration": 5
								})	
							BASE.TYPE.DEBUFF:		
								base_states.room[str(floor_index, ring_index, room_index)].debuffs.push_back({
									"ref": ref, 
									"duration": 5
								})	
# ---------------------
