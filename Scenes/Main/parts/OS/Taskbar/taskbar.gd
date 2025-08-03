extends PanelContainer

@onready var BtnControl:Control = $BtnControl
@onready var TaskbarPanel:PanelContainer = $TaskbarControl/PanelContainer
@onready var TaskbarMargin:MarginContainer = $TaskbarControl/PanelContainer/MarginContainer
@onready var DesktopBtn:Control = $TaskbarControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/LeftContainer/DesktopBtn

# tasks
@onready var RunningTasks:HBoxContainer = $TaskbarControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/RunningTasks
@onready var TimeAndSettings:HBoxContainer = $TaskbarControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/RightContainer/TimeAndSettings

# media player buttons
@onready var MediaPlayer:PanelContainer = $TaskbarControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/RightContainer/MediaPlayer
@onready var PlayBtn:BtnBase = $TaskbarControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/RightContainer/MediaPlayer/MarginContainer/HBoxContainer/HBoxContainer/PlayPauseBtn
@onready var NextBtn:BtnBase = $TaskbarControl/PanelContainer/MarginContainer/PanelContainer/MarginContainer/HBoxContainer/RightContainer/MediaPlayer/MarginContainer/HBoxContainer/HBoxContainer/NextBtn

@export var show_media_player:bool = false : 
	set(val):
		show_media_player = val
		on_show_media_player_update()

const ConfirmModalPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/ConfirmModal/ConfirmModal.tscn")
const TaskbarLiveItemPreload:PackedScene = preload("res://Scenes/Main/parts/OS/Taskbar/parts/TaskbarLiveItem/TaskbarLiveItem.tscn")

var control_pos_default:Dictionary
var control_pos:Dictionary
var show_taskbar:bool = false 
var is_busy:bool = false
var selected_node:Control 

var onBackToDesktop:Callable = func() -> void:pass
var onBack:Callable = func() -> void:pass
const btn_controls_offset:Vector2 = Vector2(20, 50)

# ------------------------------------------------------------------------------
func _init() -> void:
	GBL.register_node(REFS.TASKBAR, self)
	GBL.subscribe_to_control_input(self)

func _exit_tree() -> void:
	GBL.unregister_node(REFS.TASKBAR)	
	GBL.unsubscribe_to_control_input(self)
	
