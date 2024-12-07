extends MouseInteractions
class_name Layout

@onready var Taskbar:Control = $SubViewport/Taskbar
@onready var RunningAppsContainer:Control = $SubViewport/RunningAppsContainer
@onready var TaskbarAppsContainer:Control = $SubViewport/TaskbarAppsContainer
@onready var FullScreenAppsContainer:Control = $SubViewport/FullScreenAppsContainer
@onready var BackgroundWindow:PanelContainer = $SubViewport/BackgroundWindow
@onready var SimulatedWait:PanelContainer = $SubViewport/SimulatedWait

@onready var DesktopIconContainer:Control = $SubViewport/Desktop/MarginContainer/HBoxContainer/VBoxContainer/DesktopIconContainer
@onready var RecycleBin:PanelContainer = $SubViewport/Desktop/MarginContainer/HBoxContainer/VBoxContainer2/RecycleBin

enum APPS {SDT, README, SETTINGS, MUSIC_PLAYER, EMAIL, MEDIA_PLAYER_MINI, BIN, CONTEXT_MENU, TASKBAR_MENU, RECYCLE_BIN}

const WindowUIScene:PackedScene = preload("res://UI/WindowUI/WindowUI.tscn")
const AppItemScene:PackedScene = preload("res://UI/Layout/AppItem/AppItem.tscn")

const SiteDirectorTrainingAppScene:PackedScene = preload("res://UI/Layout/Apps/SiteDirectorTrainingApp/SiteDirectorTrainingApp.tscn")
const EmailAppScene:PackedScene = preload("res://UI/Layout/Apps/EmailApp/EmailApp.tscn")
const MediaPlayerMiniAppScene:PackedScene = preload("res://UI/Layout/Apps/MediaPlayerMiniApp/MediaPlayerMiniApp.tscn")
const TaskBarMenuAppScene:PackedScene = preload("res://UI/Layout/Apps/TaskbarMenuApp/TaskbarMenuApp.tscn")
const ContextMenuAppScene:PackedScene = preload("res://UI/Layout/Apps/ContextMenuApp/ContextMenuApp.tscn")
const TextFileAppScene:PackedScene = preload("res://UI/Layout/Apps/TextFileApp/TextFileApp.tscn")
const RecycleBinAppScene:PackedScene = preload("res://UI/Layout/Apps/RecycleBin/RecycleBin.tscn")

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

var running_apps_positions:Dictionary = {
	
}

var default_app_positions:Dictionary = app_positions.duplicate()

var tracklist_unlocks:Dictionary = {
	0:true,
	1:true,
	2:true
}

