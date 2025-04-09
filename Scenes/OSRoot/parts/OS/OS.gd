extends MouseInteractions
class_name Layout

@onready var Taskbar:Control = $MarginContainer/Taskbar
@onready var RunningAppsContainer:Control = $MarginContainer/RunningAppsContainer
@onready var TaskbarAppsContainer:Control = $MarginContainer/TaskbarAppsContainer
@onready var FullScreenAppsContainer:Control = $MarginContainer/FullScreenAppsContainer
@onready var NotificationContainer:PanelContainer = $MarginContainer/NotificationContainer
@onready var BackgroundWindow:PanelContainer = $MarginContainer/BackgroundWindow
@onready var Installer:PanelContainer = $MarginContainer/Installer

@onready var DesktopIconContainer:Control = $MarginContainer/Desktop/MarginContainer/HBoxContainer/VBoxContainer/DesktopIconContainer
@onready var RecycleBin:PanelContainer = $MarginContainer/Desktop/MarginContainer/HBoxContainer/VBoxContainer2/RecycleBin

@export var skip_to_game:bool = false

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
	SDT, SDT_MODS, README, SETTINGS, MUSIC_PLAYER, EMAIL, MEDIA_PLAYER_MINI, 
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
	APPS.SDT: Vector2(0, 0),
	APPS.SDT_MODS: Vector2(0, 0),
	APPS.SETTINGS: Vector2(0, 0),
	APPS.README: Vector2(0, 0),
	APPS.EMAIL: Vector2(0, 0),
	APPS.MUSIC_PLAYER: Vector2(0, 0),
}

var default_app_positions:Dictionary = app_positions.duplicate()

