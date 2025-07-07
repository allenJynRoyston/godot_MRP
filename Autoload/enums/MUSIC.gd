extends Node

enum TRACK { 
	INTRO, 
	LOADING, 
	
	GAME_MAIN_MENU,
	GAME_TRACK_ONE, 
	GAME_TRACK_TWO,
	
	INITIAL_CONTAINMENT, 
	CONTAINMENT_BREACH 
}


var track_list:Array = [
	# ---------------------------------------------------------------------------------------------- SYSTEM
	{
		"details": {
			"name": "INTRO",
			"author": "INTRO",
			"ref": TRACK.INTRO,
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Audio/mp3/R6S Loading Screen - itryti - SoundLoadMate.com.mp3")
	},
	{
		"details": {
			"name": "LOADING",
			"author": "LOADING",
			"ref": TRACK.LOADING,
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Audio/mp3/DEMO - Minimalista Electrónico - Gianluca Faccilongo - SoundLoadMate.com.mp3")
	},
	
	# ---------------------------------------------------------------------------------------------- GAME TRACKS
	{
		"details": {
			"name": "GAME_MAIN_MENU",
			"author": "GAME_MAIN_MENU",
			"ref": TRACK.GAME_MAIN_MENU
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Audio/mp3/Water - Flanny - SoundLoadMate.com.mp3")
	},	
	{
		"details": {
			"name": "GAME_TRACK_ONE",
			"author": "GAME_TRACK_ONE",
			"ref": TRACK.GAME_TRACK_ONE
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Audio/mp3/Heretic Frypan (Eastward OST Extended).mp3")
	},
	{
		"details": {
			"name": "GAME_TRACK_TWO",
			"author": "GAME_TRACK_TWO",
			"ref": TRACK.GAME_TRACK_TWO
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Audio/mp3/Tokyo Night - Gabtosin - SoundLoadMate.com.mp3")
	},
	
	
	# ---------------------------------------------------------------------------------------------- GAME TRACKS
	{
		"details": {
			"name": "INITIAL_CONTAINMENT",
			"author": "INITIAL_CONTAINMENT",
			"ref": TRACK.INITIAL_CONTAINMENT
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Audio/mp3/Desert - 8 Bit Chiptune Ambient Music - Colorful Hour Music - SoundLoadMate.com.mp3")
	},		
	{
		"details": {
			"name": "CONTAINMENT_BREACH",
			"author": "CONTAINMENT_BREACH",
			"ref": TRACK.CONTAINMENT_BREACH
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Audio/mp3/Horror Night - Chiptune.mp3")
	},	
	
]
