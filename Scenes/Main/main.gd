extends PanelContainer

@onready var MousePointer:TextureRect = $FinalComposition/MousePointer
@onready var Output:TextureRect = $FinalOutput/Output
@onready var ActiveSubviewport:SubViewport = $ActiveSubviewport
@onready var MusicShaderViewport:SubViewport = $MusicShader

# OS
@onready var OSViewport:SubViewport = $OSViewport
@onready var OsScene:PanelContainer = $OSViewport/OsScene

# ARTICLE
@onready var ArticleViewport:SubViewport = $ArticleViewport
@onready var ArticleScene:PanelContainer = $ArticleViewport/ArticleScene

# OS
@onready var CellViewport:SubViewport = $CellViewport
@onready var CellScene:PanelContainer = $CellViewport/CellScene

# texture rect
@onready var OsTextureRect:TextureRect = $ActiveSubviewport/OsTextureRect
@onready var ArticleTextureRect:TextureRect = $ActiveSubviewport/ArticleTextureRect
@onready var CellTextureRect:TextureRect = $ActiveSubviewport/CellTextureRect

# MAIN SCENES
@onready var IntroAndTitleScreen:Control = $ActiveSubviewport/IntroAndTitleScreen
@onready var TransitionScreen:Control = $ActiveSubviewport/TransitionScreen

# TEXT RECTS with SHADERSs
@onready var GlitchShaderTextureRect:TextureRect = $GlitchShader/TextureRect
@onready var CRTShaderTextureRect:TextureRect = $CRTShader/TextureRect
@onready var ScreenBendTextureRect:TextureRect = $Screenbend/Bend/TextureRect
@onready var BrightnessTextureRect:TextureRect = $Screenbend/Brightness/TextureRect2
@onready var BorderShaderTextureRect:TextureRect = $BorderShader/TextureRect
@onready var FinalCompositeTextureRect:TextureRect = $FinalComposition/FinalComposite

# NOTE AND MESSAGE BUTTON
@onready var NoteBtn:PanelContainer = $NoteOverlay/Notes/MarginContainer/NoteBtn
@onready var MessageBtn:PanelContainer = $NoteOverlay/Notes/MarginContainer/MessageBtn

# COLORRECT bluescreens
@onready var CRTColorRect:ColorRect = $CRTShader/ColorRectBG
@onready var FinalCompositionColorRect:ColorRect = $FinalComposition/ColorRectBG

# SHADERS
@onready var MusicShaderTexture:TextureRect = $MusicShader/MusicShaderTexture

# ENUMS
enum LAYER {CELLBLOCK_LAYER, OS_lAYER, SCP_LAYER, GAMEPLAY_LAYER}
enum SHADER_PROFILE {NONE, ALL}

# CONSTS
const mouse_cursor:CompressedTexture2D = preload("res://Media/mouse/icons8-select-cursor-24.png")
const mouse_busy:CompressedTexture2D = preload("res://Media/mouse/icons8-hourglass-24.png")
const mouse_pointer:CompressedTexture2D = preload("res://Media/mouse/icons8-click-24.png")

@export_category("PRODUCTION DEBUG")
@export var shader_profile:SHADER_PROFILE = SHADER_PROFILE.ALL : 
	set(val):
		shader_profile = val
		on_shader_profile_update()

# GAMEPLAY OPTIONS
@export_category("PRODUCTION DEBUG")
@export var is_production_build:bool = false

# USER PROFILE DEBUG
@export_category("USER_PROFILE DEBUG")
@export var reset_userprofile_save:bool = false

# GRAPHICS DEBUG
@export_category("GRAPHIC DEBUG")
@export var start_at_fullscreen:bool = false

# AUDIO DEBUG
@export_category("AUDIO DEBUG")
@export var audio_mute:bool = false

# SKIPS
@export_category("SKIPS")
@export var skip_splash:bool = false

