extends PanelContainer

@onready var WaitContainer:Control = $WaitContainer
@onready var BtnControls:Control = $BtnControl
@onready var TrackList:VBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/List

const TextBtnPreload:PackedScene = preload("res://UI/Buttons/ItemBtn/ItemBtn.tscn")

var MediaPlayerNode:Control 
var onBackToDesktop:Callable = func() -> void:pass
var selected_node:Control 
var track_id:int = 0
var music_data:Dictionary
var music_track_list:Array :
	set(val): 
		music_track_list = val
		on_music_track_list_update()

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
				selected_node = node
				track_id = index

	
	BtnControls.onAction = func() -> void:
		MediaPlayerNode.on_pause()
		
		# open music player, no music selected
		SUBSCRIBE.music_data = {
			"selected": track_id,
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
func on_music_data_update(new_val:Dictionary = music_data) -> void:
	music_data = new_val
	if !is_node_ready() or music_data.is_empty():return
	for index in TrackList.get_child_count():
		var n:Control = TrackList.get_child(index)
		n.is_checked = index == music_data.selected
		

func on_music_track_list_update() -> void:
	if !is_node_ready():return
	for item in TrackList.get_children():
		item.queue_free()
		
	for item in music_track_list:
		var new_btn:PanelContainer = TextBtnPreload.instantiate()
		new_btn.title = item.details.name
		new_btn.display_checkmark = true
		new_btn.is_checked = false
		TrackList.add_child(new_btn)
	
# ------------------------------------------------------------------------------
