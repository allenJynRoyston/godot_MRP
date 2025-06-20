extends MouseInteractions
class_name Layout

@onready var BtnControls:Control = $BtnControl
@onready var Taskbar:Control = $Taskbar
@onready var PauseContainer:PanelContainer = $PauseContainer
@onready var TransitionScreen:Control = $TransitionScreen
@onready var RunningAppsContainer:Control = $RunningAppsContainer

@onready var StartOptionControl:Control = $StartOptionControl
@onready var StartOptionsList:VBoxContainer = $StartOptionControl/PanelContainer/MarginContainer/VBoxContainer/MarginContainer/OptionsContainer
@onready var StartOptionStartBtn:Control = $StartOptionControl/PanelContainer/MarginContainer/VBoxContainer/StartBtn



@onready var DesktopGrid:Control =  $Desktop/MarginContainer/DesktopGrid
@onready var LoginContainer:PanelContainer = $NodeControl/LoginContainer
@onready var Installer:PanelContainer = $NodeControl/Installer
@onready var NotificationContainer:PanelContainer = $NodeControl/NotificationContainer

@onready var HeaderControls:Control = $HeaderControls
@onready var HeaderPanel:PanelContainer = $HeaderControls/PanelContainer
@onready var HeaderMargin:MarginContainer = $HeaderControls/PanelContainer/MarginContainer
@onready var TaskbarBtn:BtnBase = $HeaderControls/PanelContainer/MarginContainer/VBoxContainer/TaskbarBtn

const AppItemPreload:PackedScene = preload("res://Scenes/Main/parts/OS/AppItem/AppItem.tscn")
const SiteDirectorTrainingAppPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/SiteDirectorTrainingApp/SiteDirectorTrainingApp.tscn")
const SiteDirectorTrainingModsAppPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/ModApp/ModApp.tscn")
const EmailAppPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/EmailApp/EmailApp.tscn")
const MediaPlayerMiniAppPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/MediaPlayerMiniApp/MediaPlayerMiniApp.tscn")
const TaskBarMenuAppPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/TaskbarMenuApp/TaskbarMenuApp.tscn")
const ContextMenuAppPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/ContextMenuApp/ContextMenuApp.tscn")
const TextFileAppPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/TextFileApp/TextFileApp.tscn")
const RecycleBinAppPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Apps/RecycleBin/RecycleBin.tscn")

const CheckboxPreload:PackedScene = preload("res://UI/Buttons/Checkbox/Checkbox.tscn")

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


var desktop_itemlist:Array = []
var previous_desktop_index:int = 0
#endregion
# -----------------------------------