func _ready() -> void:
	self.modulate = Color(1, 1, 1, 0)		
	
	var update_media_player:Callable = func() -> void:
		BtnControl.a_btn_title = "RESUME TRACK" if !MediaPlayer.is_already_playing() else 'PAUSE TRACK'	
	
	BtnControl.onBack = func() -> void:
		await set_show_taskbar(false)
		GBL.find_node(REFS.OS_LAYOUT).return_to_desktop()


	
	BtnControl.onUpdate = func(_node:Control) -> void:
		selected_node = _node
		
		for node in BtnControl.itemlist:
			node.modulate = Color(1, 1, 1, 1 if node == _node else 0.7)		
		
		match selected_node:
			PlayBtn:
				GBL.find_node(REFS.OS_LAYOUT).freeze_inputs = true
				BtnControl.offset = Vector2(0, 0)
				BtnControl.hide_c_btn = false
				update_media_player.call()
				get_parent().currently_running_app = null
			NextBtn:
				GBL.find_node(REFS.OS_LAYOUT).freeze_inputs = true
				BtnControl.offset = Vector2(0, 0)
				BtnControl.hide_c_btn = true
				BtnControl.a_btn_title = "NEXT TRACK"
				# replace with music node later
				get_parent().currently_running_app = null
			DesktopBtn:
				GBL.find_node(REFS.OS_LAYOUT).freeze_inputs = false
				BtnControl.offset = btn_controls_offset + Vector2(30, 0)
				BtnControl.a_btn_title = "DESKTOP"
				BtnControl.hide_c_btn = true
				# replace with music node later
				get_parent().currently_running_app = null
			_:
				GBL.find_node(REFS.OS_LAYOUT).freeze_inputs = false
				BtnControl.offset = btn_controls_offset				
				BtnControl.hide_c_btn = false
				BtnControl.a_btn_title = "SWITCH"

				if "node" in selected_node.data and selected_node.data.node != null:
					get_parent().currently_running_app = selected_node.data.node

	BtnControl.onAction = func() -> void:
		match selected_node:
			PlayBtn:
				if SUBSCRIBE.music_data.is_empty():
					SUBSCRIBE.music_data = {"selected": 0}
				else:
					MediaPlayer.on_pause()
				update_media_player.call()
			NextBtn:
				if SUBSCRIBE.music_data.is_empty():
					SUBSCRIBE.music_data = {"selected": 0}
				else:				
					MediaPlayer.on_next()
			DesktopBtn:
				await set_show_taskbar(false)
				GBL.find_node(REFS.OS_LAYOUT).return_to_desktop()
			_:
				await set_show_taskbar(false)
				GBL.find_node(REFS.OS_LAYOUT).return_to_app(selected_node.data.ref)
				
	BtnControl.onCBtn = func() -> void:
		is_busy = true		
		await BtnControl.reveal(false)
		var confirm:bool = await create_modal("Quit this program?", "Your progress will be saved.")
		BtnControl.reveal(true)	
		if confirm:
			match selected_node:
				_:
					GBL.find_node(REFS.OS_LAYOUT).force_close_app(selected_node.data.ref)
			
			await U.tick()
			BtnControl.itemlist = get_itemlist()
			BtnControl.item_index = BtnControl.itemlist.size() - 1
		is_busy = false
		
	BtnControl.directional_pref = "LR"
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func activate() -> void:
	control_pos[TaskbarPanel] = {
		"show": 0, 
		"hide": -TaskbarMargin.size.y - 20
	}
	
	TaskbarPanel.position.y = control_pos[TaskbarPanel].hide	
	self.modulate = Color(1, 1, 1, 1)
	
	on_show_media_player_update()
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------	
func set_show_taskbar(state:bool, skip_animation:bool = false) -> void:
	is_busy = true		

	show_taskbar = state

	BtnControl.reveal(state)
	await U.tween_node_property(TaskbarPanel, "position:y", control_pos[TaskbarPanel].show if show_taskbar else control_pos[TaskbarPanel].hide, 0 if skip_animation else 0.3)
	
	if state:
		BtnControl.itemlist = get_itemlist()
		if get_parent().currently_running_app != null:			
			for index in RunningTasks.get_child_count():
				var node:Control = RunningTasks.get_child(index)
				if node.data.node == get_parent().currently_running_app:
					BtnControl.item_index = index + 1
		else:
			BtnControl.item_index = 0
		

	is_busy = false
		
func on_show_media_player_update() -> void:
	if !is_node_ready():return
	MediaPlayer.show() if show_media_player else MediaPlayer.hide()

	
func add_item(item:Dictionary) -> void:
	if !is_node_ready():return
	var new_node:Control = TaskbarLiveItemPreload.instantiate()
	new_node.data = item
	
	new_node.modulate = Color(1, 1, 1, 0.7)
	new_node.hint_description = "Switch to %s." % [item.title]
	new_node.hint_title = "HINT"
	new_node.hint_icon = SVGS.TYPE.INFO

	RunningTasks.add_child(new_node)
	
	await U.tick()
	BtnControl.itemlist = get_itemlist()
	BtnControl.item_index = 0	
	
func remove_item(ref:int) -> void:
	if !is_node_ready():return
	for task in RunningTasks.get_children():
		if task.data.ref == ref:
			RunningTasks.remove_child(task)

func get_itemlist() -> Array:
	var list:Array = [DesktopBtn] 
	for btn in RunningTasks.get_children():
		list.push_back(btn)
	if show_media_player:
		for btn in [PlayBtn, NextBtn]:
			list.push_back(btn)		
	return list
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
