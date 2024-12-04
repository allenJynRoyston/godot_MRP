extends MouseInteractions

@onready var AppListContainer:Control = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/AppListContainer
@onready var RunningAppsContainer:Control = $RunningAppsContainer
@onready var RecycleBin:PanelContainer = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/RecycleBin
@onready var BackgroundWindow:PanelContainer = $BackgroundWindow

enum APPS {SDT, README, SETTINGS, MUSIC_PLAYER, EMAIL, MEDIA_PLAYER_MINI, BIN}

const WindowUIScene:PackedScene = preload("res://UI/WindowUI/WindowUI.tscn")
const AppItemScene:PackedScene = preload("res://UI/Layout/AppItem/AppItem.tscn")

const SiteDirectorTrainingAppScene:PackedScene = preload("res://UI/Layout/Apps/SiteDirectorTrainingApp/SiteDirectorTrainingApp.tscn")
const EmailAppScene:PackedScene = preload("res://UI/Layout/Apps/EmailApp/EmailApp.tscn")
const MediaPlayerMiniAppScene:PackedScene = preload("res://UI/Layout/Apps/MediaPlayerMiniApp/MediaPlayerMiniApp.tscn")

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

var app_positions:Dictionary = {
	APPS.SDT: Vector2(0, 0),
	APPS.SETTINGS: Vector2(0, 0),
	APPS.README: Vector2(0, 0),
	APPS.EMAIL: Vector2(0, 0),
	APPS.MUSIC_PLAYER: Vector2(0, 0),
}

var tracklist_unlocks:Dictionary = {
	0:true,
	1:true,
	2:true
}

var email_has_read:Array = [] 
#endregion
# -----------------------------------

# -----------------------------------
#region LOCAL DATA
var music_track_list:Array = [
	{
		"metadata": {
			"name": "ghost trick finale",
			"author": "capcom"
		},
		"unlocked": func():
			return tracklist_unlocks[0],
		"file": preload("res://Media/mp3/ghost_trick_test_track.mp3")
	},
	{
		"metadata": {
			"name": "phoenix wright",
			"author": "capcom"
		},
		"unlocked": func():
			return tracklist_unlocks[1],
		"file": preload("res://Media/mp3/phoenix wright.mp3")
	},
	{
		"metadata": {
			"name": "The Weeknd - Popular",
			"author": "Vidojean X Oliver Loenn Amapiano Remix"
		},
		"unlocked": func():
			return tracklist_unlocks[2],
		"file": preload("res://Media/mp3/The Weeknd - Popular (Vidojean X Oliver Loenn Amapiano Remix).mp3")
	}							
]

var app_list:Array[Dictionary] = [
	{
		"data": {
			"ref": APPS.SDT,
			"title": "Site Director Training.exe",
			"icon": preload("res://SVGs/exe-svgrepo-com.svg"),
			"app": SiteDirectorTrainingAppScene,
		},
		"events": {
			"onRightClick": func() -> void:
				print("on right click"),
			"onDblClick": open_app
		}
	},
	{
		"data": {
			"ref": APPS.SETTINGS,
			"title": "SETTINGS.exe",
			"icon": preload("res://SVGs/settings-svgrepo-com.svg"),
		},
		"defaults": {
			"pos_offset": Vector2(0, 0),
		},
		"events": {
			"onRightClick": func() -> void:
				print("on right click"),
			"onDblClick": open_app
		},
	},
	{
		"data": {
			"ref": APPS.EMAIL,
			"title": "EMAIL.exe",
			"icon": preload("res://SVGs/email-svgrepo-com.svg"),
			"app": EmailAppScene,
			"app_props": {
				"get_has_read": func() -> Array:
					return email_has_read,
			},
			"app_events": {
				"onHasReadUpdate": func(new_email_has_read:Array):
					email_has_read = new_email_has_read
					save_state(),
				"onOpenAttachment": func(data:Dictionary):
					match data.type:
						"media_player":							
							GBL.music_data = {
								"track_list": data.track_list,
								"selected": 0,
							}
					,
			}
		},
		"defaults": {
			"pos_offset": Vector2(0, 0),
		},
		"events": {
			"onRightClick": func() -> void:
				print("on right click"),
			"onDblClick": open_app	
		},
	},
	{
		"data": {
			"ref": APPS.MUSIC_PLAYER,
			"title": "MUSIC PLAYER.exe",
			"icon": preload("res://SVGs/music-svgrepo-com.svg")
		},
		"defaults": {
			"pos_offset": Vector2(0, 0),
		},
		"events": {
			"onRightClick": func() -> void:
				print("on right click"),
			"onDblClick": func(data:Dictionary) -> void:
				# open music player, no music selected
				GBL.music_data = {
					"track_list": music_track_list,
					"selected": 0,
				},
		},
	},		
	{
		"data": {
			"ref": APPS.README,
			"title": "README.txt",
			"icon": preload("res://SVGs/txt-text-file-svgrepo-com.svg"),
		},
		"defaults": {
			"pos_offset": Vector2(0, 0),
		},
		"events": {
			"onRightClick": func() -> void:
				print("on right click"),
			"onDblClick": open_app
		},
	}	
]

var icon_focus_list:Array[Control] = []
var window_focus_list:Array[Control] = []
var running_apps_list:Array = []
#endregion
# -----------------------------------

# -----------------------------------
func _ready() -> void:
	load_state()
	render_list()

	GBL.register_node(REFS.OS_LAYOUT, self)

	RecycleBin.onDblClick = func() -> void:
		print("dbl click")	
# -----------------------------------

# -----------------------------------
func _exit_tree() -> void:
	GBL.unregister_node(REFS.OS_LAYOUT)
# -----------------------------------	

