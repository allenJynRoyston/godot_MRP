@tool
extends PanelContainer

@onready var BtnControl:Control = $BtnControl
@onready var TaskbarControl:Control = $TaskbarControl
@onready var TaskbarPanel:PanelContainer = $TaskbarControl/PanelContainer
@onready var DesktopBtn:Control = $TaskbarControl/PanelContainer/MarginContainer/HBoxContainer/LeftContainer/DesktopBtn

# tasks
@onready var RunningTasks:HBoxContainer = $TaskbarControl/PanelContainer/MarginContainer/HBoxContainer/RunningTasks
@onready var TimeAndSettings:HBoxContainer = $TaskbarControl/PanelContainer/MarginContainer/HBoxContainer/RightContainer/TimeAndSettings

# media player buttons
@onready var MediaPlayer:HBoxContainer = $TaskbarControl/PanelContainer/MarginContainer/HBoxContainer/RightContainer/MediaPlayer
@onready var PlayBtn:BtnBase = $TaskbarControl/PanelContainer/MarginContainer/HBoxContainer/RightContainer/MediaPlayer/HBoxContainer/PlayPauseBtn
@onready var NextBtn:BtnBase = $TaskbarControl/PanelContainer/MarginContainer/HBoxContainer/RightContainer/MediaPlayer/HBoxContainer/NextBtn

@export var show_media_player:bool = false : 
	set(val):
		show_media_player = val
		on_show_media_player_update()

const ConfirmModalPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ConfirmModal/ConfirmModal.tscn")
const TaskbarLiveItemPreload:PackedScene = preload("res://Scenes/OSRoot/parts/OS/Taskbar/parts/TaskbarLiveItem/TaskbarLiveItem.tscn")

var control_pos_default:Dictionary
var control_pos:Dictionary

var music_data:Dictionary = {} : 
	set(val): 
		music_data = val
		on_music_data_update()

var show_taskbar:bool = false 
var is_busy:bool = false
var selected_node:Control 

var onBackToDesktop:Callable = func() -> void:pass
#var onDesktopBtnFocus:Callable = func() -> void:pass
var onBack:Callable = func() -> void:pass
var onItemSelect:Callable = func(_dict:Dictionary) -> void:pass
var onItemClose:Callable = func(_dict:Dictionary) -> void:pass
var onItemFocus:Callable = func() -> void:pass

#var task_index:int = -1:
	#set(val):
		#task_index = val
		#on_task_index()

# ------------------------------------------------------------------------------
func _init() -> void:
	self.modulate = Color(1, 1, 1, 0)	
	GBL.subscribe_to_music_player(self)	
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_music_player(self)
	GBL.unsubscribe_to_control_input(self)
	
func _ready() -> void:
	on_music_data_update()
	on_show_media_player_update()
	
	BtnControl.onUpdate = func(_node:Control) -> void:
		selected_node = _node
		
		BtnControl.disable_back_btn = selected_node == DesktopBtn 
		BtnControl.hide_a_btn = selected_node not in [PlayBtn, NextBtn]
		for node in BtnControl.itemlist:
			node.modulate = Color(1, 1, 1, 1 if node == _node else 0.7)

		# desktop btn
		if selected_node == DesktopBtn:
			get_parent().currently_running_app = null
			return

		# media buttons desktop
		if selected_node in [PlayBtn, NextBtn]:
			get_parent().currently_running_app = null
			return			
			
		# preview of any current apps
		if ("data" in selected_node) and ("node" not in selected_node.data):
			get_parent().currently_running_app = selected_node.data.node
			
	BtnControl.onAction = func() -> void:
		# media buttons desktop
		if selected_node == PlayBtn:
			MediaPlayer.on_pause()
			return		
			
		if selected_node == NextBtn:
			MediaPlayer.on_next()
			return
			
	BtnControl.onBack = func() -> void:
		is_busy = true		
		await BtnControl.reveal(false)
		var confirm:bool = await create_modal("Quit this program?", "Your progress will be saved.")
		is_busy = false
		BtnControl.reveal(true)	
		if confirm:
			if selected_node in [PlayBtn, NextBtn]:
				show_media_player = false
				await U.tick()
				BtnControl.itemlist = get_itemlist()
				BtnControl.item_index = 0				
				return
	
			if "data" in selected_node:
				remove_item(selected_node.data.ref)
		
	BtnControl.directional_pref = "LR"
	
	await U.tick()
	control_pos[TaskbarControl] = {
		"show": 0, 
		"hide": -TaskbarPanel.size.y - 20
	}
	
	TaskbarControl.position.y = control_pos[TaskbarControl].hide
	
	set_show_taskbar(false, true)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------	