# INTRODUCTION
@export_category("INTRO LAYER")
@export var skip_intro:bool = false 
@export var intro_skip_logo:bool = false
@export var intro_skip_title:bool = false
@export var intro_skip_sequence:bool = false
@export var intro_skip_start_at:bool = false

@export_category("OFFICE LAYER")
@export var skip_office_intro:bool = false
@export var office_skip_animation:bool = false

@export_category("OS LAYER")

# USERPROFILE DEBUG
@export_category("STORYPROGRESS DEBUG")
@export var debug_story_progress:bool = false
@export var user_profile_ref:FS.FILE = FS.FILE.SAVE_ONE
@export var skip_to_chapter:int = 0

# OS
@export_category("DEBUG OS")
@export var os_skip_boot:bool = false
@export var os_skip_to_game:bool = false
@export var os_app_fast_load:bool = false

# INTRODUCTION
@export_category("SITE DIRECTOR")
@export var stdr_skip_titlescreen:bool = false
@export var stdr_skip_loadingscreen:bool = false

@export_category("DEBUG GAMEPLAYLOOP")
@export var show_debug_menu:bool = false
@export var skip_setup_progress:bool = false
@export var start_at_ring_level:bool = false
@export var skip_objectives:bool = false
@export var enable_scp_debug:bool = false
@export var max_energy:bool = true
@export var all_rooms_available:bool = false
@export var all_resources:bool = false

@export_category("EVENTS IN GAMEPLAYLOOP")
@export var skip_initial_containment:bool = false
@export var skip_breach_events:bool = false
@export var skip_contained_events:bool = false

@export_category("PERSONNEL DEBUG")
@export var staff_debug:bool = false

@export var staff_starting_researchers:int = 9
@export var staff_starting_admin:int = 9
@export var staff_starting_security:int = 9
@export var staff_starting_dclass:int = 9
@export var xp_needed_for_promotion:int = 0

@export var mtf_alpha:bool = false
@export var mtf_bravo:bool = false
@export var mtf_delta:bool = false

# SHADER VARS
@onready var shader_arr:Array = [ 
	[GlitchShaderTextureRect, "glitch"], 
	[CRTShaderTextureRect, "crt"], 
	[ScreenBendTextureRect, "bend"], 
	[BrightnessTextureRect, "brightness"], 
	[BorderShaderTextureRect, "border"], 
	[FinalCompositeTextureRect, "final"]
]

@onready var shader_list:Array = [
	GlitchShaderTextureRect, 
	CRTShaderTextureRect, 
	ScreenBendTextureRect,
	BrightnessTextureRect,
	BorderShaderTextureRect, 
	FinalCompositeTextureRect
]

@onready var color_rect_arr:Array = [ 
	[CRTColorRect, "crt"],
	[FinalCompositionColorRect, "final"]
]

@onready var color_rect_list:Array = [
	FinalCompositionColorRect, 
	CRTColorRect
]

var color_rect_props:Dictionary = {
	"node": null,
	"color": null
}

var shader_props:Dictionary = {
	"node": null,
	"material": null,
	"shader": null
}
	
var shader_defaults:Dictionary = {
	"glitch": shader_props.duplicate(true),
	"bend": shader_props.duplicate(true),
	"brightness": shader_props.duplicate(true),
	"crt": shader_props.duplicate(true),
	"border": shader_props.duplicate(true),
	"final": shader_props.duplicate(true),
}

var colorrect_defaults:Dictionary = {
	"crt": color_rect_props.duplicate(true),
	"final": color_rect_props.duplicate(true)
}

# SAVE FILE STRUCTURE/DEFAULTS
var default_save_profiles:Dictionary = {
	"os_setting": {
		"read_emails": [],
		"tracks_unlocked": [],
		"apps_installed": [],
		"store_purchases": [],
		"audio_visulizer_in_background": false,
		"play_music_on_boot": true,
		"currency": {
			"amount": 10
		}
	},
	"graphics": {
		"fullscreen": false,
		"shaders":{
			"crt_effect": true,
			"screen_bend": true,
			"screen_burn": true,
			"monitor_overlay": true
		}	
	},	
	"snapshots": {
		"after_setup": {},
		"restore_checkpoint": {},
		"quicksaves": {}
	}	
}

