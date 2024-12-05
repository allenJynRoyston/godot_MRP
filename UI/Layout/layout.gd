extends MouseInteractions

@onready var Taskbar:Control = $Taskbar
@onready var RunningAppsContainer:Control = $RunningAppsContainer
@onready var TaskbarAppsContainer:Control = $TaskbarAppsContainer
@onready var FullScreenAppsContainer:Control = $FullScreenAppsContainer
@onready var BackgroundWindow:PanelContainer = $BackgroundWindow
@onready var SimulatedWait:PanelContainer = $SimulatedWait

@onready var DesktopIconContainer:Control = $Desktop/MarginContainer/HBoxContainer/VBoxContainer/DesktopIconContainer
@onready var RecycleBin:PanelContainer = $Desktop/MarginContainer/HBoxContainer/VBoxContainer2/RecycleBin

enum APPS {SDT, README, SETTINGS, MUSIC_PLAYER, EMAIL, MEDIA_PLAYER_MINI, BIN, CONTEXT_MENU}

const WindowUIScene:PackedScene = preload("res://UI/WindowUI/WindowUI.tscn")
const AppItemScene:PackedScene = preload("res://UI/Layout/AppItem/AppItem.tscn")

const SiteDirectorTrainingAppScene:PackedScene = preload("res://UI/Layout/Apps/SiteDirectorTrainingApp/SiteDirectorTrainingApp.tscn")
const EmailAppScene:PackedScene = preload("res://UI/Layout/Apps/EmailApp/EmailApp.tscn")
const MediaPlayerMiniAppScene:PackedScene = preload("res://UI/Layout/Apps/MediaPlayerMiniApp/MediaPlayerMiniApp.tscn")
const ContextMenuAppScene:PackedScene = preload("res://UI/Layout/Apps/ContextMenuApp/ContextMenuApp.tscn")
const TextFileAppScene:PackedScene = preload("res://UI/Layout/Apps/TextFileApp/TextFileApp.tscn")

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

