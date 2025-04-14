@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var BtnControl:Control = $BtnControl

@onready var TaskbarControl:Control = $TaskbarControl
@onready var TaskbarPanel:PanelContainer = $TaskbarControl/PanelContainer
@onready var TitleBar:HBoxContainer = $TaskbarControl/PanelContainer/MarginContainer/HBoxContainer/LeftContainer/TitleBar
@onready var TimeAndSettings:HBoxContainer = $TaskbarControl/PanelContainer/MarginContainer/HBoxContainer/RightContainer/TimeAndSettings
@onready var MediaPlayer:HBoxContainer = $TaskbarControl/PanelContainer/MarginContainer/HBoxContainer/RightContainer/MediaPlayer
@onready var RunningTasks:HBoxContainer = $TaskbarControl/PanelContainer/MarginContainer/HBoxContainer/RunningTasks

@export var show_media_player:bool = false : 
	set(val):
		show_media_player = val
		on_show_media_player_update()

const TaskbarLiveItemPreload:PackedScene = preload("res://Scenes/OSRoot/parts/OS/Taskbar/parts/TaskbarLiveItem/TaskbarLiveItem.tscn")

var control_pos_default:Dictionary
var control_pos:Dictionary

var music_data:Dictionary = {} : 
	set(val): 
		music_data = val
		on_music_data_update()

var is_busy:bool = false : 
	set(val):
		is_busy = val
		on_is_busy_update()
		
var show_taskbar:bool = false 
var onBackToDesktop:Callable = func() -> void:pass
var onBack:Callable = func() -> void:pass
var onItemSelect:Callable = func(_dict:Dictionary) -> void:pass
var onItemClose:Callable = func(_dict:Dictionary) -> void:pass

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.subscribe_to_music_player(self)	
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_music_player(self)
	GBL.unsubscribe_to_control_input(self)
	
func _ready() -> void:
	on_music_data_update()
	on_show_media_player_update()
	on_is_busy_update()

	# setup controls
	TitleBar.onClick = func():
		onBackToDesktop.call()

	BtnControl.onBack = func() -> void:
		onBack.call()
		
	BtnControl.directional_pref = "LR"
	
	await U.tick()
	control_pos[TaskbarControl] = {
		"show": 0, 
		"hide": -TaskbarPanel.size.y - 20
	}
	
	await U.tick()
	set_show_taskbar(false, true)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func set_show_taskbar(state:bool, skip_animation:bool = false) -> void:
	show_taskbar = state
	BtnControl.reveal(state)
	
	print("set showtaskbar: ", state)
	
	await U.tween_node_property(TaskbarControl, "position:y", control_pos[TaskbarControl].show if show_taskbar else control_pos[TaskbarControl].hide, 0 if skip_animation else 0.3)
	if state:
		update_itemlist()

func on_is_busy_update() -> void:
	if !is_node_ready():return
	TitleBar.is_busy = is_busy
	
func on_show_media_player_update() -> void:
	if !is_node_ready():return
	MediaPlayer.show() if show_media_player else MediaPlayer.hide()

func add_item(item:Dictionary, start:bool = true) -> void:
	if !is_node_ready():return
	var new_node:Control = TaskbarLiveItemPreload.instantiate()
	new_node.data = item
	new_node.show_min_button = false
	
	new_node.onClose = func():
		RunningTasks.remove_child(new_node)
		onItemClose.call(item)
		new_node.queue_free()
		await U.tick()
		update_itemlist()
		
	new_node.onClick = func():
		onItemSelect.call(item)
	
	RunningTasks.add_child(new_node)	

func update_itemlist() -> void:
	var itemlist:Array = [TitleBar]
	
	for node in RunningTasks.get_children():
		for btn in node.get_buttons():
			itemlist.push_back(btn)

	BtnControl.itemlist = itemlist	
	

func on_music_data_update() -> void:
	show_media_player = !music_data.is_empty()
	MediaPlayer.data = music_data
# ------------------------------------------------------------------------------