# DEFAULT (NEW) USER PROFILE SCHEMA
var user_profile_schema:Dictionary = {
	"boot_count": 0,
	"story_progress": {
		"on_chapter": skip_to_chapter if debug_story_progress else 0,
		"messages_played": [],
		"completed_chapters": []
	},
	"use_save_profile": FS.FILE.SAVE_ONE if !user_profile_ref else user_profile_ref,
	"save_profiles":{
		FS.FILE.SAVE_ONE: default_save_profiles.duplicate(),
		FS.FILE.SAVE_TWO: default_save_profiles.duplicate()
	}
}

# DEFAULT RESOLUTION IS MAX WIDTH/HEIGHT
var resolution:Vector2i = DisplayServer.screen_get_size()

var current_layer:LAYER : 
	set(val):
		current_layer = val
		on_current_layer_update()

var has_note:bool = false
var has_message:bool = false
var note:Dictionary 

# ------------------------------------------------------------------------------
# SETUP GAME RESOLUTION
func _init() -> void:
	if FileAccess.file_exists("user://scp_mrp.config.json"):
		var file = FileAccess.open("user://scp_mrp.config.json", FileAccess.READ)
		var result = JSON.parse_string(file.get_as_text())
		if result is Dictionary:
			resolution = Vector2(result.resolution_width, result.resolution_height)
	else:
		GBL.save_resolution(DisplayServer.screen_get_size())
		
	GBL.register_node(REFS.MAIN, self)		
	GBL.subscribe_to_process(self)
	GBL.subscribe_to_control_input(self)	
	GBL.subscribe_to_mouse_icons(self)
	SUBSCRIBE.subscribe_to_notes(self)
# ------------------------------------------------------------------------------

# -----------------------------------	
func _exit_tree() -> void:
	GBL.unsubscribe_to_process(self)
	GBL.unregister_node(REFS.MAIN)
	GBL.unregister_node(REFS.MAIN_ACTIVE_VIEWPORT)
	GBL.unregister_node(REFS.MAIN_ARTICLE_VIEWPORT)
	GBL.unregister_node(REFS.MAIN_OS_VIEWPORT)
	GBL.unsubscribe_to_mouse_icons(self)
	GBL.unsubscribe_to_control_input(self)	
	SUBSCRIBE.unsubscribe_to_notes(self)

# -----------------------------------		

# -----------------------------------	
func _ready() -> void:
	# print important stuff
	if !is_production_build:
		print( "Save files located at: ", OS.get_user_data_dir() )
	
	# register node
	GBL.register_node(REFS.MAIN_ACTIVE_VIEWPORT, ActiveSubviewport)
	GBL.register_node(REFS.MAIN_ARTICLE_VIEWPORT, ArticleViewport)
	GBL.register_node(REFS.MAIN_OS_VIEWPORT, OSViewport)
	GBL.register_node(REFS.MAIN_CELL_VIEWPORT, CellViewport)
	
	# assign debugs
	assign_debugs()
	
	NoteBtn.modulate.a = 0.1
	MessageBtn.modulate.a = 0.1

	# assign functions
	CellScene.transInFx = func(duration:float = 1.3) -> void:
		await use_transition()

	CellScene.gotoOs = func() -> void:
		current_layer = LAYER.OS_lAYER		

	CellScene.gotoScp = func() -> void:
		current_layer = LAYER.SCP_LAYER	
	
	OsScene.onBack = func() -> void:
		use_transition()
		current_layer = LAYER.CELLBLOCK_LAYER
	
	ArticleScene.onBack = func() -> void:
		use_transition()
		current_layer = LAYER.CELLBLOCK_LAYER
		
	# get default parameters
	duplicate_shader_defaults()
	duplicate_colorrect_defaults()
	
	# apply shader profile
	on_shader_profile_update()
	
	# mouse behavior
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
	# -------------------
	if start_at_fullscreen:
		on_fullscreen_update(resolution)
		toggle_fullscreen()
	else:		
		on_fullscreen_update(Vector2(1280, 720))			
	
	# -------------------
	if reset_userprofile_save:
		print("RESET USER PROFILE")
		update_and_save_user_profile(user_profile_schema.duplicate())
	else:
		var res:Dictionary = FS.load_file(FS.FILE.USER_PROFILE)
		if res.success:
			GBL.active_user_profile = res.filedata.data
		else:
			print("NEW USER PROFILE CREATED!")
			update_and_save_user_profile(user_profile_schema.duplicate())
	
	# start
	start()