var tracklist_unlocks:Dictionary = {
	PLAYLIST.TRACK_1:true,
	PLAYLIST.TRACK_2:true,
	PLAYLIST.TRACK_3:true
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
var mods_not_new:Array = ["00"]  #"00" makes easy "marked" in mods
var email_not_new:Array = []
var in_recycle_bin:Array = []
var apps_installed:Array = [] 
var apps_installing:Array = []
 
#endregion
# -----------------------------------

# -----------------------------------
#region LOCAL DATA
var app_list:Array[Dictionary] = [
	{
		"details": {
			"ref": APPS.SDT,
			"title": "Site Director Training Program",
			"icon": SVGS.TYPE.EXE_FILE,
			"app": SiteDirectorTrainingAppPreload,
			"app_events": {
				"onQuit": func() -> void:
					close_app(APPS.SDT),
			}
		},
		"installed": func() -> bool:
			return APPS.SDT in apps_installed,
		"events": {
			"onDblClick": func(data:Dictionary) -> void:
				open_app(data, true),
		}
	},
	{
		"details": {
			"ref": APPS.SDT_MODS,
			"title": "Mods",
			"icon": SVGS.TYPE.EXE_FILE,
			"app": SiteDirectorTrainingModsAppPreload,
			"app_props": {
				"get_not_new": func() -> Array:
					return mods_not_new,
				"get_mod_settings": func() -> Array:
					return mod_settings,
				"get_modifications_unlocked": func() -> Dictionary:
					return modifications_unlocked,
			},
			"app_events": {
				"on_marked": func(updated_vals:Array) -> void:
					mods_not_new = updated_vals
					save_state(0),
			}
		},
		"installed": func() -> bool:
			return true, #APPS.SDT_MODS in apps_installed,
		"events": {
			"onDblClick": func(data:Dictionary) -> void:
				open_app(data, false),
		}
	},
	{
		"details": {
			"ref": APPS.EMAIL,
			"title": "Email",
			"icon": SVGS.TYPE.EMAIL,
			"app": EmailAppPreload,
			"installed": func() -> bool:
				return true,
			"app_props": {
				"get_not_new": func() -> Array:
					return email_not_new,
			},
			"app_events": {
				"on_marked": func(updated_vals:Array) -> void:
					email_not_new = updated_vals
					save_state(0),
				"onOpenAttachment": on_open_attachment,
			}
		},
		"installed": func() -> bool:
			return true,
		"defaults": {
			"pos_offset": Vector2(0, 0),
		},
		"events": {
			"onDblClick": open_app	
		},
	},
	{
		"details": {
			"ref": APPS.MUSIC_PLAYER,
			"title": "Music Player",
			"icon": SVGS.TYPE.MUSIC
		},
		"installed": func() -> bool:
			return true,
		"defaults": {
			"pos_offset": Vector2(0, 0),
		},
		"events": {
			"onDblClick": func(data:Dictionary) -> void:
				if GBL.music_data.is_empty() and !has_notification:
					await simulate_wait(0.7)
					# open music player, no music selected
					GBL.music_data = {
						"track_list": music_track_list,
						"selected": 1,
					},
		},
	},		
	{
		"details": {
			"ref": APPS.README,
			"title": "IMPORTANT PLEASE READ",
			"icon": SVGS.TYPE.TXT_FILE,
			"app": TextFileAppPreload,
			"app_props": {
				"title": "URGENT",
				"content": "Check your EMAILS!"
			},					
		},
		"installed": func() -> bool:
			return true,
		"defaults": {
			"pos_offset": Vector2(0, 0),
		},
		"events": {
			"onDblClick": open_app
		},
	}	
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

var has_notification:bool = false
var notification_data:Dictionary = {} : 
	set(val):
		notification_data = val
		on_notification_data_update()

var already_loaded:Array = []
var simulate_busy:bool = false : 
	set(val):
		simulate_busy = val
		on_simulated_busy_update()

var icon_focus_list:Array[Control] = []
var window_focus_list:Array[Control] = [] : 
	set(val):
		window_focus_list = val
		on_window_focus_list_update()
		
var running_apps_list:Array = [] : 
	set(val): 
		running_apps_list = val
		on_running_apps_list_update()
var app_in_fullscreen:bool = false 

var top_level_icon:Control
var top_level_window:Control : 
	set(val):
		top_level_window = val
		set_node_selectable_state(top_level_window == null)

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
	visible = false
	set_process(false)
	set_physics_process(false)	
# -----------------------------------

# -----------------------------------
func start() -> void:
	load_state()	
	on_simulated_busy_update()
	
	# finish this part	
	if event_switches.show_status_on_boot:
		show_status_notice(true)

	render_desktop_icons()	
	on_notification_data_update()

	Taskbar.onTitleBarClick = open_taskbar_menu

	RecycleBin.onDblClick = func(node:Control, is_focused:bool, data:Dictionary) -> void:
		if is_focused:
			open_app({
				"ref": APPS.RECYCLE_BIN,
				"icon": SVGS.TYPE.TXT_FILE,
				"app": RecycleBinAppPreload,
				"app_props": {
					"app_data": app_list.duplicate().map(func(item):return item.details),
					"in_bin": in_recycle_bin
				},					
			})
			
	if skip_to_game:
		open_app(find_in_app_list(APPS.SDT).details, true, true, true)
# -----------------------------------	

# -----------------------------------	
func on_simulated_busy_update() -> void:	
	if is_node_ready():
		Taskbar.is_busy = simulate_busy	
# -----------------------------------		

# -----------------------------------		
func simulate_wait(duration:float, show_busy:bool = true) -> void:
	if show_busy and duration > 0:
		simulate_busy = true
		GBL.change_mouse_icon(GBL.MOUSE_ICON.BUSY)
		
	await U.set_timeout(duration * 1.0)
	
	if show_busy and duration > 0:
		simulate_busy = false
		GBL.end_mouse_busy()
# -----------------------------------		

# -----------------------------------	
func notification_splash(data:Dictionary) -> Dictionary:
	notification_data = data
	var notification_res:Dictionary = await NotificationContainer.resolve
	notification_data = {}
	return notification_res
# -----------------------------------	

# -----------------------------------		
func on_notification_data_update() -> void:
	if is_node_ready():
		NotificationContainer.data = notification_data

	has_notification = !notification_data.is_empty()	
# -----------------------------------		

# -----------------------------------		
func on_bin_restore(data:Dictionary) -> void:
	in_recycle_bin = in_recycle_bin.filter(func(ref): return ref != data.details.ref)

	# update contents of bin
	data.details.bin_node.update_bin(in_recycle_bin)
	
	# rerender ions
	render_desktop_icons(0.0)
	
	# save state
	save_state(0.2)
# -----------------------------------		

# -----------------------------------		
func on_window_focus_list_update() -> void:
	set_desktop_hoverable_state(window_focus_list.is_empty())
# -----------------------------------			

# -----------------------------------
func on_running_apps_list_update() -> void:
	var refs:Array = running_apps_list.map(func(item): return item.data.ref)
	var filter_list:Array = app_list.filter(func(item): return item.details.ref in refs)
	var taskbar_live_items:Array = filter_list.map(func(item): 
		var node_data:Dictionary = running_apps_list.filter(func(n): return item.details.ref == n.data.ref)[0]
		var details:Dictionary = item.details
		
		return {
			"title": details.title,
			"icon": details.icon,
			"ref": details.ref,
			"onClick": func() -> void:
				if app_in_fullscreen:
					close_app(details.ref)
					open_app(details, true, true)
				else:
					RunningAppsContainer.move_child(node_data.node, RunningAppsContainer.get_child_count() - 1),
			"onMinimize": func() -> void:
				node_data.node.on_minification.call()
				app_in_fullscreen = false
				Taskbar.fullscreen_data = {},
			"onClose": func() -> void:
				close_app(details.ref),
		}
	)
	
	Taskbar.taskbar_live_items = taskbar_live_items
# -----------------------------------

# -----------------------------------
func find_in_app_list(ref:APPS) -> Dictionary:
	return app_list.filter(func(i): return i.details.ref == ref)[0]
# -----------------------------------

# -----------------------------------
func on_open_attachment(data:Dictionary) -> void:
	match data.type:
		"media_player":
			GBL.music_data = {
				"track_list": data.track_list,
				"selected": 0,
			}
		"download": 
			Installer.add_item(data.installer_data)
# -----------------------------------

# -----------------------------------
func update_mod_settings(new_state:Array) -> void:
	mod_settings = new_state
	await show_save_notice()
	close_app(APPS.SDT_MODS)
	
func installing_app_start(ref:APPS) -> void:
	apps_installing.push_back(ref)

func install_app_complete(ref:APPS) -> void:
	apps_installing.erase(ref)
	apps_installed.push_back(ref)
	render_desktop_icons(0)
	save_state()
# -----------------------------------
#endregion

# -----------------------------------
#region MOUSE 
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if !window_focus_list.is_empty() or !icon_focus_list.is_empty() or GBL.mouse_pos.y < 40 or has_notification:return	
	
	if btn == MOUSE_BUTTON_RIGHT:
		open_context_menu("Properties", [
			{
				"get_details": func():
					return {
						"title": "Sort Desktop Icons..."
					},
				"onClick": func(_data:Dictionary):
					sort_desktop_icons(),
			}
		])
	
func on_mouse_release(node:Control, btn:int, on_hover:bool) -> void:
	pass

func on_mouse_dbl_click(node:Control, btn:int, on_hover:bool) -> void:
	pass
#endregion
# -----------------------------------

# -----------------------------------
#region SETTINGS
func toggle_fullscreen() -> void:
	var os_root:Control = GBL.find_node(REFS.OS_ROOT)
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		os_root.update_fullscreen(false)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)	
		os_root.update_fullscreen(true)
#endregion
# -----------------------------------

# -----------------------------------
#region SAVE/LOAD
func save_state(duration:float = 0.2) -> void:
	var save_data:Dictionary = {
		"settings": settings,
		"in_recycle_bin": in_recycle_bin,
		"email_not_new": email_not_new,
		"mods_not_new": mods_not_new,
		"app_positions": app_positions,
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
	var no_save:bool = restore_data.is_empty()
	settings = restore_data.settings if !no_save else settings
	in_recycle_bin = restore_data.in_recycle_bin if !no_save else in_recycle_bin
	email_not_new = restore_data.email_not_new if !no_save else email_not_new
	mods_not_new = restore_data.mods_not_new if !no_save else mods_not_new
	tracklist_unlocks = restore_data.tracklist_unlocks if !no_save else tracklist_unlocks
	modifications_unlocked = restore_data.modifications_unlocked if !no_save else modifications_unlocked
	app_positions = restore_data.app_positions if !no_save else app_positions
	event_switches = restore_data.event_switches if !no_save else event_switches
	apps_installed = restore_data.apps_installed if !no_save else apps_installed
	mod_settings = restore_data.mod_settings if !no_save else mod_settings
#endregion		
# -----------------------------------

# -----------------------------------	
#region NOTIFICATIONS
func show_status_notice(show_dismiss:bool = false) -> void:
	await simulate_wait(1.0)
	var res:Dictionary = await notification_splash({
		"type": Notification.TYPE.INFO,
		"title": "Status",
		"message": "Memsoft OS has booted sucessfully.",
		"buttons": [
			{
				"title": "Do not show again", 
				"show": show_dismiss,
				"onClick": func():
					event_switches.show_status_on_boot = false
					save_state(),
			},
			{
				"title": "Dismiss", 
				"onClick": func():
					pass,
			}
		]
	})
	
func show_save_notice() -> void:
	await save_state()
	var res:Dictionary = await notification_splash({
		"type": Notification.TYPE.INFO,
		"title": "Status",
		"message": "Save state.",
		"buttons": [
			{
				"title": "Dismiss", 
				"onClick": func():
					pass,
			}
		]
	})

func show_confirm_notice(message:String = "Confirm?") -> void:
	var res:Dictionary = await notification_splash({
		"type": Notification.TYPE.INFO,
		"title": "Confirm",
		"message": message,
		"buttons": [
			{
				"title": "Okay", 
				"onClick": func() -> void:
					on_confirm.emit(true),
			},
			{
				"title": "Cancel", 
				"onClick": func() -> void:
					on_confirm.emit(false),
			}			
		]
	})	
#endregion
# -----------------------------------		

# -----------------------------------
#region OPEN APP/TASKBAR_DROPDOWNS/CONTEXT MENU
# -----------------------------------
func open_taskbar_menu(data:Dictionary) -> void:
	var list_data:Array[Dictionary] = [
		{
			"section": "Resolution",
			"opened": true,
			"items": [
				{
					"get_details": func():
						return {
							"title": "Widescreen mode"
						},
					"onClick": func(_data:Dictionary):
						GBL.change_resolution(Vector2(1440, 900))
						close_app(APPS.TASKBAR_MENU),
				},
				{
					"get_details": func():
						return {
							"title": "Desktop mode"
						},
					"onClick": func(_data:Dictionary):
						GBL.change_resolution(Vector2(1920, 1080))
						close_app(APPS.TASKBAR_MENU),
				},
				{
					"get_details": func():
						return {
							"title": "Steamdeck mode"
						},
					"onClick": func(_data:Dictionary):
						GBL.change_resolution(Vector2(1280, 720))
						close_app(APPS.TASKBAR_MENU),
				},	
				{
					"get_details": func():
						return {
							"title": "MacOS mode"
						},
					"onClick": func(_data:Dictionary):
						GBL.change_resolution(Vector2(1680, 1050))
						close_app(APPS.TASKBAR_MENU),
				},	
			]
		},
		{
			"section": "System",
			"opened": true,
			"items": [
				{
					"get_details": func():
						return {
							"title": "Status"
						},
					"onClick": func(_data:Dictionary):
						show_status_notice()
						close_app(APPS.TASKBAR_MENU),
				},
				{
					"get_details": func():
						return {
							"title": "Settings"
						},
					"onClick": func(_data:Dictionary):
						close_app(APPS.TASKBAR_MENU),
				},
				{
					"get_details": func():
						return {
							"title": "Save"
						},
					"onClick": func(_data:Dictionary):
						show_save_notice()
						close_app(APPS.TASKBAR_MENU),
				},				
			]			
		},		
		{
			"section": "Shutdown",
			"opened": data.is_empty(),
			"items": [
				{
					"get_details": func():
						return {
							"title": "Save and exit"
						},
					"onClick": func(_data:Dictionary):
						show_confirm_notice()
						close_app(APPS.TASKBAR_MENU)
						if await on_confirm:
							await save_state(1.0)
							Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
							get_tree().quit(),
				},				
			]			
		}
	]

	if !data.is_empty():
		list_data.push_back({
			"section": data.title,
			"opened": true,
			"items": [
				{
					"get_details": func():
						return {
							"title": "Minimize"
						},
					"onClick": func(_data:Dictionary):
						close_app(data.ref)
						open_app(data, false, true)
						close_app(APPS.TASKBAR_MENU),
				},
				{
					"get_details": func():
						return {
							"title": "Close"
						},
					"onClick": func(_data:Dictionary):
						close_app(data.ref)
						close_app(APPS.TASKBAR_MENU),
				},				
			]
		})

	open_taskbar_dropdown(Taskbar, APPS.TASKBAR_MENU, {"list_data": list_data})	
	
# -----------------------------------	

# -----------------------------------
func open_media_player_mini(node:Control) -> void:
	if has_notification: return
	open_taskbar_dropdown(node, APPS.MEDIA_PLAYER_MINI, {"music_track_list": music_track_list})
# -----------------------------------	

# -----------------------------------	
func open_context_menu(title:String = "Context Menu", items:Array = []) -> void:		
	var data := {
		"ref": APPS.CONTEXT_MENU,
		"title": title,
		"icon": SVGS.TYPE.EXE_FILE,
		"app": ContextMenuAppPreload,
		"app_props": {
			"window_label": title,
			"offset": GBL.mouse_pos,
			"items": items
		}
	}	
	open_app(data, false, true)
# -----------------------------------	

# -----------------------------------	
func open_taskbar_dropdown(node:Control, ref:int, props:Dictionary = {}) -> void:
	if has_notification:return
	
	var selected_scene:PackedScene
	match ref:
		APPS.MEDIA_PLAYER_MINI:
			selected_scene = MediaPlayerMiniAppPreload
		APPS.TASKBAR_MENU:
			selected_scene = TaskBarMenuAppPreload
					
	var app_refs:Array = running_apps_list.map(func(item): return item.data.ref)	
	if selected_scene != null and ref not in app_refs:
		var new_node:Control = selected_scene.instantiate()
		
		# set offset	
		new_node.offset = Vector2(node.global_position.x + 10, 40)

		# adds to running apps list and when updated show up in the taskbar
		running_apps_list.push_back({"node": new_node, "data": {"ref": ref}})
		running_apps_list = running_apps_list
			
		if "data" in new_node:
			new_node.data = props
			
		new_node.onClick = func(node:Control, window_node:Node, btn:int, on_hover:bool) -> void:
			if !on_hover:
				node.queue_free()
				window_focus_list.erase(node)
				window_focus_list = window_focus_list
				close_app(ref)
	
		new_node.onCloseBtn = func(node:Control, window_node:Control) -> void:
			node.queue_free()
			window_focus_list.erase(node)
			window_focus_list = window_focus_list
			close_app(ref)
		
			
		new_node.onFocus = func(node:Control, window_node:Control) -> void:
			if node not in window_focus_list:
				window_focus_list.push_back(node)
				
		new_node.onBlur = func(node:Control, window_node:Control) -> void:
			window_focus_list.erase(node)
			window_focus_list = window_focus_list

		TaskbarAppsContainer.add_child( new_node )
# -----------------------------------	

# -----------------------------------	
func close_app(ref:int) -> void:	
	var node:Control = running_apps_list.filter(func(item): return item.data.ref == ref)[0].node
	running_apps_list = running_apps_list.filter(func(item): return item.data.ref != ref)	
	window_focus_list.erase(node)
	window_focus_list = window_focus_list
	
	if top_level_window == node:
		top_level_window = null
	if node.in_fullscreen:
		var in_fs:Array = running_apps_list.filter(func(item): return item.node.in_fullscreen)
		# checks if there are any other apps running in fullscreen
		if in_fs.size() == 0:
			app_in_fullscreen = false
			Taskbar.fullscreen_data = {}
		else:
			Taskbar.fullscreen_data = in_fs[0].data
			RunningAppsContainer.move_child(in_fs[0].node, RunningAppsContainer.get_child_count() - 1)
			
	node.queue_free()

func open_app(data:Dictionary, in_fullscreen:bool = false, skip_loading:bool = false, force_open:bool = false) -> void:
	if !force_open and (simulate_busy or has_notification):
		return

	var app_refs:Array = running_apps_list.map(func(item): return item.data.ref)	
	if data.ref not in app_refs:		
		# adds a mock timer
		var previously_loaded:bool = data.ref in already_loaded
		if !skip_loading and !previously_loaded:
			already_loaded.push_back(data.ref)
		
		if !skip_loading:
			await simulate_wait(0.2 if previously_loaded else 0.7)
		
		# adds new node and passes and props to them
		var new_node:Control = data.app.instantiate()

		# adds to running apps list and when updated show up in the taskbar
		running_apps_list.push_back({"node": new_node, "data": data})
		running_apps_list = running_apps_list
	
		# adds any props
		if "app_props" in data:
			new_node.app_props = data.app_props
		if "app_events" in data:
			new_node.app_events = data.app_events
		
		# start in fullscreen or not, pass previously loaded
		new_node.fast_load = (previously_loaded or skip_loading or force_open)
		new_node.in_fullscreen = in_fullscreen
		if in_fullscreen:
			Taskbar.fullscreen_data = data
			app_in_fullscreen = true
		
		# determines which container to add it  to
		RunningAppsContainer.add_child( new_node )
		
		# adds event handlers
		# -------------------
		new_node.onClick = func(node:Control, window_node:Node, btn:int, on_hover:bool) -> void:
			if btn == MOUSE_BUTTON_LEFT:
				# freeze content window (if it's not a context menu, and it's not fullscreen)
				if data.ref != APPS.CONTEXT_MENU and !on_hover and !new_node.in_fullscreen:
					window_node.freeze_content_input = true

				# --- IF CONTEXT MENU, CLOSE WHEN IT'S NOT HOVERED OVER
				if data.ref == APPS.CONTEXT_MENU and !on_hover:
					close_app(data.ref)
					
				# else, move the top level window to the top
				if top_level_window != null:
					top_level_window.get_child(0).freeze_content_input = false
					RunningAppsContainer.move_child(top_level_window, RunningAppsContainer.get_child_count() - 1)
			
		# -------------------
		new_node.onCloseBtn = func(node:Control, window_node:Control) -> void:			
			close_app(data.ref)
			
		# -------------------	
		new_node.onMaxBtn = func(node:Control, window_node:Control) -> void:
			Taskbar.fullscreen_data = data
			app_in_fullscreen = true
			node.on_max()

			
		# -------------------
		new_node.onFocus = func(node:Control, window_node:Control) -> void:
			if node not in window_focus_list:
				window_focus_list.push_back(node)
			window_focus_list = window_focus_list
				
			# determine which window is on top
			var z_order:Dictionary = {}
			for index in RunningAppsContainer.get_children().size():
				z_order[RunningAppsContainer.get_child(index)] = index
			if window_focus_list.size() > 1 and node in z_order:
				if z_order[node] == RunningAppsContainer.get_children().size() - 1:
					top_level_window = node
			else:
				top_level_window = node
				
				
		# -------------------
		new_node.onBlur = func(node:Control, window_node:Control) -> void:
			window_focus_list.erase(node)
			window_focus_list = window_focus_list

			if window_focus_list.size() > 0:
				top_level_window = window_focus_list[0]

			else:
				top_level_window = null
		# -------------------
		
		# -------------------
		new_node.onDragEnd = func(new_offset:Vector2, node:Control, window_node:Control) -> void:
			pass
		# -------------------			
		
# -----------------------------------	
#endregion
# -----------------------------------

# -----------------------------------
#region LIST AND NODE BEHAVIOR
# -----------------------------------	
func set_node_selectable_state(state:bool, exclude = null) -> void:
	if DesktopIconContainer != null:
		for child in DesktopIconContainer.get_children():
			if exclude != child:
				child.is_selectable = state
# -----------------------------------			

# -----------------------------------			
func set_desktop_hoverable_state(state:bool) -> void:
	for child in DesktopIconContainer.get_children():
		child.is_hoverable = state
# -----------------------------------			

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
	await simulate_wait(wait_time)
	
	var column_tracker := {}
	
	# remove and rerender icons, waitTime used to wait for changes
	for child in DesktopIconContainer.get_children():
		child.queue_free()
	icon_focus_list = []	
	await U.set_timeout(0)
	
	for item in app_list:
		if (item.details.ref not in in_recycle_bin) and item.installed.call():
			var new_node:Control = AppItemPreload.instantiate()	
			DesktopIconContainer.add_child(new_node)
			new_node.pos_offset = app_positions[item.details.ref]
			new_node.data = item.details
			
			new_node.onDblClick = func(node:Control, is_focused:bool, data:Dictionary) -> void:
				if window_focus_list.is_empty() and !has_notification:
					item.events.onDblClick.call(data)
				
			new_node.onClick = func(node:Control, btn:int, on_hover:bool) -> void:
				if on_hover and !has_notification:
					if btn == MOUSE_BUTTON_RIGHT:
						var details:Dictionary = item.details
						open_context_menu(details.title, [
							{
								"get_details": func():
									return {
										"title": "Open..."
									},
								"onClick": func(_data:Dictionary):
									item.events.onDblClick.call(details)
									close_app(APPS.CONTEXT_MENU),
							},						
							{
								"get_details": func():
									return {
										"title": "Move to Recycle Bin..."
									},
								"onClick": func(_data:Dictionary):
									# add to recycle bin
									in_recycle_bin.push_back(details.ref)
									
									# update recycle bin if it's open
									for app in running_apps_list:
										if app.data.ref == APPS.RECYCLE_BIN:
											app.node.in_bin_list = in_recycle_bin
											
									# rerender desktop icons
									render_desktop_icons(0.0)
									close_app(APPS.CONTEXT_MENU)
									
									save_state(),
							}
						])
						
					if btn == MOUSE_BUTTON_LEFT:
						DesktopIconContainer.move_child(top_level_icon, DesktopIconContainer.get_child_count() - 1)
				
			new_node.onDragStart = func(node:Control) -> void:
				set_node_selectable_state(false, top_level_icon)
				
			new_node.onDragEnd = func(new_offset:Vector2, node:Control) -> void:
				set_node_selectable_state(true)
				icon_focus_list.erase(node)
				if app_positions[item.details.ref] != new_offset:
					if icon_focus_list.is_empty():
						app_positions[item.details.ref] = new_offset
						save_state()
					else:
						new_node.pos_offset = app_positions[item.details.ref]
						
			new_node.onFocus = func(node:Control) -> void:
				if node not in icon_focus_list:
					icon_focus_list.push_back(node)
				var z_order:Dictionary = {}
				for index in DesktopIconContainer.get_children().size():
						z_order[DesktopIconContainer.get_child(index)] = index
				if icon_focus_list.size() > 1:
					if z_order[node] == DesktopIconContainer.get_children().size() - 1:
						top_level_icon = node
				else:
					top_level_icon = node				
					
			new_node.onBlur = func(node:Control) -> void:
				icon_focus_list.erase(node)
				if icon_focus_list.size() > 0:
					top_level_icon = icon_focus_list[0]
				else:
					top_level_icon = null			

			

# -----------------------------------
#endregion
# -----------------------------------
