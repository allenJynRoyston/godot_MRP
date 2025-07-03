extends Node

enum TRACK { INTRO, LOADING, GAME_TRACK_ONE, CONTAINMENT_BREACH }


var track_list:Array = [
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
			"name": "CONTAINMENT_BREACH",
			"author": "CONTAINMENT_BREACH",
			"ref": TRACK.CONTAINMENT_BREACH
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Audio/mp3/Horror Night - Chiptune.mp3")
	},	
	
]