# -----------------------------------	

# -----------------------------------	
func start() -> void:
	# skip intro
	if DEBUG.get_val(DEBUG.SKIP_INTRO):
		IntroAndTitleScreen.queue_free()
	else:
		IntroAndTitleScreen.start()
		await IntroAndTitleScreen.on_complete

	# start at OS
	if DEBUG.get_val(DEBUG.SKIP_OFFICE_INTRO):
		current_layer = LAYER.OS_lAYER	
		return
		
	# apply fast forward
	current_layer = LAYER.CELLBLOCK_LAYER		
	CellScene.start( DEBUG.get_val(DEBUG.OFFICE_SKIP_ANIMATION) )
# -----------------------------------			

# -----------------------------------	
func assign_debugs() -> void:
	# IS PRODUCTION
	DEBUG.assign(DEBUG.IS_PRODUCTION_BUILD, is_production_build)		
	
	# GRAPHICS
	DEBUG.assign(DEBUG.START_AT_FULLSCREEN, start_at_fullscreen)

	# GRAPHICS
	DEBUG.assign(DEBUG.AUDIO_MUTE, audio_mute)	
	
	# progress 
	DEBUG.assign(DEBUG.DEBUG_STORY_PROGRESS, debug_story_progress)	
	DEBUG.assign(DEBUG.DEBUG_USER_PROFILE_REF, user_profile_ref)
	DEBUG.assign(DEBUG.DEBUG_CURRENT_STORY_VAL, skip_to_chapter)
		
	# save files
	DEBUG.assign(DEBUG.NEW_SYSTEM_FILE, false)	
	DEBUG.assign(DEBUG.NEW_PROGRESS_FILE, false)	
	DEBUG.assign(DEBUG.NEW_PERSISTANT_FILE, false)
	DEBUG.assign(DEBUG.NEW_QUICKSAVE_FILE, false)	

	# skips
	DEBUG.assign(DEBUG.SKIP_SPLASH, skip_splash)	
	DEBUG.assign(DEBUG.SKIP_INTRO, skip_intro)
	
	# office
	DEBUG.assign(DEBUG.SKIP_OFFICE_INTRO, skip_office_intro)
	DEBUG.assign(DEBUG.OFFICE_SKIP_ANIMATION, office_skip_animation)
	
	# intro
	DEBUG.assign(DEBUG.INTRO_SKIP_LOGO, intro_skip_logo)
	DEBUG.assign(DEBUG.INTRO_SKIP_TITLE, intro_skip_title)	
	DEBUG.assign(DEBUG.INTRO_SKIP_SEQUENCE, intro_skip_sequence)
	DEBUG.assign(DEBUG.INTRO_SKIP_STARTAT, intro_skip_start_at)
	
	# os
	DEBUG.assign(DEBUG.OS_SKIP_TO_GAME, os_skip_to_game)	
	DEBUG.assign(DEBUG.OS_SKIP_BOOT, os_skip_boot)
	DEBUG.assign(DEBUG.OS_APP_FAST_LOAD, os_app_fast_load)
	
	# app
	DEBUG.assign(DEBUG.APP_SKIP_LOADING_SCREEN, stdr_skip_titlescreen)	
	DEBUG.assign(DEBUG.APP_SKIP_TITLESCREEN, stdr_skip_loadingscreen)	
	
	# gameplayloop
	DEBUG.assign(DEBUG.GAMEPLAY_SHOW_DEBUG_MENU, show_debug_menu)
	DEBUG.assign(DEBUG.GAMEPLAY_SKIP_SETUP_PROGRSS, skip_setup_progress)	
	DEBUG.assign(DEBUG.GAMEPLAY_START_AT_RING_LEVEL, start_at_ring_level)	
	DEBUG.assign(DEBUG.GAMEPLAY_SKIP_OBJECTIVES, skip_objectives)
	DEBUG.assign(DEBUG.GAMEPLAY_ENABLE_SCP_DEBUG, enable_scp_debug)
	DEBUG.assign(DEBUG.GAMPELAY_ALL_ROOMS_AVAILABLE, all_rooms_available)
	DEBUG.assign(DEBUG.GAMEPLAY_MAX_ENERGY, max_energy)
	DEBUG.assign(DEBUG.GAMEPLAY_ALL_RESOURCES, all_resources)
	
	# EVENTS
	DEBUG.assign(DEBUG.GAMEPLAY_EVENTS_SKIP_INITIAL_CONTAINMENT, skip_initial_containment)
	DEBUG.assign(DEBUG.GAMEPLAY_EVENTS_SKIP_BREACH_EVENTS, skip_breach_events)
	DEBUG.assign(DEBUG.GAMEPLAY_EVENTS_SKIP_CONTAINED_EVENTS, skip_contained_events)
	
	# staff
	DEBUG.assign(DEBUG.STAFF_DEBUG, staff_debug)
	DEBUG.assign(DEBUG.STAFF_XP_REQUIRED_FOR_PROMOTION, xp_needed_for_promotion if !is_production_build else 10)			
	DEBUG.assign(DEBUG.STAFF_STARTING_RESEARCHERS, staff_starting_researchers)	
	DEBUG.assign(DEBUG.STAFF_STARTING_ADMIN, staff_starting_admin)	
	DEBUG.assign(DEBUG.STAFF_STARTING_SECURITY, staff_starting_security)	
	DEBUG.assign(DEBUG.STAFF_STARTING_DCLASS, staff_starting_dclass)	

	DEBUG.assign(DEBUG.STAFF_MTF_ALPHA, mtf_alpha)	
	DEBUG.assign(DEBUG.STAFF_MTF_BRAVO, mtf_bravo)	
	DEBUG.assign(DEBUG.STAFF_MTF_DELTA, mtf_delta)
