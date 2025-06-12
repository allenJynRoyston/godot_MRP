extends MouseInteractions
class_name Layout

@onready var Background:TextureRect = $BG
@onready var PauseContainer:PanelContainer = $PauseContainer
@onready var HeaderControls:Control = $HeaderControls
@onready var HeaderPanel:PanelContainer = $HeaderControls/PanelContainer
@onready var HeaderMargin:MarginContainer = $HeaderControls/PanelContainer/MarginContainer
@onready var TaskbarBtn:BtnBase = $HeaderControls/PanelContainer/MarginContainer/VBoxContainer/TaskbarBtn
@onready var NewMessageBtn:BtnBase = $HeaderControls/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NewMessageBtn
@onready var NewEmailBtn:BtnBase = $HeaderControls/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NewEmailBtn

@onready var Taskbar:Control = $Taskbar
@onready var BackgroundWindow:PanelContainer = $MarginContainer/BackgroundWindow
@onready var DesktopIconContainer:Control = $Desktop/MarginContainer/HBoxContainer/VBoxContainer/DesktopIconContainer
@onready var RecycleBin:PanelContainer = $MarginContainer/Desktop/MarginContainer/HBoxContainer/VBoxContainer2/RecycleBin

@onready var BtnControls:Control = $BtnControl
@onready var RunningAppsContainer:Control = $RunningAppsContainer

@onready var LoginContainer:PanelContainer = $NodeControl/LoginContainer
@onready var Installer:PanelContainer = $NodeControl/Installer
@onready var NotificationContainer:PanelContainer = $NodeControl/NotificationContainer


@export var background_subviewport:SubViewport

const AppItemPreload:PackedScene = preload("res://Scenes/OSRoot/parts/OS/AppItem/AppItem.tscn")
const SiteDirectorTrainingAppPreload:PackedScene = preload("res://Scenes/OSRoot/parts/OS/Apps/SiteDirectorTrainingApp/SiteDirectorTrainingApp.tscn")
const SiteDirectorTrainingModsAppPreload:PackedScene = preload("res://Scenes/OSRoot/parts/OS/Apps/ModApp/ModApp.tscn")
const EmailAppPreload:PackedScene = preload("res://Scenes/OSRoot/parts/OS/Apps/EmailApp/EmailApp.tscn")
const MediaPlayerMiniAppPreload:PackedScene = preload("res://Scenes/OSRoot/parts/OS/Apps/MediaPlayerMiniApp/MediaPlayerMiniApp.tscn")
const TaskBarMenuAppPreload:PackedScene = preload("res://Scenes/OSRoot/parts/OS/Apps/TaskbarMenuApp/TaskbarMenuApp.tscn")
const ContextMenuAppPreload:PackedScene = preload("res://Scenes/OSRoot/parts/OS/Apps/ContextMenuApp/ContextMenuApp.tscn")
const TextFileAppPreload:PackedScene = preload("res://Scenes/OSRoot/parts/OS/Apps/TextFileApp/TextFileApp.tscn")
const RecycleBinAppPreload:PackedScene = preload("res://Scenes/OSRoot/parts/OS/Apps/RecycleBin/RecycleBin.tscn")

enum APPS {
	SDT_TUTORIAL, SDT_FULL, SDT_MODS, README, SETTINGS, MUSIC_PLAYER, EMAIL, MEDIA_PLAYER_MINI, 
	BIN, CONTEXT_MENU, TASKBAR_MENU, RECYCLE_BIN
}

enum MODS {
	NONE,
	DIFFICULTY_EASY, DIFFICULTY_NORMAL, DIFFICULTY_STORY,
	PRODUCTION_ONE, PRODUCTION_TWO, PRODUCTION_THREE,
	ECONOMY_ONE, ECONOMY_TWO, ECONOMY_THREE,
}

enum PLAYLIST {
	TRACK_1, TRACK_2, TRACK_3
}


