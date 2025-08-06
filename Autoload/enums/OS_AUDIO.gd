extends SubscribeWrapper

enum CHANNEL {
	MAIN,
	REVERB
}

enum TRACK {
	# -------------------- 
	INTRO, 
	LOADING, 
	OS_STARTUP_SFX,
	# --------------------
	OS_TRACK_ONE,
	OS_TRACK_TWO,
	
	# --------------------
	GAME_MAIN_MENU,
	GAME_TRACK_ONE, 
	GAME_TRACK_TWO,
	GAME_TRACK_THREE,
	
	# --------------------
	SCP_INITIAL_CONTAINMENT, 
	SCP_CONTAINMENT_BREACH,
	SCP_FINAL_CONTAINMENT,
}


var track_data:Array = [
	{
		"category": "CATEGORY A",
		"list": [
			{
				"details": {
					"name": "GNOSSIENNE 1",
					"author": "Erik Satie",
					"ref": TRACK.INTRO,
				},
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/actual/Erik Satie - Gnossiennes 1,2,3.mp3")
			},
			{
				"details": {
					"name": "OS_STARTUP_SFX",
					"author": "Dávid Halmi",
					"ref": TRACK.OS_STARTUP_SFX,
				},
				"is_unlocked": func(data:Dictionary) -> bool:
					return false,
				"file": preload("res://Audio/fx/Computer Start Up - Premier Sound - SoundLoadMate.com.mp3")
			},	
			
			# ---------------------------------------------------------------------------------------------- OS TRACKS
			{
				"details": {
					"name": "FUNK PROTOCOL",
					"author": "Dávid Halmi",
					"ref": TRACK.OS_TRACK_ONE,
				},
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/actual/scp-mrp_int_1.mp3")
			},		
			{
				"details": {
					"name": "CONTAINMENT BREACH",
					"author": "Dávid Halmi",
					"ref": TRACK.OS_TRACK_TWO,
				},
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/actual/scp-mrp_int_2.mp3")
			},
			{
				"details": {
					"name": "CONTINGENCY PLAN",
					"author": "Dávid Halmi",
					"ref": TRACK.GAME_MAIN_MENU
				},
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/actual/scp-mrp_int_3.mp3")
			},	
				
			
			# ---------------------------------------------------------------------------------------------- GAME TRACKS
			{
				"details": {
					"name": "UNCONTAINABLE",
					"author": "Dávid Halmi",
					"ref": TRACK.GAME_TRACK_ONE
				},
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/actual/scp-mrp_main_1.mp3")
			},
			{
				"details": {
					"name": "NON EUCLIDEAN",
					"author": "Dávid Halmi",
					"ref": TRACK.GAME_TRACK_TWO
				},
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/actual/scp-mrp_main_2.mp3")
			},
			# ---------------------------------------------------------------------------------------------- GAME TRACKS
		]
	}
]

func return_data(track:TRACK) -> Dictionary:
	
	for index in track_data[0].list.size():
		if track_data[0].list[index].details.ref == track:
			return track_data[0].list[index]
			break
	return {}
	
func get_track_index(track:TRACK) -> int:
	for index in track_data[0].list.size():
		if track_data[0].list[index].details.ref == track:
			return index
			break
	return -1
	

func play(track:TRACK, channel:OS_AUDIO.CHANNEL = OS_AUDIO.CHANNEL.MAIN) -> void:
	SUBSCRIBE.music_data = {
		"track": track,
		"channel": channel
	}

func stop() -> void:
	GBL.find_node(REFS.AUDIO).stop()

func change_bus(change_to:OS_AUDIO.CHANNEL) -> void:
	GBL.find_node(REFS.AUDIO).change_bus(change_to)

func fade_out(channel:OS_AUDIO.CHANNEL, duration:float = 2.0, and_stop_after:bool = true) -> void:
	GBL.find_node(REFS.AUDIO).fade_out(channel, duration, and_stop_after)
	
func fade_in(channel:OS_AUDIO.CHANNEL, duration:float = 2.0) -> void:
	GBL.find_node(REFS.AUDIO).fade_out(channel, duration)