var default_app_positions:Dictionary = app_positions.duplicate()

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
			"title": "Site Director Training Program",
			"icon": SVGS.EXE_FILE,
			"app": SiteDirectorTrainingAppScene,
		},
		"events": {
			"onRightClick": func() -> void:
				open_context_menu("Properties"),
			"onDblClick": func(data:Dictionary) -> void:
				open_app(data, true),
		}
	},
	{
		"data": {
			"ref": APPS.SETTINGS,
			"title": "Settings",
			"icon": SVGS.SETTINGS,
			"app": TextFileAppScene
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
			"title": "Email",
			"icon": SVGS.EMAIL,
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
			"title": "Music Player",
			"icon": SVGS.MUSIC
		},
		"defaults": {
			"pos_offset": Vector2(0, 0),
		},
		"events": {
			"onRightClick": func() -> void:
				print("on right click"),
			"onDblClick": func(data:Dictionary) -> void:
				if GBL.music_data.is_empty():
					# open music player, no music selected
					GBL.music_data = {
						"track_list": music_track_list,
						"selected": 1,
					},
		},
	},		
	{
		"data": {
			"ref": APPS.README,
			"title": "README.txt",
			"icon": SVGS.TXT_FILE,
			"app": TextFileAppScene
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

var already_loaded:Array = []
var simulate_busy:bool = false : 
	set(val):
		simulate_busy = val
		on_simulated_busy_update()

var icon_focus_list:Array[Control] = []
var window_focus_list:Array[Control] = []
var running_apps_list:Array = [] : 
	set(val): 
		running_apps_list = val
		on_running_apps_list_update()

var top_level_icon:Control
var top_level_window:Control : 
	set(val):
		top_level_window = val
		set_node_selectable_state(top_level_window == null)
#endregion
# -----------------------------------

# -----------------------------------
func _ready() -> void:
	load_state()
	render_desktop_icons()
	on_simulated_busy_update()

	GBL.register_node(REFS.OS_LAYOUT, self)

	RecycleBin.onDblClick = func(data:Dictionary) -> void:
		pass
# -----------------------------------

# -----------------------------------
func _exit_tree() -> void:
	GBL.unregister_node(REFS.OS_LAYOUT)
# -----------------------------------	

# -----------------------------------	
func on_simulated_busy_update() -> void:	
	SimulatedWait.show() if simulate_busy else SimulatedWait.hide()	
# -----------------------------------		

# -----------------------------------		
func simulate_wait(duration:float) -> void:
	simulate_busy = true
	await U.set_timeout(duration * 1.0)
	simulate_busy = false
# -----------------------------------		
	

# -----------------------------------
func on_running_apps_list_update() -> void:
	var refs:Array = running_apps_list.map(func(item): return item.ref)
	var filter_list:Array = app_list.filter(func(item): return item.data.ref in refs)
	var taskbar_live_items:Array = filter_list.map(func(item): 
		var node_data:Dictionary = running_apps_list.filter(func(n): return item.data.ref == n.ref)[0]
		
		return {
			"title": item.data.title,
			"icon": item.data.icon,
			"onClick": func() -> void:
				RunningAppsContainer.move_child(node_data.node, RunningAppsContainer.get_child_count() - 1),
			"onClose": func() -> void:
				close_app(item.data.ref),
		}
	)
	

	Taskbar.taskbar_live_items = taskbar_live_items
# -----------------------------------


# -----------------------------------
#region MOUSE 
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if btn == MOUSE_BUTTON_RIGHT:
		open_context_menu("Properties", [
			{
				"get_details": func():
					return {
						"title": "Sort Desktop Icons..."
					},
				"onClick": func(_data:Dictionary):
					sort_desktop_icons(),
				"onClose": func():
					print("on close"),
			}
		])
	
func on_mouse_release(node:Control, btn:int, on_hover:bool) -> void:
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
	tracklist_unlocks = restore_data.tracklist_unlocks if !no_save else tracklist_unlocks
	app_positions = restore_data.app_positions if !no_save else app_positions
#endregion		
# -----------------------------------

# -----------------------------------
#region OPEN APP/TASKBAR_DROPDOWNS/CONTEXT MENU
func open_context_menu(title:String = "Context Menu", items:Array = []) -> void:
	var data = {
		"ref": APPS.CONTEXT_MENU,
		"title": title,
		"icon": SVGS.EXE_FILE,
		"app": ContextMenuAppScene,
		"app_props": {
			"window_label": title,
			"offset": GBL.mouse_pos,
			"items": items
		}
	}	
	open_app(data, false, true)

	
# -----------------------------------	
func open_taskbar_dropdown(node:Control, id:String) -> void:
	var new_node:Control
	var ref:int
	match id:
		"media_player":
			new_node = MediaPlayerMiniAppScene.instantiate()
			ref = APPS.MEDIA_PLAYER_MINI
			new_node.offset = Vector2(node.global_position.x, 40)
			new_node.music_track_list = music_track_list
			
	if new_node != null:
		new_node.onClick = func(node:Control, window_node:Node, btn:int, on_hover:bool) -> void:
			if !on_hover:
				node.queue_free()
	
		new_node.onCloseBtn = func(node:Control, window_node:Control) -> void:
			node.queue_free()

		TaskbarAppsContainer.add_child( new_node )
# -----------------------------------	

# -----------------------------------	
func close_app(ref:int) -> void:
	var node:Control = running_apps_list.filter(func(item): return item.ref == ref)[0].node	
	running_apps_list = running_apps_list.filter(func(item): return item.ref != ref)
	window_focus_list.erase(node)
	if top_level_window == node:
		top_level_window = null
	node.queue_free()	

func open_app(data:Dictionary, in_fullscreen:bool = false, skip_loading:bool = false) -> void:
	if simulate_busy:
		return
		
	var app_refs:Array = running_apps_list.map(func(item): return item.ref)	
	if data.ref not in app_refs:
		if !skip_loading:
			if data.ref not in already_loaded:
				already_loaded.push_back(data.ref)
				await simulate_wait(0.7)
			else:
				await simulate_wait(0.2)
				
		var new_node:Control = data.app.instantiate()

		running_apps_list.push_back({"ref": data.ref, "node": new_node})
		running_apps_list = running_apps_list
		
		if "app_props" in data:
			new_node.app_props = data.app_props
		
		if "app_events" in data:
			new_node.app_events = data.app_events
		
		new_node.in_fullscreen = in_fullscreen
		
		new_node.onClick = func(node:Control, window_node:Node, btn:int, on_hover:bool) -> void:
			# --- IF CONTEXT MENU, CLOSE WHEN IT'S NOT HOVERED OVER
			if data.ref == APPS.CONTEXT_MENU and !on_hover:
				close_app(data.ref)
				
			# else, move the top level window to the top
			if top_level_window != null:
				RunningAppsContainer.move_child(top_level_window, RunningAppsContainer.get_child_count() - 1)

		new_node.onCloseBtn = func(node:Control, window_node:Control) -> void:			
			close_app(data.ref)
			
		new_node.onMaxBtn = func(node:Control, window_node:Control) -> void:
			close_app(data.ref)
			open_app(data, !new_node.in_fullscreen, true)			
		
		new_node.onFocus = func(node:Control, window_node:Control) -> void:
			if node not in window_focus_list:
				window_focus_list.push_back(node)
				
			var z_order:Dictionary = {}
			for index in RunningAppsContainer.get_children().size():
					z_order[RunningAppsContainer.get_child(index)] = index
			if window_focus_list.size() > 1:
				if z_order[node] == RunningAppsContainer.get_children().size() - 1:
					top_level_window = node
			else:
				top_level_window = node
				
		new_node.onBlur = func(node:Control, window_node:Control) -> void:
			window_focus_list.erase(node)

			if window_focus_list.size() > 0:
				top_level_window = window_focus_list[0]
			else:
				top_level_window = null
		
		if in_fullscreen:
			FullScreenAppsContainer.add_child(new_node)
		else:
			RunningAppsContainer.add_child( new_node )
			

# -----------------------------------	
#endregion
# -----------------------------------

# -----------------------------------
#region LIST AND NODE BEHAVIOR
# -----------------------------------	
func set_node_selectable_state(state:bool, exclude = null) -> void:
	for child in DesktopIconContainer.get_children():
		if exclude != child:
			child.is_selectable = state
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
func render_desktop_icons() -> void:
	var column_tracker := {}
	
	for node in [DesktopIconContainer]:
		for child in node.get_children():
			node.queue_free()
			
	for item in app_list:
		var new_node:Control = AppItemScene.instantiate()	
		new_node.pos_offset = app_positions[item.data.ref]
		new_node.data = item.data
		
		new_node.onDblClick = item.events.onDblClick
		new_node.onRightClick = item.events.onRightClick		
		
		new_node.onClick = func(node:Control, btn:int, on_hover:bool) -> void:
			DesktopIconContainer.move_child(top_level_icon, DesktopIconContainer.get_child_count() - 1)
		
		new_node.onDragStart = func(node:Control) -> void:
			set_node_selectable_state(false, top_level_icon)
			
		new_node.onDragEnd = func(new_offset:Vector2, node:Control) -> void:
			set_node_selectable_state(true)
			icon_focus_list.erase(node)
			if app_positions[item.data.ref] != new_offset:
				if icon_focus_list.is_empty():
					app_positions[item.data.ref] = new_offset
					save_state()
				else:
					new_node.pos_offset = app_positions[item.data.ref]
					
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

		DesktopIconContainer.add_child(new_node)
# -----------------------------------
#endregion
