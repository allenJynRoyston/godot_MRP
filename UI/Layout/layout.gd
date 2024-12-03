extends MouseInteractions

@onready var AppListContainer:Control = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/AppListContainer
@onready var RunningAppsContainer:Control = $RunningAppsContainer
@onready var RecycleBin:PanelContainer = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer2/RecycleBin
@onready var BackgroundWindow:PanelContainer = $BackgroundWindow

enum APPS {SDT, README, SETTINGS, BIN}

const WindowUIScene:PackedScene = preload("res://UI/WindowUI/WindowUI.tscn")
const AppItemScene:PackedScene = preload("res://UI/Layout/AppItem/AppItem.tscn")

const SiteDirectorTrainingAppScene:PackedScene = preload("res://UI/Layout/Apps/SiteDirectorTrainingApp/SiteDirectorTrainingApp.tscn")

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
	APPS.README: Vector2(0, 0)
}
#endregion
# -----------------------------------

# -----------------------------------
#region LOCAL DATA
var app_list:Array[Dictionary] = [
	{
		"ref": APPS.SDT,
		"data": {
			"title": "Site Director Training.exe",
			"icon": preload("res://SVGs/exe-svgrepo-com.svg"),
		},
		"events": {
			"onRightClick": func() -> void:
				print("on right click"),
			"onDblClick": func() -> void:
				if APPS.SDT not in running_apps_list:
					running_apps_list.push_back(APPS.SDT)
					var node:Control = SiteDirectorTrainingAppScene.instantiate()
					node.onCloseBtn = func(node:Control) -> void:
						running_apps_list.erase(APPS.SDT)
						node.queue_free()
						
					RunningAppsContainer.add_child( node ),
					
		}
	},
	{
		"ref": APPS.SETTINGS,
		"data": {
			"title": "SETTINGS.exe",
			"icon": preload("res://SVGs/exe-svgrepo-com.svg"),
		},
		"defaults": {
			"pos_offset": Vector2(0, 0),
		},
		"events": {
			"onRightClick": func() -> void:
				print("on right click"),
			"onDblClick": func() -> void:
				print("open readme txt"),			
		},
	},
	{
		"ref": APPS.README,
		"data": {
			"title": "README.txt",
			"icon": preload("res://SVGs/txt-text-file-svgrepo-com.svg"),
		},
		"defaults": {
			"pos_offset": Vector2(0, 0),
		},
		"events": {
			"onRightClick": func() -> void:
				print("on right click"),
			"onDblClick": func() -> void:
				print("open readme txt"),			
		},
	}	
]

var focus_list:Array[Control] = []
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
func on_mouse_click(btn:int, on_hover:bool) -> void:
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
		"app_positions": app_positions
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
	app_positions = restore_data.app_positions if !no_save else app_positions
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
		new_node.pos_offset = app_positions[item.ref]
		new_node.data = item.data
		
		new_node.onDblClick = item.events.onDblClick
		new_node.onRightClick = item.events.onRightClick		
		
		new_node.onDragStart = func(node:Control) -> void:
			set_node_selectable_state(false, node)
			
		new_node.onDragEnd = func(new_offset:Vector2, node:Control) -> void:
			focus_list.erase(node)
			set_node_selectable_state(true)
			if focus_list.is_empty():
				app_positions[item.ref] = new_offset
				save_state()
			else:
				new_node.pos_offset = app_positions[item.ref]

		new_node.onFocus = func(node:Control) -> void:
			if node not in focus_list:
				focus_list.push_back(node)
				
		new_node.onBlur = func(node:Control) -> void:
			focus_list.erase(node)

		
		AppListContainer.add_child(new_node)
# -----------------------------------
#endregion