# -----------------------------------	

# -----------------------------------	
func use_transition(duration:float = 1.3) -> void:
	TransitionScreen.start(duration, true)	
	await U.set_timeout(duration * 0.5)
# -----------------------------------	

# -----------------------------------	
func on_mouse_icon_update(mouse_icon:GBL.MOUSE_ICON) -> void:
	if is_node_ready():
		match mouse_icon:
			GBL.MOUSE_ICON.CURSOR:
				MousePointer.texture = mouse_cursor
			GBL.MOUSE_ICON.BUSY:
				MousePointer.texture = mouse_busy
			GBL.MOUSE_ICON.POINTER:
				MousePointer.texture = mouse_pointer
# -----------------------------------	

# -----------------------------------
func get_max_resolution():
	var display_index = DisplayServer.window_get_current_screen()
	return DisplayServer.screen_get_size(display_index)
# -----------------------------------

# -----------------------------------	
func toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		on_fullscreen_update(Vector2(1280, 720))
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)	
		on_fullscreen_update( get_max_resolution() )
# -----------------------------------	

# -----------------------------------	
func on_note_update(new_val:Dictionary) -> void:
	if !is_node_ready():return
	note = new_val
	if !note.is_empty():
		print("NOTE: ", note)
	has_note = !note.is_empty()
	NoteBtn.modulate.a = 1 if has_note else 0.2
# -----------------------------------	

