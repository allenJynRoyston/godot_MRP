extends PanelContainer

@onready var WaitContainer:Control = $WaitContainer
@onready var BtnControls:Control = $BtnControl
@onready var SplashContainer:Control = $Control/SplashContainer
@onready var TrackList:VBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/List

const SummaryBtnPreload:PackedScene = preload("res://UI/Buttons/SummaryBtn/SummaryBtn.tscn")
const SplashPreload:PackedScene = preload("res://Scenes/TrainingProgram/parts/GameplayLoop/parts/Splash/Splash.tscn")

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
		var item:Dictionary = track_data[tab_index].list[ SelectedNode.index ]
		var os_settings:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].os_settings
		var track_ref:int = item.details.ref
		var is_unlocked:bool = item.is_unlocked.call(os_settings)
		
		# still locked, so do nothing...
		if !is_unlocked:
			return
		
		# else, pause music and start next track
		MediaPlayerNode.on_pause()
		#
		## play music
		OS_AUDIO.play(track_ref)
	
	for index in range(0, 10):
		var splash_node:Control = SplashPreload.instantiate()
		splash_node.auto_start = true
		splash_node.v_offset = index * 150
		splash_node.speed = 1
		SplashContainer.add_child(splash_node)
		splash_node.hide()


func start() -> void:
	on_music_data_update()
	BtnControls.itemlist = TrackList.get_children()
	BtnControls.item_index = 0
	await BtnControls.reveal(true)
	WaitContainer.hide()
	await U.set_timeout(3.0)
	on_music_data_update()
	

func pause() -> void:
	await BtnControls.reveal(false)
	
func unpause() -> void:
	await BtnControls.reveal(true)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_music_track_list_update() -> void:
	if !is_node_ready():return
	var os_settings:Dictionary = GBL.active_user_profile.save_profiles[GBL.active_user_profile.use_save_profile].os_settings	
	
	for item in TrackList.get_children():
		item.queue_free()
		
	for index in track_data[tab_index].list.size():
		var new_btn:PanelContainer = SummaryBtnPreload.instantiate()		
		var item:Dictionary = track_data[tab_index].list[index]
		var is_unlocked:bool = item.is_unlocked.call(os_settings)
		
		new_btn.index = index
		new_btn.title = item.details.name if is_unlocked else "???"
		new_btn.ref_data = {"ref": item.details.ref}
		new_btn.show_checked_panel = true		
		new_btn.hint_description = "Song by %s" % item.details.author if is_unlocked else "???"
		new_btn.hint_title = "COMPOSER" if is_unlocked else "???"
		new_btn.hide_icon = true
		new_btn.fill = true			

		TrackList.add_child(new_btn)
	
	on_music_data_update()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
func on_music_data_update(new_val:Dictionary = music_data) -> void:
	music_data = new_val
	if !is_node_ready():
		return
	
	if music_data.is_empty():
		for splash_node in SplashContainer.get_children():
			splash_node.hide()	
		return
		
	for index in TrackList.get_child_count():
		var n:Control = TrackList.get_child(index)
		n.is_checked = n.ref_data.ref == music_data.track
		n.use_alt = n.ref_data.ref == music_data.track
	
	var has_funk:bool = true
	if has_funk:
		for splash_node in SplashContainer.get_children():
			var audio_details:Dictionary = OS_AUDIO.return_data(music_data.track)
			if audio_details.is_empty():return
			var str := ""
			for n in range(0, 5):
				str += "🪩 %s 🪩 %s " % [audio_details.details.name, audio_details.details.author]
			splash_node.title = str
			splash_node.show()		
# ------------------------------------------------------------------------------

var time:float = 0
func _process(delta: float) -> void:
	time += delta
	if !is_node_ready():return

	# Scale up and down (optional squashing/growing)
	var scale_factor := 1.0 + sin(time * 2.0) * 0.1  # Adjust frequency and amplitude
	SplashContainer.scale = Vector2(scale_factor, 1.0)

	# Left-right sway (in radians)
	var sway_amplitude := 0.2   # Max rotation in radians (~11 degrees)
	var sway_speed := 1.2    # How fast it sways
	SplashContainer.rotation = sin(time * sway_speed) * sway_amplitude