func set_show_taskbar(state:bool, skip_animation:bool = false) -> void:
	is_busy = true		

	show_taskbar = state
	
	if state:
		self.modulate = Color(1, 1, 1, 1)

	BtnControl.reveal(state)
	await U.tween_node_property(TaskbarControl, "position:y", control_pos[TaskbarControl].show if show_taskbar else control_pos[TaskbarControl].hide, 0 if skip_animation else 0.3)
	
	if state:
		BtnControl.itemlist = get_itemlist()
		if get_parent().currently_running_app != null:			
			for index in RunningTasks.get_child_count():
				var node:Control = RunningTasks.get_child(index)
				if node.data.node == get_parent().currently_running_app:
					BtnControl.item_index = index + 1
		else:
			BtnControl.item_index = 0
		
	if !state:
		self.modulate = Color(1, 1, 1, 0)
		
	is_busy = false
		
		
func on_show_media_player_update() -> void:
	if !is_node_ready():return
	MediaPlayer.show() if show_media_player else MediaPlayer.hide()
	if !show_media_player:
		MediaPlayer.on_stop()

	
func add_item(item:Dictionary) -> void:
	if !is_node_ready():return
	var new_node:Control = TaskbarLiveItemPreload.instantiate()
	new_node.data = item
	
	new_node.modulate = Color(1, 1, 1, 0.7)
	new_node.hint_description = "Switch to %s." % [item.title]
	new_node.hint_title = "HINT"
	new_node.hint_icon = SVGS.TYPE.INFO
	
	new_node.onClose = func() -> void:
		onItemClose.call(item)
	
	RunningTasks.add_child(new_node)
	
	await U.tick()
	BtnControl.itemlist = get_itemlist()
	BtnControl.item_index = 0	
	
func remove_item(ref:int) -> void:
	if !is_node_ready():return
	for task in RunningTasks.get_children():
		if task.data.ref == ref:
			await task.data.node.force_save_and_quit()
			RunningTasks.remove_child(task)
			get_parent().close_app(ref)
			
	await U.tick()
	BtnControl.itemlist = get_itemlist()
	BtnControl.item_index = 0


func get_itemlist() -> Array:
	var list:Array = [DesktopBtn] 
	for btn in RunningTasks.get_children():
		list.push_back(btn)
	if show_media_player:
		for btn in [PlayBtn, NextBtn]:
			list.push_back(btn)		
	return list

func on_music_data_update() -> void:
	if MediaPlayer.is_already_playing():return
	show_media_player = !music_data.is_empty()
	MediaPlayer.data = music_data
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
func create_modal(title:String = "", subtitle:String = "", img_src:String = "", activation_requirements:Array = [], allow_controls:bool = false, color_bg:Color = Color(0, 0, 0, 0.7)) -> bool:
	var ConfirmNode:Control = ConfirmModalPreload.instantiate()
	ConfirmNode.z_index = 100	
	add_child(ConfirmNode)
	ConfirmNode.set_props(title, subtitle, img_src, color_bg)
	ConfirmNode.allow_controls = allow_controls
	
	await ConfirmNode.activate(false)
	ConfirmNode.activation_requirements = activation_requirements
	
	ConfirmNode.start()
	var confirm:bool = await ConfirmNode.user_response	
	return confirm
# ------------------------------------------------------------------------------