# -----------------------------------
#region SAVABLE DATA
var settings:Dictionary ={
	"video": {
		"MSAA": Viewport.MSAA_DISABLED,
		"SSAA": Viewport.SCREEN_SPACE_AA_DISABLED,
		"resolution": Vector2(1280, 720),
		"full_screen": DisplayServer.WINDOW_MODE_WINDOWED
	},
	"sound_enabled": {
		"fx": true,
		"music": true
	},
	"sound_volume": {
		"fx": 100,
		"music": 100,	
	},
	"controls": {
		
	}
}

var event_switches:Dictionary = {
	"show_status_on_boot": true
}

var app_positions:Dictionary = {
	APPS.SDT_TUTORIAL: Vector2(0, 0),
	APPS.SDT_FULL: Vector2(0, 0),
	APPS.SDT_MODS: Vector2(0, 0),
	APPS.SETTINGS: Vector2(0, 0),
	APPS.README: Vector2(0, 0),
	APPS.EMAIL: Vector2(0, 0),
	APPS.MUSIC_PLAYER: Vector2(0, 0),
}

var default_app_positions:Dictionary = app_positions.duplicate()

var tracklist_unlocks:Dictionary = {
	PLAYLIST.TRACK_1: true,
	PLAYLIST.TRACK_2: true,
	PLAYLIST.TRACK_3: true
}

var modifications_unlocked:Dictionary = {
	MODS.DIFFICULTY_EASY: true,
	MODS.DIFFICULTY_NORMAL: true,
	MODS.DIFFICULTY_STORY: false,
	# ------------------------------
	MODS.PRODUCTION_ONE: true,
	MODS.PRODUCTION_TWO: true,
	MODS.PRODUCTION_THREE: false,
	# ------------------------------
	MODS.ECONOMY_ONE: true,
	MODS.ECONOMY_TWO: true,
	MODS.ECONOMY_THREE: false	
}

var mod_settings:Array = []
var installed_mods:Array = ["00"]  #"00" makes easy "marked" in mods
var read_emails:Array = []
#var in_recycle_bin:Array = []
var apps_installed:Array = [] 
var apps_installing:Array = []
var has_started:bool = false
#endregion
# -----------------------------------

# -----------------------------------
#region LOCAL DATA
var app_list:Array[Dictionary] = [
	# ----------
	{
		"details": {
			"ref": APPS.SDT_TUTORIAL,
			"title": "Tutorial Program",
			"icon": SVGS.TYPE.EXE_FILE,
			"app": SiteDirectorTrainingAppPreload,
		},
		"installed": func() -> bool:
			return true,
		"events": {
			"open": func(data:Dictionary) -> void:
				open_app(data, {"is_tutorial": true}),
			"close": func() -> void:
				close_app(APPS.SDT_TUTORIAL),
		}
	},
	# ----------
	
	# ----------
	{
		"details": {
			"ref": APPS.SDT_FULL,
			"title": "Site Director Training Program",
			"icon": SVGS.TYPE.EXE_FILE,
			"app": SiteDirectorTrainingAppPreload,
		},
		"installed": func() -> bool:
			return APPS.SDT_FULL in apps_installed,
		"events": {
			"open": func(data:Dictionary) -> void:
				open_app(data),
			"close": func() -> void:
				close_app(APPS.SDT_FULL),
		}
	},
	# ----------	
	
	# ----------
	{
		"details": {
			"ref": APPS.EMAIL,
			"title": "Email",
			"icon": SVGS.TYPE.EMAIL,
			"app": EmailAppPreload,
		},
		"installed": func() -> bool:
			return true,
		"events": {
			"open": func(data:Dictionary) -> void:
				open_app(data),
			"close": func() -> void:
				close_app(APPS.EMAIL),
			"install": func(data:Dictionary) -> void:
				Installer.add_item(data.installer_data),
			"fetch_read_emails": func() -> Array:
				return read_emails,
			"mark": func(index:int) -> void:
				if index not in read_emails:
					read_emails.push_back(index)
				save_state(0.2),
					
		},
	},
	# ----------
	
	# ----------
	{
		"details": {
			"ref": APPS.MUSIC_PLAYER,
			"title": "Music Player",
			"icon": SVGS.TYPE.MUSIC
		},
		"installed": func() -> bool:
			return true,
		"events": {
			"open": func(data:Dictionary) -> void:
				# open music player, no music selected
				GBL.music_data = {
					"track_list": music_track_list,
					"selected": 1,
				},
		},
	},
	# ----------
	
	# ----------
	#{
		#"details": {
			#"ref": APPS.SDT_MODS,
			#"title": "Mods",
			#"icon": SVGS.TYPE.EXE_FILE,
			#"app": SiteDirectorTrainingModsAppPreload,
			#"app_props": {
				#"get_not_new": func() -> Array:
					#return mods_not_new,
				#"get_mod_settings": func() -> Array:
					#return mod_settings,
				#"get_modifications_unlocked": func() -> Dictionary:
					#return modifications_unlocked,
			#},
			#"app_events": {
				#"on_marked": func(updated_vals:Array) -> void:
					#mods_not_new = updated_vals
					#save_state(0),
			#}
		#},
		#"installed": func() -> bool:
			#return true, #APPS.SDT_MODS in apps_installed,
		#"events": {
			#"open": func(data:Dictionary) -> void:
				#open_app(data, false),
		#}
	#},	
	#{
		#"details": {
			#"ref": APPS.README,
			#"title": "IMPORTANT PLEASE READ",
			#"icon": SVGS.TYPE.TXT_FILE,
			#"app": TextFileAppPreload,
			#"app_props": {
				#"title": "URGENT",
				#"content": "Check your EMAILS!"
			#},					
		#},
		#"installed": func() -> bool:
			#return true,
		#"defaults": {
			#"pos_offset": Vector2(0, 0),
		#},
		#"events": {
			#"open": open_app
		#},
	#}	
]