var in_recycle_bin:Array = [
	APPS.SDT,
	APPS.README
]

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
			"title": "IMPORTANT PLEASE READ",
			"icon": SVGS.TXT_FILE,
			"app": TextFileAppScene,
			"app_props": {
				"title": "URGENT",
				"content": "Check your EMAILS!"
			},					
		},
		"defaults": {
			"pos_offset": Vector2(0, 0),
		},
		"events": {
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
var app_in_fullscreen:bool = false

var top_level_icon:Control
var top_level_window:Control : 
	set(val):
		top_level_window = val
		set_node_selectable_state(top_level_window == null)
#endregion
# -----------------------------------

#region local functions
# -----------------------------------
func _ready() -> void:
	super._ready()
	load_state()
	render_desktop_icons()
	on_simulated_busy_update()

	GBL.register_node(REFS.OS_LAYOUT, self)

	Taskbar.onTitleBarClick = open_taskbar_menu

	RecycleBin.onDblClick = func(node:Control, is_focused:bool, data:Dictionary) -> void:
		if is_focused:
			open_app({
				"ref": APPS.RECYCLE_BIN,
				"icon": SVGS.TXT_FILE,
				"app": RecycleBinAppScene,
				"app_props": {
					"app_data": app_list.duplicate().map(func(item):return item.data),
					"in_bin": in_recycle_bin
				},					
			})
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
func onBinRestore(data:Dictionary) -> void:
	in_recycle_bin = in_recycle_bin.filter(func(ref): return ref != data.details.ref)

	# update contents of bin
	data.details.bin_node.update_bin()
	
	for node in DesktopIconContainer.get_children():
		if node.data.ref in in_recycle_bin:
			node.hide()  
		else: 
			node.show()
	
  
# -----------------------------------		

# -----------------------------------
func on_running_apps_list_update() -> void:
	var refs:Array = running_apps_list.map(func(item): return item.data.ref)
	var filter_list:Array = app_list.filter(func(item): return item.data.ref in refs)
	var taskbar_live_items:Array = filter_list.map(func(item): 
		var node_data:Dictionary = running_apps_list.filter(func(n): return item.data.ref == n.data.ref)[0]
		
		return {
			"title": item.data.title,
			"icon": item.data.icon,
			"ref": item.data.ref,
			"onClick": func() -> void:
				if app_in_fullscreen:
					close_app(item.data.ref)
					open_app(item.data, true, true)
				else:
					RunningAppsContainer.move_child(node_data.node, RunningAppsContainer.get_child_count() - 1),
			"onMinimize": func() -> void:
				close_app(item.data.ref)
				open_app(item.data, false, true),
			"onClose": func() -> void:
				close_app(item.data.ref),
		}
	)
	
	Taskbar.taskbar_live_items = taskbar_live_items
# -----------------------------------
#endregion

# -----------------------------------
#region MOUSE 
func on_mouse_click(node:Control, btn:int, on_hover:bool) -> void:
	if !window_focus_list.is_empty() or !icon_focus_list.is_empty() or GBL.mouse_pos.y < 40:return	
	
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
#region SAVE/LOAD
func save_state() -> void:
	var save_data = {
		"settings": settings,
		"in_recycle_bin": in_recycle_bin,
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
	in_recycle_bin = in_recycle_bin # restore_data.in_recycle_bin if !no_save else in_recycle_bin
	email_has_read = restore_data.email_has_read if !no_save else email_has_read
	tracklist_unlocks = restore_data.tracklist_unlocks if !no_save else tracklist_unlocks
	app_positions = restore_data.app_positions if !no_save else app_positions

func toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)	
#endregion		
# -----------------------------------

# -----------------------------------
#region OPEN APP/TASKBAR_DROPDOWNS/CONTEXT MENU
# -----------------------------------
func open_taskbar_menu(data:Dictionary) -> void:
	var list_data:Array[Dictionary] = [
		{
			"section": "Options",
			"opened": data.is_empty(),
			"items": [
				{
					"get_details": func():
						return {
							"title": "Settings"
						},
					"onClick": func(_data:Dictionary):
						print("settings")
						close_app(APPS.TASKBAR_MENU),
				},
				{
					"get_details": func():
						return {
							"title": "Fullscreen"
						},
					"onClick": func(_data:Dictionary):
						toggle_fullscreen()
						close_app(APPS.TASKBAR_MENU),
				},
				{
					"get_details": func():
						return {
							"title": "Save"
						},
					"onClick": func(_data:Dictionary):
						save_state()
						close_app(APPS.TASKBAR_MENU),
				},
				{
					"get_details": func():
						return {
							"title": "Exit Game"
						},
					"onClick": func(_data:Dictionary):
						get_tree().quit() 
						close_app(APPS.TASKBAR_MENU),
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
	open_taskbar_dropdown(node, APPS.MEDIA_PLAYER_MINI, {"music_track_list": music_track_list})
# -----------------------------------	

# -----------------------------------	
func open_context_menu(title:String = "Context Menu", items:Array = []) -> void:		
	var data := {
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

# -----------------------------------	
func open_taskbar_dropdown(node:Control, ref:int, props:Dictionary = {}) -> void:
	var selected_scene:PackedScene
	match ref:
		APPS.MEDIA_PLAYER_MINI:
			selected_scene = MediaPlayerMiniAppScene
		APPS.TASKBAR_MENU:
			selected_scene = TaskBarMenuAppScene
					
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
				close_app(ref)
	
		new_node.onCloseBtn = func(node:Control, window_node:Control) -> void:
			node.queue_free()
			window_focus_list.erase(node)
			close_app(ref)
		
			
		new_node.onFocus = func(node:Control, window_node:Control) -> void:
			if node not in window_focus_list:
				window_focus_list.push_back(node)
				
		new_node.onBlur = func(node:Control, window_node:Control) -> void:
			window_focus_list.erase(node)

		TaskbarAppsContainer.add_child( new_node )
# -----------------------------------	

# -----------------------------------	
func close_app(ref:int) -> void:	
	var node:Control = running_apps_list.filter(func(item): return item.data.ref == ref)[0].node
	running_apps_list = running_apps_list.filter(func(item): return item.data.ref != ref)	
	window_focus_list.erase(node)
	
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

func open_app(data:Dictionary, in_fullscreen:bool = false, skip_loading:bool = false) -> void:
	if simulate_busy:
		return
		
	var app_refs:Array = running_apps_list.map(func(item): return item.data.ref)	
	if data.ref not in app_refs:		
		# adds new node and passes and props to them
		var new_node:Control = data.app.instantiate()

		# adds to running apps list and when updated show up in the taskbar
		running_apps_list.push_back({"node": new_node, "data": data})
		running_apps_list = running_apps_list

		# adds a mock timer
		if !skip_loading:
			if data.ref not in already_loaded:
				already_loaded.push_back(data.ref)
				await simulate_wait(0.7)
			else:
				await simulate_wait(0.2)

		# adds any props
		if "app_props" in data:
			new_node.app_props = data.app_props
		if "app_events" in data:
			new_node.app_events = data.app_events
		
		# start in fullscreen or not
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
			close_app(data.ref)
			open_app(data, !new_node.in_fullscreen, true)
			
		# -------------------
		new_node.onFocus = func(node:Control, window_node:Control) -> void:
			if node not in window_focus_list:
				window_focus_list.push_back(node)
				
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
			
			# freeze content window (if it's not a context menu, and it's not fullscreen)
			if data.ref != APPS.CONTEXT_MENU and !new_node.in_fullscreen:
				window_node.freeze_content_input = true
			
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
	
	for child in DesktopIconContainer.get_children():
		child.queue_free()
	
	for item in app_list:
		var new_node:Control = AppItemScene.instantiate()	
		new_node.pos_offset = app_positions[item.data.ref]
		new_node.data = item.data
		new_node.is_selectable = false # if item.data.ref in in_recycle_bin else new_node.show()
		
		new_node.onDblClick = func(node:Control, is_focused:bool, data:Dictionary) -> void:
			if window_focus_list.is_empty():
				item.events.onDblClick.call(data)
			
		new_node.onClick = func(node:Control, btn:int, on_hover:bool) -> void:
			if on_hover:
				if btn == MOUSE_BUTTON_RIGHT:
					open_context_menu(item.data.title, [
						{
							"get_details": func():
								return {
									"title": "Open..."
								},
							"onClick": func(_data:Dictionary):
								item.events.onDblClick.call(item.data)
								close_app(APPS.CONTEXT_MENU),
						},						
						{
							"get_details": func():
								return {
									"title": "Move to Recycle Bin..."
								},
							"onClick": func(_data:Dictionary):
								close_app(APPS.CONTEXT_MENU),
						}
					])
					
				if btn == MOUSE_BUTTON_LEFT:
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
