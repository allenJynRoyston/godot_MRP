extends PanelContainer

@onready var WaitContainer:Control = $WaitContainer
@onready var BtnControls:Control = $BtnControl
@onready var TrackList:VBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/List

const SummaryBtnPreload:PackedScene = preload("res://UI/Buttons/SummaryBtn/SummaryBtn.tscn")

var music_data:Dictionary
var track_data:Array = OS_AUDIO.track_data
var tab_index:int = 0
var SelectedNode:Control 
var MediaPlayerNode:Control 
var onBackToDesktop:Callable = func() -> void:pass

# ------------------------------------------------------------------------------
func _init() -> void:
	SUBSCRIBE.subscribe_to_music_player(self)
	
func _exit_tree() -> void:
	SUBSCRIBE.unsubscribe_to_music_player(self)
	
func _ready() -> void:	
	on_music_track_list_update()
	
	MediaPlayerNode = GBL.find_node(REFS.MEDIA_PLAYER)
	
	BtnControls.directional_pref = "UD"
	
	BtnControls.onBack = func() -> void:
		onBackToDesktop.call()
		
	BtnControls.onCBtn = func() -> void:
		MediaPlayerNode.on_pause()
	
	BtnControls.onUpdate = func(node:Control) -> void:
		for index in TrackList.get_child_count():
			var n:Control = TrackList.get_child(index)
			n.is_selected = node == n
			if node == n:
				SelectedNode = node

	
	BtnControls.onAction = func() -> void:
		if SelectedNode == null:return
		var item:Dictionary = track_data[tab_index].list[SelectedNode.index]
		var os_settings:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].os_setting
		var track_ref:int = item.details.ref
		var is_unlocked:bool = item.is_unlocked.call(os_settings)
		
		# still locked, so do nothing...
		if !is_unlocked:
			return
		
		# else, pause music and start next track
		MediaPlayerNode.on_pause()
		
		# open music player, no music selected
		SUBSCRIBE.music_data = {
			"selected": track_ref
		}


func start() -> void:
	on_music_data_update()
	BtnControls.itemlist = TrackList.get_children()
	BtnControls.item_index = 0
	await BtnControls.reveal(true)
	WaitContainer.hide()
	

func pause() -> void:
	await BtnControls.reveal(false)
	
func unpause() -> void:
	await BtnControls.reveal(true)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_music_track_list_update() -> void:
	if !is_node_ready():return
	var os_settings:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].os_setting	
	
	for item in TrackList.get_children():
		item.queue_free()
		
	for index in track_data[tab_index].list.size():
		var new_btn:PanelContainer = SummaryBtnPreload.instantiate()		
		var item:Dictionary = track_data[tab_index].list[index]
		var is_unlocked:bool = item.is_unlocked.call(os_settings)
		
		new_btn.index = index
		new_btn.title = item.details.name if is_unlocked else "???"
		
		new_btn.show_checked_panel = true		
		new_btn.hide_icon = true
		new_btn.fill = true			

		TrackList.add_child(new_btn)
	
	on_music_data_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_music_data_update(new_val:Dictionary = music_data) -> void:
	music_data = new_val
	if !is_node_ready() or music_data.is_empty():return
	for index in TrackList.get_child_count():
		var n:Control = TrackList.get_child(index)
		n.is_checked = index == music_data.selected
		n.use_alt = index == music_data.selected
# ------------------------------------------------------------------------------
