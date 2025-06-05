extends Node

enum {
	# OPTIONS
	IS_PRODUCTION_BUILD, START_AT_FULLSCREEN,	
	
	# OS
	SKIP_SPLASH, SKIP_INTRO, SKIP_OFFICE_INTRO,
	
	# PROGRESS
	DEBUG_STORY_PROGRESS,
	STORY_PROGRESS_VAL,
	
	# INTRO
	INTRO_SKIP_LOGO, INTRO_SKIP_TITLE, INTRO_SKIP_SEQUENCE, INTRO_SKIP_STARTAT,
	
	# SAVE FILES
	NEW_PROGRESS_FILE, NEW_SYSTEM_FILE, NEW_PERSISTANT_FILE, NEW_QUICKSAVE_FILE,
	
	# OS
	OS_SKIP_BOOT, OS_SKIP_TO_GAME, OS_APP_FAST_LOAD,
	
	# APP
	APP_SKIP_LOADING_SCREEN, APP_SKIP_TITLESCREEN, 
	
	# GAMEPLAY
	GAMEPLAY_SKIP_SETUP_PROGRSS, GAMEPLAY_START_AT_RING_LEVEL, 
	GAMEPLAY_SKIP_OBJECTIVES, GAMEPLAY_MAX_ENERGY, GAMEPLAY_ALL_PERSONNEL,
	GAMEPLAY_RESEARCHERS_PER_ROOM, GAMEPLAY_RESEARCHERS_BY_DEFAULT,
	
	# RESEARCHER
	RESEARCHER_XP_REQUIRED_FOR_PROMOTION
}

#@export var new_permanent_file:bool = false
#@export var skip_title_screen:bool = true
#
##export 
#
#@export_category("Gameplay Loop")
#@export var new_quicksave_file:bool = false
#@export var skip_progress_screen:bool = false
#@export var debug_energy:bool = true
#@export var debug_personnel:bool = false

#@export var gameplay_skip_loading_screen:bool = false
#@export var gameplay_max_energy:bool = true
#@export var gameplay_all_personnel:bool = false

var refs:Dictionary = {}

func assign(key:int, val) -> void:
	refs[key] = val

func get_val(key:int):
	if refs[IS_PRODUCTION_BUILD]:
		if refs[key] is bool:
			return false	
	return refs[key]
