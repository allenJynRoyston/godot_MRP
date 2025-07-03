extends PanelContainer

@onready var ColorBG:ColorRect = $ColorBG
@onready var TextureRender:TextureRect = $TextureRect
@onready var BtnControls:Control = $BtnControls
@onready var StoryNarration:Control = $StoryNarration

@onready var RenderSubviewport:SubViewport = $RenderSubviewport
@onready var SceneCamera:Camera3D = $RenderSubviewport/Node3D/Camera3D

@onready var SceneAnimationPlayer:AnimationPlayer = $RenderSubviewport/Node3D/SceneAnimationPlayer
@onready var ScreenTextureRect:TextureRect = $RenderSubviewport/Node3D/Desk/Screen/Sprite3D/SubViewport/TextureRect

enum MODE {INIT, START, START_AT_SCREEN}

var MAIN_NODE:Control
var control_pos:Dictionary = {}

var current_mode:MODE = MODE.INIT : 
	set(val):
		current_mode = val
		on_current_mode_update()

var is_ready:bool = false
var onLogin:Callable = func():pass

# new values
var story_progress:Dictionary = {}
var story_index:int
var allow_replay:bool = true


signal on_finish
signal wait_for_story

# ---------------------------------------------
func _init() -> void:
	GBL.subscribe_to_control_input(self)
	GBL.subscribe_to_fullscreen(self)
	GBL.register_node(REFS.DOOR_SCENE, self)

func _exit_tree() -> void:
	GBL.unsubscribe_to_control_input(self)
	GBL.unsubscribe_to_fullscreen(self)
	GBL.unregister_node(REFS.DOOR_SCENE)

func _ready() -> void:
	MAIN_NODE = GBL.find_node(REFS.MAIN)
	
	on_current_mode_update()	
	#on_play_sequence_update()
	
	BtnControls.reveal(false)
	
	
	#IntroAndTitleScreen.on_end = func() -> void:
		#IntroSubviewport.set_process(false)
		#IntroSubviewport.get_child(0).hide()
	
	BtnControls.onCBtn = func() -> void:
		if !is_ready:return
		await BtnControls.reveal(false)		
		play_current_story_sequence()
	
	BtnControls.onBack = func() -> void:
		pass
	# 
	BtnControls.onDirectional = func(key:String):
		if !is_visible_in_tree() or !is_node_ready() or !allow_replay:return
		var story_progress:Dictionary = GBL.active_user_profile.story_progress
		var max_story_val:int = mini(story_progress.current_story_val, STORY.chapters.size() - 1)
		
		pass
		#match key:
			#"A":
				#story_index = U.min_max(story_index - 1, 0, max_story_val)
			#"D":
				#story_index = U.min_max(story_index + 1, 0, max_story_val)
		
		check_btn_states()
	
# ---------------------------------------------

# ---------------------------------------------
func play_current_story_sequence() -> void:	
	var story_progress:Dictionary = GBL.active_user_profile.story_progress
	
	if "story_message" in STORY.chapters[story_index]:
		StoryNarration.text_list = STORY.chapters[story_index].story_message 
		await StoryNarration.reveal(true)
		await StoryNarration.on_end
	# update current progress val to story value ONLY if it's the first one
	
	if story_index == story_progress.max_story_val and story_progress.play_message_required:
		GBL.active_user_profile.story_progress.play_message_required = false
		GBL.update_and_save_user_profile(GBL.active_user_profile)

	# update btn states, reveal buttons
	check_btn_states(false)	
		
	await U.set_timeout(0.3)
	wait_for_story.emit()
	

	BtnControls.reveal(true)

# ---------------------------------------------

# ---------------------------------------------
func play_next_sequence() -> void:
	story_index = GBL.active_user_profile.story_progress.current_story_val
	
	allow_replay = false

	# update available buttons
	await BtnControls.reveal(true)	
	check_btn_states(true)
	
	# change the root node to show this scene...
	MAIN_NODE.current_layer = MAIN_NODE.LAYER.DOOR_LAYER
	
	# wait for story sequence to complete
	await wait_for_story
	
	# ... then revert to os scene
	MAIN_NODE.current_layer = MAIN_NODE.LAYER.OS_lAYER
	
	await U.set_timeout(0.3)
	
	allow_replay = true