# -----------------------------------
#region LOCAL DATA
var app_list:Array[Dictionary] = [
	# ----------
	{
		"details": {
			"title": "LOGOUT",
			"icon": SVGS.TYPE.BACK,
		},
		"installed": func() -> bool:
			return true,
		"events": {
			"open": func(data:Dictionary) -> void:
				pause(),
		}
	},
	# ----------
		
	## ----------
	#{
		#"details": {
			#"ref": APPS.SDT_TUTORIAL,
			#"title": "Tutorial Program",
			#"icon": SVGS.TYPE.EXE_FILE,
			#"app": SiteDirectorTrainingAppPreload,
		#},
		#"installed": func() -> bool:
			#return true,
		#"events": {
			#"open": func(data:Dictionary) -> void:
				#open_app(data, {"is_tutorial": true}),
			#"close": func() -> void:
				#close_app(APPS.SDT_TUTORIAL),
		#}
	#},
	## ----------
	
	# ----------
	{
		"details": {
			"ref": APPS.SDT_FULL,
			"title": "Sim Site Director 2000",
			"icon": SVGS.TYPE.EXE_FILE,
			"app": SiteDirectorTrainingAppPreload,
		},
		"installed": func() -> bool:
			return APPS.SDT_FULL in apps_installed,
		"events": {
			"open": func(data:Dictionary) -> void:
				if data.ref not in running_apps_list.map(func(i): return i.ref):
					var res:Dictionary = await open_options([
						{
							"title": "TUTORIAL MODE", "key": "is_tutorial", "value": true
						}
					])
					if !res.continue:
						return
					print(res.properties)
					open_app(data, res.properties)
					return
					
				open_app(data),
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

var running_apps_list:Array = []
var app_in_fullscreen:bool = false 

var control_pos:Dictionary
var freeze_inputs:bool = false : 
	set(val):
		freeze_inputs = val
		on_freeze_inputs_update()
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
		
	# hide
	StartOptionControl.hide()
	PauseContainer.hide()
	
	# show
	LoginContainer.show()
	
	# setup
	Taskbar.onBack = func() -> void:
		if freeze_inputs or Taskbar.is_busy:return
		toggle_show_taskbar(false)
				
	TaskbarBtn.onClick = func() -> void:
		if freeze_inputs or Taskbar.is_busy:return		
		toggle_show_taskbar()
		
	StartOptionStartBtn.onClick = func() -> void:
		on_confirm.emit(true)		
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
		"hide": -HeaderMargin.size.y
	}
		
	await U.set_timeout(1.0 if !skip_boot else 0)
	if skip_boot:
		LoginContainer.end()
	else:
		LoginContainer.start()
	await LoginContainer.is_complete	
		
	await render_desktop_icons()	
	await U.set_timeout(0.3 if !skip_boot else 0)
	await BtnControls.reveal(true)
	
	if skip_to_game:
		var app:Dictionary = find_in_app_list(APPS.SDT_TUTORIAL)
		app.events.open.call(app.details)
		
func return_to_desktop() -> void:
	currently_running_app = null	
	PauseContainer.hide()
	await toggle_show_taskbar(false)
	BtnControls.reveal(true)
	
func return_to_app(ref:int) -> void:
	PauseContainer.hide()
	await toggle_show_taskbar(false)
	currently_running_app = running_apps_list.filter(func(i): return i.ref == ref)[0].node
	currently_running_app.unpause()
# -----------------------------------	

# -----------------------------------	
func on_simulated_busy_update() -> void:	
	if !is_node_ready():return
	# DOES NOTHING RIGHT NOW
# -----------------------------------		

# -----------------------------------		
func simulate_wait(duration:float, show_busy:bool = true) -> void:
	if show_busy and duration > 0:
		simulate_busy = true
		
	await U.set_timeout(duration * 1.0)
	
	if show_busy and duration > 0:
		simulate_busy = false
# -----------------------------------		

# -----------------------------------
func open_options(arr:Array = []) -> Dictionary:
	StartOptionControl.show()
	
	var properties:Dictionary = {}
	
	for child in StartOptionsList.get_children():
		child.queue_free()
		
	for item in arr:
		var new_checkbox:Control = CheckboxPreload.instantiate()
		properties[item.key] = item.value
		
		new_checkbox.title = item.title
		new_checkbox.no_bg = true
		new_checkbox.checkbox_color = Color(0, 0, 0, 1)
		new_checkbox.is_checked = item.value
		new_checkbox.onClick = func():
			new_checkbox.is_checked = !new_checkbox.is_checked
			properties[item.key] = new_checkbox.is_checked
		StartOptionsList.add_child(new_checkbox)
	
	await U.tick()
	set_btn_to_app_open_mode()
	
	var res:bool = await on_confirm
	StartOptionControl.hide()
	set_btn_to_desktop_mode()
	return {"continue": res, "properties": properties}

func find_in_app_list(ref:APPS) -> Dictionary:
	return app_list.filter(func(i): return ("ref" in i.details) and (i.details.ref == ref))[0]
	
func installing_app_start(ref:APPS) -> void:
	if ref not in apps_installing:
		apps_installing.push_back(ref)

func install_app_complete(ref:APPS) -> void:
	apps_installing.erase(ref)
	if ref not in apps_installed:
		apps_installed.push_back(ref)
	await render_desktop_icons()
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
func open_app(data:Dictionary, options:Dictionary = {}) -> void:
	if simulate_busy or freeze_inputs:return
	
	# hide button controls
	freeze_inputs = true	
	await BtnControls.reveal(false)	
	
	# grab background image for pause continaer	
	PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))	

	# ... now open the "app"
	if data.ref not in running_apps_list.map(func(i): return i.ref):
		simulate_busy = true
		var app:Dictionary = find_in_app_list(data.ref) 
		var new_node:Control = data.app.instantiate()
		var previously_loaded:bool = data.ref in already_loaded
		
		# added to running apps list
		running_apps_list.push_back({
			"ref": data.ref, 
			"node": new_node
		})		
		
		# add to already loaded list
		if data.ref not in already_loaded:
			already_loaded.push_back(data.ref)
		
		# pass properties
		if "events" in app:
			new_node.events = app.events
		new_node.options = options
		new_node.in_fullscreen = true
		new_node.details = app.details
		
		# add child 
		RunningAppsContainer.add_child( new_node )
		
		# add to taskbar
		Taskbar.add_item({
			"title": data.title,
			"icon": data.icon,
			"ref": data.ref,
			"node": new_node,
			"events": app.events
		}) 
		
		# start app
		await U.tick()
		currently_running_app = new_node
		await new_node.start( previously_loaded or DEBUG.get_val(DEBUG.OS_APP_FAST_LOAD) )
	
		
	else:
		currently_running_app = running_apps_list.filter(func(i): return i.ref == data.ref)[0].node
		currently_running_app.unpause()
	
	simulate_busy = false
	freeze_inputs = false		
	
