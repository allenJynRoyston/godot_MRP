extends PanelContainer

@onready var ColorBG:ColorRect = $ColorBG
@onready var TextureRender:TextureRect = $TextureRect
@onready var RenderSubviewport:SubViewport = $RenderSubviewport
@onready var SceneCamera:Camera3D = $RenderSubviewport/Node3D/Camera3D
@onready var IntroSubviewport:SubViewport = $SubViewport
@onready var IntroAndTitleScreen:Control = $SubViewport/IntroAndTitleScreen
@onready var SceneAnimationPlayer:AnimationPlayer = $RenderSubviewport/Node3D/SceneAnimationPlayer
@onready var ScreenTextureRect:TextureRect = $RenderSubviewport/Node3D/Desk/Screen/Sprite3D/SubViewport/TextureRect

@onready var BtnControls:Control = $BtnControls

@onready var StoryNarration:Control = $StoryNarration

enum MODE {INIT, START, START_AT_SCREEN}

var OSRootNode:Control
var control_pos:Dictionary = {}

var current_mode:MODE = MODE.INIT : 
	set(val):
		current_mode = val
		on_current_mode_update()

var is_ready:bool = false
var onLogin:Callable = func():pass

# new values
var story_progress:Dictionary = {}

#var play_sequence:bool = true : 
	#set(val):
		#play_sequence = val
		#on_play_sequence_update()

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
	OSRootNode = GBL.find_node(REFS.OS_ROOT)
	
	on_current_mode_update()	
	#on_play_sequence_update()
	
	BtnControls.reveal(false)

	IntroAndTitleScreen.on_end = func() -> void:
		IntroSubviewport.set_process(false)
		IntroSubviewport.get_child(0).hide()
	
	BtnControls.onCBtn = func() -> void:
		if !is_ready:return
		await BtnControls.reveal(false)		
		play_current_story_sequence()
	
	BtnControls.onBack = func() -> void:
		pass
	
	# 
	BtnControls.onDirectional = func(key:String):
		if !is_visible_in_tree() or !is_node_ready():return
		
		match key:
			"A":
				print("go back to previous objective")
			"D":
				print("go to next to objective")
	
	# check needs to be deferred to load correctly
	check_btn_states.call_deferred(false)
# ---------------------------------------------

# ---------------------------------------------
func play_current_story_sequence() -> void:	
	var story_progress:Dictionary = GBL.active_user_profile.story_progress
	
	StoryNarration.text_list = STORY.chapters[story_progress.current_story_val].story_message 
	await StoryNarration.reveal(true)
	await StoryNarration.on_end
	
	# update current progress val to story value ONLY if it's the first one
	if story_progress.play_message_required:
		GBL.active_user_profile.story_progress.play_message_required = false
		GBL.update_and_save_user_profile(GBL.active_user_profile)

	# update btn states, reveal buttons
	check_btn_states(false)	
	
	await U.tick()
	await BtnControls.reveal(true)
	wait_for_story.emit()
	
# ---------------------------------------------

# ---------------------------------------------
func update_progress_and_get_next_objective() -> Array:
	var story_progress:Dictionary = GBL.active_user_profile.story_progress
	
	# TODO: need to add a check to ensure that there IS more story to tell
	if story_progress.current_story_val == story_progress.max_story_val:
		story_progress.max_story_val += 1	
		story_progress.play_message_required = true
		
	# increament current story 
	story_progress.current_story_val = U.min_max(story_progress.current_story_val + 1, 0, story_progress.max_story_val)

	# update and save user profile
	GBL.update_and_save_user_profile(GBL.active_user_profile)

	# update available buttons
	await BtnControls.reveal(true)	
	check_btn_states(true)
	
	# change the root node to show this scene...
	OSRootNode.current_layer = OSRootNode.LAYER.DOOR_LAYER
	
	# wait for story sequence to complete
	await wait_for_story
	
	# ... then revert to os scene
	OSRootNode.current_layer = OSRootNode.LAYER.OS_lAYER
	
	# return new objectives
	return STORY.get_objectives(story_progress.current_story_val)
# ---------------------------------------------
		
## ---------------------------------------------
#func get_current_save_state() -> Dictionary:
	#return {
		## this can be debugged if you need to start on a different story sequence
		#"story_progress_val": DEBUG.get_val(DEBUG.STORY_PROGRESS_VAL) if DEBUG.get_val(DEBUG.DEBUG_STORY_PROGRESS) else progress_data.story_progress_val,
		## these are read-only
		#"play_message_required": progress_data.play_message_required,
		#"current_progress_val": progress_data.current_progress_val,
		#"quicksave_snapshots": progress_data.quicksave_snapshots
	#}	
## ---------------------------------------------

# ---------------------------------------------
func check_btn_states(use_for_skip:bool = false) -> void:
	var play_message_required:bool = GBL.active_user_profile.story_progress.play_message_required

	# if the story val is 0 (new game), then hide until the first story segement has been completed
	BtnControls.hide_a_btn = play_message_required
	
	# c btn title
	BtnControls.c_btn_title = "PLAY MESSAGE" if (play_message_required) else "REPLAY MESSAGE"
	
	# modify on action so it skips
	BtnControls.a_btn_title = "SKIP" if use_for_skip else "LOGIN"
		
	BtnControls.onAction = func() -> void:
		await BtnControls.reveal(false)		
		if use_for_skip:
			wait_for_story.emit()
		else:
			onLogin.call()
				
		
# ---------------------------------------------
	
# ---------------------------------------------
func start() -> void:
	show()	
	await U.tick()	
	current_mode = MODE.START

func fastfoward() -> void:
	await U.tick()	
	current_mode = MODE.START_AT_SCREEN
	show()	

func end() -> void:
	hide()
	current_mode = MODE.INIT
	on_finish.emit()

func switch_to() -> void:
	if current_mode == MODE.INIT:return
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
			for subviewport in [IntroSubviewport, RenderSubviewport]:
				subviewport.set_process(false)

			for node in [ColorBG, TextureRender]:
				node.show()

			ColorBG.color = Color.BLACK			
		
		# ---------
		MODE.START:
			U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 2.0)
			IntroAndTitleScreen.start()
			await IntroAndTitleScreen.on_continue
			IntroAndTitleScreen.queue_free()

			RenderSubviewport.set_process(true)

			U.tween_node_property(SceneCamera, "fov", 77, 4.0, 0, Tween.TRANS_EXPO)
			TextureRender.texture = RenderSubviewport.get_texture()
			#ScreenTextureRect.texture = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))
			
			await U.tween_node_property(SceneCamera, "rotation_degrees:y", 1, 0.7, 2.5)
			SceneAnimationPlayer.active = true
			SceneAnimationPlayer.play("LightsOn")			
			BtnControls.reveal(true)

		# ---------
		MODE.START_AT_SCREEN:
			U.tween_node_property(self, "modulate", Color(1, 1, 1, 1), 0)
			IntroAndTitleScreen.queue_free()

			RenderSubviewport.set_process(true)
			U.tween_node_property(SceneCamera, "fov", 77, 0)
			TextureRender.texture = RenderSubviewport.get_texture()
			#ScreenTextureRect.texture = U.get_viewport_texture(GBL.find_node(REFS.GAMELAYER_SUBVIEWPORT))
			
			U.tween_node_property(SceneCamera, "rotation_degrees:y", 1, 0)
			SceneAnimationPlayer.active = true
			SceneAnimationPlayer.play("LightsOn")			
			
			BtnControls.reveal(true)

		# ---------
	
	is_ready = true
# ---------------------------------------------	
