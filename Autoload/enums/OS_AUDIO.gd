extends Node

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
				"file": preload("res://Audio/mp3/R6S Loading Screen - itryti - SoundLoadMate.com.mp3")
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
				"file": preload("res://Audio/mp3/nagz-2-DO_NOT_USE_IN_FINAL.mp3")
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
				"file": preload("res://Audio/mp3/nagz-2-DO_NOT_USE_IN_FINAL.mp3")
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
				"file": preload("res://Audio/mp3/Water - Flanny - SoundLoadMate.com.mp3")
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
				"file": preload("res://Audio/mp3/Heretic Frypan (Eastward OST Extended).mp3")
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
				"file": preload("res://Audio/mp3/Tokyo Night - Gabtosin - SoundLoadMate.com.mp3")
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
				"file": preload("res://Audio/mp3/stephen-walking-the-difference-between-us-and-the-aliens-scdler.mp3")
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
