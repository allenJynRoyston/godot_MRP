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

var onLogin:Callable = func():pass

# new values
var story_progress:Dictionary = {}
#var story_index:int
var allow_replay:bool = true

var original_fov:float
var original_rotation_degrees:Vector3
var fast_animation:bool = false

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
	for subviewport in [ RenderSubviewport]:
		subviewport.set_process(false)

	for node in [ColorBG, TextureRender]:
		node.show()	

	MAIN_NODE = GBL.find_node(REFS.MAIN)	

	BtnControls.reveal(false)
	
	BtnControls.onCBtn = func() -> void:
		await BtnControls.reveal(false)		
		await play_current_story_sequence()
		BtnControls.reveal(true)	
	
	BtnControls.onBack = func() -> void:
		pass
	# 
	BtnControls.onDirectional = func(key:String):
		if !is_visible_in_tree() or !is_node_ready() or !allow_replay:return
		#var story_progress:Dictionary = GBL.active_user_profile.story_progress
		#var max_story_val:int = mini(story_progress.current_story_val, STORY.chapters.size() - 1)
		
		#pass
		match key:
			"A":
				print("look left")
			"D":
				print("look righta")
		
		check_btn_states()
	
	original_fov = SceneCamera.fov
	original_rotation_degrees = SceneCamera.rotation_degrees
# ---------------------------------------------

# ---------------------------------------------
func start(use_fast_animation:bool = false) -> void:
	show()	
	await U.tick()	
	check_btn_states()	

	RenderSubviewport.set_process(true)	
	TextureRender.texture = RenderSubviewport.get_texture()

	SUBSCRIBE.music_data = {
		"selected": OS_AUDIO.TRACK.LOADING
	}
	
	fast_animation = use_fast_animation
	await U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 1.0)
		
	SceneAnimationPlayer.active = true
	SceneAnimationPlayer.play("LightsOn")
	BtnControls.reveal(true)

func end() -> void:
	hide()
	on_finish.emit()
# ---------------------------------------------

# ---------------------------------------------
func play_current_story_sequence() -> void:	
	var on_chapter:int = GBL.get_current_chapter()
	
	StoryNarration.text_list = STORY.chapters[on_chapter].story_message 
	await StoryNarration.reveal(true)
	await StoryNarration.on_end

	# modify on action so it skips
	BtnControls.a_btn_title = "SKIP"
		
	BtnControls.onAction = func() -> void:
		await BtnControls.reveal(false)		
		wait_for_story.emit()
		
	await U.set_timeout(0.3)
	wait_for_story.emit()

	GBL.mark_messages_played(on_chapter)
	check_btn_states()
# ---------------------------------------------

# ---------------------------------------------
func play_next_sequence() -> void:
	allow_replay = false
	var on_chapter:int = GBL.get_current_chapter()

	# update available buttons
	await BtnControls.reveal(true)	
	check_btn_states()
	
	# change the root node to show this scene...
	MAIN_NODE.current_layer = MAIN_NODE.LAYER.CELLBLOCK_LAYER

	# wait for story sequence to complete
	await wait_for_story
	GBL.mark_messages_played(on_chapter)
	
	# ... then revert to os scene
	MAIN_NODE.current_layer = MAIN_NODE.LAYER.OS_lAYER
	
	await U.set_timeout(0.3)
	
	allow_replay = true
# ---------------------------------------------

# ---------------------------------------------
func check_btn_states() -> void:	
	if allow_replay:
		var on_chapter:int = GBL.get_current_chapter()
		var has_story_message:bool = "story_message" in STORY.chapters[on_chapter]		
		var message_has_been_played:bool = GBL.has_message_been_played(on_chapter)
				
		# c btn title
		BtnControls.hide_c_btn = !has_story_message
		BtnControls.c_btn_title = "PLAY MESSAGE" if on_chapter not in GBL.active_user_profile.story_progress.messages_played else "REPLAY MESSAGE"
		
		# modify on action so it skips
		BtnControls.hide_a_btn = !message_has_been_played
		BtnControls.a_btn_title = "LOGIN"
			
		BtnControls.onAction = func() -> void:
			BtnControls.reveal(false)		
			await zoom_into_screen(false)
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
func zoom_into_screen(state:bool, duration:float = 2.0) -> void:
	if state:
		U.tween_node_property(SceneCamera, "fov", 77, duration if !fast_animation else 0.3, 0, Tween.TRANS_QUART)
		await U.tween_node_property(SceneCamera, "rotation_degrees:y", 1, 0.7 if !fast_animation else 0.3, duration/2)	
	else:
		U.tween_node_property(SceneCamera, "rotation_degrees:y", original_rotation_degrees.y, 1.0 if !fast_animation else 0.3)	
		U.tween_node_property(SceneCamera, "fov", 23, duration if !fast_animation else 0.3, 0, Tween.TRANS_QUART)
		await U.set_timeout(duration - 0.6)
# ---------------------------------------------

# ---------------------------------------------
func skip_to_login() -> void:
	await BtnControls.reveal(false)		
	onLogin.call()

func switch_to() -> void:		
	ScreenTextureRect.texture = 	GBL.find_node(REFS.MAIN).OSTexture.texture
		
	await zoom_into_screen(true)	
	BtnControls.reveal(true)
# ---------------------------------------------