# -----------------------------------	
func on_fullscreen_update(use_resolution:Vector2i) -> void:
	for node in get_children():
		if node is SubViewport:
			node.size = use_resolution	

	# start children nodes
	var screen_size = DisplayServer.screen_get_size()
	var window_position = (screen_size - use_resolution) / 2
	DisplayServer.window_set_size(use_resolution)
	DisplayServer.window_set_position(window_position, DisplayServer.get_primary_screen())			
	
	GBL.trigger_fullscreen_prechange()
	await U.tick()
	
	# set as reference
	GBL.game_resolution = use_resolution
	
	match DisplayServer.window_get_mode():
		DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			Output.stretch_mode = TextureRect.STRETCH_SCALE
			Output.size = screen_size
			Output.custom_minimum_size = screen_size
			GBL.update_fullscreen_mode(true)
		DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
			Output.stretch_mode = TextureRect.STRETCH_KEEP
			GBL.update_fullscreen_mode(false)
			
# -----------------------------------	

# -----------------------------------	
func switch_to_node(use_texture:TextureRect) -> void:
	var use_crt_effect:bool = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].graphics.shaders.crt_effect

	for node in [CellTextureRect, OsTextureRect, ArticleTextureRect]:
		if node == use_texture:
			node.show()
		else: 
			node.hide()		

	match use_texture:
		CellTextureRect:
			no_shader_effects()
		OsTextureRect:
			if use_crt_effect:
				apply_shader_effects()
			else:
				no_shader_effects()
		ArticleTextureRect:
			if use_crt_effect:
				apply_shader_effects()
			else:
				no_shader_effects()
	
# -----------------------------------	

# -----------------------------------
func on_current_layer_update() -> void:
	if !is_node_ready():return
	
	# first, deactivate to save resources
	for node in [CellScene, OsScene, ArticleScene]:
		node.set_process(false)
		node.set_physics_process(false)		
		
	# then activate the one that's relevant
	match current_layer:
		# -----------
		LAYER.OS_lAYER:
			# activate
			OsScene.set_process(true)
			OsScene.set_physics_process(true)
			OsScene.switch_to()
			#MousePointer.show()

			# start scene
			if !OsScene.has_started:
				OsScene.start()	
				
			switch_to_node(OsTextureRect)
			
			OsScene.show()
			for node in [ CellScene, ArticleScene]:
				node.hide()
							
			# update audio
			OS_AUDIO.change_bus(OS_AUDIO.CHANNEL.MAIN)

		# -----------
		LAYER.CELLBLOCK_LAYER:
			# activate
			CellScene.set_process(true)
			CellScene.set_physics_process(true)
			CellScene.switch_to()
			#MousePointer.hide()

			# switch nodes
			switch_to_node(CellTextureRect)
			for node in [ OsScene, CellScene, ArticleScene]:
				node.show()
						
			# update audio
			OS_AUDIO.change_bus(OS_AUDIO.CHANNEL.REVERB)

		# -----------
		LAYER.SCP_LAYER:
			# activate
			ArticleScene.set_process(true)
			ArticleScene.set_physics_process(true)
			ArticleScene.switch_to()
			#MousePointer.hide()
			
			# switch nodes
			switch_to_node(ArticleTextureRect)
			ArticleTextureRect.show()
			for node in [ CellScene, OsScene]:
				node.hide()	
				
			# update audio
			# OS_AUDIO.change_bus_channel(OS_AUDIO.CHANNEL.REVERB)

# -----------------------------------	

# -----------------------------------		
func update_and_save_user_profile(user_profile_data:Dictionary) -> void:
	# save file...
	FS.save_file(FS.FILE.USER_PROFILE, user_profile_data)	
	# then push to global space
	GBL.active_user_profile = user_profile_data		
# -----------------------------------		

# -----------------------------------		SHADER STUFF
func duplicate_shader_defaults() -> void:
	for item in shader_arr:
		var node:Control = item[0]
		var key:String = item[1]
		
		shader_defaults[key].node = node
		shader_defaults[key].material = node.material
		shader_defaults[key].shader = node.material.shader
		
