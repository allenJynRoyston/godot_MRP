@tool
extends PanelContainer

@onready var RootPanel:PanelContainer = $"."
@onready var BtnControl:Control = $BtnControl

@onready var TaskbarControl:Control = $TaskbarControl
@onready var TaskbarPanel:PanelContainer = $TaskbarControl/PanelContainer
@onready var DesktopBtn:BtnBase = $TaskbarControl/PanelContainer/MarginContainer/HBoxContainer/LeftContainer/DesktopBtn
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

var show_taskbar:bool = false 
var onBackToDesktop:Callable = func() -> void:pass
var onDesktopBtnFocus:Callable = func() -> void:pass
var onBack:Callable = func() -> void:pass
var onItemSelect:Callable = func(_dict:Dictionary) -> void:pass
var onItemClose:Callable = func(_dict:Dictionary) -> void:pass
var onItemFocus:Callable = func() -> void:pass

var task_index:int = -1:
	set(val):
		task_index = val
		on_task_index()

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
	on_task_index()
	
	#DesktopBtn.onFocus = func(_node:Control) -> void:
		#onDesktopBtnFocus.call()
#
	## setup controls
	#DesktopBtn.onClick = func() -> void:
		#onBackToDesktop.call()
	
	BtnControl.onDirectional = func(key:String) -> void:
		if !is_visible_in_tree() or !is_node_ready(): return
		match key:
			"A":
				task_index = U.min_max(task_index - 1, -1, RunningTasks.get_child_count() - 1)
			"D":
				task_index = U.min_max(task_index + 1, -1, RunningTasks.get_child_count() - 1)
	
	BtnControl.onAction = func() -> void:
		if task_index == -1:
			onBackToDesktop.call()
			return
			
		onBack.call()		
	
	BtnControl.onBack = func() -> void:
		#GBL.find_node(REFS.OS_ROOT).play_door()
		pass #
		# onBack.call()
	BtnControl.onCBtn = func() -> void:
		await U.set_timeout(1.0)
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
func on_task_index() -> void:
	if !is_node_ready():return
	if task_index == -1:
		GBL.find_node(REFS.OS_LAYOUT).set_pause_container(true) 
	else: 
		GBL.find_node(REFS.OS_LAYOUT).set_pause_container(false)
	
	## RunningTasks.hide() if task_index == -1 else RunningTasks.show()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func set_show_taskbar(state:bool, skip_animation:bool = false) -> void:
	show_taskbar = state
	if !state:
		if skip_animation:
			BtnControl.reveal(state)
		else:
			await BtnControl.reveal(state)	
	await U.tween_node_property(TaskbarControl, "position:y", control_pos[TaskbarControl].show if show_taskbar else control_pos[TaskbarControl].hide, 0 if skip_animation else 0.3)
	if state:
		BtnControl.reveal(state)	
		
func on_show_media_player_update() -> void:
	if !is_node_ready():return
	MediaPlayer.show() if show_media_player else MediaPlayer.hide()
	

func add_item(item:Dictionary) -> void:
	if !is_node_ready():return
	var new_node:Control = TaskbarLiveItemPreload.instantiate()
	new_node.data = item
	new_node.show_min_button = false
	
	new_node.onFocus = func() -> void:
		onItemFocus.call(item)
	
	new_node.onClose = func() -> void:
		onItemClose.call(item)
		
	new_node.onClick = func() -> void:
		onBack.call()
		onItemSelect.call(item)
	
	RunningTasks.add_child(new_node)	
	
	
func remove_item(ref:int) -> void:
	if !is_node_ready():return
	for node in RunningTasks.get_children():
		if node.data.ref == ref:
			RunningTasks.remove_child(node)
			node.queue_free()
	

func on_music_data_update() -> void:
	show_media_player = !music_data.is_empty()
	MediaPlayer.data = music_data
# ------------------------------------------------------------------------------