# ---------------------------------------------

# ---------------------------------------------
func check_btn_states(use_for_skip:bool = false) -> void:
	if allow_replay:
		var play_message_required:bool = GBL.active_user_profile.story_progress.current_story_val == GBL.active_user_profile.story_progress.max_story_val
		var story_progress:Dictionary = GBL.active_user_profile.story_progress
		var has_story_message:bool = "story_message" in STORY.chapters[story_index]

		
		# if the story val is 0 (new game), then hide until the first story segement has been completed
		BtnControls.hide_a_btn = play_message_required and has_story_message
		
		# c btn title
		BtnControls.c_btn_title = "PLAY MESSAGE" if (play_message_required and has_story_message) else "REPLAY MESSAGE"
		
		# modify on action so it skips
		BtnControls.a_btn_title = "SKIP" if use_for_skip else "LOGIN"
			
		BtnControls.onAction = func() -> void:
			await BtnControls.reveal(false)		
			if use_for_skip:
				wait_for_story.emit()
			else:
				onLogin.call()
	
	else:
		# modify on action so it skips
		BtnControls.c_btn_title = "PLAY MESSAGE"
		BtnControls.hide_a_btn = true
			
		BtnControls.onAction = func() -> void:
			await BtnControls.reveal(false)		
			wait_for_story.emit()
		
# ---------------------------------------------


# ---------------------------------------------
func start() -> void:
	show()	
	await U.tick()	
	story_index = GBL.active_user_profile.story_progress.current_story_val
	check_btn_states(false)	

	current_mode = MODE.START

func fastfoward() -> void:
	await U.tick()	
	current_mode = MODE.START_AT_SCREEN
	show()	
	
func skip_to_login() -> void:
	await BtnControls.reveal(false)		
	onLogin.call()

func end() -> void:
	hide()
	current_mode = MODE.INIT
	on_finish.emit()

func switch_to() -> void:
	if current_mode == MODE.INIT:
		return
		
	ScreenTextureRect.texture = 	GBL.find_node(REFS.MAIN).OSTexture.texture
		
	is_ready = false	
	await BtnControls.reveal(true)
	is_ready = true
# ---------------------------------------------

# ---------------------------------------------
func on_current_mode_update() -> void:
	if !is_node_ready():return
	match current_mode:
		# ---------
		MODE.INIT:
			for subviewport in [ RenderSubviewport]:
				subviewport.set_process(false)

			for node in [ColorBG, TextureRender]:
				node.show()

			ColorBG.color = Color.BLACK	
		# ---------
		MODE.START:
			SUBSCRIBE.music_data = {
				"selected": MUSIC.TRACK.LOADING
			}
			
			U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 1.0)

			RenderSubviewport.set_process(true)

			U.tween_node_property(SceneCamera, "fov", 77, 4.0, 0, Tween.TRANS_EXPO)
			TextureRender.texture = RenderSubviewport.get_texture()
			
			await U.tween_node_property(SceneCamera, "rotation_degrees:y", 1, 0.7, 2.5)
			SceneAnimationPlayer.active = true
			SceneAnimationPlayer.play("LightsOn")			
			BtnControls.reveal(true)

		# ---------
		MODE.START_AT_SCREEN:
			U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0)

			RenderSubviewport.set_process(true)
			U.tween_node_property(SceneCamera, "fov", 77, 0)
			TextureRender.texture = RenderSubviewport.get_texture()
			
			U.tween_node_property(SceneCamera, "rotation_degrees:y", 1, 0)
			SceneAnimationPlayer.active = true
			SceneAnimationPlayer.play("LightsOn")			
			
			BtnControls.reveal(true)

		# ---------
	
	is_ready = true
# ---------------------------------------------	