var music_track_list:Array = [
	{
		"details": {
			"name": "ghost trick finale",
			"author": "capcom",
			"ref": PLAYLIST.TRACK_1,
		},
		"unlocked": func(data:Dictionary) -> bool:
			return tracklist_unlocks[data.ref],
		"file": preload("res://Media/mp3/ghost_trick_test_track.mp3")
	},
	{
		"details": {
			"name": "phoenix wright",
			"author": "capcom",
			"ref": PLAYLIST.TRACK_2,
		},
		"unlocked": func(data:Dictionary) -> bool:
			return tracklist_unlocks[data.ref],
		"file": preload("res://Media/mp3/phoenix wright.mp3")
	},
	{
		"details": {
			"name": "The Weeknd - Popular",
			"author": "Vidojean X Oliver Loenn Amapiano Remix",
			"ref": PLAYLIST.TRACK_3,
		},
		"unlocked": func(data:Dictionary) -> bool:
			return tracklist_unlocks[data.ref],
		"file": preload("res://Media/mp3/The Weeknd - Popular (Vidojean X Oliver Loenn Amapiano Remix).mp3")
	}							
]

var already_loaded:Array = []
var simulate_busy:bool = false : 
	set(val):
		simulate_busy = val
		on_simulated_busy_update()

var icon_focus_list:Array[Control] = []
#var window_focus_list:Array[Control] = [] : 
	#set(val):
		#window_focus_list = val
		#on_window_focus_list_update()
		
var running_apps_list:Array = []
var app_in_fullscreen:bool = false 

var top_level_icon:Control
#var top_level_window:Control : 
	#set(val):
		#top_level_window = val
		#set_node_selectable_state(top_level_window == null)

#var selected_index:int = 0: 
	#set(val):
		#selected_index = val
		#on_selected_index_update()
var control_pos:Dictionary
var btnlist:Array = []	
var freeze_inputs:bool = false
var show_taskbar:bool = false
		
var currently_running_app:Control : 
	set(val):
		currently_running_app = val
		on_currently_running_app_update()

var onBack:Callable = func() -> void:pass

signal on_confirm
#endregion
# -----------------------------------

