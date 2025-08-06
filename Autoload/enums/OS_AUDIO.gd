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
					"name": "INTRO",
					"author": "INTRO",
					"ref": TRACK.INTRO,
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/actual/Erik Satie - Gnossiennes 1,2,3.mp3")
			},
			{
				"details": {
					"name": "LOADING",
					"author": "LOADING",
					"ref": TRACK.LOADING,
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/mp3/DEMO - Minimalista Electrónico - Gianluca Faccilongo - SoundLoadMate.com.mp3")
			},
			{
				"details": {
					"name": "OS_STARTUP_SFX",
					"author": "OS_STARTUP_SFX",
					"ref": TRACK.OS_STARTUP_SFX,
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return false,
				"file": preload("res://Audio/fx/Computer Start Up - Premier Sound - SoundLoadMate.com.mp3")
			},	
			
			# ---------------------------------------------------------------------------------------------- OS TRACKS
			{
				"details": {
					"name": "OS_TRACK_ONE",
					"author": "OS_TRACK_ONE",
					"ref": TRACK.OS_TRACK_ONE,
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return false,
				"file": preload("res://Audio/actual/scp-mrp_int_1.mp3")
			},		
			{
				"details": {
					"name": "OS_TRACK_TWO",
					"author": "OS_TRACK_TWO",
					"ref": TRACK.OS_TRACK_TWO,
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return false,
				"file": preload("res://Audio/actual/scp-mrp_int_2.mp3")
			},
			
				
			
			# ---------------------------------------------------------------------------------------------- GAME TRACKS
			{
				"details": {
					"name": "GAME_MAIN_MENU",
					"author": "GAME_MAIN_MENU",
					"ref": TRACK.GAME_MAIN_MENU
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/actual/scp-mrp_int_3.mp3")
			},	
			{
				"details": {
					"name": "GAME_TRACK_ONE",
					"author": "GAME_TRACK_ONE",
					"ref": TRACK.GAME_TRACK_ONE
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/actual/scp-mrp_main_1.mp3")
			},
			{
				"details": {
					"name": "GAME_TRACK_TWO",
					"author": "GAME_TRACK_TWO",
					"ref": TRACK.GAME_TRACK_TWO
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/actual/scp-mrp_main_2.mp3")
			},
			{
				"details": {
					"name": "GAME_TRACK_THREE",
					"author": "GAME_TRACK_THREE",
					"ref": TRACK.GAME_TRACK_THREE
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/actual/scp-mrp_main_2.mp3")
			},
				
			
			# ---------------------------------------------------------------------------------------------- GAME TRACKS
			{
				"details": {
					"name": "INITIAL_CONTAINMENT",
					"author": "INITIAL_CONTAINMENT",
					"ref": TRACK.SCP_INITIAL_CONTAINMENT
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/mp3/Desert - 8 Bit Chiptune Ambient Music - Colorful Hour Music - SoundLoadMate.com.mp3")
			},		
			{
				"details": {
					"name": "CONTAINMENT_BREACH",
					"author": "CONTAINMENT_BREACH",
					"ref": TRACK.SCP_CONTAINMENT_BREACH
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/mp3/Horror Night - Chiptune.mp3")
			},	
			{
				"details": {
					"name": "SCP_FINAL_CONTAINMENT",
					"author": "SCP_FINAL_CONTAINMENT",
					"ref": TRACK.SCP_FINAL_CONTAINMENT
				},
				"cost": 10,
				"is_unlocked": func(data:Dictionary) -> bool:
					return true,
				"file": preload("res://Audio/mp3/Cant Catch Me - That Andy Guy - SoundLoadMate.com.mp3")
			},		
		]
	}
]

func play(track:TRACK, channel:OS_AUDIO.CHANNEL = OS_AUDIO.CHANNEL.MAIN) -> void:
	SUBSCRIBE.music_data = {
		"track": track,
		"channel": channel
	}

func stop() -> void:
	GBL.find_node(REFS.AUDIO).stop()

func change_bus(change_to:OS_AUDIO.CHANNEL) -> void:
	GBL.find_node(REFS.AUDIO).change_bus(change_to)

func fade_out(channel:OS_AUDIO.CHANNEL, and_stop_after:bool = false) -> void:
	GBL.find_node(REFS.AUDIO).fade_out(channel, and_stop_after)
	
func fade_in(channel:OS_AUDIO.CHANNEL) -> void:
	GBL.find_node(REFS.AUDIO).fade_out(channel)

#func change_bus_channel(channel:OS_AUDIO.CHANNEL, stop_current_track:bool = false) -> void:
	#if GBL.find_node(REFS.AUDIO) != null:
		#GBL.find_node(REFS.AUDIO).change_bus(channel, stop_current_track)