func close_app(ref:int) -> void:
	var filtered:Array = running_apps_list.filter(func(item): return item.ref == ref)
	if !filtered.is_empty():
		# quit node
		filtered[0].node.queue_free()
		# remove from taskbar
		Taskbar.remove_item(ref)
		
	running_apps_list = running_apps_list.filter(func(item): return item.ref != ref)
	if running_apps_list.is_empty():
		currently_running_app = null
	

func on_currently_running_app_update() -> void:
	TransitionScreen.start(0.2, true)
	# hide/show any desktop icons 
	for node in DesktopGrid.get_children():
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
# -----------------------------------	
func set_btn_to_desktop_mode() -> void:
	BtnControls.offset = Vector2(5, 5)

	await U.tick()
	BtnControls.directional_pref = "LR"
	BtnControls.itemlist = desktop_itemlist
	BtnControls.item_index = previous_desktop_index
	
	BtnControls.hide_b_btn = true
	
	BtnControls.onBack = func() -> void:
		pass
			
	BtnControls.onAction = func() -> void:
		selected_app.events.open.call(selected_app.details)	
				


func set_btn_to_app_open_mode() -> void:
	previous_desktop_index = BtnControls.item_index
	BtnControls.offset = Vector2(5, 5)
	
	BtnControls.hide_b_btn = false
			
	var itemlist:Array = []
	for item in StartOptionsList.get_children():
		itemlist.push_back(item)
	itemlist.push_back(StartOptionStartBtn)
	
	await U.tick()
	BtnControls.directional_pref = "UD"
	BtnControls.itemlist = itemlist 
	BtnControls.item_index = 0
	
	BtnControls.onBack = func() -> void:
		on_confirm.emit(false)
		set_btn_to_desktop_mode()
		
	BtnControls.onAction = func() -> void:
		pass
	


var selected_app:Dictionary
func render_desktop_icons(wait_time:float = 1.0) -> void:
	freeze_inputs = true
	await BtnControls.reveal(false)
	
	desktop_itemlist = []

	for child in DesktopGrid.get_children():
		child.free()
			
	
	for app in app_list:
		if app.installed.call():
			var new_node:Control = AppItemPreload.instantiate()	
			DesktopGrid.add_child(new_node)
			desktop_itemlist.push_back(new_node)
			new_node.data = app.details

			new_node.onFocus = func(node:Control) -> void:
				for child in DesktopGrid.get_children():
					child.is_selected = child == node
					if child == node:
						selected_app = app
				
	# sets 
	set_btn_to_desktop_mode()
	await BtnControls.reveal(true)
	freeze_inputs = false
# -----------------------------------
#endregion
# -----------------------------------

func on_freeze_inputs_update() -> void:
	if !is_node_ready():return
	TaskbarBtn.is_disabled = freeze_inputs
	

# -----------------------------------
func toggle_show_taskbar(state:bool = !show_taskbar) -> void:
	show_taskbar = state
	freeze_inputs = true
	
	for app in RunningAppsContainer.get_children():
		await app.pause() if state else await app.unpause()
		
	TaskbarBtn.title = "TASKBAR"	if show_taskbar else "RETURN"
	TaskbarBtn.icon = SVGS.TYPE.CLEAR if show_taskbar else SVGS.TYPE.ARROW_DOWN
		
	
	if show_taskbar:		
		if currently_running_app == null:
			PauseContainer.background_image = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))
		PauseContainer.show()	
		Taskbar.set_show_taskbar(show_taskbar)
		await BtnControls.reveal(false)	
		
		
	if !show_taskbar:
		await Taskbar.set_show_taskbar(false)		
		PauseContainer.hide()
		
		if currently_running_app == null:
			await BtnControls.reveal(true)

	freeze_inputs = false		
# -----------------------------------

# ------------------------------------------
func on_control_input_update(input_data:Dictionary) -> void:
	if !is_node_ready() or freeze_inputs or Taskbar.is_busy:return		

	match input_data.key:
		"BACKSPACE":
			toggle_show_taskbar()
# ------------------------------------------
