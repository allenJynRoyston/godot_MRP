@tool
extends PanelContainer

@onready var TitleBar:HBoxContainer = $MarginContainer/HBoxContainer/LeftContainer/TitleBar
@onready var TimeAndSettings:HBoxContainer = $MarginContainer/HBoxContainer/RightContainer/TimeAndSettings
@onready var MediaPlayer:HBoxContainer = $MarginContainer/HBoxContainer/RightContainer/MediaPlayer

@onready var RunningTasks:HBoxContainer = $MarginContainer/HBoxContainer/RunningTasks

@export var show_media_player:bool = false : 
	set(val):
		show_media_player = val
		on_show_media_player_update()

const TaskbarLiveItemScene:PackedScene = preload("res://UI/Layout/Taskbar/parts/TaskbarLiveItem/TaskbarLiveItem.tscn")

var fullscreen_data:Dictionary = {} : 
	set(val):
		fullscreen_data = val
		on_fullscreen_data_update()

var music_data:Dictionary = {} : 
	set(val): 
		music_data = val
		on_music_data_update()

var taskbar_live_items:Array = [] : 
	set(val):
		taskbar_live_items = val
		on_taskbar_live_items_update()

var title_bar_defaults:Dictionary = {}

var onTitleBarClick = func(data:Dictionary) -> void:pass

# ------------------------------------------------------------------------------
func _ready() -> void:
	if Engine.is_editor_hint():
		return	
	
	# grab defaults
	title_bar_defaults = {
		"title": TitleBar.title,
		"icon": TitleBar.icon
	}

	GBL.subscribe_to_music_player(self)
	on_music_data_update()
	on_show_media_player_update()
	on_taskbar_live_items_update()
	on_fullscreen_data_update()
	
	TitleBar.onClick = func() -> void:
		onTitleBarClick.call(fullscreen_data)
			
	

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		return	
	GBL.unsubscribe_to_music_player(self)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func on_show_media_player_update() -> void:
	if !is_node_ready():return
	MediaPlayer.show() if show_media_player else MediaPlayer.hide()
		
func on_taskbar_live_items_update() -> void:
	if !is_node_ready():return
	for child in RunningTasks.get_children():
		child.queue_free()
	
	for data in taskbar_live_items:
		var new_node:Control = TaskbarLiveItemScene.instantiate()
		new_node.data = data
		RunningTasks.add_child(new_node)
			
func on_fullscreen_data_update() -> void:
	if !is_node_ready():return
	if fullscreen_data.is_empty():
		TitleBar.title = title_bar_defaults.title
		TitleBar.icon = title_bar_defaults.icon
	else:
		TitleBar.title = fullscreen_data.title
		TitleBar.icon = fullscreen_data.icon
		
		for child in RunningTasks.get_children():
			child.show_min_button = child.data.ref == fullscreen_data.ref
		

func on_music_data_update() -> void:
	show_media_player = !music_data.is_empty()
	MediaPlayer.data = music_data
# ------------------------------------------------------------------------------