#region local functions
# -----------------------------------
func _init() -> void:
	GBL.register_node(REFS.OS_LAYOUT, self)
	GBL.subscribe_to_control_input(self)
# -----------------------------------

# -----------------------------------
func _exit_tree() -> void:
	GBL.unregister_node(REFS.OS_LAYOUT)
	GBL.unsubscribe_to_control_input(self)
# -----------------------------------	

# -----------------------------------
func _ready() -> void:	
	super._ready()	
	hide()
	set_process(false)
	set_physics_process(false)	
	
	LoginContainer.show()
	
	PauseContainer.hide()
	
	Taskbar.onBack = func() -> void:
		toggle_show_taskbar(false)
	
	Background.texture = background_subviewport.get_texture()
	
	BtnControls.onBack = func() -> void:
		pause()
				
	TaskbarBtn.onClick = func() -> void:
		if freeze_inputs:return
		toggle_show_taskbar()
	

		#await GBL.find_node(REFS.DOOR_SCENE).play_next_sequence()

	
	#TaskbarBtn.is_disabled = true
# -----------------------------------

# -----------------------------------
func pause() -> void:
	freeze_inputs = true
	await BtnControls.reveal(false)
	onBack.call()	
	
func resume() -> void:
	await BtnControls.reveal(true)
	freeze_inputs = false
# -----------------------------------

# -----------------------------------
func start() -> void:
	var skip_boot:bool = DEBUG.get_val(DEBUG.OS_SKIP_BOOT)
	var skip_to_game:bool = DEBUG.get_val(DEBUG.OS_SKIP_TO_GAME)
	
	has_started = true
	load_state()	
	on_simulated_busy_update()
	
	control_pos[HeaderPanel] = {
		"show": 0,
		"hide": 40
	}
		
	await U.set_timeout(1.0 if !skip_boot else 0)
	if skip_boot:
		LoginContainer.end()
	else:
		LoginContainer.start()
	await LoginContainer.is_complete	
		
	await render_desktop_icons()	
	await U.set_timeout(0.3 if !skip_boot else 0)
	
	#Taskbar.set_show_taskbar(false)	
	#TaskbarBtn.is_disabled = false
	await BtnControls.reveal(true)			
	
	if skip_to_game:
		var app:Dictionary = find_in_app_list(APPS.SDT_TUTORIAL)
		app.events.open.call(app.details)
# -----------------------------------	

# -----------------------------------	
func on_simulated_busy_update() -> void:	
	if !is_node_ready():return
# -----------------------------------		

# -----------------------------------		
func simulate_wait(duration:float, show_busy:bool = true) -> void:
	if show_busy and duration > 0:
		simulate_busy = true
		#GBL.change_mouse_icon(GBL.MOUSE_ICON.BUSY)
		
	await U.set_timeout(duration * 1.0)
	
	if show_busy and duration > 0:
		simulate_busy = false
		#GBL.end_mouse_busy()
# -----------------------------------		

# -----------------------------------
func find_in_app_list(ref:APPS) -> Dictionary:
	return app_list.filter(func(i): return i.details.ref == ref)[0]
	
func installing_app_start(ref:APPS) -> void:
	if ref not in apps_installing:
		apps_installing.push_back(ref)

func install_app_complete(ref:APPS) -> void:
	apps_installing.erase(ref)
	if ref not in apps_installed:
		apps_installed.push_back(ref)
	render_desktop_icons(0)
	save_state()
# -----------------------------------
#endregion


# -----------------------------------
#region SAVE/LOAD
func save_state(duration:float = 0.2) -> void:
	var save_data:Dictionary = {
		"settings": settings,
		"read_emails": read_emails,
		"installed_mods": installed_mods,
		"tracklist_unlocks": tracklist_unlocks,
		"modifications_unlocked": modifications_unlocked,
		"event_switches": event_switches,
		"apps_installed": apps_installed,
		"mod_settings": mod_settings,
	}	
	FS.save_file(FS.FILE.SETTINGS, save_data)
	
	await simulate_wait(duration)

