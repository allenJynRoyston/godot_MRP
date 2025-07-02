extends Node

var track_list:Array = [
	{
		"details": {
			"name": "ghost trick finale",
			"author": "CAPCOM",
			"ref": 0,
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Media/mp3/ghost_trick_test_track.mp3")
	},
	{
		"details": {
			"name": "phoenix wright",
			"author": "CAPCOM",
			"ref": 1,
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Media/mp3/phoenix wright.mp3")
	},
	{
		"details": {
			"name": "The Weeknd - Popular",
			"author": "Vidojean X Oliver Loenn Amapiano Remix",
			"ref": 2
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Media/mp3/The Weeknd - Popular (Vidojean X Oliver Loenn Amapiano Remix).mp3")
	},
	{
		"details": {
			"name": "Horror Night",
			"author": "Uncredited (temp file erase later)",
			"ref": 3
		},
		"unlocked": func(data:Dictionary) -> bool:
			return true,
		"file": preload("res://Media/mp3/Horror Night - Chiptune.mp3")
	},	
	
]