# -----------------------------------
#region MOUSE 
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if btn == MOUSE_BUTTON_RIGHT:
		print("right lcick in layout")
	
func on_mouse_release(btn:int, on_hover:bool) -> void:
	pass

func on_mouse_dbl_click(btn:int, on_hover:bool) -> void:
	pass
#endregion
# -----------------------------------

# -----------------------------------
#region SAVE/LOAD
func save_state() -> void:
	var save_data = {
		"settings": settings,
		"email_has_read": email_has_read,
		"app_positions": app_positions,
		"tracklist_unlocks": tracklist_unlocks,
	}	
	FS.save_file(FS.FILE.SETTINGS, save_data)
	print("saved settings state!")

func load_state() -> void:
	var res = FS.load_file(FS.FILE.SETTINGS)		
	if res.success:
		restore_state(res.filedata.data)
		
func restore_state(restore_data:Dictionary = {}) -> void:
	var no_save:bool = restore_data.is_empty()
	settings = restore_data.settings if !no_save else settings
	email_has_read = restore_data.email_has_read if !no_save else email_has_read
	tracklist_unlocks = tracklist_unlocks #restore_data.tracklist_unlocks if !no_save else tracklist_unlocks
	app_positions = restore_data.app_positions if !no_save else app_positions
#endregion		
# -----------------------------------

# -----------------------------------
#region OPEN APP OR TASKBAR_DROPDOWNS
# -----------------------------------	
func open_taskbar_dropdown(node:Control, id:String) -> void:
	var new_node:Control
	var ref:int
	match id:
		"media_player":
			new_node = MediaPlayerMiniAppScene.instantiate()
			ref = APPS.MEDIA_PLAYER_MINI
			new_node.offset = Vector2(node.global_position.x, 35)
			new_node.music_track_list = music_track_list
			
	
	if new_node != null:
		new_node.onClick = func(node:Control, window_node:Node, btn:int, is_hover:bool) -> void:
			if !is_hover:
				running_apps_list.erase(ref)
				node.queue_free()
				set_node_selectable_state(true)
		
		new_node.onCloseBtn = func(node:Control) -> void:
			running_apps_list.erase(ref)
			node.queue_free()
			set_node_selectable_state(true)

		new_node.onFocus = func(node:Control) -> void:
			set_node_selectable_state(false, node)
			if node not in window_focus_list:
				window_focus_list.push_back(node)

		new_node.onBlur = func(node:Control) -> void:
			window_focus_list.erase(node)
			set_node_selectable_state(true)

		RunningAppsContainer.add_child( new_node )
		set_node_selectable_state(false)
# -----------------------------------	

# -----------------------------------	
func open_app(data:Dictionary) -> void:
	if data.ref not in running_apps_list:
		running_apps_list.push_back(data.ref)
		var new_node:Control = data.app.instantiate()
		if "app_props" in data:
			new_node.app_props = data.app_props
		
		if "app_events" in data:
			new_node.app_events = data.app_events
		
		new_node.onClick = func(node:Control, window_node:Node, btn:int, on_hover:bool) -> void:

			if !window_focus_list.is_empty():
				var first_in_stack:Control = window_focus_list[0]
				if first_in_stack == node:
					node.disable
			for child in RunningAppsContainer.get_children():
				if child == node:
					RunningAppsContainer.move_child(child, RunningAppsContainer.get_child_count() - 1)

		new_node.onCloseBtn = func(node:Control, window_node:Control) -> void:
			running_apps_list.erase(data.ref)
			node.queue_free()
			set_node_selectable_state(true)

		new_node.onFocus = func(node:Control, window_node:Control) -> void:
			set_node_selectable_state(false, node)
			if node not in window_focus_list:
				window_focus_list.push_back(node)

		new_node.onBlur = func(node:Control, window_node:Control) -> void:
			window_focus_list.erase(node)
			set_node_selectable_state(true)

		RunningAppsContainer.add_child( new_node )
		set_node_selectable_state(false)
# -----------------------------------	
#endregion
# -----------------------------------

# -----------------------------------
#region LIST AND NODE BEHAVIOR
# -----------------------------------	
func set_node_selectable_state(state:bool, exclude = null) -> void:
	for child in AppListContainer.get_children():
		if exclude != child:
			child.is_selectable = state
# -----------------------------------			

# -----------------------------------	
func render_list() -> void:
	var column_tracker := {}
	
	for node in [AppListContainer]:
		for child in node.get_children():
			node.queue_free()
			
	for item in app_list:
		var new_node:Control = AppItemScene.instantiate()	
		new_node.pos_offset = app_positions[item.data.ref]
		new_node.data = item.data
		
		new_node.onDblClick = item.events.onDblClick
		new_node.onRightClick = item.events.onRightClick		
		
		new_node.onDragStart = func(node:Control) -> void:
			if running_apps_list.size() > 0: return
			set_node_selectable_state(false, node)
			
		new_node.onDragEnd = func(new_offset:Vector2, node:Control) -> void:
			if running_apps_list.size() > 0: return
			icon_focus_list.erase(node)
			set_node_selectable_state(true)
			if app_positions[item.data.ref] != new_offset:
				if icon_focus_list.is_empty():
					app_positions[item.data.ref] = new_offset
					save_state()
				else:
					new_node.pos_offset = app_positions[item.data.ref]

		new_node.onFocus = func(node:Control) -> void:
			if running_apps_list.size() > 0: return
			if node not in icon_focus_list:
				icon_focus_list.push_back(node)
				
		new_node.onBlur = func(node:Control) -> void:
			if running_apps_list.size() > 0: return
			icon_focus_list.erase(node)

		AppListContainer.add_child(new_node)
# -----------------------------------
#endregion