func load_state() -> void:
	var res:Dictionary = FS.load_file(FS.FILE.SETTINGS)		
	if res.success:
		restore_state(res.filedata.data)
		
func restore_state(restore_data:Dictionary = {}) -> void:
	var no_save:bool = DEBUG.get_val(DEBUG.NEW_SYSTEM_FILE) or restore_data.is_empty() 
	if no_save:
		print("No SYSTEM_FILE available: creating new one.")
	
	settings = restore_data.settings if !no_save else settings
	read_emails = restore_data.read_emails if !no_save else read_emails
	installed_mods = restore_data.installed_mods if !no_save else installed_mods
	tracklist_unlocks = restore_data.tracklist_unlocks if !no_save else tracklist_unlocks
	modifications_unlocked = restore_data.modifications_unlocked if !no_save else modifications_unlocked
	event_switches = restore_data.event_switches if !no_save else event_switches
	apps_installed = restore_data.apps_installed if !no_save else apps_installed
	mod_settings = restore_data.mod_settings if !no_save else mod_settings
	
#endregion		
# -----------------------------------

# -----------------------------------	
func take_background_snapshot() -> void:
	BtnControls.hide()
	HeaderPanel.hide()
	await U.tick()	
	PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))
	BtnControls.show()
	if currently_running_app == null:
		HeaderPanel.show()
# -----------------------------------	


# -----------------------------------	
func open_app(data:Dictionary, options:Dictionary = {}) -> void:
	if simulate_busy or freeze_inputs:return
	
	# hide button controls
	freeze_inputs = true	
	await BtnControls.reveal(false)	
	
	# grab background image for pause continaer	
	PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))	
	
	# ... now open the "app"
	if data.ref not in running_apps_list.map(func(i): return i.ref):		
		var app:Dictionary = find_in_app_list(data.ref) 
		var new_node:Control = data.app.instantiate()
		var previously_loaded:bool = data.ref in already_loaded
		running_apps_list.push_back({"ref": data.ref, "node": new_node})		

		if data.ref not in already_loaded:
			already_loaded.push_back(data.ref)
		
		# and events
		if "events" in app:
			new_node.events = app.events

		# start in fullscreen or not, pass previously loaded
		new_node.options = options
		new_node.fast_load = previously_loaded or DEBUG.get_val(DEBUG.OS_APP_FAST_LOAD)
		new_node.in_fullscreen = true
		new_node.onCloseBtn = func(node:Control, window_node:Control) -> void:			
			close_app(data.ref)
			
		# determines which container to add it  to
		RunningAppsContainer.add_child( new_node )
		
		Taskbar.add_item({
			"title": data.title,
			"icon": data.icon,
			"ref": data.ref,
			"node": new_node,
			"events": app.events
		}) 

		currently_running_app = new_node
		
		# adds a mock loading splash
		if !previously_loaded:
			await simulate_wait(0.2 if previously_loaded else 0.7)
		
		new_node.start()
		await new_node.is_ready
			
		#await U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].hide)
		
	else:
		currently_running_app = running_apps_list.filter(func(i): return i.ref == data.ref)[0].node
		currently_running_app.unpause()

	freeze_inputs = false		
	
func close_app(ref:int) -> void:	
	if running_apps_list.is_empty():return
	
	var node:Control = running_apps_list.filter(func(item): return item.ref == ref)[0].node
	running_apps_list = running_apps_list.filter(func(item): return item.ref != ref)
	
	if running_apps_list.size() == 0:
		currently_running_app = null		
		Taskbar.set_show_taskbar(false)
		PauseContainer.hide()
		BtnControls.reveal(true)
		toggle_show_taskbar(false)
	else:
		currently_running_app = null

	node.queue_free()
	Taskbar.remove_item(ref)