func duplicate_colorrect_defaults() -> void:
	for item in color_rect_arr:
		var node:Control = item[0]
		var key:String = item[1]
		
		colorrect_defaults[key].node = node
		colorrect_defaults[key].color = node.color
# -----------------------------------	

# -----------------------------------	
func add_all_shaders() -> void:
	for item in shader_arr:		
		var node:Control = item[0]
		var key:String = item[1]
		
		node = shader_defaults[key].node
		node.material = shader_defaults[key].material
		node.material.shader = shader_defaults[key].shader
# -----------------------------------	

# -----------------------------------	
func remove_all_shaders() -> void:
	for node in shader_list:
		node.material = null
# -----------------------------------	

# -----------------------------------	
func set_monitor_overlay(state:bool) -> void:
	for node in color_rect_list:
		if state:
			node.show()
		else:
			node.hide()
# -----------------------------------	

# -----------------------------------	
func no_shader_effects(instant:bool = false) -> void:	
	await use_full_shader_settings(false, instant)
# -----------------------------------	

# -----------------------------------	
func apply_shader_effects(instant:bool = false) -> void:		
	await use_full_shader_settings(true, instant)		
# -----------------------------------	

# -----------------------------------	
func use_full_shader_settings(state:bool, instant:bool = false) -> void:
	var duration:float = 0.7 if !instant else 0
	
	# restore colors
	for item in color_rect_arr:
		var node:Control = item[0]
		var key:String = item[1]
		var color:Color = colorrect_defaults[key].color if state else 0
		U.tween_node_property(node, 'color:a', color.a, duration)
	
	# restores bend amount
	for item in [ [ScreenBendTextureRect, "bend"], [FinalCompositeTextureRect, "final"] ]:
		var node:Control = item[0]
		var key:String = item[1]
		var material_dupe = shader_defaults[key].material.duplicate(true)
		var new_amount:float = material_dupe.get_shader_parameter("bend_amount") if state else 0
		node.material = material_dupe

		U.tween_range(material_dupe.get_shader_parameter("bend_amount"), new_amount, duration, func(val:float) -> void:
			material_dupe.set_shader_parameter("bend_amount", val)
		).finished
		
	for item in [ [BorderShaderTextureRect, "border"] ]:
		var node:Control = item[0]
		var key:String = item[1]
		var material_dupe = shader_defaults[key].material.duplicate(true)
		var new_amount_top:float = material_dupe.get_shader_parameter("top_bottom_border_pixels") if state else 0
		var new_amount_sides:float = material_dupe.get_shader_parameter("left_right_border_pixels") if state else 0

		node.material = material_dupe

		U.tween_range(material_dupe.get_shader_parameter("top_bottom_border_pixels"), new_amount_top, duration, func(val:float) -> void:
			material_dupe.set_shader_parameter("top_bottom_border_pixels", val)
		).finished		
		
		await U.tween_range(material_dupe.get_shader_parameter("left_right_border_pixels"), new_amount_sides, duration, func(val:float) -> void:
			material_dupe.set_shader_parameter("left_right_border_pixels", val)
		).finished						
# -----------------------------------	

# -----------------------------------	
func on_shader_profile_update() -> void:
	match shader_profile:
		SHADER_PROFILE.NONE:
			remove_all_shaders()
			set_monitor_overlay(false)
		SHADER_PROFILE.ALL:
			add_all_shaders()
			set_monitor_overlay(true)
# -----------------------------------	

# -----------------------------------	
func on_control_input_update(input_data:Dictionary) -> void:	
	if !is_node_ready():return
	var key:String = input_data.key	
	GBL
	match key:
		"N":
			if has_note:
				print(note)
		"M":
			if has_message:
				print("open message")
# -----------------------------------				

# -----------------------------------	
func on_process_update(delta: float) -> void:
	var mouse_pos:Vector2 = get_global_mouse_position()
	GBL.mouse_pos = mouse_pos
	MousePointer.position = mouse_pos - Vector2(4, 0)
# -----------------------------------	