func on_currently_running_app_update() -> void:
	# hide/show any desktop icons 
	for node in DesktopIconContainer.get_children():
		if currently_running_app == null:
			node.show() 
		else: 
			node.hide()
	
	for app in RunningAppsContainer.get_children():
		if app == currently_running_app:
			app.show() 
		else:
			app.hide()
			
	if currently_running_app == null:
		RunningAppsContainer.hide()
	else:
		RunningAppsContainer.show()
		
# -----------------------------------	
#endregion
# -----------------------------------

# -----------------------------------
#region LIST AND NODE BEHAVIOR
## -----------------------------------	
#func set_node_selectable_state(state:bool, exclude = null) -> void:
	#if DesktopIconContainer != null:
		#for child in DesktopIconContainer.get_children():
			#if exclude != child:
				#child.is_selectable = state
## -----------------------------------			

# -----------------------------------			
#func set_desktop_hoverable_state(state:bool) -> void:
	#for child in DesktopIconContainer.get_children():
		#child.is_hoverable = state
## -----------------------------------			

# -----------------------------------
func sort_desktop_icons() -> void:	
	var context_menu_node:Control = null
	
	# first, repositions all desktop icons back to their default 
	app_positions = default_app_positions.duplicate()
	for node in DesktopIconContainer.get_children():
		node.pos_offset = app_positions[node.data.ref]
	
	# save
	save_state()
	
	# then close
	close_app(APPS.CONTEXT_MENU)
# -----------------------------------

# -----------------------------------	
func render_desktop_icons(wait_time:float = 1.0) -> void:
	freeze_inputs = true
	await simulate_wait(wait_time)
	
	var column_tracker := {}
	
	# remove and rerender icons, waitTime used to wait for changes
	for child in DesktopIconContainer.get_children():
		child.queue_free()
		
	icon_focus_list = []	
	await U.tick()
	btnlist = []
	
	for item in app_list:
		if item.installed.call():
			var new_node:Control = AppItemPreload.instantiate()	
			DesktopIconContainer.add_child(new_node)
			btnlist.push_back(new_node)
			new_node.pos_offset = app_positions[item.details.ref]
			new_node.data = item.details
				
			new_node.onFocus = func(node:Control) -> void:
				for child in DesktopIconContainer.get_children():
					child.is_selected = child == node
				
			new_node.onClick = func() -> void:
				item.events.open.call(item.details)
			
	BtnControls.directional_pref = "LR"
	BtnControls.itemlist = btnlist
	BtnControls.item_index = 0
	
	freeze_inputs = false
# -----------------------------------
#endregion
# -----------------------------------

# -----------------------------------
func set_pause_container(state:bool) -> void:
	if !is_node_ready():return
	RunningAppsContainer.show() if !state else RunningAppsContainer.hide()
# -----------------------------------

func on_show_taskbar_update() -> void:
	if !is_node_ready():return

# -----------------------------------
func toggle_show_taskbar(state:bool = !show_taskbar) -> void:		
	show_taskbar = state
	freeze_inputs = true
	
	for app in RunningAppsContainer.get_children():
		app.taskbar_is_open = state
	
	if show_taskbar:
		TaskbarBtn.title = "RETURN"
		TaskbarBtn.icon = SVGS.TYPE.CLEAR
		
		await BtnControls.reveal(false)	
		#await U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].hide)
		
		if currently_running_app == null:
			PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))			
	
		Taskbar.set_show_taskbar(show_taskbar)
		
		PauseContainer.show()	

	if !show_taskbar:
		TaskbarBtn.title = "TASKBAR"
		TaskbarBtn.icon = SVGS.TYPE.ARROW_DOWN

		U.tween_node_property(HeaderPanel, "position:y", control_pos[HeaderPanel].show)		
		await Taskbar.set_show_taskbar(false)		
		PauseContainer.hide()
		
		if currently_running_app == null:
			await BtnControls.reveal(true)
		await U.set_timeout(0.4)


	freeze_inputs = false		
# -----------------------------------

# ------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or freeze_inputs: return

	match input_data.key:
		"BACKSPACE":
			if Taskbar.is_busy:return
			toggle_show_taskbar()
# ------------------------------------------
